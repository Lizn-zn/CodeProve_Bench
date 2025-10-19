import Mathlib

-- Precondition definitions
@[reducible, simp]
def multiply_odd_index_precond (numbers : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def multiply_odd_index (numbers : List Nat) (h_precond : multiply_odd_index_precond (numbers)) : List Nat :=
  -- !benchmark @start code
  match numbers with
  | [] => []
  | x0 :: xs =>
    let rec aux : Nat → List Nat → List Nat := λ
      | _, [] => []
      | i, x :: xs' => 
        if i % 2 = 1 then (x * 10) :: aux (i + 1) xs'
        else x :: aux (i + 1) xs'
    x0 :: aux 1 xs
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def multiply_odd_index_aux (numbers : List Nat) : List Nat :=
  numbers.enum.map (λ ⟨i, x⟩ => if i % 2 = 1 then x * 10 else x)

-- Postcondition definitions
@[reducible, simp]
def multiply_odd_index_postcond (numbers : List Nat) (result: List Nat) (h_precond : multiply_odd_index_precond (numbers)) : Prop :=
  -- !benchmark @start postcond
  result = multiply_odd_index_aux numbers
  -- !benchmark @end postcond


-- Proof content
theorem multiply_odd_index_postcond_satisfied (numbers: List Nat) (h_precond : multiply_odd_index_precond (numbers)) :
    multiply_odd_index_postcond (numbers) (multiply_odd_index (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

