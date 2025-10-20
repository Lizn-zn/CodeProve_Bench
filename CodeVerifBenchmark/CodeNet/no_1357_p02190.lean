import Mathlib

namespace no_1357_p02190


-- Precondition definitions
@[reducible, simp]
def countDistinctValues_precond (n : Nat) (a : List Nat) : Prop :=
  -- !benchmark @start precond
  -- The list length matches n and all elements are between 1 and 10^9
  a.length = n ∧ n ≥ 1 ∧ n ≤ 100000 ∧ ∀ x ∈ a, 1 ≤ x ∧ x ≤ 1000000000
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to convert list to a set-like structure and count distinct elements
def listToDistinctCount (l : List Nat) : Nat :=
  l.eraseDups.length

-- Helper function to insert element into list if not present
def insertIfAbsent (acc : List Nat) (x : Nat) : List Nat :=
  if acc.contains x then acc else x :: acc

-- Main function definitions
def countDistinctValues (n : Nat) (a : List Nat) (h_precond : countDistinctValues_precond (n) (a)) : Nat :=
  -- !benchmark @start code
  -- Count distinct values using eraseDups which removes duplicates
  a.eraseDups.length
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to count distinct elements in a list
def countDistinct (l : List Nat) : Nat :=
  l.foldl (fun acc x => if acc.contains x then acc else acc.concat x) [] |>.length

-- Alternative definition using eraseDups
def countDistinct' (l : List Nat) : Nat :=
  l.eraseDups.length

-- Postcondition definitions
@[reducible, simp]
def countDistinctValues_postcond (n : Nat) (a : List Nat) (result: Nat) (h_precond : countDistinctValues_precond (n) (a)) : Prop :=
  -- !benchmark @start postcond
  -- The result equals the number of distinct values in the list
  result = countDistinct a ∧ result = a.eraseDups.length
  -- !benchmark @end postcond


-- Proof content
theorem countDistinctValues_postcond_satisfied (n: Nat) (a: List Nat) (h_precond : countDistinctValues_precond (n) (a)) :
    countDistinctValues_postcond (n) (a) (countDistinctValues (n) (a) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1357_p02190