import Mathlib

namespace no_61995_codeexercises_161995


-- Precondition definitions
@[reducible, simp]
def find_unique_numbers_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_unique_numbers (nums : List Int) (h_precond : find_unique_numbers_precond (nums)) : List Int :=
  -- !benchmark @start code
  nums.filter (λ x => nums.count x = 1)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_unique_in_list (x : Int) (nums : List Int) : Prop :=
  nums.count x = 1

def all_unique_numbers (nums : List Int) : List Int :=
  nums.filter (λ x => nums.count x = 1)

-- Postcondition definitions
@[reducible, simp]
def find_unique_numbers_postcond (nums : List Int) (result: List Int) (h_precond : find_unique_numbers_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result = all_unique_numbers nums ∧
  ∀ x : Int, x ∈ result ↔ is_unique_in_list x nums
  -- !benchmark @end postcond


-- Proof content
theorem find_unique_numbers_postcond_satisfied (nums: List Int) (h_precond : find_unique_numbers_precond (nums)) :
    find_unique_numbers_postcond (nums) (find_unique_numbers (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_61995_codeexercises_161995