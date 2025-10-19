import Mathlib

-- Precondition auxiliary definitions
-- Characters at even indices can be freely swapped among themselves.
-- Characters at odd indices can be freely swapped among themselves.
-- Thus, two strings are equalizable if and only if:
-- 1. They have the same multiset of characters at even indices.
-- 2. They have the same multiset of characters at odd indices.

-- Define a function to extract characters at even indices
def charsAtEvenIndices (s : String) : List Char :=
  s.data.enum.filter (fun (i, _) => i % 2 = 0) |>.map (·.2)

-- Define a function to extract characters at odd indices
def charsAtOddIndices (s : String) : List Char :=
  s.data.enum.filter (fun (i, _) => i % 2 = 1) |>.map (·.2)

-- Define equality of multisets (lists up to permutation)
def List.equiv (l1 l2 : List Char) : Prop :=
  l1.Perm l2

-- Notation for multiset equality
infix:50 " ≈ " => List.equiv

-- Precondition definitions
@[reducible, simp]
def canMakeEqual_precond (s1 : String) (s2 : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Main function definitions
def canMakeEqual (s1 : String) (s2 : String) (h_precond : canMakeEqual_precond s1 s2) : Bool :=
  -- !benchmark @start code
  let even1 := charsAtEvenIndices s1
  let odd1 := charsAtOddIndices s1
  let even2 := charsAtEvenIndices s2
  let odd2 := charsAtOddIndices s2
  (even1.Perm even2) && (odd1.Perm odd2)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def canMakeEqual_postcond (s1 : String) (s2 : String) (result : Bool) (h_precond : canMakeEqual_precond s1 s2) : Prop :=
  -- !benchmark @start postcond
  let even1 := charsAtEvenIndices s1
  let odd1 := charsAtOddIndices s1
  let even2 := charsAtEvenIndices s2
  let odd2 := charsAtOddIndices s2
  result = ((List.equiv even1 even2) ∧ (List.equiv odd1 odd2))
  -- !benchmark @end postcond


-- Proof content
theorem canMakeEqual_postcond_satisfied (s1 : String) (s2 : String) (h_precond : canMakeEqual_precond s1 s2) :
    canMakeEqual_postcond s1 s2 (canMakeEqual s1 s2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof