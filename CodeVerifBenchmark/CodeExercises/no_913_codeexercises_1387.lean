import Mathlib

-- Precondition definitions
@[reducible, simp]
def create_tuples_precond (strings : String) (delimiter : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the implementation

-- Main function definitions
def create_tuples (strings : String) (delimiter : String) (h_precond : create_tuples_precond (strings) (delimiter)) : List (Nat × String) :=
  -- !benchmark @start code
  let words := strings.splitOn delimiter
  List.enumFrom 0 (words.map (λ s => s.toList.reverse.asString))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def splitString (s : String) (delimiter : String) : List String :=
  if delimiter.isEmpty then
    [s]
  else
    s.splitOn delimiter

def reverseString (s : String) : String :=
  s.toList.reverse.asString

def createExpectedTuples (strings : String) (delimiter : String) : List (Nat × String) :=
  let words := splitString strings delimiter
  List.enumFrom 0 (words.map reverseString)

-- Postcondition definitions
@[reducible, simp]
def create_tuples_postcond (strings : String) (delimiter : String) (result: List (Nat × String)) (h_precond : create_tuples_precond (strings) (delimiter)) : Prop :=
  -- !benchmark @start postcond
  result = createExpectedTuples strings delimiter
  -- !benchmark @end postcond


-- Proof content
theorem create_tuples_postcond_satisfied (strings: String) (delimiter: String) (h_precond : create_tuples_precond (strings) (delimiter)) :
    create_tuples_postcond (strings) (delimiter) (create_tuples (strings) (delimiter) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

