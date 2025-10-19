import Mathlib

-- Precondition definitions
@[reducible, simp]
def delete_duplicates_precond (data : List (List α)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def delete_duplicates [DecidableEq α] (data : List (List α)) (h_precond : delete_duplicates_precond (data)) : List (List α) :=
  -- !benchmark @start code
  let result := data.dedup
  have h1 : result.Nodup := by
    simp [result, List.nodup_dedup]
  have h2 : ∀ (x : List α), x ∈ result ↔ x ∈ data := by
    intro x
    constructor
    · intro h
      simp [result] at h
      exact h
    · intro h
      simp [result, h]
  result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def delete_duplicates_postcond_aux (data : List (List α)) (result : List (List α)) : Prop :=
  result.Nodup ∧ ∀ (x : List α), x ∈ result ↔ x ∈ data

-- Postcondition definitions
@[reducible, simp]
def delete_duplicates_postcond (data : List (List α)) (result: List (List α)) (h_precond : delete_duplicates_precond (data)) : Prop :=
  -- !benchmark @start postcond
  delete_duplicates_postcond_aux data result
  -- !benchmark @end postcond


-- Proof content
theorem delete_duplicates_postcond_satisfied [DecidableEq α] (data: List (List α)) (h_precond : delete_duplicates_precond (data)) :
    delete_duplicates_postcond (data) (delete_duplicates (data) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof