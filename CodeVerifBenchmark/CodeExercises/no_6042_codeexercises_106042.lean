import Mathlib

-- Precondition definitions
@[reducible, simp]
def rock_strata_age_precond (rock_strata : List Nat) : Prop :=
  -- !benchmark @start precond
  rock_strata ≠ []
  -- !benchmark @end precond


-- Code auxiliary definitions
def find_minimum_aux : List Nat → Nat → Nat
  | [], acc => acc
  | x :: xs, acc => 
    if x < acc then 
      find_minimum_aux xs x 
    else 
      find_minimum_aux xs acc

-- Main function definitions
def rock_strata_age (rock_strata : List Nat) (h_precond : rock_strata_age_precond (rock_strata)) : Nat :=
  -- !benchmark @start code
  match rock_strata with
    | [] => by
      exfalso
      exact h_precond rfl
    | x :: xs => find_minimum_aux xs x
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_minimum (xs : List Nat) (x : Nat) : Prop :=
  ∀ y ∈ xs, x ≤ y

-- Postcondition definitions
@[reducible, simp]
def rock_strata_age_postcond (rock_strata : List Nat) (result: Nat) (h_precond : rock_strata_age_precond (rock_strata)) : Prop :=
  -- !benchmark @start postcond
  result ∈ rock_strata ∧ is_minimum rock_strata result
  -- !benchmark @end postcond


-- Proof content
theorem rock_strata_age_postcond_satisfied (rock_strata: List Nat) (h_precond : rock_strata_age_precond (rock_strata)) :
    rock_strata_age_postcond (rock_strata) (rock_strata_age (rock_strata) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

