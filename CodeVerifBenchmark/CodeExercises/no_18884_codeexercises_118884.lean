import Mathlib

namespace no_18884_codeexercises_118884


-- Precondition definitions
@[reducible, simp]
def count_unique_incomes_precond (incomes : List Int) (income_threshold : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def count_unique_incomes (incomes : List Int) (income_threshold : Int) (h_precond : count_unique_incomes_precond (incomes) (income_threshold)) : Nat :=
  -- !benchmark @start code
  let filtered_incomes := incomes.filter (λ x => x > income_threshold)
    let unique_incomes := filtered_incomes.eraseDups
    unique_incomes.length
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def unique_incomes_above_threshold (incomes : List Int) (income_threshold : Int) : Finset Int :=
  (incomes.filter (λ x => x > income_threshold)).toFinset

-- Postcondition definitions
@[reducible, simp]
def count_unique_incomes_postcond (incomes : List Int) (income_threshold : Int) (result: Nat) (h_precond : count_unique_incomes_precond (incomes) (income_threshold)) : Prop :=
  -- !benchmark @start postcond
  result = (unique_incomes_above_threshold incomes income_threshold).card
  -- !benchmark @end postcond


-- Proof content
theorem count_unique_incomes_postcond_satisfied (incomes: List Int) (income_threshold: Int) (h_precond : count_unique_incomes_precond (incomes) (income_threshold)) :
    count_unique_incomes_postcond (incomes) (income_threshold) (count_unique_incomes (incomes) (income_threshold) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_18884_codeexercises_118884