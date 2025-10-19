import Mathlib

-- Precondition definitions
@[reducible, simp]
def maxDivisionOperations_precond (n : Nat) (numbers : List Nat) : Prop :=
  -- !benchmark @start precond
  n ≥ 1 ∧ numbers.length = n ∧ ∀ x ∈ numbers, x ≥ 1
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to count divisions for a single number
def countDivisionsForNumber (x : Nat) (acc : Nat := 0) : Nat :=
  if x = 0 then acc
  else if x % 2 = 1 then acc
  else countDivisionsForNumber (x / 2) (acc + 1)

-- Helper function to find minimum divisions across a list
def findMinDivisions (numbers : List Nat) : Nat :=
  match numbers with
  | [] => 0
  | [x] => countDivisionsForNumber x
  | x :: xs => min (countDivisionsForNumber x) (findMinDivisions xs)

-- Main function definitions
def maxDivisionOperations (n : Nat) (numbers : List Nat) (h_precond : maxDivisionOperations_precond (n) (numbers)) : Nat :=
  -- !benchmark @start code
  findMinDivisions numbers
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Count how many times a number can be divided by 2
def countDivisions (x : Nat) : Nat :=
  if x = 0 then 0
  else if x % 2 = 1 then 0
  else 1 + countDivisions (x / 2)

-- The minimum number of divisions across all numbers in the list
def minDivisions (numbers : List Nat) : Nat :=
  match numbers with
  | [] => 0
  | x :: xs => 
    match xs with
    | [] => countDivisions x
    | _ => min (countDivisions x) (minDivisions xs)

-- Postcondition definitions
@[reducible, simp]
def maxDivisionOperations_postcond (n : Nat) (numbers : List Nat) (result: Nat) (h_precond : maxDivisionOperations_precond (n) (numbers)) : Prop :=
  -- !benchmark @start postcond
  result = minDivisions numbers
  -- !benchmark @end postcond


-- Proof content
theorem maxDivisionOperations_postcond_satisfied (n: Nat) (numbers: List Nat) (h_precond : maxDivisionOperations_precond (n) (numbers)) :
    maxDivisionOperations_postcond (n) (numbers) (maxDivisionOperations (n) (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

