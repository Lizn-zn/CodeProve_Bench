import Mathlib

-- Precondition definitions
@[reducible, simp]
def maxOperationLength_precond (s : String) : Prop :=
  -- !benchmark @start precond
  s.length > 0 ∧ s.all (fun c => c = '0' ∨ c = '1')
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to convert String to List Char for easier indexing
def stringToCharList (s : String) : List Char := s.toList

-- Helper to get character at index (with bounds checking)
def getCharAt (s : String) (i : Nat) : Option Char :=
  s.toList.get? i

-- Helper to find the maximum of two natural numbers
def natMax (a b : Nat) : Nat :=
  if a ≥ b then a else b

-- Helper to find the minimum of two natural numbers
def natMin (a b : Nat) : Nat :=
  if a ≤ b then a else b

-- Main function definitions
def maxOperationLength (s : String) (h_precond : maxOperationLength_precond (s)) : Nat :=
  -- !benchmark @start code
  let n := s.length
  let chars := s.toList
  -- Initialize answer to the length of the string
  let ans := Id.run do
    let mut ans := n
    -- Check consecutive pairs for differences
    for i in [0:n-1] do
      let c1 := chars[i]!
      let c2 := chars[i+1]!
      if c1 ≠ c2 then
        -- When we find a position where adjacent characters differ,
        -- we need at least max(i+1, n-i-1) length operations
        let leftPart := i + 1
        let rightPart := n - i - 1
        let required := natMax leftPart rightPart
        ans := natMin ans required
    return ans
  ans
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper to flip a character
def flipChar (c : Char) : Char :=
  if c = '0' then '1' else '0'

-- Helper to flip a substring from index l to r (inclusive)
def flipSegment (s : String) (l r : Nat) : String :=
  let chars := s.toList
  let flipped := chars.mapIdx (fun i c => 
    if l ≤ i ∧ i ≤ r then flipChar c else c)
  ⟨flipped⟩

-- Check if a string is all zeros
def isAllZeros (s : String) : Bool :=
  s.all (fun c => c = '0')

-- Check if we can turn string s into all zeros using operations with minimum length K
def canMakeAllZeros (s : String) (K : Nat) : Prop :=
  ∃ (ops : List (Nat × Nat)), 
    -- Each operation is valid (within bounds and length ≥ K)
    (∀ op, op ∈ ops → op.1 < s.length ∧ op.2 < s.length ∧ op.1 ≤ op.2 ∧ op.2 - op.1 + 1 ≥ K) ∧
    -- Applying all operations results in all zeros
    (ops.foldl (fun str op => flipSegment str op.1 op.2) s).all (fun c => c = '0')

-- Postcondition definitions
@[reducible, simp]
def maxOperationLength_postcond (s : String) (result: Nat) (h_precond : maxOperationLength_precond (s)) : Prop :=
  -- !benchmark @start postcond
  -- result is at most the length of the string
  result ≤ s.length ∧
    -- We can turn all characters to '0' using operations of length ≥ result
    canMakeAllZeros s result ∧
    -- result is maximal: for any K > result, we cannot turn all characters to '0'
    (∀ K > result, K ≤ s.length → ¬canMakeAllZeros s K)
  -- !benchmark @end postcond


-- Proof content
theorem maxOperationLength_postcond_satisfied (s: String) (h_precond : maxOperationLength_precond (s)) :
    maxOperationLength_postcond (s) (maxOperationLength (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof