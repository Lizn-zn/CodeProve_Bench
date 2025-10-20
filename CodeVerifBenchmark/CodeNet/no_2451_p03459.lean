import Mathlib

namespace no_2451_p03459


-- Precondition definitions
@[reducible, simp]
def canCarryOutPlan_precond (n : Nat) (checkpoints : List (Nat × Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  checkpoints.length = n
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute absolute difference
def absDiff (a b : Nat) : Nat :=
  if a >= b then a - b else b - a

-- Helper function to check if a checkpoint is reachable from previous position
def isCheckpointReachable (t_prev x_prev y_prev : Nat) (t x y : Nat) : Bool :=
  let dt := t - t_prev
  let dx := absDiff x x_prev
  let dy := absDiff y y_prev
  let d := dx + dy
  (d <= dt) && (dt % 2 == d % 2)

-- Main recursive function to check all checkpoints
def checkCheckpoints (checkpoints : List (Nat × Nat × Nat)) (t_prev x_prev y_prev : Nat) : Bool :=
  match checkpoints with
  | [] => true
  | (t, x, y) :: rest =>
    if isCheckpointReachable t_prev x_prev y_prev t x y then
      checkCheckpoints rest t x y
    else
      false

-- Main function definitions
def canCarryOutPlan (n : Nat) (checkpoints : List (Nat × Nat × Nat)) (h_precond : canCarryOutPlan_precond (n) (checkpoints)) : Bool :=
  -- !benchmark @start code
  checkCheckpoints checkpoints 0 0 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if a single checkpoint is reachable from a previous position
def isReachable (t_prev x_prev y_prev : Nat) (t x y : Nat) : Bool :=
  let dt := t - t_prev
  let dx := if x >= x_prev then x - x_prev else x_prev - x
  let dy := if y >= y_prev then y - y_prev else y_prev - y
  let d := dx + dy
  (d <= dt) && (dt % 2 == d % 2)

-- Helper function to check all checkpoints sequentially
def checkAllCheckpoints (checkpoints : List (Nat × Nat × Nat)) : Bool :=
  match checkpoints with
  | [] => true
  | (t, x, y) :: rest =>
    if isReachable 0 0 0 t x y then
      checkAllCheckpointsAux rest t x y
    else
      false
where
  checkAllCheckpointsAux (remaining : List (Nat × Nat × Nat)) (t_prev x_prev y_prev : Nat) : Bool :=
    match remaining with
    | [] => true
    | (t, x, y) :: rest =>
      if isReachable t_prev x_prev y_prev t x y then
        checkAllCheckpointsAux rest t x y
      else
        false

-- Postcondition definitions
@[reducible, simp]
def canCarryOutPlan_postcond (n : Nat) (checkpoints : List (Nat × Nat × Nat)) (result: Bool) (h_precond : canCarryOutPlan_precond (n) (checkpoints)) : Prop :=
  -- !benchmark @start postcond
  result = checkAllCheckpoints checkpoints
  -- !benchmark @end postcond


-- Proof content
theorem canCarryOutPlan_postcond_satisfied (n: Nat) (checkpoints: List (Nat × Nat × Nat)) (h_precond : canCarryOutPlan_precond (n) (checkpoints)) :
    canCarryOutPlan_postcond (n) (checkpoints) (canCarryOutPlan (n) (checkpoints) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2451_p03459