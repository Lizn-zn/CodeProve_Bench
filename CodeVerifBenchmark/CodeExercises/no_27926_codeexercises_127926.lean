import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def print_negative_indexed_square_precond (size : Nat) : Prop :=
  -- !benchmark @start precond
  size > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the code

-- Main function definitions
def print_negative_indexed_square (size : Nat) (h_precond : print_negative_indexed_square_precond (size)) : IO Unit :=
  -- !benchmark @start code
  do
    let mut output_lines : List String := []
    
    -- First line: 1 2 3 4 5
    let first_line := String.intercalate " " ((List.range size).map (λ i => toString (i + 1)))
    output_lines := output_lines ++ [first_line]
    
    -- Middle lines
    if size > 2 then
      for i in [1:size-1] do
        let row_num := i + 1
        let left_num := toString row_num
        let right_num := toString (size - i)
        
        -- Calculate the number of spaces needed between numbers
        let num_spaces := (size - 2) * 2 + 1
        let spaces := String.mk (List.replicate num_spaces ' ')
        
        let middle_line := s!"{left_num}{spaces}{right_num}"
        output_lines := output_lines ++ [middle_line]
    
    -- Last line: 5 4 3 2 1
    let last_line := String.intercalate " " ((List.range size).map (λ i => toString (size - i)))
    output_lines := output_lines ++ [last_line]
    
    -- Print all lines
    for line in output_lines do
      IO.println line
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def expected_output (size : Nat) : List String :=
  let first_line := String.intercalate " " ((List.range size).map (λ i => toString (i + 1)))
  let last_line := String.intercalate " " ((List.range size).map (λ i => toString (size - i)))
  let middle_lines := 
    if size > 2 then
      (List.range (size - 2)).map (λ i => 
        let row_num := i + 2
        let left_num := toString row_num
        let right_num := toString (size - i - 1)
        let num_spaces := (size - 2) * 2 + 1
        let spaces := String.mk (List.replicate num_spaces ' ')
        s!"{left_num}{spaces}{right_num}"
      )
    else
      []
  [first_line] ++ middle_lines ++ [last_line]

-- Postcondition definitions
@[reducible, simp]
def print_negative_indexed_square_postcond (size : Nat) (result: IO Unit) (h_precond : print_negative_indexed_square_precond (size)) : Prop :=
  -- !benchmark @start postcond
  ∃ (output_lines : List String), 
    output_lines = expected_output size ∧
    (do for line in output_lines do IO.println line) = result
  -- !benchmark @end postcond


-- Proof content
theorem print_negative_indexed_square_postcond_satisfied (size: Nat) (h_precond : print_negative_indexed_square_precond (size)) :
    print_negative_indexed_square_postcond (size) (print_negative_indexed_square (size) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof