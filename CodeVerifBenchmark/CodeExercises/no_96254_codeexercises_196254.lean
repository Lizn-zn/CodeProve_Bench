import Mathlib

namespace no_96254_codeexercises_196254


-- Precondition definitions
@[reducible, simp]
def dancer_performance_precond (dance_moves : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed for this implementation

-- Main function definitions
def dancer_performance (dance_moves : List Nat) (h_precond : dancer_performance_precond (dance_moves)) : IO Unit :=
  -- !benchmark @start code
  let dance_move_for_beat (beat : Nat) : String :=
    if beat % 3 = 0 then "spin"
    else if beat % 2 = 0 then "jump"
    else "step"
  let output := dance_moves.map dance_move_for_beat
  IO.println (String.intercalate "\n" output)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def dance_move_for_beat (beat : Nat) : String :=
  if beat % 3 = 0 then "spin"
  else if beat % 2 = 0 then "jump"
  else "step"

def expected_output (dance_moves : List Nat) : List String :=
  dance_moves.map dance_move_for_beat

-- Postcondition definitions
@[reducible, simp]
def dancer_performance_postcond (dance_moves : List Nat) (result: IO Unit) (h_precond : dancer_performance_precond (dance_moves)) : Prop :=
  -- !benchmark @start postcond
  ∃ (output : List String), 
    output = expected_output dance_moves ∧ 
    IO.println (String.intercalate "\n" output) = result
  -- !benchmark @end postcond


-- Proof content
theorem dancer_performance_postcond_satisfied (dance_moves: List Nat) (h_precond : dancer_performance_precond (dance_moves)) :
    dancer_performance_postcond (dance_moves) (dancer_performance (dance_moves) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_96254_codeexercises_196254