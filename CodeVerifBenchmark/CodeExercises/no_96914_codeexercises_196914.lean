import Mathlib

namespace no_96914_codeexercises_196914


-- Precondition definitions
@[reducible, simp]
def check_intersection_precond (police_officers : List String) (suspects : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def is_member_dec (x : String) (lst : List String) : Bool :=
  lst.elem x

-- Main function definitions
def check_intersection (police_officers : List String) (suspects : List String) (h_precond : check_intersection_precond (police_officers) (suspects)) : List String :=
  -- !benchmark @start code
  suspects.filter (λ s => is_member_dec s police_officers)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_member (x : String) (lst : List String) : Prop :=
  ∃ i : Fin lst.length, lst.get i = x

-- Postcondition definitions
@[reducible, simp]
def check_intersection_postcond (police_officers : List String) (suspects : List String) (result: List String) (h_precond : check_intersection_precond (police_officers) (suspects)) : Prop :=
  -- !benchmark @start postcond
  ∀ s : String, s ∈ result ↔ (s ∈ suspects ∧ is_member s police_officers)
  -- !benchmark @end postcond


-- Proof content
theorem check_intersection_postcond_satisfied (police_officers: List String) (suspects: List String) (h_precond : check_intersection_precond (police_officers) (suspects)) :
    check_intersection_postcond (police_officers) (suspects) (check_intersection (police_officers) (suspects) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_96914_codeexercises_196914