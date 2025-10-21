#!/usr/bin/env python3
"""
Simple test script: Compare CheckRec and LLM's judgement on recursion

coded by cursor
"""

import os
import subprocess
import random
import json
from pathlib import Path

PROJECT_ROOT = "/local/home/zenali/CodeVerif-Lean4"
BENCHMARK_DIR = os.path.join(PROJECT_ROOT, "CodeVerifBenchmark")

# Test configuration
NUM_SAMPLES = 10  # Number of files to randomly sample for testing

def get_random_lean_files(n=10):
    """Randomly get n .lean files"""
    all_files = []
    for root, dirs, files in os.walk(BENCHMARK_DIR):
        for file in files:
            if file.endswith('.lean'):
                all_files.append(os.path.join(root, file))
    
    return random.sample(all_files, min(n, len(all_files)))

def check_with_checkRec(file_path):
    """Check if recursive using CheckRec"""
    try:
        result = subprocess.run(
            ['lake', 'exe', 'check-rec', file_path],
            cwd=PROJECT_ROOT,
            capture_output=True,
            text=True,
            timeout=60
        )
        
        output = result.stdout + result.stderr
        
        # Determine if recursive
        is_recursive = False
        indicators = []
        
        if 'Direct recursion: Yes' in output:
            is_recursive = True
            indicators.append('direct_recursion')
        if 'Mutual recursion: Yes' in output:
            is_recursive = True
            indicators.append('mutual_recursion')
        if 'partial function' in output or 'partial keyword' in output:
            is_recursive = True
            indicators.append('partial')
        if 'Opaque definition' in output:
            is_recursive = True
            indicators.append('opaque')
        if 'opaque nested functions' in output:
            is_recursive = True
            indicators.append('opaque_nested')
            
        return is_recursive, indicators, output
        
    except Exception as e:
        return None, [], str(e)

def check_with_llm(file_path, file_content):
    """Check if recursive using LLM"""
    try:
        import openai
        
        client = openai.OpenAI(
            api_key="PLACEHOLDER",
            base_url="https://api.deepseek.com"
        )
        
        prompt = f"""Please analyze the following Lean 4 code file and determine if it contains recursive functions.

Answer only: Yes or No

Code file content:
```lean
{file_content}
```
"""

        response = client.chat.completions.create(
            model="deepseek-chat",
            messages=[{"role": "user", "content": prompt}],
            max_tokens=10
        )
        
        answer = response.choices[0].message.content.strip()
        is_recursive = 'Yes' in answer or 'yes' in answer
        
        return is_recursive, answer
        
    except Exception as e:
        return None, str(e)

def main():
    print("="*80)
    print("CheckRec vs LLM Comparison Test")
    print("="*80)
    
    # Get random files
    files = get_random_lean_files(NUM_SAMPLES)
    print(f"\nRandomly selected {len(files)} files for testing\n")
    
    results = []
    
    for i, file_path in enumerate(files, 1):
        filename = os.path.basename(file_path)
        print(f"[{i}/{len(files)}] Testing file: {filename}")
        
        # Read file content
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # CheckRec analysis
        checkRec_result, indicators, checkRec_output = check_with_checkRec(file_path)
        print(f"  CheckRec: {'recursive' if checkRec_result else 'non-recursive'} {indicators}")
        
        # LLM analysis
        llm_result, llm_response = check_with_llm(file_path, content)
        print(f"  LLM:      {'recursive' if llm_result else 'non-recursive'} ({llm_response})")
        
        # Comparison
        if checkRec_result is not None and llm_result is not None:
            match = "✓ match" if checkRec_result == llm_result else "✗ mismatch"
            print(f"  Result:   {match}")
        else:
            print(f"  Result:   skipped (error occurred)")
        
        print()
        
        results.append({
            'file': filename,
            'path': file_path,
            'checkRec': checkRec_result,
            'checkRec_indicators': indicators,
            'llm': llm_result,
            'llm_response': llm_response,
            'match': checkRec_result == llm_result if checkRec_result is not None and llm_result is not None else None
        })
    
    # Statistics
    valid_results = [r for r in results if r['match'] is not None]
    if valid_results:
        match_count = sum(1 for r in valid_results if r['match'])
        total = len(valid_results)
        
        print("="*80)
        print("Statistics")
        print("="*80)
        print(f"Valid tests: {total}")
        print(f"Matches: {match_count} ({match_count/total*100:.1f}%)")
        print(f"Mismatches: {total-match_count} ({(total-match_count)/total*100:.1f}%)")
        
        # Show mismatched files
        if match_count < total:
            print("\nMismatched files:")
            for r in results:
                if r['match'] is False:
                    print(f"  - {r['file']}")
                    print(f"    CheckRec: {'recursive' if r['checkRec'] else 'non-recursive'} {r['checkRec_indicators']}")
                    print(f"    LLM:      {'recursive' if r['llm'] else 'non-recursive'}")
    
    # Save results
    output_file = os.path.join(PROJECT_ROOT, "Analysis", "checkRec_llm_comparison.json")
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(results, f, indent=2, ensure_ascii=False)
    
    print(f"\nDetailed results saved to: {output_file}")
    print("="*80)

if __name__ == '__main__':
    main()

