import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def shredding_company_precond (target : Nat) (paper_number : String) : Prop :=
  -- !benchmark @start precond
  -- The paper_number should be a valid non-empty string of digits
    -- with no leading zeros (unless it's just "0")
    paper_number.length > 0 ∧ 
    paper_number.length ≤ 6 ∧
    paper_number.all (fun c => c.isDigit) ∧
    (paper_number.length = 1 ∨ paper_number.get! 0 ≠ '0') ∧
    target > 0 ∧ 
    target ≤ 999999
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper to parse a string to a natural number
def parseNat (s : String) : Nat :=
  s.foldl (fun acc c => acc * 10 + (c.toNat - '0'.toNat)) 0

-- Helper to compute the sum of parsed parts
def sumParts (parts : List String) : Nat :=
  parts.foldl (fun acc p => acc + parseNat p) 0

-- Helper function to generate all partitions of a string
partial def generatePartitions (s : String) (start : Nat) : List (List String) :=
  if start >= s.length then
    [[]]
  else
    let rec helper (i : Nat) (acc : List (List String)) : List (List String) :=
      if i > s.length then
        acc
      else if i <= start then
        helper (i + 1) acc
      else
        let piece := s.extract ⟨start⟩ ⟨i⟩
        let subPartitions := generatePartitions s i
        let newPartitions := subPartitions.map (fun rest => piece :: rest)
        helper (i + 1) (acc ++ newPartitions)
    helper (start + 1) []

-- Find all partitions with their sums
def findAllPartitionsWithSums (paper_number : String) (target : Nat) : List (Nat × List String) :=
  let allPartitions := generatePartitions paper_number 0
  allPartitions.filterMap (fun parts =>
    if parts.isEmpty then none
    else
      let sum := sumParts parts
      if sum <= target then some (sum, parts) else none)

-- Find the maximum sum that doesn't exceed target
def findMaxSum (partitionsWithSums : List (Nat × List String)) : Option Nat :=
  partitionsWithSums.foldl (fun acc (sum, _) =>
    match acc with
    | none => some sum
    | some maxSum => some (max maxSum sum)) none

-- Count partitions with a given sum
def countPartitionsWithSum (partitionsWithSums : List (Nat × List String)) (targetSum : Nat) : Nat :=
  partitionsWithSums.filter (fun (sum, _) => sum = targetSum) |>.length

-- Get a partition with a given sum
def getPartitionWithSum (partitionsWithSums : List (Nat × List String)) (targetSum : Nat) : Option (List String) :=
  partitionsWithSums.find? (fun (sum, _) => sum = targetSum) |>.map (fun (_, parts) => parts)

-- Main function definitions
def shredding_company (target : Nat) (paper_number : String) (h_precond : shredding_company_precond (target) (paper_number)) : String :=
  -- !benchmark @start code
  let paper_value := parseNat paper_number
    
    -- Case 1: If target equals paper number, don't cut
    if paper_value = target then
      paper_value.repr ++ " " ++ paper_number
    else
      -- Find all valid partitions with their sums
      let partitionsWithSums := findAllPartitionsWithSums paper_number target
      
      -- Case 2: If no valid partition exists
      if partitionsWithSums.isEmpty then
        "error"
      else
        -- Find the maximum sum
        match findMaxSum partitionsWithSums with
        | none => "error"
        | some maxSum =>
          -- Count how many partitions have this maximum sum
          let count := countPartitionsWithSum partitionsWithSums maxSum
          
          -- Case 3: Multiple optimal partitions
          if count > 1 then
            "rejected"
          -- Case 4: Unique optimal partition
          else
            match getPartitionWithSum partitionsWithSums maxSum with
            | none => "error"
            | some parts =>
              maxSum.repr ++ " " ++ String.intercalate " " parts
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper to check if a list of strings represents a valid partition of the paper_number
def isValidPartition (paper_number : String) (parts : List String) : Prop :=
  parts.length > 0 ∧
  String.join parts = paper_number ∧
  parts.all (fun p => p.length > 0)

-- Helper to generate all valid partitions of a string
-- This is a specification-level definition
def allValidPartitions (s : String) : List (List String) :=
  -- This would generate all ways to partition the string
  -- For specification purposes, we define it axiomatically
  sorry

-- Check if there exists a unique optimal partition
def hasUniqueOptimalPartition (target : Nat) (paper_number : String) : Prop :=
  ∃! parts : List String, 
    isValidPartition paper_number parts ∧
    sumParts parts ≤ target ∧
    (∀ parts' : List String, 
      isValidPartition paper_number parts' ∧ sumParts parts' ≤ target →
      sumParts parts' ≤ sumParts parts)

-- Postcondition definitions
@[reducible, simp]
def shredding_company_postcond (target : Nat) (paper_number : String) (result: String) (h_precond : shredding_company_precond (target) (paper_number)) : Prop :=
  -- !benchmark @start postcond
  -- Parse the original paper number
    let paper_value := parseNat paper_number
    
    -- Case 1: If target equals paper_number, no cutting is done
    (paper_value = target → result = paper_value.repr ++ " " ++ paper_number) ∧
    
    -- Case 2: If no valid partition exists (all sums exceed target), return "error"
    ((∀ parts : List String, 
        isValidPartition paper_number parts → 
        sumParts parts > target) → 
      result = "error") ∧
    
    -- Case 3: If multiple optimal partitions exist, return "rejected"
    ((paper_value ≠ target ∧ 
      (∃ parts : List String, 
        isValidPartition paper_number parts ∧ 
        sumParts parts ≤ target) ∧
      ¬hasUniqueOptimalPartition target paper_number) →
      result = "rejected") ∧
    
    -- Case 4: If a unique optimal partition exists, return it
    ((paper_value ≠ target ∧ 
      hasUniqueOptimalPartition target paper_number) →
      ∃ parts : List String,
        isValidPartition paper_number parts ∧
        sumParts parts ≤ target ∧
        (∀ parts' : List String, 
          isValidPartition paper_number parts' ∧ 
          sumParts parts' ≤ target →
          sumParts parts' ≤ sumParts parts) ∧
        result = (sumParts parts).repr ++ " " ++ String.intercalate " " parts)
  -- !benchmark @end postcond


-- Proof content
theorem shredding_company_postcond_satisfied (target: Nat) (paper_number: String) (h_precond : shredding_company_precond (target) (paper_number)) :
    shredding_company_postcond (target) (paper_number) (shredding_company (target) (paper_number) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof