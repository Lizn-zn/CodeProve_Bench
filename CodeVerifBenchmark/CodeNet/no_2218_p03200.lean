import Mathlib

-- Precondition definitions
@[reducible, simp]
def maxReversiOperations_precond (s : String) : Prop :=
  -- !benchmark @start precond
  s.length > 0 ∧ s.all (fun c => c = 'B' ∨ c = 'W')
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to process the string and count operations
def processString (s : String) : Nat :=
  let chars := s.toList
  let (_, result) := chars.foldl (fun (bCount, ops) c =>
    if c = 'B' then
      (bCount + 1, ops)
    else
      (bCount, ops + bCount)
  ) (0, 0)
  result

-- Main function definitions
def maxReversiOperations (s : String) (h_precond : maxReversiOperations_precond (s)) : Nat :=
  -- !benchmark @start code
  processString s
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Count the number of 'B's before each position
def countBsBefore (s : String) (pos : Nat) : Nat :=
  (s.take pos).toList.filter (· = 'B') |>.length

-- The maximum number of operations is the sum of B's before each W
def maxOperations (s : String) : Nat :=
  (List.range s.length).foldl (fun acc i =>
    if s.get ⟨i⟩ = 'W' then acc + countBsBefore s i else acc
  ) 0

-- Postcondition definitions
@[reducible, simp]
def maxReversiOperations_postcond (s : String) (result: Nat) (h_precond : maxReversiOperations_precond (s)) : Prop :=
  -- !benchmark @start postcond
  result = maxOperations s
  -- !benchmark @end postcond


-- Proof content
theorem maxReversiOperations_postcond_satisfied (s: String) (h_precond : maxReversiOperations_precond (s)) :
    maxReversiOperations_postcond (s) (maxReversiOperations (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof