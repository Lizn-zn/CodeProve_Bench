import Mathlib

-- Precondition definitions
@[reducible, simp]
def extinguish_fire_precond (fire_intensity : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ fire_intensity ∧ fire_intensity ≤ 10
  -- !benchmark @end precond


-- Main function definitions
def extinguish_fire (fire_intensity : Nat) (h_precond : extinguish_fire_precond (fire_intensity)) : String :=
  -- !benchmark @start code
  if fire_intensity ≤ 3 then
      "use extinguisher"
    else if fire_intensity ≤ 7 then
      "use both extinguisher and fire hose"
    else
      "use fire hose"
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def extinguish_fire_postcond (fire_intensity : Nat) (result: String) (h_precond : extinguish_fire_precond (fire_intensity)) : Prop :=
  -- !benchmark @start postcond
  match fire_intensity with
  | 1 | 2 | 3 => result = "use extinguisher"
  | 4 | 5 | 6 | 7 => result = "use both extinguisher and fire hose"
  | 8 | 9 | 10 => result = "use fire hose"
  | _ => False
  -- !benchmark @end postcond


-- Proof content
theorem extinguish_fire_postcond_satisfied (fire_intensity: Nat) (h_precond : extinguish_fire_precond (fire_intensity)) :
    extinguish_fire_postcond (fire_intensity) (extinguish_fire (fire_intensity) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

