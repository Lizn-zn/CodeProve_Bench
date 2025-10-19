import Mathlib

-- Precondition definitions
@[reducible, simp]
def count_marathon_completers_precond (athletes : List Nat) : Prop :=
  -- !benchmark @start precond
  ∀ (p : Nat), p ∈ athletes → p ≤ 100
  -- !benchmark @end precond


-- Main function definitions
def count_marathon_completers (athletes : List Nat) (h_precond : count_marathon_completers_precond (athletes)) : Nat :=
  -- !benchmark @start code
  let rec loop (athletes_slice : List Nat) (count : Nat) : Nat :=
      match athletes_slice with
      | [] => count
      | p :: rest =>
        if p < 90 then
          loop rest count
        else
          loop rest (count + 1)
    loop athletes 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def count_marathon_completers_postcond (athletes : List Nat) (result: Nat) (h_precond : count_marathon_completers_precond (athletes)) : Prop :=
  -- !benchmark @start postcond
  result = (athletes.filter (λ p => p ≥ 90)).length
  -- !benchmark @end postcond


-- Proof content
theorem count_marathon_completers_postcond_satisfied (athletes: List Nat) (h_precond : count_marathon_completers_precond (athletes)) :
    count_marathon_completers_postcond (athletes) (count_marathon_completers (athletes) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

