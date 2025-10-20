import Mathlib

namespace no_1439_leetcode_1769


-- Precondition auxiliary definitions
def boxesValid (boxes : String) : Prop :=
  boxes.length > 0 ∧ boxes.length ≤ 2000 ∧
  ∀ (c : Char), c ∈ boxes.data → (c = '0' ∨ c = '1')

-- Precondition definitions
@[reducible, simp]
def minOperations_precond (boxes : String) : Prop :=
  -- !benchmark @start precond
  boxesValid boxes
  -- !benchmark @end precond


-- Code auxiliary definitions
def minOperationsAux (boxes : List Char) (acc : List Nat) : List Nat :=
  let n := boxes.length
  let indicesWithBalls := List.filterMap (fun (i, c) => if c = '1' then some i else none) (List.zip (List.range n) boxes)
  List.map (fun target => List.sum (List.map (fun pos => Nat.dist pos target) indicesWithBalls)) (List.range n)

-- Main function definitions
def minOperations (boxes : String) (h_precond : minOperations_precond (boxes)) : List Nat :=
  -- !benchmark @start code
  minOperationsAux boxes.data []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def moveCount (boxes : String) (target : Nat) : Nat :=
  List.sum <| List.mapIdx (fun i c => if c = '1' then Nat.dist i target else 0) boxes.data

-- Postcondition definitions
@[reducible, simp]
def minOperations_postcond (boxes : String) (result: List Nat) (h_precond : minOperations_precond (boxes)) : Prop :=
  -- !benchmark @start postcond
  result.length = boxes.length ∧
  ∀ (i : Nat), i < result.length → result[i]! = moveCount boxes i
  -- !benchmark @end postcond


-- Proof content
theorem minOperations_postcond_satisfied (boxes: String) (h_precond : minOperations_precond (boxes)) :
    minOperations_postcond (boxes) (minOperations (boxes) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1439_leetcode_1769