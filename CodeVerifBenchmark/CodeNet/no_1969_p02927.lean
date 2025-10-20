import Mathlib

namespace no_1969_p02927


-- Precondition definitions
@[reducible, simp]
def countProductDays_precond (M : Nat) (D : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ M ∧ M ≤ 100 ∧ 1 ≤ D ∧ D ≤ 99
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def countProductDays (M : Nat) (D : Nat) (h_precond : countProductDays_precond (M) (D)) : Nat :=
  -- !benchmark @start code
  Id.run do
    let mut count := 0
    for m in [1:M+1] do
      for d in [10:D+1] do
        let d1 := d % 10  -- ones digit
        let d10 := d / 10  -- tens digit
        if d1 >= 2 && d10 >= 2 && d1 * d10 = m then
          count := count + 1
    return count
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if a day is a Product Day for a given month
def isProductDay (m : Nat) (d : Nat) : Bool :=
  if d < 10 then false
  else
    let d1 := d % 10  -- ones digit
    let d10 := d / 10  -- tens digit
    d1 ≥ 2 && d10 ≥ 2 && d1 * d10 = m

-- Count all Product Days in the calendar
def countAllProductDays (M : Nat) (D : Nat) : Nat :=
  (List.range M).foldl (fun acc m =>
    let month := m + 1  -- months are 1-indexed
    let daysInMonth := (List.range D).foldl (fun dayAcc d =>
      let day := d + 1  -- days are 1-indexed
      if isProductDay month day then dayAcc + 1 else dayAcc
    ) 0
    acc + daysInMonth
  ) 0

-- Postcondition definitions
@[reducible, simp]
def countProductDays_postcond (M : Nat) (D : Nat) (result: Nat) (h_precond : countProductDays_precond (M) (D)) : Prop :=
  -- !benchmark @start postcond
  result = countAllProductDays M D
  -- !benchmark @end postcond


-- Proof content
theorem countProductDays_postcond_satisfied (M: Nat) (D: Nat) (h_precond : countProductDays_precond (M) (D)) :
    countProductDays_postcond (M) (D) (countProductDays (M) (D) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1969_p02927