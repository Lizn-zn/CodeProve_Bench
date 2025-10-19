import Mathlib

-- Precondition definitions
@[reducible, simp]
def police_officer_precond (speed_limit : Nat) (speed_checkpoints : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def police_officer (speed_limit : Nat) (speed_checkpoints : List Nat) (h_precond : police_officer_precond (speed_limit) (speed_checkpoints)) : Nat :=
  -- !benchmark @start code
  let rec loop (checkpoints : List Nat) (violations : Nat) : Nat :=
    match checkpoints with
    | [] => violations
    | speed :: rest =>
      if speed > speed_limit then
        loop rest (violations + 1)
      else
        loop rest violations
  loop speed_checkpoints 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_violations (speed_limit : Nat) (speed_checkpoints : List Nat) : Nat :=
  speed_checkpoints.filter (λ speed => speed > speed_limit) |>.length

-- Postcondition definitions
@[reducible, simp]
def police_officer_postcond (speed_limit : Nat) (speed_checkpoints : List Nat) (result: Nat) (h_precond : police_officer_precond (speed_limit) (speed_checkpoints)) : Prop :=
  -- !benchmark @start postcond
  result = count_violations speed_limit speed_checkpoints
  -- !benchmark @end postcond


-- Proof content
theorem police_officer_postcond_satisfied (speed_limit: Nat) (speed_checkpoints: List Nat) (h_precond : police_officer_precond (speed_limit) (speed_checkpoints)) :
    police_officer_postcond (speed_limit) (speed_checkpoints) (police_officer (speed_limit) (speed_checkpoints) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

