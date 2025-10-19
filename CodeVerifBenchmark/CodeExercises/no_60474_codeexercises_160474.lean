import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_lowest_temperature_precond (temperatures : List Int) : Prop :=
  -- !benchmark @start precond
  ¬ temperatures.isEmpty
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to find the index of the minimum element in a list
def find_min_index_aux : List Int → Nat → Nat → Int → Nat
  | [], _, minIdx, _ => minIdx
  | x::xs, currentIdx, minIdx, minVal =>
    if x < minVal then
      find_min_index_aux xs (currentIdx + 1) currentIdx x
    else
      find_min_index_aux xs (currentIdx + 1) minIdx minVal

-- Main function definitions
def find_lowest_temperature (temperatures : List Int) (h_precond : find_lowest_temperature_precond (temperatures)) : Nat :=
  -- !benchmark @start code
  -- Start with the first element as the minimum
  match temperatures with
  | [] => by
    exfalso
    exact h_precond (by simp [find_lowest_temperature_precond])
  | x::xs =>
    find_min_index_aux xs 1 0 x
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_min_index (temperatures : List Int) (idx : Nat) : Prop :=
  idx < temperatures.length ∧
  (∀ i : Nat, i < temperatures.length → temperatures.get! i ≥ temperatures.get! idx) ∧
  (∀ i : Nat, i < idx → temperatures.get! i > temperatures.get! idx)

-- Postcondition definitions
@[reducible, simp]
def find_lowest_temperature_postcond (temperatures : List Int) (result: Nat) (h_precond : find_lowest_temperature_precond (temperatures)) : Prop :=
  -- !benchmark @start postcond
  is_min_index temperatures result
  -- !benchmark @end postcond


-- Proof content
theorem find_lowest_temperature_postcond_satisfied (temperatures: List Int) (h_precond : find_lowest_temperature_precond (temperatures)) :
    find_lowest_temperature_postcond (temperatures) (find_lowest_temperature (temperatures) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof