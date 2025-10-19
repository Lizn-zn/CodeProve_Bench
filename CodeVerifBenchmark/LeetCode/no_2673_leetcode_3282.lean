import Mathlib
open Array

-- Precondition auxiliary definitions
def maxJumpScore_validPath (nums : List Nat) (path : List Nat) : Prop :=
  match path with
  | [] => False
  | p::ps =>
    p = 0 ∧
    List.Chain (· < ·) p ps ∧
    (match ps with
     | [] => False
     | _ => ps.getLast! = nums.length - 1)

def maxJumpScore_pathScore (nums : List Nat) (path : List Nat) : Nat :=
  match path with
  | [] => 0
  | [_] => 0
  | p::(q::qs) =>
    (q - p) * nums[p]! + maxJumpScore_pathScore nums (q::qs)

-- Precondition definitions
@[reducible, simp]
def maxJumpScore_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  nums.length ≥ 1
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- `maxJumpScore_dp nums` computes the maximum score to reach the last index using dynamic programming. -/
def maxJumpScore_dp (nums : List Nat) : Nat :=
  match nums with
  | [] => 0
  | [_] => 0
  | _ =>
    let n := nums.length
    let scores := mkArray n 0
    let rec loop (i : Nat) (scores : Array Nat) : Array Nat :=
      if i ≥ n then scores
      else
        let rec updateJ (j : Nat) (scores : Array Nat) : Array Nat :=
          if j ≥ n then scores
          else
            let newScore := scores[i]! + (j - i) * nums[i]!
            let updatedScores := if newScore > scores[j]! then scores.set! j newScore else scores
            updateJ (j+1) updatedScores
        let scores' := updateJ (i+1) scores
        loop (i+1) scores'
    let finalScores := loop 0 scores
    finalScores[(n-1)]!

-- Main function definitions
def maxJumpScore (nums : List Nat) (h_precond : maxJumpScore_precond (nums)) : Nat :=
  -- !benchmark @start code
  maxJumpScore_dp nums
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def maxJumpScore_postcond (nums : List Nat) (result: Nat) (h_precond : maxJumpScore_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  ∀ (path : List Nat), maxJumpScore_validPath nums path → maxJumpScore_pathScore nums path ≤ result ∧
  ∃ (path : List Nat), maxJumpScore_validPath nums path ∧ maxJumpScore_pathScore nums path = result
  -- !benchmark @end postcond


-- Proof content
theorem maxJumpScore_postcond_satisfied (nums: List Nat) (h_precond : maxJumpScore_precond (nums)) :
    maxJumpScore_postcond (nums) (maxJumpScore (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof