import Mathlib

-- Precondition definitions
@[reducible, simp]
def dances_in_sync_precond (dancers : List String) : Prop :=
  -- !benchmark @start precond
  ∀ d ∈ dancers, d = "+" ∨ d = "-"
  -- !benchmark @end precond


-- Code auxiliary definitions
def is_alternating_aux : List String → Bool
  | [] => true
  | [_] => true
  | x::y::rest => 
    if x = "+" then y = "-" && is_alternating_aux (y::rest)
    else if x = "-" then y = "+" && is_alternating_aux (y::rest)
    else false

-- Main function definitions
def dances_in_sync (dancers : List String) (h_precond : dances_in_sync_precond (dancers)) : Bool :=
  -- !benchmark @start code
  let forward_count := dancers.filter (λ d => d = "+") |>.length
  let backward_count := dancers.filter (λ d => d = "-") |>.length
  forward_count = backward_count && is_alternating_aux dancers
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_alternating (dancers : List String) : Prop :=
  match dancers with
  | [] => True
  | [x] => True
  | x::y::rest => (x = "+" → y = "-") ∧ (x = "-" → y = "+") ∧ is_alternating (y::rest)

def count_direction (dancers : List String) (dir : String) : Nat :=
  dancers.filter (λ d => d = dir) |>.length

-- Postcondition definitions
@[reducible, simp]
def dances_in_sync_postcond (dancers : List String) (result: Bool) (h_precond : dances_in_sync_precond (dancers)) : Prop :=
  -- !benchmark @start postcond
  let forward_count := count_direction dancers "+"
  let backward_count := count_direction dancers "-"
  result = (forward_count = backward_count ∧ is_alternating dancers)
  -- !benchmark @end postcond


-- Proof content
theorem dances_in_sync_postcond_satisfied (dancers: List String) (h_precond : dances_in_sync_precond (dancers)) :
    dances_in_sync_postcond (dancers) (dances_in_sync (dancers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof