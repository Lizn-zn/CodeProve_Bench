#!/usr/bin/env python3
"""
临时脚本：找出所有使用 List.length, List.foldl, List.map, List.filter 其中一个的题目编号

使用完后可以删除
"""

import os
import subprocess
import json
import re
from collections import defaultdict
from concurrent.futures import ProcessPoolExecutor, as_completed

PROJECT_ROOT = "/local/home/zenali/CodeVerif-Lean4"
BENCHMARK_DIR = os.path.join(PROJECT_ROOT, "CodeVerifBenchmark")
ANALYSIS_DIR = os.path.join(PROJECT_ROOT, "Analysis")

# List functions to track
TARGET_LIST_FUNCTIONS = ['List.length', 'List.foldl', 'List.map', 'List.filter']

MAX_WORKERS = 64  # Number of concurrent workers

os.makedirs(ANALYSIS_DIR, exist_ok=True)


def extract_problem_id(file_path):
    """Extract problem ID from file path (e.g., no_1756_leetcode_3463.lean -> 1756)"""
    basename = os.path.basename(file_path)
    # Pattern: no_{id}_{category}_{another_id}.lean
    match = re.match(r'no_(\d+)_', basename)
    if match:
        return match.group(1)
    # For verina files: verina_basic_1.lean -> verina_basic_1
    match = re.match(r'verina_(basic|advanced)_(\d+)\.lean', basename)
    if match:
        return f"verina_{match.group(1)}_{match.group(2)}"
    return None


def find_lean_files():
    """Find all .lean files"""
    files = []
    for root, dirs, filenames in os.walk(BENCHMARK_DIR):
        for filename in filenames:
            if filename.endswith('.lean'):
                files.append(os.path.join(root, filename))
    return files


def check_file_dependencies(file_path):
    """Check if file uses any of the target List functions"""
    problem_id = extract_problem_id(file_path)
    relative_path = os.path.relpath(file_path, BENCHMARK_DIR)
    
    result = {
        'problem_id': problem_id,
        'path': relative_path,
        'functions_used': [],
        'error': None
    }
    
    try:
        # Check dependencies
        dep_result = subprocess.run(
            ['lake', 'exe', 'check-deps', file_path],
            cwd=PROJECT_ROOT,
            capture_output=True,
            text=True,
            timeout=300
        )
        
        dep_output = dep_result.stdout + dep_result.stderr
        
        # Extract Init dependencies
        in_init_section = False
        for line in dep_output.split('\n'):
            if '[Init] Dependencies from Core Library:' in line:
                in_init_section = True
                continue
            elif in_init_section:
                if line.strip().startswith('-'):
                    dep = line.strip()[1:].strip()
                    # Check if this dependency is one of our target List functions
                    if dep in TARGET_LIST_FUNCTIONS:
                        result['functions_used'].append(dep)
                elif line.strip() == '' or line.strip().startswith('[Mathlib]') or line.strip().startswith('[Std]') or line.strip().startswith('[Local]'):
                    in_init_section = False
        
        if result['functions_used']:
            print(f"  [FOUND] {os.path.basename(file_path)}: {', '.join(result['functions_used'])}")
        
    except subprocess.TimeoutExpired:
        result['error'] = 'TIMEOUT'
        print(f"  [TIMEOUT] {os.path.basename(file_path)}")
    except Exception as e:
        result['error'] = str(e)
        print(f"  [ERROR] {os.path.basename(file_path)}: {e}")
    
    return result


def main():
    print("="*80)
    print("查找使用 List.length, List.foldl, List.map, List.filter 的题目编号")
    print("="*80)
    
    # Find all lean files
    print("\n正在查找所有 .lean 文件...")
    all_files = find_lean_files()
    print(f"找到 {len(all_files)} 个文件\n")
    
    # Check files concurrently
    print(f"正在分析 {len(all_files)} 个文件 (使用 {MAX_WORKERS} 个进程)...\n")
    results = []
    
    with ProcessPoolExecutor(max_workers=MAX_WORKERS) as executor:
        # Submit all tasks
        future_to_file = {
            executor.submit(check_file_dependencies, file_path): file_path
            for file_path in all_files
        }
        
        # Collect results as they complete
        for future in as_completed(future_to_file):
            try:
                result = future.result()
                results.append(result)
            except Exception as e:
                file_path = future_to_file[future]
                print(f"  [EXCEPTION] {os.path.basename(file_path)}: {e}")
                results.append({
                    'problem_id': extract_problem_id(file_path),
                    'path': os.path.relpath(file_path, BENCHMARK_DIR),
                    'functions_used': [],
                    'error': f'EXCEPTION: {str(e)}'
                })
    
    # Filter files that use target functions
    files_using_target_functions = [
        r for r in results 
        if r['functions_used'] and r['problem_id']
    ]
    
    # Group by function
    problem_ids_by_function = defaultdict(set)
    all_problem_ids = set()
    
    for r in files_using_target_functions:
        all_problem_ids.add(r['problem_id'])
        for func in r['functions_used']:
            problem_ids_by_function[func].add(r['problem_id'])
    
    # Print summary
    print("\n" + "="*80)
    print("结果汇总")
    print("="*80)
    print(f"使用目标函数的文件数: {len(files_using_target_functions)}")
    print(f"唯一题目编号数: {len(all_problem_ids)}")
    print(f"\n按函数分类:")
    for func in TARGET_LIST_FUNCTIONS:
        ids = sorted(problem_ids_by_function[func], key=lambda x: (x.startswith('verina'), x))
        print(f"  {func}: {len(ids)} 个题目")
    
    print(f"\n所有使用目标 List 函数的题目编号 ({len(all_problem_ids)} 个):")
    sorted_problem_ids = sorted(all_problem_ids, key=lambda x: (x.startswith('verina'), x))
    
    for pid in sorted_problem_ids:
        # Find which functions this problem uses
        funcs_used = set()
        for r in files_using_target_functions:
            if r['problem_id'] == pid:
                funcs_used.update(r['functions_used'])
        funcs_str = ', '.join(sorted(funcs_used))
        print(f"  {pid} ({funcs_str})")
    
    # Save results to JSON
    output_file = os.path.join(ANALYSIS_DIR, "list_functions_usage_temp.json")
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump({
            'target_functions': TARGET_LIST_FUNCTIONS,
            'total_files_using_target_functions': len(files_using_target_functions),
            'unique_problem_ids': sorted(list(all_problem_ids)),
            'problem_ids_by_function': {
                func: sorted(list(ids)) 
                for func, ids in problem_ids_by_function.items()
            },
            'detailed_files': files_using_target_functions
        }, f, indent=2, ensure_ascii=False)
    
    print(f"\n结果已保存到: {output_file}")
    print("="*80)


if __name__ == '__main__':
    main()

