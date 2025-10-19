import Mathlib

-- Precondition definitions
@[reducible, simp]
def remove_duplicates_from_list_precond (athlete_list : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def remove_duplicates_from_list (athlete_list : List String) (h_precond : remove_duplicates_from_list_precond (athlete_list)) : List String :=
  -- !benchmark @start code
  let unique_names := athlete_list.eraseDups
  unique_names
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def remove_duplicates_from_list_postcond_aux (athlete_list : List String) (l : List String) : Prop :=
  ∀ x : String, x ∈ l → x ∈ athlete_list

-- Postcondition definitions
@[reducible, simp]
def remove_duplicates_from_list_postcond (athlete_list : List String) (result: List String) (h_precond : remove_duplicates_from_list_precond (athlete_list)) : Prop :=
  -- !benchmark @start postcond
  List.Nodup result ∧ 
  ∀ x : String, x ∈ result ↔ x ∈ athlete_list
  -- !benchmark @end postcond


-- Proof content
theorem remove_duplicates_from_list_postcond_satisfied (athlete_list: List String) (h_precond : remove_duplicates_from_list_precond (athlete_list)) :
    remove_duplicates_from_list_postcond (athlete_list) (remove_duplicates_from_list (athlete_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof