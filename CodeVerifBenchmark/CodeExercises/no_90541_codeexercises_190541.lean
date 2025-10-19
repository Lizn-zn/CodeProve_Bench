import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def find_non_dancers_precond (dancers : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the implementation

-- Main function definitions
def find_non_dancers (dancers : List String) (h_precond : find_non_dancers_precond (dancers)) : List String :=
  -- !benchmark @start code
  let result : List String := []
  dancers.foldl (λ acc dancer => if dancer != "dancer" then dancer :: acc else acc) result |>.reverse
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- No auxiliary definitions needed for postcondition

-- Postcondition definitions
@[reducible, simp]
def find_non_dancers_postcond (dancers : List String) (result: List String) (h_precond : find_non_dancers_precond (dancers)) : Prop :=
  -- !benchmark @start postcond
  result = dancers.filter (λ dancer => dancer != "dancer")
  -- !benchmark @end postcond


-- Proof content
theorem find_non_dancers_postcond_satisfied (dancers: List String) (h_precond : find_non_dancers_precond (dancers)) :
    find_non_dancers_postcond (dancers) (find_non_dancers (dancers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof