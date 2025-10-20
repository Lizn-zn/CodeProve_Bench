import Mathlib

namespace no_412_leetcode_495


-- Precondition auxiliary definitions
def nonDecreasing : List Nat → Prop
  | [] => True
  | [_] => True
  | a :: b :: rest => a ≤ b ∧ nonDecreasing (b :: rest)

-- Precondition definitions
@[reducible, simp]
def findPoisonedDuration_precond (timeSeries : List Nat) (duration : Nat) : Prop :=
  -- !benchmark @start precond
  duration ≥ 0 ∧ timeSeries.length > 0 ∧ nonDecreasing timeSeries
  -- !benchmark @end precond


-- Code auxiliary definitions
def sumPoisonedDurationAux : List Nat → Nat → Nat
  | [], _ => 0
  | [t], d => d
  | t1 :: t2 :: rest, d =>
    let overlap := max 0 (d - (t2 - t1))
    (d - overlap) + sumPoisonedDurationAux (t2 :: rest) d

-- Main function definitions
def findPoisonedDuration (timeSeries : List Nat) (duration : Nat) (h_precond : findPoisonedDuration_precond (timeSeries) (duration)) : Nat :=
  -- !benchmark @start code
  match timeSeries with
    | [] => 0
    | [t] => duration
    | t1 :: t2 :: rest =>
      let overlap := max 0 (duration - (t2 - t1))
      (duration - overlap) + findPoisonedDuration (t2 :: rest) duration (by
        constructor
        · exact h_precond.left
        · cases h_precond.right.right
          constructor
          · simp
          · assumption
      )
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sumPoisonedDuration : List Nat → Nat → Nat
  | [], _ => 0
  | [t], d => d
  | t1 :: t2 :: rest, d =>
    let overlap := max 0 (d - (t2 - t1))
    (d - overlap) + sumPoisonedDuration (t2 :: rest) d

-- Postcondition definitions
@[reducible, simp]
def findPoisonedDuration_postcond (timeSeries : List Nat) (duration : Nat) (result: Nat) (h_precond : findPoisonedDuration_precond (timeSeries) (duration)) : Prop :=
  -- !benchmark @start postcond
  result = sumPoisonedDuration timeSeries duration
  -- !benchmark @end postcond


-- Proof content
theorem findPoisonedDuration_postcond_satisfied (timeSeries: List Nat) (duration: Nat) (h_precond : findPoisonedDuration_precond (timeSeries) (duration)) :
    findPoisonedDuration_postcond (timeSeries) (duration) (findPoisonedDuration (timeSeries) (duration) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_412_leetcode_495