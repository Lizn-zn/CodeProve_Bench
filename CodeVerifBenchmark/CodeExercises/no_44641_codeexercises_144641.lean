import Mathlib

namespace no_44641_codeexercises_144641


-- Precondition definitions
@[reducible, simp]
def check_values_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  ∃ i, i < numbers.length ∧ numbers.get! i < 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def check_values (numbers : List Int) (h_precond : check_values_precond (numbers)) : Option Int :=
  -- !benchmark @start code
  let rec loop (idx : Nat) : Option Int :=
    if h : idx < numbers.length then
      let current := numbers.get! idx
      if not (current ≥ 0) then
        some current
      else
        loop (idx + 1)
    else
      none
  loop 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def check_values_postcond (numbers : List Int) (result: Option Int) (h_precond : check_values_precond (numbers)) : Prop :=
  -- !benchmark @start postcond
  match result with
  | none => ∀ i, i < numbers.length → numbers.get! i ≥ 0
  | some r => ∃ i, i < numbers.length ∧ numbers.get! i = r ∧ r < 0 ∧ ∀ j, j < i → numbers.get! j ≥ 0
  -- !benchmark @end postcond


-- Proof content
theorem check_values_postcond_satisfied (numbers: List Int) (h_precond : check_values_precond (numbers)) :
    check_values_postcond (numbers) (check_values (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_44641_codeexercises_144641