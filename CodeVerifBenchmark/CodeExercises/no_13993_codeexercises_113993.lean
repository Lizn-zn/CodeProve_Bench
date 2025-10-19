import Mathlib

-- Precondition definitions
@[reducible, simp]
def remove_zeros_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def remove_zeros (numbers : List Int) (h_precond : remove_zeros_precond (numbers)) : List Int :=
  -- !benchmark @start code
  let rec helper (nums : List Int) (acc : List Int) : List Int :=
      match nums with
      | [] => acc.reverse
      | h :: t => 
        if h = 0 then
          helper t acc
        else
          helper t (h :: acc)
  helper numbers []
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def remove_zeros_postcond (numbers : List Int) (result: List Int) (h_precond : remove_zeros_precond (numbers)) : Prop :=
  -- !benchmark @start postcond
  ∀ (x : Int), x ∈ result → x ≠ 0 ∧
  ∀ (x : Int), x ∈ numbers → (x ≠ 0 → x ∈ result) ∧
  ∀ (x : Int), x ∈ result → x ∈ numbers
  -- !benchmark @end postcond


-- Proof content
theorem remove_zeros_postcond_satisfied (numbers: List Int) (h_precond : remove_zeros_precond (numbers)) :
    remove_zeros_postcond (numbers) (remove_zeros (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof