import Mathlib

namespace no_59580_codeexercises_159580


-- Precondition definitions
@[reducible, simp]
def pattern_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def pattern (n : Nat) (h_precond : pattern_precond (n)) : String :=
  -- !benchmark @start code
  let numbers := List.range n |>.map (· + 1) |>.map toString
    let row := String.intercalate " " numbers
    String.intercalate "\n" (List.replicate n row)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def pattern_rows (n : Nat) : List String :=
  match n with
  | 0 => []
  | n+1 => 
    let numbers := List.range n |>.map (· + 1) |>.map toString
    let row := String.intercalate " " numbers
    List.replicate (n + 1) row

-- Postcondition definitions
@[reducible, simp]
def pattern_postcond (n : Nat) (result: String) (h_precond : pattern_precond (n)) : Prop :=
  -- !benchmark @start postcond
  result = String.intercalate "\n" (pattern_rows n)
  -- !benchmark @end postcond


-- Proof content
theorem pattern_postcond_satisfied (n: Nat) (h_precond : pattern_precond (n)) :
    pattern_postcond (n) (pattern (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_59580_codeexercises_159580