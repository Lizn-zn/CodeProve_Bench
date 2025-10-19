import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_absolute_average_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  ¬ numbers.isEmpty
  -- !benchmark @end precond


-- Main function definitions
def find_absolute_average (numbers : List Int) (h_precond : find_absolute_average_precond (numbers)) : Float :=
  -- !benchmark @start code
  let abs_sum := numbers.foldl (λ acc x => acc + Float.ofInt (x.natAbs)) 0.0
    let count := Float.ofNat numbers.length
    abs_sum / count
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def absolute_sum (numbers : List Int) : Float :=
  (numbers.map (λ x => Float.ofInt (x.natAbs))).foldl (· + ·) 0.0

-- Postcondition definitions
@[reducible, simp]
def find_absolute_average_postcond (numbers : List Int) (result: Float) (h_precond : find_absolute_average_precond (numbers)) : Prop :=
  -- !benchmark @start postcond
  result = absolute_sum numbers / Float.ofNat numbers.length
  -- !benchmark @end postcond


-- Proof content
theorem find_absolute_average_postcond_satisfied (numbers: List Int) (h_precond : find_absolute_average_precond (numbers)) :
    find_absolute_average_postcond (numbers) (find_absolute_average (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof