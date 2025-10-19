import Mathlib

-- Precondition auxiliary definitions
def scoreOfSegment (possible : List Int) (start : Nat) (len : Nat) : Int :=
  (List.take len (List.drop start possible)).foldl (fun acc x => if x = 1 then acc + 1 else acc - 1) 0

-- Precondition definitions
@[reducible, simp]
def minLevelsForAliceToWin_precond (possible : List Int) : Prop :=
  -- !benchmark @start precond
  2 ≤ possible.length ∧ ∀ i, i < possible.length → (possible[i]! = 0 ∨ possible[i]! = 1)
  -- !benchmark @end precond


-- Code auxiliary definitions
def totalScore (possible : List Int) : Int :=
  possible.foldl (fun acc x => if x = 1 then acc + 1 else acc - 1) 0

def prefixScore (possible : List Int) : List Int :=
  let rec go (lst : List Int) (acc : Int) : List Int :=
    match lst with
    | [] => []
    | x :: xs =>
      let newAcc := if x = 1 then acc + 1 else acc - 1
      newAcc :: go xs newAcc
  go possible 0

-- Main function definitions
def minLevelsForAliceToWin (possible : List Int) (h_precond : minLevelsForAliceToWin_precond (possible)) : Int :=
  -- !benchmark @start code
  let n := possible.length
    let total := totalScore possible
    let prefixScores := prefixScore possible
    let rec findMinLevels (i : Nat) (prefixScores : List Int) : Int :=
      match prefixScores with
      | [] => -1
      | score :: rest =>
        if i + 1 < n then
          let aliceScore := score
          let bobScore := total - aliceScore
          if aliceScore > bobScore then
            (i + 1 : Int)
          else
            findMinLevels (i + 1) rest
        else
          -1
    findMinLevels 0 prefixScores
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def minLevelsForAliceToWin_postcond (possible : List Int) (result: Int) (h_precond : minLevelsForAliceToWin_precond (possible)) : Prop :=
  -- !benchmark @start postcond
  if result = -1 then
    ∀ aliceLevels : Nat, 1 ≤ aliceLevels ∧ aliceLevels < possible.length →
      let aliceScore := scoreOfSegment possible 0 aliceLevels
      let bobLevels := possible.length - aliceLevels
      let bobScore := scoreOfSegment possible aliceLevels bobLevels
      aliceScore ≤ bobScore
  else
    1 ≤ result ∧ result < possible.length ∧
    (let aliceScore := scoreOfSegment possible 0 (result.toNat)
     let bobLevels := possible.length - (result.toNat)
     let bobScore := scoreOfSegment possible (result.toNat) bobLevels
     aliceScore > bobScore) ∧
    (∀ aliceLevels : Nat, 1 ≤ aliceLevels ∧ aliceLevels < (result.toNat) →
      let aliceScore := scoreOfSegment possible 0 aliceLevels
      let bobLevels := possible.length - aliceLevels
      let bobScore := scoreOfSegment possible aliceLevels bobLevels
      aliceScore ≤ bobScore)
  -- !benchmark @end postcond


-- Proof content
theorem minLevelsForAliceToWin_postcond_satisfied (possible: List Int) (h_precond : minLevelsForAliceToWin_precond (possible)) :
    minLevelsForAliceToWin_postcond (possible) (minLevelsForAliceToWin (possible) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof