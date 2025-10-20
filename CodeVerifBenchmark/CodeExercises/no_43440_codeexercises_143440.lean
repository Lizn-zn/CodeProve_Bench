import Mathlib

namespace no_43440_codeexercises_143440


-- Precondition definitions
@[reducible, simp]
def index_and_loop_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def find_first_divisible_by_five_index (numbers : List Int) : Option (Nat × Int) :=
  let rec loop (idx : Nat) (nums : List Int) : Option (Nat × Int) :=
    match nums with
    | [] => none
    | n :: ns => 
      if n % 5 = 0 then some (idx, n)
      else loop (idx + 1) ns
  loop 0 numbers

-- Main function definitions
def index_and_loop (numbers : List Int) (h_precond : index_and_loop_precond (numbers)) : Int :=
  -- !benchmark @start code
  match find_first_divisible_by_five_index numbers with
  | some (idx, n) => n * (Int.ofNat idx)
  | none => (-1 : Int)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- (find_first_divisible_by_five_index moved to code auxiliary definitions)

-- Postcondition definitions
@[reducible, simp]
def index_and_loop_postcond (numbers : List Int) (result: Int) (h_precond : index_and_loop_precond (numbers)) : Prop :=
  -- !benchmark @start postcond
  match find_first_divisible_by_five_index numbers with
  | some (idx, n) => result = n * (Int.ofNat idx)
  | none => result = (-1 : Int)
  -- !benchmark @end postcond


-- Proof content
theorem index_and_loop_postcond_satisfied (numbers: List Int) (h_precond : index_and_loop_precond (numbers)) :
    index_and_loop_postcond (numbers) (index_and_loop (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_43440_codeexercises_143440