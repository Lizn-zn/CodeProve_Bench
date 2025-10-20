import Mathlib

namespace no_23954_codeexercises_36881


-- Precondition definitions
@[reducible, simp]
def create_set_of_advantages_precond (advantages : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def create_set_of_advantages (advantages : List String) (h_precond : create_set_of_advantages_precond (advantages)) : Set String :=
  -- !benchmark @start code
  let filtered := advantages.filter (λ s => s.get? 0 = some 'A')
  {x | x ∈ filtered}
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def starts_with_A (s : String) : Prop :=
  match s.toList with
  | [] => False
  | c :: _ => c = 'A'

-- Postcondition definitions
@[reducible, simp]
def create_set_of_advantages_postcond (advantages : List String) (result: Set String) (h_precond : create_set_of_advantages_precond (advantages)) : Prop :=
  -- !benchmark @start postcond
  ∀ (s : String), s ∈ result ↔ (s ∈ advantages ∧ starts_with_A s)
  -- !benchmark @end postcond


-- Proof content
theorem create_set_of_advantages_postcond_satisfied (advantages: List String) (h_precond : create_set_of_advantages_precond (advantages)) :
    create_set_of_advantages_postcond (advantages) (create_set_of_advantages (advantages) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_23954_codeexercises_36881