import Mathlib

namespace no_35259_codeexercises_135259


-- Precondition definitions
@[reducible, simp]
def get_runner_name_precond (runners : List (Nat × String)) (position : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def get_runner_name (runners : List (Nat × String)) (position : Nat) (h_precond : get_runner_name_precond (runners) (position)) : String :=
  -- !benchmark @start code
  match runners.find? (λ (p, _) => p = position) with
  | some (_, name) => name
  | none => "Unknown"
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def find_runner_by_position (runners : List (Nat × String)) (position : Nat) : Option String :=
  match runners.find? (λ (p, _) => p = position) with
  | some (_, name) => some name
  | none => none

-- Postcondition definitions
@[reducible, simp]
def get_runner_name_postcond (runners : List (Nat × String)) (position : Nat) (result: String) (h_precond : get_runner_name_precond (runners) (position)) : Prop :=
  -- !benchmark @start postcond
  result = match find_runner_by_position runners position with
    | some name => name
    | none => "Unknown"
  -- !benchmark @end postcond


-- Proof content
theorem get_runner_name_postcond_satisfied (runners: List (Nat × String)) (position: Nat) (h_precond : get_runner_name_precond (runners) (position)) :
    get_runner_name_postcond (runners) (position) (get_runner_name (runners) (position) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_35259_codeexercises_135259