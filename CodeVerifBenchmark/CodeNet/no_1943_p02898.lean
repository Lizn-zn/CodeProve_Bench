import Mathlib

-- Precondition definitions
@[reducible, simp]
def countEligibleFriends_precond (n : Nat) (k : Nat) (heights : List Nat) : Prop :=
  -- !benchmark @start precond
  heights.length = n
  -- !benchmark @end precond


-- Main function definitions
def countEligibleFriends (n : Nat) (k : Nat) (heights : List Nat) (h_precond : countEligibleFriends_precond (n) (k) (heights)) : Nat :=
  -- !benchmark @start code
  heights.foldl (fun acc h => if h >= k then acc + 1 else acc) 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def countEligibleFriends_postcond (n : Nat) (k : Nat) (heights : List Nat) (result: Nat) (h_precond : countEligibleFriends_precond (n) (k) (heights)) : Prop :=
  -- !benchmark @start postcond
  result = (heights.filter (fun h => h >= k)).length
  -- !benchmark @end postcond


-- Proof content
theorem countEligibleFriends_postcond_satisfied (n: Nat) (k: Nat) (heights: List Nat) (h_precond : countEligibleFriends_precond (n) (k) (heights)) :
    countEligibleFriends_postcond (n) (k) (heights) (countEligibleFriends (n) (k) (heights) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

