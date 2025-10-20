import Mathlib

namespace no_2224_syn_1_iter_2224


-- Precondition definitions
@[reducible, simp]
def dedup_and_sort_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def dedup_and_sort (nums : List Nat) (h_precond : dedup_and_sort_precond (nums)) : List Nat :=
  -- !benchmark @start code
  let s : Finset Nat := nums.toFinset
  s.sort (fun a b => a ≤ b)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_sorted (l : List Nat) : Prop :=
  ∀ i j : Nat, i < j → j < l.length → ∀ x y, l.get? i = some x → l.get? j = some y → x ≤ y

def no_duplicates (l : List Nat) : Prop :=
  ∀ i j : Nat, i < j → j < l.length → ∀ x y, l.get? i = some x → l.get? j = some y → x ≠ y

-- Postcondition definitions
@[reducible, simp]
def dedup_and_sort_postcond (nums : List Nat) (result : List Nat) (h_precond : dedup_and_sort_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  let s := (nums.toFinset : Finset Nat).sort (fun a b => a ≤ b)
  result = s ∧ is_sorted result ∧ no_duplicates result
  -- !benchmark @end postcond


-- Proof content
theorem dedup_and_sort_postcond_satisfied (nums : List Nat) (h_precond : dedup_and_sort_precond (nums)) :
    dedup_and_sort_postcond nums (dedup_and_sort nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2224_syn_1_iter_2224