import Mathlib

-- Precondition definitions
@[reducible, simp]
def remove_duplicates_precond (names : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def remove_duplicates (names : List String) (h_precond : remove_duplicates_precond (names)) : List String :=
  -- !benchmark @start code
  match names with
  | [] => []
  | x :: xs =>
    let filtered := remove_duplicates xs h_precond
    if x ∈ filtered then filtered else x :: filtered
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def List.NoDuplicates {α : Type} [DecidableEq α] (l : List α) : Prop :=
  ∀ (i j : Nat) (hi : i < l.length) (hj : j < l.length), i < j → l.get ⟨i, hi⟩ ≠ l.get ⟨j, hj⟩

def List.toSet (l : List String) : Set String := {x | x ∈ l}

-- Postcondition definitions
@[reducible, simp]
def remove_duplicates_postcond (names : List String) (result: List String) (h_precond : remove_duplicates_precond (names)) : Prop :=
  -- !benchmark @start postcond
  result.NoDuplicates ∧ result.toSet = names.toSet
  -- !benchmark @end postcond


-- Proof content
theorem remove_duplicates_postcond_satisfied (names: List String) (h_precond : remove_duplicates_precond (names)) :
    remove_duplicates_postcond (names) (remove_duplicates (names) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
