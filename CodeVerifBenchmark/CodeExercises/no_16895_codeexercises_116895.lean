import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_duplicates_precond (t : List α) (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_duplicates (t : List α) (n : Nat) (h_precond : find_duplicates_precond (t) (n)) : List α :=
  -- !benchmark @start code
  match n with
  | 0 => []
  | 1 => t
  | n + 1 => find_duplicates t n h_precond ++ t
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def replicate_concat (t : List α) (n : Nat) : List α :=
  match n with
  | 0 => []
  | n + 1 => replicate_concat t n ++ t

-- Postcondition definitions
@[reducible, simp]
def find_duplicates_postcond (t : List α) (n : Nat) (result: List α) (h_precond : find_duplicates_precond (t) (n)) : Prop :=
  -- !benchmark @start postcond
  result = replicate_concat t n
  -- !benchmark @end postcond


-- Proof content
theorem find_duplicates_postcond_satisfied (t: List α) (n: Nat) (h_precond : find_duplicates_precond (t) (n)) :
    find_duplicates_postcond (t) (n) (find_duplicates (t) (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

