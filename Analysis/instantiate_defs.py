#!/usr/bin/env python3
"""
将定义实例化并展开，保存为 JSON

使用方法:
    python instantiate_defs.py
"""

import subprocess
import tempfile
import os
import json
from typing import List, Dict, Any, Optional
from concurrent.futures import ThreadPoolExecutor, as_completed

PROJECT_ROOT = "/local/home/zenali/CodeVerif-Lean4"
TEST_SHOW_DEF_FILE = "/local/home/zenali/lean-portal/Test/test_show_def.lean"

# 要实例化的类型
INSTANCE_TYPES = ["Nat", "Int", "Float", "Bool", "(List Nat)", "(List Int)", "(List Float)", "(List Bool)"]

# 从 axiom_extract.py 中读取定义列表
def load_definitions():
    return [
      "Applicative.toFunctor",
      "Applicative.toPure",
      "And.casesOn",
      "Alternative.toApplicative",
      "Array.all",
      "Array.all_iff_forall",
      "Array.any_iff_exists",
      "Array.all_congr",
      "Array.all_eq",
      "Array.any_eq_true._simp_1",
      "Array.any_congr",
      "Array.any",
      "Array.any_eq",
      "Array.casesOn",
      "Array.filter",
      "Array.filterMap",
      "Array.find?",
      "Array.foldl",
      "Array.findIdx?",
      "Array.getElem_map._proof_1",
      "Array.getElem_map",
      "Array.getElem_mapIdx._proof_1",
      "Array.getElem_mapIdx",
      "Array.idxOf",
      "Array.instForIn'InferInstanceMembership",
      "Array.insertionSort",
      "Array.map",
      "Array.mapIdx",
      "Array.ofFn",
      "Array.modify",
      "Array.qsort",
      "Array.size_map",
      "Array.size_mapIdx",
      "Array.sum",
      "BEq.mk",
      "BEq.beq",
      "BaseIO",
      "Bind.bind",
      "Bool.casesOn",
      "Bool.forall_bool._simp_1",
      "Bool.not",
      "Bool.xor",
      "ByteArray.get!",
      "Decidable.byContradiction",
      "Decidable.casesOn",
      "Decidable.imp_iff_not_or",
      "DecidablePred",
      "DecidableRel",
      "Dvd.dvd",
      "EIO",
      "Eq.casesOn",
      "Eq",
      "Eq.ndrec",
      "Eq.propIntro",
      "Eq.rec",
      "Eq.substr",
      "Except.casesOn",
      "Except.ok",
      "Except.error",
      "Exists",
      "Exists.casesOn",
      "Exists.choose",
      "Exists.intro",
      "Fin.casesOn",
      "Fin.castSucc",
      "Fin.instGetElem?FinVal",
      "Fin.instGetElemFinVal",
      "Fin.succ",
      "Float.abs",
      "Float.floor",
      "Float.ofInt",
      "Float.toUInt64",
      "Float.round",
      "ForIn.forIn",
      "Float.sqrt",
      "ForInStep.done",
      "ForInStep.yield",
      "GetElem?.getElem!",
      "GetElem",
      "GetElem?.toGetElem",
      "GetElem.getElem",
      "GetElem?.getElem?",
      "HAdd.hAdd",
      "HAnd.hAnd",
      "HAppend.hAppend",
      "HDiv.hDiv",
      "HEq",
      "HMod.hMod",
      "HOr.hOr",
      "HPow.hPow",
      "HMul.hMul",
      "HShiftLeft.hShiftLeft",
      "HShiftRight.hShiftRight",
      "HSub.hSub",
      "HXor.hXor",
      "HasSubset.Subset",
      "Hashable.hash",
      "Hashable.mk",
      "IO",
      "Id.instMonadLiftTOfPure",
      "Iff.intro",
      "Iff.mp",
      "Iff.mpr",
      "Insert.insert",
      "Int.Linear.eq_eq_true",
      "Int.casesOn",
      "Int.cast",
      "Int.emod_eq_zero_of_dvd",
      "Int.mul_ediv_assoc",
      "Int.negSucc",
      "Int.ofNat",
      "Int.toNat",
      "Inter.inter",
      "LE.le",
      "LT.lt",
      "Lean.RArray.branch",
      "Lean.RArray.leaf",
      "Lean.instForInLoopUnit",
      "List.Nodup",
      "List.Pairwise",
      "List.Sublist",
      "List.Perm",
      "List.all",
      "List.all_eq_true._simp_1",
      "List.all_toArray'",
      "List.any",
      "List.any_eq_true._simp_1",
      "List.below",
      "List.beq",
      "List.brecOn",
      "List.casesOn",
      "List.concat",
      "List.count",
      "List.countP",
      "List.decidableBAll",
      "List.decidableBEx",
      "List.dropLast",
      "List.dropWhile",
      "List.erase",
      "List.enum",
      "List.eraseP",
      "List.filter",
      "List.filterMap",
      "List.filter_unattach",
      "List.filter_wfParam",
      "List.find?",
      "List.findIdx?",
      "List.flatMap_unattach",
      "List.flatMap",
      "List.flatten",
      "List.flatMap_wfParam",
      "List.foldl",
      "List.foldr",
      "List.forM",
      "List.get",
      "List.getElem?_map",
      "List.getElem_map",
      "List.getLast!",
      "List.getLast?",
      "List.head?",
      "List.head!",
      "List.idxOf",
      "List.indexOf",
      "List.indexOf?",
      "List.instDecidablePairwise",
      "List.instForIn'InferInstanceMembership",
      "List.isEmpty",
      "List.isPerm",
      "List.length",
      "List.length_filter_le",
      "List.length_mapIdx",
      "List.length_map",
      "List.lookup",
      "List.map",
      "List.mapIdx",
      "List.mapIdx_toArray",
      "List.mapM",
      "List.max?",
      "List.map_unattach.match_1",
      "List.mergeSort",
      "List.min?",
      "List.mem_mapIdx._simp_1",
      "List.min?_eq_some_iff'",
      "List.ofFn",
      "List.partition",
      "List.rec",
      "List.sum",
      "List.tail",
      "List.tail!",
      "List.tail?",
      "List.takeWhile",
      "List.unattach",
      "List.zip",
      "List.zipWith",
      "MProd.casesOn",
      "Max.max",
      "Membership.mem",
      "Monad.toApplicative",
      "Min.min",
      "Monad.toBind",
      "MonadLiftT.monadLift",
      "Nat.add",
      "Nat.beq",
      "Nat.ble",
      "Nat.below",
      "Nat.brecOn",
      "Nat.casesAuxOn",
      "Nat.casesOn",
      "Nat.cast",
      "Nat.decidableBallLT",
      "Nat.decidableExistsFin",
      "Nat.decidableExistsLT",
      "Nat.decidableExistsLT'",
      "Nat.elimOffset",
      "Nat.land",
      "Nat.le.step",
      "Nat.le",
      "Nat.le.casesOn",
      "Nat.le_of_lt_add_one",
      "Nat.le_sub_one_of_lt",
      "Nat.le_trans",
      "Nat.lt_of_lt_of_le",
      "Nat.lt_of_succ_lt_succ",
      "Nat.lt_succ_of_le",
      "Nat.lt_trans",
      "Nat.mod_lt",
      "Nat.not_lt_of_ge",
      "Nat.not_lt_of_le",
      "Nat.pos_of_ne_zero",
      "Nat.pow",
      "Nat.rec",
      "Nat.recAux",
      "Nat.shiftRight",
      "Nat.sub",
      "Nat.sub_lt_sub_right",
      "Nat.xor",
      "Neg.neg",
      "Option.casesOn",
      "Option.get!",
      "Option.isNone",
      "Option.isSome",
      "Option.map",
      "Or.casesOn",
      "Or.elim",
      "Ord.compare",
      "PSigma",
      "PSigma.mk",
      "Prod.casesOn",
      "Pure.pure",
      "Repr.mk",
      "SDiff.sdiff",
      "SizeOf.sizeOf",
      "Singleton.singleton",
      "Std.Iterators.Iter.attachWith",
      "Std.Iterators.Iter.map",
      "Std.Iterators.Map.instIteratorCollect",
      "Std.Iterators.Map",
      "Std.Iterators.PostconditionT",
      "Std.Iterators.Types.Attach",
      "Std.Iterators.Types.ULiftIterator",
      "Std.Iterators.Types.Attach.instIterator",
      "Std.Iterators.Types.ULiftIterator.instIterator",
      "Std.Iterators.Types.ULiftIterator.instIteratorCollect",
      "Std.Iterators.instIteratorCollectState",
      "Std.Iterators.ULiftT",
      "Std.Iterators.instIteratorMap",
      "Std.Iterators.instIteratorState",
      "Std.Iterators.instMonadPostconditionT",
      "Std.Iterators.instMonadULiftT",
      "Std.Range.instForIn'NatInferInstanceMembership",
      "String.Iterator.curr",
      "String.Iterator.next",
      "String.Iterator.atEnd",
      "String.all",
      "String.any",
      "String.foldl",
      "String.foldr",
      "String.extract",
      "String.get?",
      "String.intercalate",
      "String.length",
      "String.push",
      "String.split",
      "Subtype",
      "Subtype.val",
      "Sum.casesOn",
      "ToString.toString",
      "Union.union",
      "WellFounded.fix",
      "WellFounded.fix_eq",
      "and_imp._simp_1",
      "congr",
      "congrArg",
      "dif_neg",
      "dite",
      "dif_pos",
      "dite_cond_eq_true",
      "dite_congr",
      "dite_eq_right_iff._simp_1",
      "eq_false'",
      "exists_and_left._simp_1",
      "exists_prop_congr",
      "exists_true_left._simp_1",
      "false_implies",
      "forall_congr",
      "forall_false",
      "forall_exists_index._simp_1",
      "forall_prop_decidable",
      "forall_prop_domain_congr",
      "funext",
      "getElem!_pos",
      "getElem!_neg",
      "getElem?_pos",
      "have_body_congr'",
      "have_congr'",
      "imp_false._simp_1",
      "imp_self._simp_1",
      "implies_congr",
      "implies_congr_ctx",
      "implies_dep_congr_ctx",
      "instDecidableDite",
      "instForInOfForIn'",
      "instGetElem?OfGetElemOfDecidable",
      "instMonadLiftT",
      "instMonadLiftTOfMonadLift",
      "instToIteratorSubarrayId.match_1",
      "invImage",
      "ite_congr",
      "ite_eq_right_iff._simp_1",
      "ite_eq_left_iff._simp_1",
      "liftM",
      "noConfusionEnum",
      "noConfusionTypeEnum",
      "not_and._simp_1",
      "of_decide_eq_false",
      "of_decide_eq_true",
      "propext",
      "right_eq_ite_iff._simp_1"
    ]


def create_lean_script(def_name: str, instance_types: List[str]) -> str:
    """创建 Lean 脚本来实例化和展开定义"""
    script = """import Lean
open Lean Meta Elab Command

elab "#show_def" e:term : command => do
  liftTermElabM do
    let term ← Term.elabTerm e.raw none
    let exprToShow ← Meta.withTransparency .all <| do
      matchConst term.getAppFn (fun _ => pure term) fun cinfo fLvls => do
        if cinfo.hasValue && cinfo.levelParams.length == fLvls.length then
          let defValue ← instantiateValueLevelParams cinfo fLvls
          let expanded1 := defValue.betaRev term.getAppRevArgs (useZeta := true)
          match expanded1.getAppFn with
          | Expr.const constName2 levels2 =>
            match (← getEnv).find? constName2 with
            | some cinfo2 =>
              if cinfo2.hasValue && cinfo2.levelParams.length == levels2.length &&
                 constName2 != cinfo.name then
                let defValue2 ← instantiateValueLevelParams cinfo2 levels2
                pure (defValue2.betaRev expanded1.getAppRevArgs (useZeta := true))
              else
                pure expanded1
            | _ => pure expanded1
          | _ => pure expanded1
        else
          pure term
    let normalized ← try
      Meta.zetaReduce exprToShow
    catch _ =>
      pure exprToShow
    let fmt ← Meta.withTransparency .default <| Meta.ppExpr normalized
    IO.println fmt.pretty

"""
    
    # 为每个实例化类型创建测试
    for inst_type in instance_types:
        # 尝试不同的实例化方式
        # 方式1: @def_name inst_type
        script += f'\ndef test_{def_name.replace(".", "_").replace("?", "_").replace("!", "_")}_{inst_type.replace(" ", "_").replace("(", "_").replace(")", "_")} := @{def_name} {inst_type}\n'
        script += f'#show_def test_{def_name.replace(".", "_").replace("?", "_").replace("!", "_")}_{inst_type.replace(" ", "_").replace("(", "_").replace(")", "_")}\n\n'
        
        # 方式2: 如果有多个类型参数，尝试不同的组合
        # 这里先简单处理，之后可以根据需要扩展
    
    return script


def extract_content_from_output(output: str) -> Optional[str]:
    """从 Lean 输出中提取展开后的内容"""
    # 首先尝试使用标记来提取内容
    if "===CONTENT_START===" in output and "===CONTENT_END===" in output:
        start_idx = output.find("===CONTENT_START===")
        end_idx = output.find("===CONTENT_END===")
        if start_idx < end_idx:
            content = output[start_idx + len("===CONTENT_START==="):end_idx].strip()
            if content:
                return content
    
    # 如果没有标记，尝试从输出中查找函数表达式
    lines = output.split('\n')
    content_lines = []
    
    # 查找从 "fun" 开始的行或者包含 "=>" 的行
    found_start = False
    bracket_count = 0
    
    for line in lines:
        line_stripped = line.strip()
        
        # 跳过明显的错误信息
        if "error" in line.lower() and ("unknown" in line.lower() or "not found" in line.lower()):
            return None
        
        # 跳过定义声明行和注释
        if (line_stripped.startswith("def ") or 
            line_stripped.startswith("#show_def") or 
            line_stripped.startswith("--") or
            line_stripped.startswith("import")):
            continue
        
        # 如果包含函数表达式的开始
        if "fun" in line_stripped or "=>" in line_stripped or found_start:
            if not found_start and "fun" in line_stripped:
                found_start = True
            
            if found_start:
                content_lines.append(line_stripped)
                # 简单计数括号来判断是否完整
                bracket_count += line_stripped.count('(') - line_stripped.count(')')
                # 如果括号平衡且已有内容，可能已完成
                if bracket_count <= 0 and len(content_lines) > 1 and '=>' in line_stripped:
                    break
    
    if not content_lines:
        # 如果没找到函数表达式，尝试找其他类型的表达式
        for line in lines:
            line_stripped = line.strip()
            if (line_stripped and 
                not line_stripped.startswith("--") and 
                not line_stripped.startswith("def") and
                not line_stripped.startswith("import")):
                if any(keyword in line_stripped for keyword in ["List.", "Array.", "Nat.", "Int.", "Float.", "List.brecOn"]):
                    content_lines.append(line_stripped)
        
        if not content_lines:
            return None
    
    content = " ".join(content_lines).strip()
    
    # 清理一些常见的无用内容
    if "Definition:" in content:
        content = content.split("Definition:")[-1].strip()
    
    if not content or len(content) < 5:
        return None
    
    return content


def try_instantiate_definition(def_name: str, inst_type: str, max_retries: int = 3) -> Optional[Dict[str, Any]]:
    """尝试实例化定义并获取展开内容"""
    safe_def_name = def_name.replace(".", "_").replace("?", "_").replace("!", "_")
    # 处理类型名称，移除括号用于文件名，但保留用于 Lean 代码
    safe_inst_type = inst_type.replace(" ", "_").replace("(", "_").replace(")", "_")
    test_name = f"test_{safe_def_name}_{safe_inst_type}"
    
    # 创建临时 Lean 文件
    lean_content = f"""import Lean
open Lean Meta Elab Command

elab "#show_def" e:term : command => do
  liftTermElabM do
    let term ← Term.elabTerm e.raw none
    let exprToShow ← Meta.withTransparency .all <| do
      matchConst term.getAppFn (fun _ => pure term) fun cinfo fLvls => do
        if cinfo.hasValue && cinfo.levelParams.length == fLvls.length then
          let defValue ← instantiateValueLevelParams cinfo fLvls
          let expanded1 := defValue.betaRev term.getAppRevArgs (useZeta := true)
          match expanded1.getAppFn with
          | Expr.const constName2 levels2 =>
            match (← getEnv).find? constName2 with
            | some cinfo2 =>
              if cinfo2.hasValue && cinfo2.levelParams.length == levels2.length &&
                 constName2 != cinfo.name then
                let defValue2 ← instantiateValueLevelParams cinfo2 levels2
                pure (defValue2.betaRev expanded1.getAppRevArgs (useZeta := true))
              else
                pure expanded1
            | _ => pure expanded1
          | _ => pure expanded1
        else
          pure term
    let normalized ← try
      Meta.zetaReduce exprToShow
    catch _ =>
      pure exprToShow
    let fmt ← Meta.withTransparency .default <| Meta.ppExpr normalized
    -- 直接输出到标准输出
    IO.println "===CONTENT_START==="
    IO.println fmt.pretty
    IO.println "===CONTENT_END==="

def {test_name} := @{def_name} {inst_type}

#show_def {test_name}
"""
    
    with tempfile.NamedTemporaryFile(mode='w', suffix='.lean', delete=False, dir=PROJECT_ROOT) as f:
        f.write(lean_content)
        temp_file = f.name
        temp_file_rel = os.path.relpath(temp_file, PROJECT_ROOT)
    
    try:
        # 先检查语法错误（使用 lean --check 或类似方式）
        # 尝试运行 lean 检查语法
        check_result = subprocess.run(
            ['lake', 'env', 'lean', '--check', temp_file_rel],
            cwd=PROJECT_ROOT,
            capture_output=True,
            text=True,
            timeout=15
        )
        
        check_output = check_result.stdout + check_result.stderr
        
        # 检查是否有语法错误
        if check_result.returncode != 0:
            # 检查是否是严重的语法错误（不是类型检查错误）
            if any(keyword in check_output.lower() for keyword in [
                "unknown identifier", "unknown constant", "expected", 
                "syntax error", "parse error", "unexpected token",
                "cannot apply", "type mismatch", "has type", "but is expected"
            ]):
                # 如果错误信息表明无法实例化（类型不匹配等），跳过
                error_lower = check_output.lower()
                # 如果明确是无法实例化的类型错误，返回 None
                if ("type" in error_lower and "mismatch" in error_lower) or \
                   ("cannot apply" in error_lower) or \
                   ("has type" in error_lower and "but is expected" in error_lower):
                    return None
        
        # 尝试运行 lean
        for attempt in range(max_retries):
            result = subprocess.run(
                ['lake', 'env', 'lean', '--run', temp_file_rel],
                cwd=PROJECT_ROOT,
                capture_output=True,
                text=True,
                timeout=30
            )
            
            output = result.stdout + result.stderr
            
            # 检查是否有语法错误
            if result.returncode != 0:
                error_lower = output.lower()
                # 如果是类型不匹配或其他无法实例化的错误，跳过
                if any(keyword in error_lower for keyword in [
                    "type mismatch", "cannot apply", "has type", "but is expected",
                    "type class instance", "failed to synthesize", "don't know how to synthesize"
                ]):
                    return None
            
            # 如果成功，提取内容
            if result.returncode == 0 or ("fun" in output and "=>" in output) or ("===CONTENT_START===" in output):
                content = extract_content_from_output(output)
                if content:
                    return {
                        "def": f"def {test_name} := @{def_name} {inst_type}",
                        "content": content,
                        "origin_def": def_name,
                        "Inst": inst_type
                    }
            
            # 如果失败是因为需要导入，尝试添加导入
            if "unknown" in output.lower() or "not found" in output.lower():
                # 添加基本导入
                lean_content_with_import = f"""import Init.Prelude
{lean_content}"""
                
                with tempfile.NamedTemporaryFile(mode='w', suffix='.lean', delete=False, dir=PROJECT_ROOT) as f2:
                    f2.write(lean_content_with_import)
                    temp_file2 = f2.name
                    temp_file2_rel = os.path.relpath(temp_file2, PROJECT_ROOT)
                
                # 再次检查语法
                check_result2 = subprocess.run(
                    ['lake', 'env', 'lean', '--check', temp_file2_rel],
                    cwd=PROJECT_ROOT,
                    capture_output=True,
                    text=True,
                    timeout=15
                )
                
                if check_result2.returncode != 0:
                    check_output2 = check_result2.stdout + check_result2.stderr
                    error_lower2 = check_output2.lower()
                    if ("type" in error_lower2 and "mismatch" in error_lower2) or \
                       ("cannot apply" in error_lower2) or \
                       ("has type" in error_lower2 and "but is expected" in error_lower2):
                        try:
                            os.unlink(temp_file2)
                        except:
                            pass
                        return None
                
                result2 = subprocess.run(
                    ['lake', 'env', 'lean', '--run', temp_file2_rel],
                    cwd=PROJECT_ROOT,
                    capture_output=True,
                    text=True,
                    timeout=30
                )
                output2 = result2.stdout + result2.stderr
                
                try:
                    os.unlink(temp_file2)
                except:
                    pass
                
                if result2.returncode != 0:
                    error_lower2 = output2.lower()
                    if any(keyword in error_lower2 for keyword in [
                        "type mismatch", "cannot apply", "has type", "but is expected",
                        "type class instance", "failed to synthesize"
                    ]):
                        return None
                
                if result2.returncode == 0 or ("fun" in output2 and "=>" in output2) or ("===CONTENT_START===" in output2):
                    content = extract_content_from_output(output2)
                    if content:
                        return {
                            "def": f"def {test_name} := @{def_name} {inst_type}",
                            "content": content,
                            "origin_def": def_name,
                            "Inst": inst_type
                        }
                
                break  # 如果还是失败，放弃
        
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
    
    print(f"开始处理 {len(definitions)} 个定义，每个定义尝试 {len(instance_types)} 种实例化...")
    print(f"总共需要尝试 {len(definitions) * len(instance_types)} 次实例化\n")
    
    total_tasks = len(definitions) * len(instance_types)
    completed = 0
    successful = 0
    
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
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
                    results.append(result)
                    successful += 1
                    print(f"  [{completed}/{total_tasks}] ✓ {def_name} -> {inst_type}")
                else:
                    if completed % 50 == 0:
                        print(f"  [{completed}/{total_tasks}] 处理中... (成功: {successful})")
            except Exception as e:
                completed += 1
                if completed % 50 == 0:
                    print(f"  [{completed}/{total_tasks}] 处理中... (成功: {successful})")
    
    return results


def main():
    print("="*80)
    print("实例化定义并展开")
    print("="*80)
    print()
    
    # 加载定义列表
    definitions = load_definitions()
    print(f"从 axiom_extract.py 加载了 {len(definitions)} 个定义")
    
    if not definitions:
        print("错误: 无法加载定义列表")
        return
    
    # 处理定义
    results = process_definitions(definitions, INSTANCE_TYPES)
    
    # 保存结果
    output_file = os.path.join(PROJECT_ROOT, "Analysis", "instantiated_defs.json")
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(results, f, indent=2, ensure_ascii=False)
    
    print("\n" + "="*80)
    print("处理完成")
    print("="*80)
    print(f"成功实例化 {len(results)} 个定义")
    print(f"结果已保存到: {output_file}")
    print("="*80)


if __name__ == "__main__":
    main()

