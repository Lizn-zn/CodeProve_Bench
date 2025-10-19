import Mathlib

-- Precondition definitions
@[reducible, simp]
def medicalCheckup_precond (n : Nat) (t : Nat) (healthConditions : List Nat) : Prop :=
  -- !benchmark @start precond
  n > 0 ∧ healthConditions.length = n ∧ (∀ h ∈ healthConditions, h > 0)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute the result iteratively
def medicalCheckupHelper (t : Nat) (healthConditions : List Nat) (i : Nat) (mx : Nat) (s : Nat) (acc : List Nat) : List Nat :=
  if i >= healthConditions.length then
    acc.reverse
  else
    let h := healthConditions[i]!
    let newMx := max mx h
    let r := if t < s then 0 else t - s
    let ans := if t < s then 1 else
      let base := r / newMx + 1
      if r % newMx >= h then base + 1 else base
    medicalCheckupHelper t healthConditions (i + 1) newMx (s + h) (ans :: acc)

-- Main function definitions
def medicalCheckup (n : Nat) (t : Nat) (healthConditions : List Nat) (h_precond : medicalCheckup_precond (n) (t) (healthConditions)) : List Nat :=
  -- !benchmark @start code
  medicalCheckupHelper t healthConditions 0 0 0 []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Calculate the maximum health condition seen so far up to index i (exclusive)
def maxHealthUpTo (healthConditions : List Nat) (i : Nat) : Nat :=
  if i = 0 then 0
  else (healthConditions.take i).foldl max 0

-- Calculate the sum of health conditions up to index i (exclusive)
def sumHealthUpTo (healthConditions : List Nat) (i : Nat) : Nat :=
  (healthConditions.take i).sum

-- Calculate the checkup item number for student i at time t
def checkupItemForStudent (t : Nat) (healthConditions : List Nat) (i : Nat) : Nat :=
  let mx := maxHealthUpTo healthConditions (i + 1)
  let s := sumHealthUpTo healthConditions i
  let h := healthConditions[i]!
  if t < s then
    1
  else
    let r := t - s
    let ans := r / mx + 1
    if r % mx >= h then
      ans + 1
    else
      ans

-- Postcondition definitions
@[reducible, simp]
def medicalCheckup_postcond (n : Nat) (t : Nat) (healthConditions : List Nat) (result: List Nat) (h_precond : medicalCheckup_precond (n) (t) (healthConditions)) : Prop :=
  -- !benchmark @start postcond
  -- The result has exactly n elements, one for each student
  result.length = n ∧
    -- Each element in the result corresponds to the checkup item number for that student
    (∀ i : Nat, i < n → 
      result[i]! = checkupItemForStudent t healthConditions i)
  -- !benchmark @end postcond


-- Proof content
theorem medicalCheckup_postcond_satisfied (n: Nat) (t: Nat) (healthConditions: List Nat) (h_precond : medicalCheckup_precond (n) (t) (healthConditions)) :
    medicalCheckup_postcond (n) (t) (healthConditions) (medicalCheckup (n) (t) (healthConditions) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

