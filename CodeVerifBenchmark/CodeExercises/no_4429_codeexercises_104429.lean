import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_common_letters_precond (actor1 : String) (actor2 : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_common_letters (actor1 : String) (actor2 : String) (h_precond : find_common_letters_precond (actor1) (actor2)) : Set Char :=
  -- !benchmark @start code
  let result : Set Char := actor1.foldl (λ acc c => if actor2.contains c then acc.insert c else acc) ∅
  result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def common_letters_set (s1 s2 : String) : Set Char :=
  {c | s1.contains c ∧ s2.contains c}

-- Postcondition definitions
@[reducible, simp]
def find_common_letters_postcond (actor1 : String) (actor2 : String) (result: Set Char) (h_precond : find_common_letters_precond (actor1) (actor2)) : Prop :=
  -- !benchmark @start postcond
  result = common_letters_set actor1 actor2
  -- !benchmark @end postcond


-- Proof content
theorem find_common_letters_postcond_satisfied (actor1: String) (actor2: String) (h_precond : find_common_letters_precond (actor1) (actor2)) :
    find_common_letters_postcond (actor1) (actor2) (find_common_letters (actor1) (actor2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof