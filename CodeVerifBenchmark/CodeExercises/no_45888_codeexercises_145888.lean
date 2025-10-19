import Mathlib

-- Precondition auxiliary definitions
inductive Predator : String → Prop
  | lion : Predator "lion"
  | tiger : Predator "tiger"
  | wolf : Predator "wolf"
  | bear : Predator "bear"
  | shark : Predator "shark"
  | eagle : Predator "eagle"

-- Precondition definitions
@[reducible, simp]
def is_predator_precond (animal : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def is_predator (animal : String) (h_precond : is_predator_precond (animal)) : Bool :=
  -- !benchmark @start code
  match animal with
  | "lion" => true
  | "tiger" => true
  | "wolf" => true
  | "bear" => true
  | "shark" => true
  | "eagle" => true
  | _ => false
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def is_predator_postcond (animal : String) (result: Bool) (h_precond : is_predator_precond (animal)) : Prop :=
  -- !benchmark @start postcond
  result = (Predator animal)
  -- !benchmark @end postcond


-- Proof content
theorem is_predator_postcond_satisfied (animal: String) (h_precond : is_predator_precond (animal)) :
    is_predator_postcond (animal) (is_predator (animal) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

