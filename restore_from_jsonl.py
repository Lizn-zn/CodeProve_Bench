#!/usr/bin/env python3
import json
from pathlib import Path

# Read the JSONL file
jsonl_path = Path("/local/home/zenali/Code-Prover-New/Code-Prover/test_data_v10_16_with_proofs.jsonl")
base_path = Path("/local/home/zenali/CodeVerif-Lean4/CodeVerifBenchmark")

# Map source to directory
source_map = {
    "syn": "Syn",
    "leetcode": "LeetCode", 
    "codeexercises": "CodeExercises",
    "codenet": "CodeNet"
}

restored_count = 0
error_count = 0

with open(jsonl_path, 'r') as f:
    for line in f:
        try:
            data = json.loads(line.strip())
            problem_id = data['problem_id']
            formal_problem = data['formal_problem']
            source = data.get('source', '')
            
            # Determine the directory based on source
            if source.lower() in source_map:
                dir_name = source_map[source.lower()]
                file_path = base_path / dir_name / f"{problem_id}.lean"
                
                # Write the original content
                file_path.parent.mkdir(parents=True, exist_ok=True)
                with open(file_path, 'w') as out_f:
                    out_f.write(formal_problem)
                
                restored_count += 1
                if restored_count % 100 == 0:
                    print(f"Restored {restored_count} files...")
            else:
                print(f"Unknown source '{source}' for problem {problem_id}")
                error_count += 1
                
        except Exception as e:
            print(f"Error processing line: {e}")
            error_count += 1

print(f"\n✅ Restoration complete!")
print(f"   Restored: {restored_count} files")
print(f"   Errors: {error_count}")

