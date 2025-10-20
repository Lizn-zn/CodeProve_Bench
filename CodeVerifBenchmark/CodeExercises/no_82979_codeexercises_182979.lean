import Mathlib

namespace no_82979_codeexercises_182979


-- Precondition definitions
@[reducible, simp]
def print_pattern_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def print_pattern_impl (n : Nat) : IO Unit := do
  for i in List.range n do
    for j in List.range n do
      let num := (i + 1) * (j + 1)
      IO.print (toString num ++ " ")
    IO.println ""

-- Main function definitions
def print_pattern (n : Nat) (h_precond : print_pattern_precond (n)) : IO Unit :=
  -- !benchmark @start code
  if n == 0 then
    pure ()
  else
    print_pattern_impl n
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def expected_pattern (n : Nat) : List (List Nat) :=
  List.range n |>.map (λ i => 
    List.range n |>.map (λ j => (i + 1) * (j + 1))
  )

def pattern_to_string (pattern : List (List Nat)) : String :=
  String.join (pattern.map (λ row => 
    String.join (row.map (λ num => toString num ++ " ")) ++ "\n"
  ))

-- Postcondition definitions
@[reducible, simp]
def print_pattern_postcond (n : Nat) (result: IO Unit) (h_precond : print_pattern_precond (n)) : Prop :=
  -- !benchmark @start postcond
  IO.println (pattern_to_string (expected_pattern n)) = result
  -- !benchmark @end postcond


-- Proof content
theorem print_pattern_postcond_satisfied (n: Nat) (h_precond : print_pattern_precond (n)) :
    print_pattern_postcond (n) (print_pattern (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_82979_codeexercises_182979