#!/usr/bin/env python3
"""
提取使用 List 函数的题目，并使用 deepseek API 提取相关引理

根据 find_list_functions_temp.py 的结果，找出所有使用 List.length, List.foldl, 
List.map, List.filter 的题目，然后使用 deepseek API 为每道题提取证明过程中需要的最基本 lemma。
"""

import os
import json
import re
import time
from openai import OpenAI
from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import Dict, List, Optional

PROJECT_ROOT = "/local/home/zenali/CodeVerif-Lean4"
BENCHMARK_DIR = os.path.join(PROJECT_ROOT, "CodeVerifBenchmark")
ANALYSIS_DIR = os.path.join(PROJECT_ROOT, "Analysis")
INPUT_JSON = os.path.join(ANALYSIS_DIR, "list_functions_usage_temp.json")
OUTPUT_JSON = os.path.join(ANALYSIS_DIR, "list_functions_lemmas_extracted.json")

# 目标函数列表
TARGET_FUNCTIONS = ['List.length', 'List.foldl', 'List.map', 'List.filter']

# Deepseek API 配置
DEEPSEEK_MODEL = "deepseek-chat"  # 或者 "deepseek-coder"
API_KEY = os.environ.get('DEEPSEEK_API_KEY', "sk-e64c2fb5c4fe476ca67feda8c310b3f9")
MAX_WORKERS = 10  # 并发请求数
REQUEST_TIMEOUT = 120  # 请求超时时间（秒）

os.makedirs(ANALYSIS_DIR, exist_ok=True)

# 创建 OpenAI 客户端（用于 Deepseek）
# 客户端是线程安全的，可以在多个线程中共享使用
deepseek_client = OpenAI(
    api_key=API_KEY,
    base_url="https://api.deepseek.com",
    timeout=REQUEST_TIMEOUT
)


def load_problems_by_function(data: Dict) -> Dict[str, Dict[str, List[str]]]:
    """按函数分类，将问题ID映射到文件路径"""
    # 结构: {function_name: {problem_id: [paths]}}
    problems_by_function = {func: {} for func in TARGET_FUNCTIONS}
    
    for file_info in data.get('detailed_files', []):
        functions_used = file_info.get('functions_used', [])
        problem_id = file_info.get('problem_id')
        path = file_info.get('path')
        
        if problem_id and path:
            for func in TARGET_FUNCTIONS:
                if func in functions_used:
                    if problem_id not in problems_by_function[func]:
                        problems_by_function[func][problem_id] = []
                    problems_by_function[func][problem_id].append(path)
    
    return problems_by_function


def find_lean_file_by_path(relative_path: str) -> Optional[str]:
    """根据相对路径找到完整的 .lean 文件路径"""
    # 尝试直接路径
    full_path = os.path.join(BENCHMARK_DIR, relative_path)
    if os.path.exists(full_path):
        return full_path
    
    # 如果直接路径不存在，尝试在 BENCHMARK_DIR 下递归查找文件名
    filename = os.path.basename(relative_path)
    for root, dirs, files in os.walk(BENCHMARK_DIR):
        if filename in files:
            return os.path.join(root, filename)
    
    return None


def read_lean_file(file_path: str) -> Optional[str]:
    """读取 .lean 文件内容"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return f.read()
    except Exception as e:
        print(f"  读取文件失败 {file_path}: {e}")
        return None


def call_deepseek_api(problem_code: str, function_name: str) -> Optional[str]:
    """调用 deepseek API 提取引理"""
    # 将 List.map 转换为 list.map 等格式用于 prompt（例如：List.map -> list.map）
    func_name_for_prompt = function_name.lower()
    
    prompt = f"This problem involves the function {func_name_for_prompt}, please help me write the most basic lemma that is needed to prove this problem."
    
    full_prompt = f"""You are a Lean 4 expert. Below is the code of a problem that uses {function_name}:

```lean
{problem_code}
```

{prompt}
"""
    
    try:
        response = deepseek_client.chat.completions.create(
            model=DEEPSEEK_MODEL,
            messages=[
                {"role": "system", "content": "You are a Lean 4 expert."},
                {"role": "user", "content": full_prompt}
            ],
            temperature=0.3,
            max_tokens=2000
        )
        
        if response.choices and len(response.choices) > 0:
            return response.choices[0].message.content.strip()
        else:
            return None
            
    except Exception as e:
        error_msg = str(e)
        if "timeout" in error_msg.lower() or "timed out" in error_msg.lower():
            return "TIMEOUT"
        elif "api" in error_msg.lower() or "http" in error_msg.lower():
            return f"API_ERROR: {error_msg}"
        else:
            return f"ERROR: {error_msg}"


def process_problem(problem_id: str, file_paths: List[str], function_name: str) -> Dict:
    """处理一道题目，提取引理"""
    result = {
        'problem_id': problem_id,
        'function_name': function_name,
        'file_paths': file_paths,
        'lemma': None,
        'error': None,
        'api_response': None
    }
    
    # 尝试读取第一个文件
    file_content = None
    for rel_path in file_paths:
        full_path = find_lean_file_by_path(rel_path)
        if full_path:
            file_content = read_lean_file(full_path)
            if file_content:
                result['file_path_used'] = rel_path
                break
    
    if not file_content:
        result['error'] = "无法读取任何文件"
        return result
    
    # 调用 API
    print(f"  处理题目 {problem_id} ({function_name})...")
    api_result = call_deepseek_api(file_content, function_name)
    
    result['api_response'] = api_result
    if api_result and not api_result.startswith(('TIMEOUT', 'API_ERROR', 'ERROR')):
        result['lemma'] = api_result
    else:
        result['error'] = api_result
    
    return result


def main():
    print("="*80)
    print("提取使用 List 函数的题目引理")
    print(f"目标函数: {', '.join(TARGET_FUNCTIONS)}")
    print("="*80)
    
    # 读取 JSON 文件
    print("\n正在读取 JSON 文件...")
    try:
        with open(INPUT_JSON, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception as e:
        print(f"读取 JSON 文件失败: {e}")
        return
    
    # 按函数分类获取题目
    problems_by_function = load_problems_by_function(data)
    
    print("\n找到的题目统计:")
    total_unique_problems = set()
    for func in TARGET_FUNCTIONS:
        count = len(problems_by_function[func])
        total_unique_problems.update(problems_by_function[func].keys())
        print(f"  {func}: {count} 道题目")
    print(f"\n总共 {len(total_unique_problems)} 道唯一题目\n")
    
    # 检查是否有已保存的结果
    existing_results = {}
    if os.path.exists(OUTPUT_JSON):
        try:
            with open(OUTPUT_JSON, 'r', encoding='utf-8') as f:
                existing_data = json.load(f)
                # 使用 (problem_id, function_name) 作为键
                existing_results = {
                    (item['problem_id'], item['function_name']): item 
                    for item in existing_data.get('results', [])
                }
            print(f"发现已保存的结果，已处理 {len(existing_results)} 个问题-函数组合")
        except:
            pass
    
    # 生成所有需要处理的任务
    tasks_to_process = []
    for func in TARGET_FUNCTIONS:
        for problem_id, paths in problems_by_function[func].items():
            key = (problem_id, func)
            if key not in existing_results:
                tasks_to_process.append((problem_id, paths, func))
    
    if tasks_to_process:
        print(f"需要处理 {len(tasks_to_process)} 个任务\n")
        
        # 并发处理
        results = []
        # 创建任务映射以便在异常时查找
        task_info_map = {(pid, func): paths for pid, paths, func in tasks_to_process}
        
        with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
            future_to_task = {
                executor.submit(process_problem, pid, paths, func): (pid, func)
                for pid, paths, func in tasks_to_process
            }
            
            for future in as_completed(future_to_task):
                problem_id, func = future_to_task[future]
                try:
                    result = future.result()
                    results.append(result)
                    if result.get('lemma'):
                        print(f"  [成功] {problem_id} ({func})")
                    else:
                        print(f"  [失败] {problem_id} ({func}): {result.get('error', '未知错误')}")
                except Exception as e:
                    print(f"  [异常] {problem_id} ({func}): {e}")
                    paths = task_info_map.get((problem_id, func), [])
                    results.append({
                        'problem_id': problem_id,
                        'function_name': func,
                        'file_paths': paths,
                        'lemma': None,
                        'error': f'EXCEPTION: {str(e)}'
                    })
                
                # 避免 API 速率限制
                time.sleep(0.5)
        
        # 合并新结果和已有结果
        all_results = list(existing_results.values()) + results
    else:
        print("所有题目已处理完成！")
        all_results = list(existing_results.values())
    
    # 按函数统计
    stats_by_function = {func: {'total': 0, 'successful': 0} for func in TARGET_FUNCTIONS}
    for r in all_results:
        func = r.get('function_name', '')
        if func in stats_by_function:
            stats_by_function[func]['total'] += 1
            if r.get('lemma'):
                stats_by_function[func]['successful'] += 1
    
    # 保存结果
    output_data = {
        'target_functions': TARGET_FUNCTIONS,
        'total_tasks': len(all_results),
        'successful_tasks': len([r for r in all_results if r.get('lemma')]),
        'stats_by_function': stats_by_function,
        'results': all_results
    }
    
    with open(OUTPUT_JSON, 'w', encoding='utf-8') as f:
        json.dump(output_data, f, indent=2, ensure_ascii=False)
    
    print("\n" + "="*80)
    print("结果汇总")
    print("="*80)
    print(f"总任务数: {len(all_results)}")
    print(f"成功提取引理: {len([r for r in all_results if r.get('lemma')])}")
    print(f"失败: {len([r for r in all_results if not r.get('lemma')])}")
    print(f"\n按函数分类统计:")
    for func in TARGET_FUNCTIONS:
        stats = stats_by_function[func]
        print(f"  {func}: {stats['successful']}/{stats['total']} 成功")
    print(f"\n结果已保存到: {OUTPUT_JSON}")
    print("="*80)


if __name__ == '__main__':
    main()

