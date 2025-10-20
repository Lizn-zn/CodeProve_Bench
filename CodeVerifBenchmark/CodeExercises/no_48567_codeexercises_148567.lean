import Mathlib

namespace no_48567_codeexercises_148567


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def calculate_max_weight_precond (load_capacity : Float) (loads_assigned : List Float) : Prop :=
  -- !benchmark @start precond
  load_capacity ≥ 0 ∧ ∀ load ∈ loads_assigned, load ≥ 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Auxiliary definition to compute total assigned load
def total_assigned_load (loads : List Float) : Float :=
  loads.foldl (λ acc x => acc + x) 0

-- Main function definitions
def calculate_max_weight (load_capacity : Float) (loads_assigned : List Float) (h_precond : calculate_max_weight_precond load_capacity loads_assigned) : Float :=
  -- !benchmark @start code
  let total_assigned := total_assigned_load loads_assigned
  let remaining_capacity := load_capacity - total_assigned
  if remaining_capacity < 0 then
    0
  else
    remaining_capacity
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- No additional auxiliary definitions needed for postcondition

-- Postcondition definitions
@[reducible, simp]
def calculate_max_weight_postcond (load_capacity : Float) (loads_assigned : List Float) (result: Float) (h_precond : calculate_max_weight_precond load_capacity loads_assigned) : Prop :=
  -- !benchmark @start postcond
  let total_assigned := total_assigned_load loads_assigned
  result ≥ 0 ∧ total_assigned + result ≤ load_capacity ∧
  (∀ (x : Float), x > result → total_assigned + x > load_capacity)
  -- !benchmark @end postcond


-- Proof content
theorem calculate_max_weight_postcond_satisfied (load_capacity: Float) (loads_assigned: List Float) (h_precond : calculate_max_weight_precond load_capacity loads_assigned) :
    calculate_max_weight_postcond load_capacity loads_assigned (calculate_max_weight load_capacity loads_assigned h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_48567_codeexercises_148567