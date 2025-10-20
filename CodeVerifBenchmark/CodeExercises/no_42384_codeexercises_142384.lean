import Mathlib

namespace no_42384_codeexercises_142384


-- Precondition auxiliary definitions
def range_contains_negative (start stop step : Int) : Prop :=
  ∃ (x : Int), x ∈ Set.range (λ (k : ℤ) => start + k * step) ∧ x < 0 ∧ x ≥ stop

-- Precondition definitions
@[reducible, simp]
def intersection_of_range_and_negative_integers_precond (start : Int) (stop : Int) (step : Int) : Prop :=
  -- !benchmark @start precond
  step ≠ 0 ∧
  ((step > 0 ∧ start < stop) ∨ (step < 0 ∧ start > stop)) ∧
  range_contains_negative start stop step
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to generate the range
def generate_range (start stop step : Int) : List Int :=
  let num_steps := (stop - start + step - (if step > 0 then 1 else -1)) / step
  if num_steps < 0 then
    []
  else
    List.range' 0 num_steps.toNat |>.map (λ i => start + i * step)

-- Helper function to filter negative integers
def filter_negatives (l : List Int) : List Int :=
  l.filter (λ x => x < 0)

-- Main function definitions
def intersection_of_range_and_negative_integers (start : Int) (stop : Int) (step : Int) (h_precond : intersection_of_range_and_negative_integers_precond (start) (stop) (step)) : List Int :=
  -- !benchmark @start code
  let num_steps := (stop - start + step - (if step > 0 then 1 else -1)) / step
  if num_steps < 0 then
    []
  else
    let range_list := List.range' 0 num_steps.toNat |>.map (λ i => start + i * step)
    range_list.filter (λ x => x < 0)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_range_element (start step x : Int) : Prop :=
  ∃ (k : ℤ), x = start + k * step

def is_in_range (start stop step x : Int) : Prop :=
  is_range_element start step x ∧
  ((step > 0 ∧ x < stop) ∨ (step < 0 ∧ x > stop)) ∧
  ((step > 0 ∧ x ≥ start) ∨ (step < 0 ∧ x ≤ start))

-- Postcondition definitions
@[reducible, simp]
def intersection_of_range_and_negative_integers_postcond (start : Int) (stop : Int) (step : Int) (result: List Int) (h_precond : intersection_of_range_and_negative_integers_precond (start) (stop) (step)) : Prop :=
  -- !benchmark @start postcond
  result = List.filter (λ x => x < 0) (List.range' 0 ((stop - start + step - (if step > 0 then 1 else -1)) / step).toNat |>.map (λ i => start + i * step)) ∧
  ∀ (x : Int), x ∈ result ↔ (x < 0 ∧ is_in_range start stop step x)
  -- !benchmark @end postcond


-- Proof content
theorem intersection_of_range_and_negative_integers_postcond_satisfied (start: Int) (stop: Int) (step: Int) (h_precond : intersection_of_range_and_negative_integers_precond (start) (stop) (step)) :
    intersection_of_range_and_negative_integers_postcond (start) (stop) (step) (intersection_of_range_and_negative_integers (start) (stop) (step) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_42384_codeexercises_142384