import Mathlib

-- Precondition definitions
@[reducible, simp]
def to_finset_precond (arr : Array (Nat ⊕ Int)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def to_finset (arr : Array (Nat ⊕ Int)) (h_precond : to_finset_precond (arr)) : Finset (Nat ⊕ Int) :=
  -- !benchmark @start code
  -- Convert array to list, filter out non-numeric elements (though all elements are Nat ⊕ Int),
  -- remove duplicates by converting to Finset
  arr.toList.toFinset
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def to_finset_postcond (arr : Array (Nat ⊕ Int)) (result: Finset (Nat ⊕ Int)) (h_precond : to_finset_precond (arr)) : Prop :=
  -- !benchmark @start postcond
  result = ((arr.toList.filterMap (λ x => match x with
    | Sum.inl n => some (Sum.inl n)
    | Sum.inr i => some (Sum.inr i))).toFinset)
  -- !benchmark @end postcond


-- Proof content
theorem to_finset_postcond_satisfied (arr: Array (Nat ⊕ Int)) (h_precond : to_finset_precond (arr)) :
    to_finset_postcond (arr) (to_finset (arr) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof