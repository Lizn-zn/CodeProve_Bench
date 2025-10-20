import Mathlib

namespace no_25934_codeexercises_39931


-- Precondition definitions
@[reducible, simp]
def create_social_worker_list_precond (names : List String) (ages : List Nat) (genders : List String) : Prop :=
  -- !benchmark @start precond
  names.length = ages.length ∧ names.length = genders.length
  -- !benchmark @end precond


-- Main function definitions
def create_social_worker_list (names : List String) (ages : List Nat) (genders : List String) (h_precond : create_social_worker_list_precond (names) (ages) (genders)) : List (String × Nat × String) :=
  -- !benchmark @start code
  List.zipWith (λ name (age, gender) => (name, age, gender)) names (List.zip ages genders)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def create_social_worker_list_postcond (names : List String) (ages : List Nat) (genders : List String) (result: List (String × Nat × String)) (h_precond : create_social_worker_list_precond (names) (ages) (genders)) : Prop :=
  -- !benchmark @start postcond
  result.length = names.length ∧
  ∀ i : Fin names.length, 
    let name := names[i]!
    let age := ages[i]!
    let gender := genders[i]!
    let entry := result[i]!
    entry.1 = name ∧ entry.2.1 = age ∧ entry.2.2 = gender
  -- !benchmark @end postcond


-- Proof content
theorem create_social_worker_list_postcond_satisfied (names: List String) (ages: List Nat) (genders: List String) (h_precond : create_social_worker_list_precond (names) (ages) (genders)) :
    create_social_worker_list_postcond (names) (ages) (genders) (create_social_worker_list (names) (ages) (genders) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_25934_codeexercises_39931