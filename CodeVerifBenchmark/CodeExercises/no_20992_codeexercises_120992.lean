import Mathlib

namespace no_20992_codeexercises_120992


-- Precondition definitions
@[reducible, simp]
def dance_moves_precond (move : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
inductive DanceMove : Type where
  | spin : DanceMove
  | jump : DanceMove
  | slide : DanceMove
  | twist : DanceMove
  deriving DecidableEq

def parseDanceMove (move : String) : Option DanceMove :=
  match move with
  | "spin" => some DanceMove.spin
  | "jump" => some DanceMove.jump
  | "slide" => some DanceMove.slide
  | "twist" => some DanceMove.twist
  | _ => none

-- Main function definitions
def dance_moves (move : String) (h_precond : dance_moves_precond (move)) : String :=
  -- !benchmark @start code
  match parseDanceMove move with
  | some .spin => "Successfully performed spin move"
  | some .jump => "Successfully performed jump move" 
  | some .slide => "Successfully performed slide move"
  | some .twist => "Successfully performed twist move"
  | none => "Invalid dance move - breaking out"
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- (DanceMove and parseDanceMove already defined above)

-- Postcondition definitions
@[reducible, simp]
def dance_moves_postcond (move : String) (result: String) (h_precond : dance_moves_precond (move)) : Prop :=
  -- !benchmark @start postcond
  match parseDanceMove move with
  | some .spin => result = "Successfully performed spin move"
  | some .jump => result = "Successfully performed jump move"
  | some .slide => result = "Successfully performed slide move"
  | some .twist => result = "Successfully performed twist move"
  | none => result = "Invalid dance move - breaking out"
  -- !benchmark @end postcond


-- Proof content
theorem dance_moves_postcond_satisfied (move: String) (h_precond : dance_moves_precond (move)) :
    dance_moves_postcond (move) (dance_moves (move) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_20992_codeexercises_120992