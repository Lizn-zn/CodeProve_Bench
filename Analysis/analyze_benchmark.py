#!/usr/bin/env python3
"""
Quick sampling analysis script - Analyze a small subset of files to get quick insights

Classifies files into two categories:
1. Non-recursive: Functions without any recursion
2. Potentially recursive: Functions with any form of recursion/loops including:
   - Direct recursion (function calls itself)
   - Mutual recursion (functions call each other)
   - Structural recursion (via pattern matching)
   - Uses known recursive functions (from standard library)
   - Partial definitions (unproven termination)
   - Opaque functions (body not accessible)
   - Functions using opaque nested helpers (partial def pattern)

Uses strict matching for CheckRec output to ensure accuracy.

coded by cursor
"""

import os
import subprocess
import json
import random
from pathlib import Path
from collections import defaultdict
from concurrent.futures import ProcessPoolExecutor, as_completed

PROJECT_ROOT = "/local/home/zenali/CodeVerif-Lean4"
BENCHMARK_DIR = os.path.join(PROJECT_ROOT, "CodeVerifBenchmark")
ANALYSIS_DIR = os.path.join(PROJECT_ROOT, "Analysis")

# Sampling size
SAMPLE_SIZE = -1  # Number of samples per category, use -1 for all files
MAX_WORKERS = 64  # Number of concurrent workers

os.makedirs(ANALYSIS_DIR, exist_ok=True)


def find_lean_files_by_category():
    """Find .lean files by category"""
    categories = {
        'LeetCode': [],
        'CodeExercises': [],
        'Syn': [],
        'CodeNet': [],
        'verina': []
    }
    
    for category in categories.keys():
        category_dir = os.path.join(BENCHMARK_DIR, category)
        if os.path.exists(category_dir):
            for file in os.listdir(category_dir):
                if file.endswith('.lean'):
                    categories[category].append(os.path.join(category_dir, file))
    
    return categories


def analyze_file(file_path, category=None):
    """Analyze a single file"""
    relative_path = os.path.relpath(file_path, BENCHMARK_DIR)
    
    result = {
        'path': relative_path,
        'category': category,
        'is_recursive': False,
        'recursion_indicators': [],
        'init_deps': [],
        'error': None
    }
    
    try:
        # Check for recursion
        rec_result = subprocess.run(
            ['lake', 'exe', 'check-rec', file_path],
            cwd=PROJECT_ROOT,
            capture_output=True,
            text=True,
            timeout=300
        )
        
        rec_output = rec_result.stdout + rec_result.stderr
        
        # Check for any form of recursion or opaque functions
        # These all indicate potential recursion (using strict matching)
        if 'Direct recursion: Yes' in rec_output:
            result['is_recursive'] = True
            result['recursion_indicators'].append('direct_recursion')
        if 'Mutual recursion: Yes' in rec_output:
            result['is_recursive'] = True
            result['recursion_indicators'].append('mutual_recursion')
        if 'OK: Conclusion: partial function' in rec_output or 'WARNING: Uses partial keyword' in rec_output:
            result['is_recursive'] = True
            result['recursion_indicators'].append('partial_def')
        if 'WARNING: Opaque definition' in rec_output:
            result['is_recursive'] = True
            result['recursion_indicators'].append('opaque')
        if 'Uses opaque nested functions (likely contains recursion)' in rec_output:
            result['is_recursive'] = True
            result['recursion_indicators'].append('opaque_nested_helpers')
        # Check if uses known recursive functions from library
        if 'Detected: Uses known recursive functions' in rec_output:
            result['is_recursive'] = True
            result['recursion_indicators'].append('uses_known_recursive')
        # Check for structural recursion via pattern matching
        if 'Detected: Structural recursion (via pattern matching)' in rec_output:
            result['is_recursive'] = True
            result['recursion_indicators'].append('structural_recursion')
        # Check summary line for recursive/opaque functions count
        if 'Recursive/Opaque functions:' in rec_output:
            for line in rec_output.split('\n'):
                if 'Recursive/Opaque functions:' in line and not line.strip().endswith(': 0'):
                    result['is_recursive'] = True
                    break
        
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
                    result['init_deps'].append(dep)
                elif line.strip() == '' or line.strip().startswith('[Mathlib]') or line.strip().startswith('[Std]') or line.strip().startswith('[Local]'):
                    in_init_section = False
        
        status = "potentially recursive" if result['is_recursive'] else "non-recursive"
        indicators = ", ".join(result['recursion_indicators']) if result['recursion_indicators'] else ""
        status_detail = f"{status} ({indicators})" if indicators else status
        
        print(f"  [OK] {os.path.basename(file_path)}: {status_detail}, Init deps: {len(result['init_deps'])}")
        
    except subprocess.TimeoutExpired:
        result['error'] = 'TIMEOUT'
        print(f"  [TIMEOUT] {os.path.basename(file_path)}")
    except Exception as e:
        result['error'] = str(e)
        print(f"  [ERROR] {os.path.basename(file_path)}: {e}")
    
    return result


def main():
    print("="*80)
    print("Quick Sampling Analysis")
    print("="*80)
    
    categories = find_lean_files_by_category()
    
    # Display file count per category
    print("\nFile count per category:")
    for category, files in categories.items():
        print(f"  {category}: {len(files)} files")
    
    # Sample files
    if SAMPLE_SIZE == -1:
        print(f"\nAnalyzing ALL files from each category...\n")
    else:
        print(f"\nSampling {SAMPLE_SIZE} files from each category for analysis...\n")
    
    # Prepare all files to analyze with their categories
    files_to_analyze = []
    for category, files in categories.items():
        if not files:
            continue
        
        if SAMPLE_SIZE == -1:
            # Use all files
            sampled_files = files
            sample_size = len(files)
        else:
            # Sample files
            sample_size = min(SAMPLE_SIZE, len(files))
            sampled_files = random.sample(files, sample_size)
        
        print(f"{category} ({sample_size} files):")
        for file_path in sampled_files:
            files_to_analyze.append((file_path, category))
    
    # Analyze files concurrently with processes
    print(f"\nAnalyzing {len(files_to_analyze)} files using {MAX_WORKERS} processes...\n")
    results = []
    
    with ProcessPoolExecutor(max_workers=MAX_WORKERS) as executor:
        # Submit all tasks
        future_to_file = {
            executor.submit(analyze_file, file_path, category): (file_path, category)
            for file_path, category in files_to_analyze
        }
        
        # Collect results as they complete
        for future in as_completed(future_to_file):
            try:
                result = future.result()
                results.append(result)
            except Exception as e:
                file_path, category = future_to_file[future]
                print(f"  [EXCEPTION] {os.path.basename(file_path)}: {e}")
                results.append({
                    'path': os.path.relpath(file_path, BENCHMARK_DIR),
                    'category': category,
                    'is_recursive': False,
                    'recursion_indicators': [],
                    'init_deps': [],
                    'error': f'EXCEPTION: {str(e)}'
                })
    
    # Statistics
    total = len(results)
    recursive_count = sum(1 for r in results if r['is_recursive'])
    non_recursive_count = total - recursive_count
    error_count = sum(1 for r in results if r['error'])
    
    # Count different types of recursion indicators
    recursion_types = defaultdict(int)
    for r in results:
        if r['is_recursive']:
            for indicator in r['recursion_indicators']:
                recursion_types[indicator] += 1
    
    # Init dependency statistics
    all_init_deps = set()
    dep_count = defaultdict(int)
    for r in results:
        for dep in r['init_deps']:
            all_init_deps.add(dep)
            dep_count[dep] += 1
    
    # Print summary
    print("\n" + "="*80)
    print("Sampling Analysis Summary")
    print("="*80)
    print(f"Total samples: {total}")
    print(f"Potentially recursive: {recursive_count} ({recursive_count/total*100:.1f}%)")
    if recursion_types:
        print(f"  Breakdown by type:")
        for rec_type, count in sorted(recursion_types.items(), key=lambda x: x[1], reverse=True):
            print(f"    - {rec_type}: {count}")
    print(f"Non-recursive: {non_recursive_count} ({non_recursive_count/total*100:.1f}%)")
    print(f"Analysis errors: {error_count}")
    print(f"\nUnique Init dependencies: {len(all_init_deps)}")
    print(f"\nMost common Init dependencies (top 20):")
    for dep, count in sorted(dep_count.items(), key=lambda x: x[1], reverse=True)[:20]:
        print(f"  {count:3d} ({count/total*100:5.1f}%) - {dep}")
    
    # Prepare path lists
    recursive_paths = [r['path'] for r in results if r['is_recursive']]
    non_recursive_paths = [r['path'] for r in results if not r['is_recursive']]
    error_paths = [r['path'] for r in results if r['error']]
    
    # Group by recursion type
    paths_by_type = defaultdict(list)
    for r in results:
        if r['is_recursive']:
            for indicator in r['recursion_indicators']:
                paths_by_type[indicator].append(r['path'])
    
    # Save summary
    summary_file = os.path.join(ANALYSIS_DIR, "sample_analysis_summary.json")
    with open(summary_file, 'w', encoding='utf-8') as f:
        json.dump({
            'statistics': {
                'total': total,
                'potentially_recursive': recursive_count,
                'non_recursive': non_recursive_count,
                'errors': error_count,
                'unique_init_deps': len(all_init_deps),
                'recursion_types': dict(recursion_types)
            },
            'potentially_recursive_files': sorted(recursive_paths),
            'non_recursive_files': sorted(non_recursive_paths),
            'error_files': sorted(error_paths),
            'files_by_recursion_type': {k: sorted(v) for k, v in paths_by_type.items()},
            'init_dependencies': {
                'frequency': dict(sorted(dep_count.items(), key=lambda x: x[1], reverse=True)),
                'all_deps': sorted(list(all_init_deps))
            }
        }, f, indent=2, ensure_ascii=False)
    
    # Save detailed results
    details_file = os.path.join(ANALYSIS_DIR, "sample_analysis_details.json")
    with open(details_file, 'w', encoding='utf-8') as f:
        json.dump({
            'total_analyzed': total,
            'results': results
        }, f, indent=2, ensure_ascii=False)
    
    print(f"\nResults saved to:")
    print(f"  Summary: {summary_file}")
    print(f"  Details: {details_file}")
    print("="*80)


if __name__ == '__main__':
    main()

