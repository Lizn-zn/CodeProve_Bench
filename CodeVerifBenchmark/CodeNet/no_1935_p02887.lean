import Mathlib

-- Precondition definitions
@[reducible, simp]
def countSlimesAfterFusion_precond (n : Nat) (s : String) : Prop :=
  -- !benchmark @start precond
  n = s.length ∧ n ≥ 1
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def countSlimesAfterFusion (n : Nat) (s : String) (h_precond : countSlimesAfterFusion_precond (n) (s)) : Nat :=
  -- !benchmark @start code
  let chars := s.toList
    let rec countGroups (lst : List Char) (acc : Nat) : Nat :=
      match lst with
      | [] => acc
      | [_] => acc
      | x :: y :: rest =>
        if x = y then
          countGroups (y :: rest) acc
        else
          countGroups (y :: rest) (acc + 1)
    if s.length = 0 then 0
    else countGroups chars 1
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to count groups of consecutive identical characters
def countConsecutiveGroups (s : String) : Nat :=
  if s.length = 0 then 0
  else
    let chars := s.toList
    let rec count_groups (lst : List Char) (acc : Nat) : Nat :=
      match lst with
      | [] => acc
      | [_] => acc
      | x :: y :: rest =>
        if x = y then
          count_groups (y :: rest) acc
        else
          count_groups (y :: rest) (acc + 1)
    count_groups chars 1

-- Postcondition definitions
@[reducible, simp]
def countSlimesAfterFusion_postcond (n : Nat) (s : String) (result: Nat) (h_precond : countSlimesAfterFusion_precond (n) (s)) : Prop :=
  -- !benchmark @start postcond
  result = countConsecutiveGroups s
  -- !benchmark @end postcond


-- Proof content
theorem countSlimesAfterFusion_postcond_satisfied (n: Nat) (s: String) (h_precond : countSlimesAfterFusion_precond (n) (s)) :
    countSlimesAfterFusion_postcond (n) (s) (countSlimesAfterFusion (n) (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

