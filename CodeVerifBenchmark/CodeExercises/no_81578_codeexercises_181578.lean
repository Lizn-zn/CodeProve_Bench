import Mathlib

namespace no_81578_codeexercises_181578


-- Precondition definitions
@[reducible, simp]
def find_artifact_precond (archaeologist : String) (map : List (List Char)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def contains_artifact_bool (map : List (List Char)) : Bool :=
  map.any (λ row => row.contains 'X')

-- Main function definitions
def find_artifact (archaeologist : String) (map : List (List Char)) (h_precond : find_artifact_precond archaeologist map) : Bool :=
  -- !benchmark @start code
  let rec search_row : List Char → Bool := λ row =>
    match row with
    | [] => false
    | h::t => if h = 'X' then true else search_row t
  let rec search_map : List (List Char) → Bool := λ map =>
    match map with
    | [] => false
    | h::t => if search_row h then true else search_map t
  search_map map
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def contains_artifact (map : List (List Char)) : Prop :=
  ∃ (row : List Char) (h : row ∈ map), 'X' ∈ row

-- Postcondition definitions
@[reducible, simp]
def find_artifact_postcond (archaeologist : String) (map : List (List Char)) (result: Bool) (h_precond : find_artifact_precond archaeologist map) : Prop :=
  -- !benchmark @start postcond
  result = contains_artifact map
  -- !benchmark @end postcond


-- Proof content
theorem find_artifact_postcond_satisfied (archaeologist: String) (map: List (List Char)) (h_precond : find_artifact_precond archaeologist map) :
    find_artifact_postcond archaeologist map (find_artifact archaeologist map h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_81578_codeexercises_181578