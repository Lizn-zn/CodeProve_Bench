import Mathlib

namespace no_78516_codeexercises_178516


-- Precondition definitions
@[reducible, simp]
def sum_odd_numbers_greater_than_ten_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-
This auxiliary code defines a function that iterates through a list of natural numbers,
summing only those that are odd and greater than 10. The implementation uses a while loop
with a break statement and demonstrates proper precedence of logical operators.
-/

-- Main function definitions
def sum_odd_numbers_greater_than_ten (nums : List Nat) (h_precond : sum_odd_numbers_greater_than_ten_precond (nums)) : Nat :=
  -- !benchmark @start code
  let rec loop (sum i : Nat) : Nat :=
    if h : i < nums.length then
      let num := nums.get ⟨i, h⟩
      let new_sum := if num > 10 ∧ num % 2 = 1 then sum + num else sum
      loop new_sum (i + 1)
    else
      sum
  loop 0 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_odd_greater_than_ten (n : Nat) : Bool :=
  n > 10 ∧ n % 2 = 1

def sum_filtered (nums : List Nat) : Nat :=
  nums.foldl (λ acc n => if is_odd_greater_than_ten n then acc + n else acc) 0

-- Postcondition definitions
@[reducible, simp]
def sum_odd_numbers_greater_than_ten_postcond (nums : List Nat) (result: Nat) (h_precond : sum_odd_numbers_greater_than_ten_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result = sum_filtered nums
  -- !benchmark @end postcond


-- Proof content
theorem sum_odd_numbers_greater_than_ten_postcond_satisfied (nums: List Nat) (h_precond : sum_odd_numbers_greater_than_ten_precond (nums)) :
    sum_odd_numbers_greater_than_ten_postcond (nums) (sum_odd_numbers_greater_than_ten (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_78516_codeexercises_178516