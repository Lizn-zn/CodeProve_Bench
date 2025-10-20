import Mathlib

namespace no_2557_p03584


-- Precondition definitions
@[reducible, simp]
def maxUtilitySum_precond (n : Nat) (k : Nat) (items : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  items.length = n ∧ k < 2^30 ∧ (∀ (item : Nat × Nat), item ∈ items → item.1 < 2^30 ∧ item.2 ≥ 1 ∧ item.2 ≤ 10^9)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to get the binary representation length (number of bits needed)
def numBits (n : Nat) : Nat :=
  if n = 0 then 1 else Nat.log2 n + 1

-- Helper function to generate candidate k values based on the algorithm
def generateCandidates (k : Nat) : List Nat :=
  let m := numBits k
  let rec aux (i : Nat) (now : Nat) (acc : List Nat) : List Nat :=
    if i >= m then acc
    else
      let bit := (k >>> (m - i - 1)) &&& 1
      let newAcc := if bit = 1 && i < m - 1 then
        (now + (1 <<< (m - i - 1)) - 1) :: acc
      else acc
      aux (i + 1) (now + bit * (1 <<< (m - i - 1))) newAcc
  k :: aux 0 0 []

-- Helper function to check if a ||| x = x (i.e., a is a subset of x in bitwise sense)
def bitwiseSubset (a x : Nat) : Bool :=
  (a ||| x) = x

-- Helper function to compute utility sum for a given candidate
def computeUtilityForCandidate (items : List (Nat × Nat)) (candidate : Nat) : Nat :=
  items.foldl (fun acc item =>
    if bitwiseSubset item.1 candidate then acc + item.2 else acc
  ) 0

-- Main computation function
def computeMaxUtility (items : List (Nat × Nat)) (k : Nat) : Nat :=
  let candidates := generateCandidates k
  candidates.foldl (fun maxVal candidate =>
    max maxVal (computeUtilityForCandidate items candidate)
  ) 0

-- Main function definitions
def maxUtilitySum (n : Nat) (k : Nat) (items : List (Nat × Nat)) (h_precond : maxUtilitySum_precond (n) (k) (items)) : Nat :=
  -- !benchmark @start code
  computeMaxUtility items k
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to compute bitwise OR of a list of naturals
def bitwiseOrList (nums : List Nat) : Nat :=
  nums.foldl (· ||| ·) 0

-- Helper function to check if a subset satisfies the OR constraint
def validSubset (subset : List (Nat × Nat)) (k : Nat) : Prop :=
  bitwiseOrList (subset.map (·.1)) ≤ k

-- Helper function to compute sum of utilities
def utilitySum (subset : List (Nat × Nat)) : Nat :=
  subset.foldl (fun acc item => acc + item.2) 0

-- Predicate to check if a list is a subset of another
def isSubsetOf (subset full : List (Nat × Nat)) : Prop :=
  ∀ x, x ∈ subset → x ∈ full

-- Postcondition definitions
@[reducible, simp]
def maxUtilitySum_postcond (n : Nat) (k : Nat) (items : List (Nat × Nat)) (result: Nat) (h_precond : maxUtilitySum_precond (n) (k) (items)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the maximum utility sum among all valid subsets
  (∃ (subset : List (Nat × Nat)), 
    isSubsetOf subset items ∧ 
    validSubset subset k ∧ 
    utilitySum subset = result) ∧
  (∀ (subset : List (Nat × Nat)), 
    isSubsetOf subset items → 
    validSubset subset k → 
    utilitySum subset ≤ result)
  -- !benchmark @end postcond


-- Proof content
theorem maxUtilitySum_postcond_satisfied (n: Nat) (k: Nat) (items: List (Nat × Nat)) (h_precond : maxUtilitySum_precond (n) (k) (items)) :
    maxUtilitySum_postcond (n) (k) (items) (maxUtilitySum (n) (k) (items) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2557_p03584