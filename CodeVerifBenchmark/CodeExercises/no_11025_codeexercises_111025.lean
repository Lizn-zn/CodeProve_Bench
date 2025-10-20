import Mathlib

namespace no_11025_codeexercises_111025


-- Precondition definitions
@[reducible, simp]
def find_criminal_precond (name : String) (list_of_criminals : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def find_criminal (name : String) (list_of_criminals : List String) (h_precond : find_criminal_precond (name) (list_of_criminals)) : Bool :=
  -- !benchmark @start code
  if list_of_criminals.isEmpty then
    false
  else
    let head := list_of_criminals.head!
    let tail := list_of_criminals.tail
    if name == head then
      true
    else
      find_criminal name tail h_precond
  -- !benchmark @end code
termination_by list_of_criminals.length
decreasing_by sorry


-- Postcondition definitions
@[reducible, simp]
def find_criminal_postcond (name : String) (list_of_criminals : List String) (result: Bool) (h_precond : find_criminal_precond (name) (list_of_criminals)) : Prop :=
  -- !benchmark @start postcond
  result = (name ∈ list_of_criminals)
  -- !benchmark @end postcond


-- Proof content
theorem find_criminal_postcond_satisfied (name: String) (list_of_criminals: List String) (h_precond : find_criminal_precond (name) (list_of_criminals)) :
    find_criminal_postcond (name) (list_of_criminals) (find_criminal (name) (list_of_criminals) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_11025_codeexercises_111025