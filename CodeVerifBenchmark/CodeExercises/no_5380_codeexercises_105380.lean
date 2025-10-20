import Mathlib

namespace no_5380_codeexercises_105380


-- Precondition definitions
@[reducible, simp]
def find_unique_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to check if an element appears exactly once in the list
def occurs_once (nums : List Int) (x : Int) : Bool :=
  (nums.filter (λ n => n = x)).length = 1

-- Main function definitions
def find_unique (nums : List Int) (h_precond : find_unique_precond (nums)) : List Int :=
  -- !benchmark @start code
  -- Filter the list to keep only elements that occur exactly once
  (nums.filter (λ x => occurs_once nums x)).eraseDups
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_occurrences (nums : List Int) (x : Int) : Nat :=
  (nums.filter (λ n => n = x)).length

def is_unique_in (nums : List Int) (x : Int) : Prop :=
  count_occurrences nums x = 1

-- Postcondition definitions
@[reducible, simp]
def find_unique_postcond (nums : List Int) (result: List Int) (h_precond : find_unique_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  ∀ x, x ∈ result ↔ (x ∈ nums ∧ is_unique_in nums x)
  -- !benchmark @end postcond


-- Proof content
theorem find_unique_postcond_satisfied (nums: List Int) (h_precond : find_unique_precond (nums)) :
    find_unique_postcond (nums) (find_unique (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_5380_codeexercises_105380