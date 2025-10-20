import Mathlib

namespace no_28249_codeexercises_128249


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def calculate_weight_gain_precond (vet_visits : List Nat) : Prop :=
  -- !benchmark @start precond
  vet_visits.length ≥ 2
  -- !benchmark @end precond


-- Code auxiliary definitions
def calculate_gains (weights : List Nat) : List Nat :=
  match weights with
  | [] => []
  | [_] => []
  | w1::w2::rest => (w2 - w1) :: calculate_gains (w2::rest)

def calculate_average_gain (gains : List Nat) : Nat :=
  if gains.isEmpty then 0
  else gains.sum / gains.length

-- Main function definitions
def calculate_weight_gain (vet_visits : List Nat) (h_precond : calculate_weight_gain_precond (vet_visits)) : List (Nat × Nat) :=
  -- !benchmark @start code
  let gains := calculate_gains vet_visits
  let avg_gain := calculate_average_gain gains
  gains.map (λ gain => (gain, avg_gain))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Removed duplicate definitions of calculate_gains and calculate_average_gain
-- Using the same definitions from Code auxiliary definitions section

-- Postcondition definitions
@[reducible, simp]
def calculate_weight_gain_postcond (vet_visits : List Nat) (result: List (Nat × Nat)) (h_precond : calculate_weight_gain_precond (vet_visits)) : Prop :=
  -- !benchmark @start postcond
  let gains := calculate_gains vet_visits
  let avg_gain := calculate_average_gain gains
  result = gains.map (λ gain => (gain, avg_gain)) ∧ gains.length = vet_visits.length - 1
  -- !benchmark @end postcond


-- Proof content
theorem calculate_weight_gain_postcond_satisfied (vet_visits: List Nat) (h_precond : calculate_weight_gain_precond (vet_visits)) :
    calculate_weight_gain_postcond (vet_visits) (calculate_weight_gain (vet_visits) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_28249_codeexercises_128249