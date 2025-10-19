import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def check_exponential_growth_precond (numbers : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def is_exponential_growth_code (numbers : List Nat) : Bool :=
  match numbers with
  | [] => false
  | [_] => false
  | x::y::rest =>
    if x = 0 then false
    else
      let ratio := y / x
      if ratio ≤ 1 then false
      else
        let rec check_rest (prev : Nat) (remaining : List Nat) : Bool :=
          match remaining with
          | [] => true
          | current::tail =>
            if prev = 0 then false
            else if current / prev = ratio then check_rest current tail
            else false
        check_rest y rest

-- Main function definitions
def check_exponential_growth (numbers : List Nat) (h_precond : check_exponential_growth_precond (numbers)) : Bool :=
  -- !benchmark @start code
  is_exponential_growth_code numbers
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_exponential_growth_prop (numbers : List Nat) : Prop :=
  match numbers with
  | [] => False
  | [_] => False
  | x::y::rest =>
    let ratio := if x = 0 then 0 else y / x
    ratio > 1 ∧ ∀ i : Fin (rest.length), 
      let current := rest.get i
      let prev := if i.val = 0 then y else rest.get ⟨i.val - 1, by omega⟩
      prev > 0 → current / prev = ratio

-- Postcondition definitions
@[reducible, simp]
def check_exponential_growth_postcond (numbers : List Nat) (result: Bool) (h_precond : check_exponential_growth_precond (numbers)) : Prop :=
  -- !benchmark @start postcond
  result = is_exponential_growth_prop numbers
  -- !benchmark @end postcond


-- Proof content
theorem check_exponential_growth_postcond_satisfied (numbers: List Nat) (h_precond : check_exponential_growth_precond (numbers)) :
    check_exponential_growth_postcond (numbers) (check_exponential_growth (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof