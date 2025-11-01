#!/usr/bin/env python3
"""
从定义列表文件读取定义，检查类型（只保留 def），尝试实例化，并获取文档注释，保存为 JSON

使用方法:
    python process_defs.py [input_file] [output_file]
    
    默认:
    python process_defs.py  # 使用 val_def_list.txt -> val_instantiated_defs.json
    
    处理 native:
    python process_defs.py native_def_list.txt native_instantiated_defs.json
"""

import subprocess
import tempfile
import os
import json
import re
import sys
from typing import List, Dict, Any, Optional
from concurrent.futures import ProcessPoolExecutor, as_completed

PROJECT_ROOT = "/local/home/zenali/CodeVerif-Lean4"

# 要实例化的类型
INSTANCE_TYPES = ["Nat", "Int", "Float", "Bool", "Array", "String", "(List Nat)", "(List Int)", "(List Float)", "(List Bool)", "(List String)"]

# 白名单：只处理以下前缀的定义（前缀匹配）
WHITELIST_PREFIXES = [
    "Array.",        # Array 相关函数
    "List.",         # List 相关函数
    "String.",       # String 相关函数
    "Nat.",          # Nat 相关函数
    "Int.",          # Int 相关函数
    "Float.",        # Float 相关函数
]


def load_definitions_from_file(file_path: str) -> List[str]:
    """从文件中读取定义列表"""
    definitions = []
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                # 移除引号和逗号
                if line.startswith('"') and line.endswith('",'):
                    line = line[1:-2]  # 移除开头的 " 和结尾的 ",
                elif line.startswith('"') and line.endswith('"'):
                    line = line[1:-1]  # 移除开头的 " 和结尾的 "
                
                if line:
                    definitions.append(line)
    except FileNotFoundError:
        print(f"错误: 文件 {file_path} 不存在")
        return []
    except Exception as e:
        print(f"错误: 读取文件时出错: {e}")
        return []
    
    return definitions


def extract_content_from_output(output: str) -> Optional[str]:
    """从 Lean 输出中提取文档注释内容"""
    # 检查是否没有文档
    if "===NO_DOC===" in output:
        return None
    
    # 首先尝试使用标记来提取内容
    if "===CONTENT_START===" in output and "===CONTENT_END===" in output:
        start_idx = output.find("===CONTENT_START===")
        end_idx = output.find("===CONTENT_END===")
        if start_idx < end_idx:
            content = output[start_idx + len("===CONTENT_START==="):end_idx].strip()
            if content:
                return content
    
    # 如果没有找到标记，返回 None
    return None


def extract_signature_from_output(output: str, check_expr: str) -> Optional[str]:
    """从 Lean 输出中提取 #check 的类型签名"""
    # Lean 输出格式:
    # ===CONTENT_START===
    # ...文档...
    # ===CONTENT_END===
    # test_Array_all_Nat (as : Array Nat) (p : Nat → Bool) ... : Bool
    # @Array.all : ...
    #
    # 只需要在 ===CONTENT_END=== 之后找包含 check_expr 的第一行即可
    
    if "===CONTENT_END===" not in output:
        return None
    
    # 找到 ===CONTENT_END=== 的位置
    content_end_idx = output.find("===CONTENT_END===")
    
    # 获取 ===CONTENT_END=== 之后的内容
    after_content = output[content_end_idx + len("===CONTENT_END==="):]
    
    # 按行分割，找到包含 check_expr 的第一行
    # 如果 check_expr 以 @ 开头，也尝试匹配不带 @ 的情况
    check_exprs = [check_expr]
    if check_expr.startswith("@"):
        check_exprs.append(check_expr[1:])  # 不带 @ 的版本
    
    lines = after_content.split('\n')
    for line in lines:
        line = line.strip()
        if not line:
            continue
        # 如果这一行包含任一 check_expr，直接返回整行作为签名（包括函数名和类型）
        for expr in check_exprs:
            if expr in line:
                # 清理空白
                signature = re.sub(r'\s+', ' ', line).strip()
                if signature:
                    return signature
    
    return None


def is_whitelisted(def_name: str) -> bool:
    """检查定义是否在白名单中"""
    for prefix in WHITELIST_PREFIXES:
        if def_name.startswith(prefix):
            return True
    return False


def batch_check_defs(def_names: List[str]) -> set:
    """批量检查哪些声明是 def 类型（而不是 theorem）"""
    if not def_names:
        return set()
    
    # 生成所有检查命令
    check_commands = "\n".join([f"#check_type {name}" for name in def_names])
    
    check_content = f"""import Lean
open Lean Meta Elab Command

elab "#check_type" e:ident : command => do
  let declName := e.getId
  let env ← getEnv
  match env.find? declName with
  | none => IO.println s!"{{declName}} is unknown, no definition"
  | some cinfo =>
    let kindStr := match cinfo with
    | .defnInfo _ => "def"
    | .thmInfo _ => "theorem"
    | .axiomInfo _ => "axiom"
    | .opaqueInfo _ => "opaque"
    | .quotInfo _ => "quot"
    | .inductInfo _ => "inductive"
    | .ctorInfo _ => "constructor"
    | .recInfo _ => "recursor"
    
    let hasValueStr := if cinfo.hasValue then "has definition" else "no definition"
    IO.println s!"{{declName}} is {{kindStr}}, {{hasValueStr}}"

{check_commands}
"""
    
    with tempfile.NamedTemporaryFile(mode='w', suffix='.lean', delete=False, dir=PROJECT_ROOT) as f:
        f.write(check_content)
        temp_file = f.name
        temp_file_rel = os.path.relpath(temp_file, PROJECT_ROOT)
    
    def_set = set()
    
    try:
        result = subprocess.run(
            ['lake', 'env', 'lean', temp_file_rel],
            cwd=PROJECT_ROOT,
            capture_output=True,
            text=True,
            timeout=60
        )
        
        output = result.stdout + result.stderr
        
        # 解析输出，找到所有 "is def" 的声明
        for line in output.split('\n'):
            for def_name in def_names:
                if f"{def_name} is def" in line:
                    def_set.add(def_name)
                    break
        
        return def_set
    
    except Exception as e:
        print(f"批量检查失败: {e}")
        return set()
    finally:
        try:
            os.unlink(temp_file)
        except:
            pass


def try_instantiate_definition(def_name: str, inst_type: str, max_retries: int = 3) -> Optional[Dict[str, Any]]:
    """尝试实例化定义并获取文档注释"""
    
    safe_def_name = def_name.replace(".", "_").replace("?", "_").replace("!", "_")
    # 处理类型名称，移除括号用于文件名，但保留用于 Lean 代码
    safe_inst_type = inst_type.replace(" ", "_").replace("(", "_").replace(")", "_")
    test_name = f"test_{safe_def_name}_{safe_inst_type}"
    
    # 创建临时 Lean 文件 - 使用 #print_doc 获取文档注释，使用 #check 获取签名
    lean_content = f"""import Lean
open Lean Meta Elab Command

elab "#print_doc" e:ident : command => do
  let declName := e.getId
  let env ← getEnv
  
  match env.find? declName with
  | none => throwError "not found declaration '{{declName}}'"
  | some _ =>
    match ← findDocString? env declName with
    | none => IO.println "===NO_DOC==="
    | some docStr => 
      IO.println "===CONTENT_START==="
      IO.println docStr
      IO.println "===CONTENT_END==="

-- 先尝试实例化，检查是否可以实例化
def {test_name} := @{def_name} {inst_type}

-- 打印原始定义的文档
#print_doc {def_name}

-- 检查实例化后的类型签名
#check {test_name}
"""
    
    with tempfile.NamedTemporaryFile(mode='w', suffix='.lean', delete=False, dir=PROJECT_ROOT) as f:
        f.write(lean_content)
        temp_file = f.name
        temp_file_rel = os.path.relpath(temp_file, PROJECT_ROOT)
    
    try:
        # 运行 lean 来尝试实例化并获取文档
        result = subprocess.run(
            ['lake', 'env', 'lean', temp_file_rel],
            cwd=PROJECT_ROOT,
            capture_output=True,
            text=True,
            timeout=15
        )
        
        output = result.stdout + result.stderr
        
        # 检查是否有类型错误（无法实例化）
        if result.returncode != 0:
            error_lower = output.lower()
            if any(keyword in error_lower for keyword in [
                "type mismatch", "cannot apply", "has type", "but is expected",
                "type class instance", "failed to synthesize", "unknown identifier"
            ]):
                # 回退：不实例化，直接获取原始定义的文档与签名
                try:
                    fallback_content = f"""import Lean
open Lean Meta Elab Command

elab "#print_doc" e:ident : command => do
  let declName := e.getId
  let env ← getEnv
  match env.find? declName with
  | none => throwError "not found declaration '{{declName}}'"
  | some _ =>
    match ← findDocString? env declName with
    | none => IO.println "===NO_DOC==="
    | some docStr => 
      IO.println "===CONTENT_START==="
      IO.println docStr
      IO.println "===CONTENT_END==="

# 打印原始定义的文档
#print_doc {def_name}

# 检查原始定义的类型签名（不实例化）
#check @{def_name}
"""
                    with tempfile.NamedTemporaryFile(mode='w', suffix='.lean', delete=False, dir=PROJECT_ROOT) as f2:
                        f2.write(fallback_content)
                        temp_file2 = f2.name
                        temp_file2_rel = os.path.relpath(temp_file2, PROJECT_ROOT)

                    try:
                        result2 = subprocess.run(
                            ['lake', 'env', 'lean', temp_file2_rel],
                            cwd=PROJECT_ROOT,
                            capture_output=True,
                            text=True,
                            timeout=15
                        )
                        output2 = result2.stdout + result2.stderr
                        content2 = extract_content_from_output(output2)
                        signature2 = extract_signature_from_output(output2, f"@{def_name}")
                        if content2:
                            result_dict2 = {
                                "def": def_name,
                                "content": content2,
                                "origin_def": def_name
                            }
                            if signature2:
                                result_dict2["signature"] = signature2
                            return result_dict2
                        return None
                    finally:
                        try:
                            os.unlink(temp_file2)
                        except:
                            pass
                except Exception:
                    return None
        
        # 提取文档注释内容
        content = extract_content_from_output(output)
        
        # 提取签名
        signature = extract_signature_from_output(output, test_name)
        
        # 调试：如果失败，打印部分输出（仅第一个失败的情况）
        if not content and def_name == "Array.all" and inst_type == "Nat":
            print(f"\n[调试] {def_name} 实例化失败")
            print(f"返回码: {result.returncode}")
            print(f"输出前500字符:\n{output[:500]}")
            print(f"签名提取结果: {signature}")
        
        if content:
            result_dict = {
                "def": f"def {test_name} := @{def_name} {inst_type}",
                "content": content,
                "origin_def": def_name,
                "Inst": inst_type
            }
            # 如果成功提取到签名，添加到结果中
            if signature:
                result_dict["signature"] = signature
            return result_dict
        
        return None
    
    except subprocess.TimeoutExpired:
        return None
    except Exception as e:
        return None
    finally:
        try:
            os.unlink(temp_file)
        except:
            pass


def process_definitions(definitions: List[str], instance_types: List[str], max_workers: int = 64) -> List[Dict[str, Any]]:
    """处理所有定义，尝试实例化"""
    results = []
    seen_contents = set()  # 用于去重（同一个文档注释可能对应多个实例化）
    filtered_by_duplicate = 0
    
    # 应用白名单过滤
    original_count = len(definitions)
    definitions = [d for d in definitions if is_whitelisted(d)]
    filtered_count = original_count - len(definitions)
    
    print(f"白名单过滤: {len(definitions)} 个定义通过（如 Array., List., String. 等），{filtered_count} 个被过滤")
    print(f"开始检查 {len(definitions)} 个声明的类型...")
    
    # 批量检查哪些是 def 类型
    def_names = batch_check_defs(definitions)
    
    print(f"检查完成: {len(def_names)} 个是 def, {len(definitions) - len(def_names)} 个是其他类型（theorem/axiom等）")
    print(f"将只处理 def 类型的定义\n")
    
    # 只处理 def 类型的定义；若无法识别（如缺少 lake 环境）则退化为处理全部白名单定义
    if def_names:
        definitions = [d for d in definitions if d in def_names]
    else:
        print("未能识别出 def（可能未安装 lake/环境未加载），将尝试直接处理全部白名单定义\n")
    
    print(f"开始处理 {len(definitions)} 个 def 定义，每个定义尝试 {len(instance_types)} 种实例化...")
    print(f"总共需要尝试 {len(definitions) * len(instance_types)} 次实例化\n")
    
    total_tasks = len(definitions) * len(instance_types)
    completed = 0
    successful = 0
    
    with ProcessPoolExecutor(max_workers=max_workers) as executor:
        # 提交所有任务
        futures = []
        for def_name in definitions:
            for inst_type in instance_types:
                future = executor.submit(try_instantiate_definition, def_name, inst_type)
                futures.append((future, def_name, inst_type))
        
        # 收集结果
        for future, def_name, inst_type in futures:
            try:
                result = future.result()
                completed += 1
                
                if result:
                    content = result.get("content", "")
                    
                    # 检查文档注释是否重复（同一个定义的文档注释是一样的）
                    if content in seen_contents:
                        filtered_by_duplicate += 1
                        if completed % 50 == 0:
                            print(f"  [{completed}/{total_tasks}] 处理中... (成功: {successful}, 过滤重复: {filtered_by_duplicate})")
                        continue
                    
                    # 添加到结果和已见集合
                    seen_contents.add(content)
                    results.append(result)
                    successful += 1
                    print(f"  [{completed}/{total_tasks}] ✓ {def_name} -> {inst_type}")
                else:
                    if completed % 50 == 0:
                        print(f"  [{completed}/{total_tasks}] 处理中... (成功: {successful}, 过滤重复: {filtered_by_duplicate})")
            except Exception as e:
                completed += 1
                if completed % 50 == 0:
                    print(f"  [{completed}/{total_tasks}] 处理中... (成功: {successful}, 过滤重复: {filtered_by_duplicate})")
    
    print(f"\n过滤统计:")
    print(f"  因重复文档注释过滤: {filtered_by_duplicate}")
    print(f"  最终保留的唯一定义: {len(results)}")
    
    return results


def main():
    # 解析命令行参数
    if len(sys.argv) >= 3:
        input_file = os.path.join(PROJECT_ROOT, "Analysis", sys.argv[1])
        output_file = os.path.join(PROJECT_ROOT, "Analysis", sys.argv[2])
    elif len(sys.argv) == 2:
        print("错误: 请同时提供输入文件和输出文件")
        print("使用方法: python process_defs.py [input_file] [output_file]")
        sys.exit(1)
    else:
        # 默认使用 val_def_list.txt
        input_file = os.path.join(PROJECT_ROOT, "Analysis", "val_def_list.txt")
        output_file = os.path.join(PROJECT_ROOT, "Analysis", "val_instantiated_defs.json")
    
    print("="*80)
    print(f"从 {os.path.basename(input_file)} 读取定义，检查类型并获取文档注释")
    print("="*80)
    print()
    
    # 从文件加载定义列表
    definitions = load_definitions_from_file(input_file)
    print(f"从 {input_file} 加载了 {len(definitions)} 个定义")
    
    if not definitions:
        print("错误: 无法加载定义列表")
        return
    
    # 显示前几个定义作为示例
    if definitions:
        print(f"\n前10个定义示例:")
        for i, def_name in enumerate(definitions[:10]):
            print(f"  {i+1}. {def_name}")
        if len(definitions) > 10:
            print(f"  ... 还有 {len(definitions) - 10} 个")
    
    # 处理定义
    results = process_definitions(definitions, INSTANCE_TYPES)
    
    # 保存结果
    print(f"\n保存结果到 {output_file}...")
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(results, f, indent=2, ensure_ascii=False)
    
    print("\n" + "="*80)
    print("处理完成")
    print("="*80)
    print(f"成功处理 {len(results)} 个定义（包含文档注释）")
    print(f"结果已保存到: {output_file}")
    print("="*80)


if __name__ == "__main__":
    main()

