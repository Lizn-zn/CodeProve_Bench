import Mathlib

namespace no_43659_codeexercises_143659


-- Precondition definitions
@[reducible, simp]
def count_even_precond (num_list : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def count_even (num_list : List Nat) (h_precond : count_even_precond num_list) : Nat :=
  -- !benchmark @start code
  let filtered := num_list.filter (λ n => n % 2 == 0)
  filtered.length
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_even (n : Nat) : Bool :=
  n % 2 == 0

-- Postcondition definitions
@[reducible, simp]
def count_even_postcond (num_list : List Nat) (result: Nat) (h_precond : count_even_precond num_list) : Prop :=
  -- !benchmark @start postcond
  result = (num_list.filter is_even).length
  -- !benchmark @end postcond


-- Proof content
theorem count_even_postcond_satisfied (num_list: List Nat) (h_precond : count_even_precond num_list) :
    count_even_postcond num_list (count_even num_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_43659_codeexercises_143659