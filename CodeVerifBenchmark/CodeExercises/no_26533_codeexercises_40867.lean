import Mathlib

namespace no_26533_codeexercises_40867


-- Precondition definitions
@[reducible, simp]
def access_elements_and_loop_precond (athlete : List (String × Nat)) (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def access_elements_and_loop (athlete : List (String × Nat)) (n : Nat) (h_precond : access_elements_and_loop_precond (athlete) (n)) : IO Unit :=
  -- !benchmark @start code
  let filtered := athlete.filter (λ (x : String × Nat) => x.2 = n)
  filtered.forM (λ (name, _) => IO.println name)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def filter_athletes_by_races (athlete : List (String × Nat)) (n : Nat) : List String :=
  (athlete.filter (λ x => x.2 = n)).map Prod.fst

def expected_output (athlete : List (String × Nat)) (n : Nat) : Prop :=
  let filtered_names := filter_athletes_by_races athlete n
  ∀ name : String, name ∈ filtered_names → IO.println name = pure ()

-- Postcondition definitions
@[reducible, simp]
def access_elements_and_loop_postcond (athlete : List (String × Nat)) (n : Nat) (result: IO Unit) (h_precond : access_elements_and_loop_precond (athlete) (n)) : Prop :=
  -- !benchmark @start postcond
  expected_output athlete n
  -- !benchmark @end postcond


-- Proof content
theorem access_elements_and_loop_postcond_satisfied (athlete: List (String × Nat)) (n: Nat) (h_precond : access_elements_and_loop_precond (athlete) (n)) :
    access_elements_and_loop_postcond (athlete) (n) (access_elements_and_loop (athlete) (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_26533_codeexercises_40867