import Tools.CheckDeps

/-
This file demonstrates how to use the dependency checking tool to analyze
what libraries Lean4 definitions use.

Note: To analyze specific definitions, you need to import the corresponding module first.
Example: import CodeVerifBenchmark.LeetCode.no_22_leetcode_23
-/

-- Method 1: Use #module_of to view module sources of constants (no module import needed)
#module_of List.flatMap List.mergeSort List.filter

/-
Method 2: Analyze specific definitions (requires importing the module first)

Example:
import CodeVerifBenchmark.LeetCode.no_22_leetcode_23

-- Analyze a single definition
#check_deps no_22_leetcode_23.flattenAndSort

-- Analyze an entire namespace
#check_namespace no_22_leetcode_23

-- Use directly in code
open DependencyChecker in
#eval show Lean.MetaM Unit from do
  Lean.Meta.IO.println "\n🔍 Custom analysis:"
  analyzeConstant `no_22_leetcode_23.mergeTwoSortedLists
-/

/-
Recommended: Use the executable file method to analyze any file:

lake exe check-deps CodeVerifBenchmark/LeetCode/no_22_leetcode_23.lean
lake exe check-deps CodeVerifBenchmark/CodeExercises/no_864_codeexercises_1316.lean
-/
