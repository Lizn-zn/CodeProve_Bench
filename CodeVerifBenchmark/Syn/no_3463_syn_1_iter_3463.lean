import Mathlib

-- Precondition definitions
@[reducible, simp]
def listToStrings_precond (l : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def listToStrings [ToString α] (l : List α) (h_precond : listToStrings_precond (l)) : List String :=
  -- !benchmark @start code
  match l with
  | [] => []
  | h :: t => (toString h) :: (listToStrings t h_precond)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def listToStrings_aux [ToString α] (l : List α) : List String :=
  match l with
  | [] => []
  | h :: t => (toString h) :: (listToStrings_aux t)

-- Postcondition definitions
@[reducible, simp]
def listToStrings_postcond [ToString α] (l : List α) (result: List String) (h_precond : listToStrings_precond (l)) : Prop :=
  -- !benchmark @start postcond
  result = listToStrings_aux l
  -- !benchmark @end postcond


-- Proof content
theorem listToStrings_postcond_satisfied [ToString α] (l: List α) (h_precond : listToStrings_precond (l)) :
    listToStrings_postcond (l) (listToStrings (l) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof