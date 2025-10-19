import Mathlib

-- Precondition definitions
@[reducible, simp]
def filter_natural_numbers_precond (n : Nat) (arr : Array Nat) (x : Int) (k : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- none


-- Main function definitions
def filter_natural_numbers (n : Nat) (arr : Array Nat) (x : Int) (k : Nat) (h_precond : filter_natural_numbers_precond n arr x k) : Finset Nat :=
  -- !benchmark @start code
  let candidates := Finset.filter (λ m => 
    m ≤ n ∧ 
    (if h : m < arr.size then 
      (if 0 ≤ x then arr[m]'h = x.natAbs else True) 
     else False) ∧ 
    (if k > 0 then k ∣ m else True)) (Finset.range (n + 1))
  candidates
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def filter_natural_numbers_postcond (n : Nat) (arr : Array Nat) (x : Int) (k : Nat) (result: Finset Nat) (h_precond : filter_natural_numbers_precond n arr x k) : Prop :=
  -- !benchmark @start postcond
  ∀ (m : Nat), m ∈ result ↔ 
    m ≤ n ∧ 
    (if h : m < arr.size then 
      (if 0 ≤ x then arr[m]'h = x.natAbs else True) 
     else False) ∧ 
    (if k > 0 then k ∣ m else True)
  -- !benchmark @end postcond


-- Proof content
theorem filter_natural_numbers_postcond_satisfied (n: Nat) (arr: Array Nat) (x: Int) (k: Nat) (h_precond : filter_natural_numbers_precond n arr x k) :
    filter_natural_numbers_postcond n arr x k (filter_natural_numbers n arr x k h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof