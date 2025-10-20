import Mathlib

namespace no_9903_codeexercises_15156


-- Precondition definitions
@[reducible, simp]
def count_even_elements_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def count_even_elements_aux (numbers : List Int) : Nat :=
  let rec loop (i : Nat) (count : Nat) : Nat :=
    if h : i < numbers.length then
      let num := numbers[i]!
      if num % 2 = 0 then
        loop (i + 1) (count + 1)
      else
        loop (i + 1) count
    else
      count
  loop 0 0

-- Main function definitions
def count_even_elements (numbers : List Int) (h_precond : count_even_elements_precond (numbers)) : Nat :=
  -- !benchmark @start code
  let rec loop (i : Nat) (count : Nat) : Nat :=
    if h : i < numbers.length then
      let num := numbers[i]!
      if num % 2 = 0 then
        loop (i + 1) (count + 1)
      else
        loop (i + 1) count
    else
      count
  loop 0 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_even (n : Int) : Bool := n % 2 = 0

def count_even_in_list (numbers : List Int) : Nat :=
  numbers.filter (λ n => is_even n) |>.length

-- Postcondition definitions
@[reducible, simp]
def count_even_elements_postcond (numbers : List Int) (result: Nat) (h_precond : count_even_elements_precond (numbers)) : Prop :=
  -- !benchmark @start postcond
  result = count_even_in_list numbers
  -- !benchmark @end postcond


-- Proof content
theorem count_even_elements_postcond_satisfied (numbers: List Int) (h_precond : count_even_elements_precond (numbers)) :
    count_even_elements_postcond (numbers) (count_even_elements (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_9903_codeexercises_15156