import Mathlib

-- Precondition definitions
@[reducible, simp]
def check_species_found_precond (species : String) (data : List (List String)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def check_species_found (species : String) (data : List (List String)) (h_precond : check_species_found_precond (species) (data)) : Bool :=
  -- !benchmark @start code
  let rec check_inner_lists : List (List String) → Bool := λ data =>
      match data with
      | [] => false
      | inner_list :: rest => 
        if inner_list.contains species then true
        else check_inner_lists rest
  check_inner_lists data
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def check_species_found_postcond (species : String) (data : List (List String)) (result: Bool) (h_precond : check_species_found_precond (species) (data)) : Prop :=
  -- !benchmark @start postcond
  result = (∃ (inner_list : List String), inner_list ∈ data ∧ species ∈ inner_list)
  -- !benchmark @end postcond


-- Proof content
theorem check_species_found_postcond_satisfied (species: String) (data: List (List String)) (h_precond : check_species_found_precond (species) (data)) :
    check_species_found_postcond (species) (data) (check_species_found (species) (data) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof