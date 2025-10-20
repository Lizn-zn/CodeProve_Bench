import Mathlib

namespace no_12890_codeexercises_19791


-- Precondition definitions
@[reducible, simp]
def feed_precond (animal : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple function

-- Main function definitions
def feed (animal : String) (h_precond : feed_precond (animal)) : String :=
  -- !benchmark @start code
  match animal with
  | "cat" => "Feeding dry food."
  | "dog" => "Feeding dry food."
  | "bird" => "Feeding seeds."
  | "fish" => "Feeding fish flakes."
  | _ => "Unknown animal."
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def expected_food (animal : String) : String :=
  match animal with
  | "cat" => "Feeding dry food."
  | "dog" => "Feeding dry food."
  | "bird" => "Feeding seeds."
  | "fish" => "Feeding fish flakes."
  | _ => "Unknown animal."

-- Postcondition definitions
@[reducible, simp]
def feed_postcond (animal : String) (result: String) (h_precond : feed_precond (animal)) : Prop :=
  -- !benchmark @start postcond
  result = expected_food animal
  -- !benchmark @end postcond


-- Proof content
theorem feed_postcond_satisfied (animal: String) (h_precond : feed_precond (animal)) :
    feed_postcond (animal) (feed (animal) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_12890_codeexercises_19791