import Mathlib

namespace no_2720_codeexercises_4116


-- Precondition definitions
@[reducible, simp]
def remove_even_numbers_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def remove_even_numbers (numbers : List Int) (h_precond : remove_even_numbers_precond (numbers)) : List Int :=
  -- !benchmark @start code
  match numbers with
  | [] => []
  | x :: xs =>
    if x % 2 = 0 then
      remove_even_numbers xs h_precond
    else
      x :: remove_even_numbers xs h_precond
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def remove_even_numbers_postcond (numbers : List Int) (result: List Int) (h_precond : remove_even_numbers_precond (numbers)) : Prop :=
  -- !benchmark @start postcond
  ∀ (x : Int), x ∈ result → x % 2 = 1 ∧ x ∈ numbers ∧
  ∀ (x : Int), x ∈ numbers → (x % 2 = 1 → x ∈ result) ∧ (x % 2 = 0 → x ∉ result)
  -- !benchmark @end postcond


-- Proof content
theorem remove_even_numbers_postcond_satisfied (numbers: List Int) (h_precond : remove_even_numbers_precond (numbers)) :
    remove_even_numbers_postcond (numbers) (remove_even_numbers (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2720_codeexercises_4116