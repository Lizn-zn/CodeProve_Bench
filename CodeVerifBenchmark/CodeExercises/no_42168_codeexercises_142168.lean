import Mathlib

-- Precondition definitions
@[reducible, simp]
def create_biomed_tuple_precond (condition1 : Bool) (condition2 : Bool) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple function

-- Main function definitions
def create_biomed_tuple (condition1 : Bool) (condition2 : Bool) (h_precond : create_biomed_tuple_precond (condition1) (condition2)) : String × Nat :=
  -- !benchmark @start code
  match condition1, condition2 with
  | true, true => ("BiomedEngineer", 100)
  | true, false => ("Biomedical", 50)
  | false, true => ("Biomedical", 50)
  | false, false => ("Engineer", 10)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def create_biomed_tuple_postcond (condition1 : Bool) (condition2 : Bool) (result: String × Nat) (h_precond : create_biomed_tuple_precond (condition1) (condition2)) : Prop :=
  -- !benchmark @start postcond
  match condition1, condition2 with
  | true, true => result = ("BiomedEngineer", 100)
  | true, false => result = ("Biomedical", 50)
  | false, true => result = ("Biomedical", 50)
  | false, false => result = ("Engineer", 10)
  -- !benchmark @end postcond


-- Proof content
theorem create_biomed_tuple_postcond_satisfied (condition1: Bool) (condition2: Bool) (h_precond : create_biomed_tuple_precond (condition1) (condition2)) :
    create_biomed_tuple_postcond (condition1) (condition2) (create_biomed_tuple (condition1) (condition2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

