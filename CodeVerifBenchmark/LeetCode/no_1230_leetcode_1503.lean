import Mathlib

-- Precondition auxiliary definitions
def validAntPositions (n : Nat) (positions : List Nat) : Prop :=
  ∀ p ∈ positions, p ≤ n

-- Precondition definitions
@[reducible, simp]
def getLastMoment_precond (n : Nat) (left : List Nat) (right : List Nat) : Prop :=
  -- !benchmark @start precond
  validAntPositions n left ∧ validAntPositions n right ∧
    left.Forall (fun x => right.Forall (fun y => x ≠ y))
  -- !benchmark @end precond


-- Code auxiliary definitions
/-
  Key insight:
  When two ants meet and change directions, it's equivalent to them passing through each other without changing direction.
  So we can ignore the direction changes and just calculate the time each ant would take to reach the end of the plank.
  The last ant to fall off will be the one that takes the longest time.
-/

-- Helper function to compute the maximum of a list of Nats, returning 0 for an empty list
def List.max' : List Nat → Nat
  | [] => 0
  | xs => xs.foldl Nat.max 0

-- Compute the time for the left-moving ants to fall off the left edge (time = position)
def leftFallTime : List Nat → Nat
  | left => left.max'

-- Compute the time for the right-moving ants to fall off the right edge (time = n - position)
def rightFallTime : Nat → List Nat → Nat
  | n, right => (right.map (fun x => n - x)).max'

-- Main function definitions
def getLastMoment (n : Nat) (left : List Nat) (right : List Nat) (h_precond : getLastMoment_precond (n) (left) (right)) : Nat :=
  -- !benchmark @start code
  Nat.max (leftFallTime left) (rightFallTime n right)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def maxLeftTime (left : List Nat) : Nat :=
  match left with
  | [] => 0
  | _ => left.foldl max 0

def maxRightTime (n : Nat) (right : List Nat) : Nat :=
  match right with
  | [] => 0
  | _ => (List.map (fun x => n - x) right).foldl max 0

-- Postcondition definitions
@[reducible, simp]
def getLastMoment_postcond (n : Nat) (left : List Nat) (right : List Nat) (result: Nat) (h_precond : getLastMoment_precond (n) (left) (right)) : Prop :=
  -- !benchmark @start postcond
  result = max (maxLeftTime left) (maxRightTime n right)
  -- !benchmark @end postcond


-- Proof content
theorem getLastMoment_postcond_satisfied (n: Nat) (left: List Nat) (right: List Nat) (h_precond : getLastMoment_precond (n) (left) (right)) :
    getLastMoment_postcond (n) (left) (right) (getLastMoment (n) (left) (right) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
