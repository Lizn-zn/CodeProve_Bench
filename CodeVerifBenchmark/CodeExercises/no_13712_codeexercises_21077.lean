import Mathlib

-- Precondition definitions
@[reducible, simp]
def count_igneous_rocks_precond (rocks : List (List String)) : Prop :=
  -- !benchmark @start precond
  ∀ rock ∈ rocks, rock.length = 2
  -- !benchmark @end precond


-- Code auxiliary definitions
def is_igneous_rock (rock : List String) : Bool :=
  match rock with
  | [name, "igneous"] => true
  | _ => false

-- Main function definitions
def count_igneous_rocks (rocks : List (List String)) (h_precond : count_igneous_rocks_precond (rocks)) : Nat :=
  -- !benchmark @start code
  let filtered_rocks := rocks.filter is_igneous_rock
  filtered_rocks.length
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_igneous_rock_prop (rock : List String) : Prop :=
  match rock with
  | [name, "igneous"] => True
  | _ => False

-- Postcondition definitions
@[reducible, simp]
def count_igneous_rocks_postcond (rocks : List (List String)) (result: Nat) (h_precond : count_igneous_rocks_precond (rocks)) : Prop :=
  -- !benchmark @start postcond
  result = (rocks.filter (λ rock => is_igneous_rock rock)).length
  -- !benchmark @end postcond


-- Proof content
theorem count_igneous_rocks_postcond_satisfied (rocks: List (List String)) (h_precond : count_igneous_rocks_precond (rocks)) :
    count_igneous_rocks_postcond (rocks) (count_igneous_rocks (rocks) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof