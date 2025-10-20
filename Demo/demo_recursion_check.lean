import Tools.CheckRec
import CodeVerifBenchmark.LeetCode.no_22_leetcode_23

open RecursionChecker

-- Demo: Check if a single function is recursive
#check_rec no_22_leetcode_23.flattenAndSort

-- Demo: Check multiple functions
#check_rec List.flatMap List.mergeSort

-- Demo: Check all recursive functions in a namespace
#check_namespace_rec no_22_leetcode_23
