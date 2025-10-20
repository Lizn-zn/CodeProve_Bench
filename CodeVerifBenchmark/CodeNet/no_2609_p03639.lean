import Mathlib

namespace no_2609_p03639


-- Precondition definitions
@[reducible, simp]
def canArrangeSequence_precond (n : Nat) (a : List Nat) : Prop :=
  -- !benchmark @start precond
  n ≥ 2 ∧ a.length = n ∧ (∀ x ∈ a, x ≥ 1)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute the "cnt" value from the Python code
-- For each element:
-- - If divisible by 4: add 2 to cnt
-- - If divisible by 2 but not 4: add 1 to cnt
-- - If odd: add 0 to cnt
def computeCnt (a : List Nat) : Nat :=
  a.foldl (fun acc x =>
    if x % 2 != 0 then acc
    else if x % 4 != 0 then acc + 1
    else acc + 2
  ) 0

-- Main function definitions
def canArrangeSequence (n : Nat) (a : List Nat) (h_precond : canArrangeSequence_precond (n) (a)) : Bool :=
  -- !benchmark @start code
  let cnt := computeCnt a
  -- Check if cnt / 2 >= n / 2
  cnt / 2 >= n / 2
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper to check if a number is divisible by 2 but not by 4
def isDivisibleBy2NotBy4 (x : Nat) : Bool :=
  x % 2 == 0 && x % 4 != 0

-- Helper to check if a number is divisible by 4
def isDivisibleBy4 (x : Nat) : Bool :=
  x % 4 == 0

-- Count elements divisible by 2 but not by 4
def countDiv2NotDiv4 (a : List Nat) : Nat :=
  a.filter isDivisibleBy2NotBy4 |>.length

-- Count elements divisible by 4
def countDiv4 (a : List Nat) : Nat :=
  a.filter isDivisibleBy4 |>.length

-- Count odd elements
def countOdd (a : List Nat) : Nat :=
  a.filter (fun x => x % 2 != 0) |>.length

-- Check if a permutation exists where consecutive products are divisible by 4
def existsValidPermutation (a : List Nat) : Prop :=
  ∃ perm : List Nat, perm.Perm a ∧
    ∀ i : Fin (perm.length - 1), (perm[i.val]! * perm[i.val + 1]!) % 4 = 0

-- Postcondition definitions
@[reducible, simp]
def canArrangeSequence_postcond (n : Nat) (a : List Nat) (result: Bool) (h_precond : canArrangeSequence_precond (n) (a)) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ existsValidPermutation a
  -- !benchmark @end postcond


-- Proof content
theorem canArrangeSequence_postcond_satisfied (n: Nat) (a: List Nat) (h_precond : canArrangeSequence_precond (n) (a)) :
    canArrangeSequence_postcond (n) (a) (canArrangeSequence (n) (a) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2609_p03639