import Mathlib

-- Precondition definitions
@[reducible, simp]
def countFloorHeightOptions_precond (H : Nat) (A : Nat) (B : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ H ∧ H ≤ 100000 ∧ 1 ≤ A ∧ A ≤ B ∧ B ≤ H
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def countFloorHeightOptions (H : Nat) (A : Nat) (B : Nat) (h_precond : countFloorHeightOptions_precond (H) (A) (B)) : Nat :=
  -- !benchmark @start code
  Id.run do
    let mut count := 0
    for i in [A:B+1] do
      if H % i == 0 then
        count := count + 1
    return count
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if a floor height divides the total height evenly
def isDivisor (h : Nat) (floorHeight : Nat) : Bool :=
  floorHeight > 0 && h % floorHeight == 0

-- Count valid floor heights in the range [A, B] that divide H evenly
def countValidFloorHeights (H A B : Nat) : Nat :=
  List.range (B - A + 1) |>.map (· + A) |>.filter (isDivisor H) |>.length

-- Postcondition definitions
@[reducible, simp]
def countFloorHeightOptions_postcond (H : Nat) (A : Nat) (B : Nat) (result: Nat) (h_precond : countFloorHeightOptions_precond (H) (A) (B)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the count of floor heights i in range [A, B] where H is divisible by i
    result = countValidFloorHeights H A B
  -- !benchmark @end postcond


-- Proof content
theorem countFloorHeightOptions_postcond_satisfied (H: Nat) (A: Nat) (B: Nat) (h_precond : countFloorHeightOptions_precond (H) (A) (B)) :
    countFloorHeightOptions_postcond (H) (A) (B) (countFloorHeightOptions (H) (A) (B) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof