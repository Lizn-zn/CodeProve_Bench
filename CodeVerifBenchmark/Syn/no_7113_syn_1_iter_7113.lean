import Mathlib

-- Precondition definitions
@[reducible, simp]
def process_natural_pair_precond (a : Nat) (b : Nat) (arr : Array Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def process_natural_pair (a : Nat) (b : Nat) (arr : Array Nat) (h_precond : process_natural_pair_precond (a) (b) (arr)) : List Char :=
  -- !benchmark @start code
  let sum := a + b
  if h : sum < arr.size then
    let element := arr[sum]
    (toString element).data
  else
    "out_of_bounds".data
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def getElementOrDefault (arr : Array Nat) (idx : Nat) : String :=
  if h : idx < arr.size then
    toString (arr[idx])
  else
    "out_of_bounds"

-- Postcondition definitions
@[reducible, simp]
def process_natural_pair_postcond (a : Nat) (b : Nat) (arr : Array Nat) (result: List Char) (h_precond : process_natural_pair_precond (a) (b) (arr)) : Prop :=
  -- !benchmark @start postcond
  result = (getElementOrDefault arr (a + b)).data
  -- !benchmark @end postcond


-- Proof content
theorem process_natural_pair_postcond_satisfied (a: Nat) (b: Nat) (arr: Array Nat) (h_precond : process_natural_pair_precond (a) (b) (arr)) :
    process_natural_pair_postcond (a) (b) (arr) (process_natural_pair (a) (b) (arr) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof