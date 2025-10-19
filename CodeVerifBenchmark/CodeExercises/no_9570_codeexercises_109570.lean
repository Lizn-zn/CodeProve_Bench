import Mathlib

-- Precondition definitions
@[reducible, simp]
def identify_artifact_precond (artifacts : List (String × Nat)) : Prop :=
  -- !benchmark @start precond
  artifacts ≠ []
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to find the minimum element in a list with a custom comparison
def find_min_by {α : Type} (l : List α) (compare : α → α → Bool) : Option α :=
  match l with
  | [] => none
  | x :: xs => 
      let min_rest := find_min_by xs compare
      match min_rest with
      | none => some x
      | some y => if compare x y then some x else some y

-- Helper function to compare artifacts by age
def compare_artifacts (a b : String × Nat) : Bool :=
  a.2 ≤ b.2

-- Main function definitions
def identify_artifact (artifacts : List (String × Nat)) (h_precond : identify_artifact_precond (artifacts)) : String :=
  -- !benchmark @start code
  match artifacts with
  | [] => by
    exfalso
    exact h_precond rfl
  | _ => 
    let min_artifact := (find_min_by artifacts compare_artifacts).get!
    min_artifact.1
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_min_age (artifacts : List (String × Nat)) (name : String) : Prop :=
  ∃ (age : Nat), (name, age) ∈ artifacts ∧ 
  ∀ (other_name : String) (other_age : Nat), (other_name, other_age) ∈ artifacts → age ≤ other_age

-- Postcondition definitions
@[reducible, simp]
def identify_artifact_postcond (artifacts : List (String × Nat)) (result: String) (h_precond : identify_artifact_precond (artifacts)) : Prop :=
  -- !benchmark @start postcond
  is_min_age artifacts result
  -- !benchmark @end postcond


-- Proof content
theorem identify_artifact_postcond_satisfied (artifacts: List (String × Nat)) (h_precond : identify_artifact_precond (artifacts)) :
    identify_artifact_postcond (artifacts) (identify_artifact (artifacts) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

