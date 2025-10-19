import Mathlib

-- Precondition definitions
@[reducible, simp]
def repeat_chars_precond (pairs : List (Char × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def repeat_char (c : Char) (n : Nat) : String :=
  String.mk (List.replicate n c)

-- Main function definitions
def repeat_chars (pairs : List (Char × Nat)) (h_precond : repeat_chars_precond pairs) : List String :=
  -- !benchmark @start code
  match pairs with
  | [] => []
  | (c, n) :: rest => 
    let current := repeat_char c n
    let rest_result := repeat_chars rest (by simp [repeat_chars_precond, h_precond])
    current :: rest_result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def expected_result (pairs : List (Char × Nat)) : List String :=
  pairs.map (λ (c, n) => repeat_char c n)

-- Postcondition definitions
@[reducible, simp]
def repeat_chars_postcond (pairs : List (Char × Nat)) (result: List String) (h_precond : repeat_chars_precond pairs) : Prop :=
  -- !benchmark @start postcond
  result = expected_result pairs
  -- !benchmark @end postcond


-- Proof content
theorem repeat_chars_postcond_satisfied (pairs: List (Char × Nat)) (h_precond : repeat_chars_precond pairs) :
    repeat_chars_postcond pairs (repeat_chars pairs h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof