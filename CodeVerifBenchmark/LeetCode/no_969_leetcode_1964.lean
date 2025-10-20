import Mathlib

namespace no_969_leetcode_1964


-- Precondition auxiliary definitions
def longestObstacleCourseAt_i (obstacles : List Nat) (i : Nat) : Nat :=
  match i with
  | 0 => 1
  | i + 1 =>
    let obstaclePrefix := obstacles.take (i + 1)
    let dp := List.range (i + 1) |>.map (fun j => 
      if obstaclePrefix.get! j <= obstaclePrefix.get! i then
        1 + (if j = 0 then 0 else longestObstacleCourseAt_i obstacles (j - 1))
      else 0
    )
    (dp.filter (fun x => x > 0)).max?.getD 1
  decreasing_by sorry

-- Precondition definitions
@[reducible, simp]
def longestObstacleCourseAtEachPosition_precond (obstacles : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def longestObstacleCourseAtEachPosition_aux (obstacles : List Nat) : List Nat :=
  let n := obstacles.length
  if n = 0 then []
  else
    -- dp[i] represents the length of the longest non-decreasing subsequence ending at i
    let dp := Array.mk (List.replicate n 1)
    -- tails[i] represents the smallest tail element of all non-decreasing subsequences of length i+1
    let tails := Array.mk (List.replicate (n+1) 0)
    let tailsSize := 0
    let result := []
    let rec loop (i : Nat) (dp : Array Nat) (tails : Array Nat) (tailsSize : Nat) (result : List Nat) : List Nat :=
      if i ≥ n then
        List.range n |>.map (fun i => dp.get! i)
      else
        let h := obstacles.get! i
        -- Binary search for the position to insert/replace in tails
        let pos := 
          let rec binarySearch (l r : Nat) : Nat :=
            if l ≥ r then l
            else
              let mid := (l + r) / 2
              if tails.get! mid ≤ h then
                binarySearch (mid + 1) r
              else
                binarySearch l mid
          binarySearch 0 tailsSize
        let tails' := tails.set! pos h
        let tailsSize' := if pos = tailsSize then tailsSize + 1 else tailsSize
        let dp' := dp.set! i (pos + 1)
        loop (i + 1) dp' tails' tailsSize' result
    loop 0 dp tails tailsSize result

-- Main function definitions
def longestObstacleCourseAtEachPosition (obstacles : List Nat) (h_precond : longestObstacleCourseAtEachPosition_precond (obstacles)) : List Nat :=
  -- !benchmark @start code
  longestObstacleCourseAtEachPosition_aux obstacles
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- This is a helper function to compute the longest non-decreasing subsequence ending at each position
def lisEndingAtEachPosition (obstacles : List Nat) : List Nat :=
  let n := obstacles.length
  if n = 0 then []
  else
    let dp := Array.mk (List.replicate n 1)
    let tails := Array.mk (List.replicate n 0)
    let tailsSize := 0
    let result := []
    let rec loop (i : Nat) (dp : Array Nat) (tails : Array Nat) (tailsSize : Nat) (result : List Nat) : List Nat :=
      if i ≥ n then
        List.range n |>.map (fun i => dp.get! i)
      else
        let h := obstacles.get! i
        -- Binary search for the position to insert/replace in tails
        let pos := 
          let rec binarySearch (l r : Nat) : Nat :=
            if l ≥ r then l
            else
              let mid := (l + r) / 2
              if tails.get! mid ≤ h then
                binarySearch (mid + 1) r
              else
                binarySearch l mid
          binarySearch 0 tailsSize
        let tails' := tails.set! pos h
        let tailsSize' := if pos = tailsSize then tailsSize + 1 else tailsSize
        let dp' := dp.set! i (pos + 1)
        loop (i + 1) dp' tails' tailsSize' result
    loop 0 dp tails tailsSize result

-- Postcondition definitions
@[reducible, simp]
def longestObstacleCourseAtEachPosition_postcond (obstacles : List Nat) (result: List Nat) (h_precond : longestObstacleCourseAtEachPosition_precond (obstacles)) : Prop :=
  -- !benchmark @start postcond
  result = lisEndingAtEachPosition obstacles
  -- !benchmark @end postcond


-- Proof content
theorem longestObstacleCourseAtEachPosition_postcond_satisfied (obstacles: List Nat) (h_precond : longestObstacleCourseAtEachPosition_precond (obstacles)) :
    longestObstacleCourseAtEachPosition_postcond (obstacles) (longestObstacleCourseAtEachPosition (obstacles) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_969_leetcode_1964