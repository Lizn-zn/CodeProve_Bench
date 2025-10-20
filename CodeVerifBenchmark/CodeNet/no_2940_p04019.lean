import Mathlib

namespace no_2940_p04019


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def canReturnHome_precond (s : String) : Prop :=
  -- !benchmark @start precond
  -- The string s should consist only of characters 'N', 'W', 'S', 'E'
  s.all (fun c => c = 'N' ∨ c = 'W' ∨ c = 'S' ∨ c = 'E')
  -- !benchmark @end precond


-- Postcondition auxiliary definitions
-- Helper function to check if a character is in the string
def containsChar (s : String) (c : Char) : Bool :=
  s.any (fun x => x = c)

-- Helper function to count occurrences of a character in a string
def countChar (s : String) (c : Char) : Nat :=
  s.foldl (fun acc ch => if ch = c then acc + 1 else acc) 0

-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already in postcond_aux

-- Main function definitions
def canReturnHome (s : String) (h_precond : canReturnHome_precond (s)) : String :=
  -- !benchmark @start code
  let hasN := containsChar s 'N'
  let hasS := containsChar s 'S'
  let hasW := containsChar s 'W'
  let hasE := containsChar s 'E'
  if (hasN == hasS) && (hasW == hasE) then
    "Yes"
  else
    "No"
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def canReturnHome_postcond (s : String) (result: String) (h_precond : canReturnHome_precond (s)) : Prop :=
  -- !benchmark @start postcond
  -- The result is "Yes" if and only if:
  -- - Both 'N' and 'S' appear in the string, or neither appears
  -- - AND both 'W' and 'E' appear in the string, or neither appears
  -- This ensures that for each direction, there's an opposite direction to cancel it out
  (result = "Yes" ↔ 
    (containsChar s 'N' = containsChar s 'S') ∧ 
    (containsChar s 'W' = containsChar s 'E')) ∧
  (result = "Yes" ∨ result = "No")
  -- !benchmark @end postcond


-- Proof content
theorem canReturnHome_postcond_satisfied (s: String) (h_precond : canReturnHome_precond (s)) :
    canReturnHome_postcond (s) (canReturnHome (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2940_p04019