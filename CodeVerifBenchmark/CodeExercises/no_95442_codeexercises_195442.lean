import Mathlib

namespace no_95442_codeexercises_195442


-- Precondition definitions
@[reducible, simp]
def sum_even_numbers_precond (numbers_list : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def isEven (n : Int) : Bool := n % 2 == 0

-- Main function definitions
def sum_even_numbers (numbers_list : List Int) (h_precond : sum_even_numbers_precond (numbers_list)) : Int :=
  -- !benchmark @start code
  let rec loop (sum : Int) (i : Nat) : Int :=
    if h : i < numbers_list.length then
      let num := numbers_list[i]'h
      if isEven num then
        loop (sum + num) (i + 1)
      else
        loop sum (i + 1)
    else
      sum
  loop 0 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sumEvenNumbers (nums : List Int) : Int :=
  nums.filter isEven |>.foldl (· + ·) 0

-- Postcondition definitions
@[reducible, simp]
def sum_even_numbers_postcond (numbers_list : List Int) (result: Int) (h_precond : sum_even_numbers_precond (numbers_list)) : Prop :=
  -- !benchmark @start postcond
  result = sumEvenNumbers numbers_list
  -- !benchmark @end postcond


-- Proof content
theorem sum_even_numbers_postcond_satisfied (numbers_list: List Int) (h_precond : sum_even_numbers_precond (numbers_list)) :
    sum_even_numbers_postcond (numbers_list) (sum_even_numbers (numbers_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_95442_codeexercises_195442