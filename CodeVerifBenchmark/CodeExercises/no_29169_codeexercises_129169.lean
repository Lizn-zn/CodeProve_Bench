import Mathlib

-- Precondition definitions
@[reducible, simp]
def draw_square_precond (side_length : Nat) : Prop :=
  -- !benchmark @start precond
  side_length > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
def replicateString (c : Char) (n : Nat) : String :=
  String.mk (List.replicate n c)

def generateSquareLine (side_length : Nat) (i : Nat) : String :=
  if i = 0 ∨ i = side_length - 1 then
    replicateString '*' side_length
  else
    let middle := replicateString ' ' (side_length - 2)
    "*" ++ middle ++ "*"

-- Main function definitions
def draw_square (side_length : Nat) (h_precond : draw_square_precond (side_length)) : String :=
  -- !benchmark @start code
  let rec loop (i : Nat) (result : String) : String :=
    if h : i < side_length then
      let new_result := result ++ generateSquareLine side_length i
      let final_result := if i < side_length - 1 then new_result ++ "\n" else new_result
      loop (i + 1) final_result
    else
      result
  loop 0 ""
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def isSquareString (s : String) (side_length : Nat) : Prop :=
  let lines := s.splitOn "\n"
  lines.length = side_length ∧
  (∀ line, line ∈ lines → line.length = side_length) ∧
  (∀ (i : Fin lines.length), 
    let line := lines.get i
    if i.val = 0 ∨ i.val = side_length - 1 then
      line = String.mk (List.replicate side_length '*')
    else
      line = String.mk (['*'] ++ List.replicate (side_length - 2) ' ' ++ ['*']))

-- Postcondition definitions
@[reducible, simp]
def draw_square_postcond (side_length : Nat) (result: String) (h_precond : draw_square_precond (side_length)) : Prop :=
  -- !benchmark @start postcond
  isSquareString result side_length
  -- !benchmark @end postcond


-- Proof content
theorem draw_square_postcond_satisfied (side_length: Nat) (h_precond : draw_square_precond (side_length)) :
    draw_square_postcond (side_length) (draw_square (side_length) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof