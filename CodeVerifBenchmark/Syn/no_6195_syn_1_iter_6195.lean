import Mathlib

namespace no_6195_syn_1_iter_6195


-- Precondition definitions
@[reducible, simp]
def fizzBuzzPair_precond (a : Nat) (b : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond the provided fizzBuzzCondition

-- Main function definitions
def fizzBuzzPair (a : Nat) (b : Nat) (h_precond : fizzBuzzPair_precond (a) (b)) : List String :=
  -- !benchmark @start code
  if a % 3 = 0 && b % 5 = 0 then
    ["FizzBuzz"]
  else if a % 3 = 0 then
    ["Fizz"]
  else if b % 5 = 0 then
    ["Buzz"]
  else
    []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def fizzBuzzCondition (a : Nat) (b : Nat) : List String :=
  let fizz := if a % 3 = 0 then ["Fizz"] else []
  let buzz := if b % 5 = 0 then ["Buzz"] else []
  match fizz, buzz with
  | ["Fizz"], ["Buzz"] => ["FizzBuzz"]
  | ["Fizz"], [] => ["Fizz"]
  | [], ["Buzz"] => ["Buzz"]
  | [], [] => []
  | _, _ => []  -- This case should never occur but is included for completeness

-- Postcondition definitions
@[reducible, simp]
def fizzBuzzPair_postcond (a : Nat) (b : Nat) (result: List String) (h_precond : fizzBuzzPair_precond (a) (b)) : Prop :=
  -- !benchmark @start postcond
  result = fizzBuzzCondition a b
  -- !benchmark @end postcond


-- Proof content
theorem fizzBuzzPair_postcond_satisfied (a: Nat) (b: Nat) (h_precond : fizzBuzzPair_precond (a) (b)) :
    fizzBuzzPair_postcond (a) (b) (fizzBuzzPair (a) (b) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_6195_syn_1_iter_6195