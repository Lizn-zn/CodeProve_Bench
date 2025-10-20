import Mathlib

namespace no_1837_leetcode_2237


-- Precondition auxiliary definitions
def validLights (n : Nat) (lights : List (Nat × Nat)) : Prop :=
  lights.all (fun light => light.1 < n ∧ light.2 ≥ 0)

def validRequirement (n : Nat) (requirement : List Nat) : Prop :=
  requirement.length = n

-- Precondition definitions
@[reducible, simp]
def meetRequirement_precond (n : Nat) (lights : List (Nat × Nat)) (requirement : List Nat) : Prop :=
  -- !benchmark @start precond
  validLights n lights ∧ validRequirement n requirement
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to update the difference array
def updateDiffArray (diff : Array Int) (l r : Nat) : Array Int :=
  let diff := if l < diff.size then diff.set! l (diff[l]! + 1) else diff
  if r + 1 < diff.size then diff.set! (r + 1) (diff[r + 1]! - 1) else diff

-- Helper function to convert difference array to actual counts
def diffToArray (diff : Array Int) : Array Nat :=
  let (_, result) := diff.foldl (init := (0, #[])) fun (acc, arr) delta =>
    let newAcc := acc + delta
    (newAcc, arr.push newAcc.natAbs)
  result

-- Main function definitions
def meetRequirement (n : Nat) (lights : List (Nat × Nat)) (requirement : List Nat) (h_precond : meetRequirement_precond (n) (lights) (requirement)) : Nat :=
  -- !benchmark @start code
  -- Initialize difference array with zeros
  let diffArray := Array.mk (List.replicate n 0)
  
  -- Apply each light's range to the difference array
  let updatedDiff := lights.foldl (fun diff ⟨pos, range⟩ =>
    let left := max 0 (pos - range)
    let right := min (n - 1) (pos + range)
    updateDiffArray diff left right
  ) diffArray
  
  -- Convert difference array to brightness array
  let brightness := diffToArray updatedDiff
  
  -- Count positions meeting requirement
  let (_, count) := List.range n |>.foldl (init := (0, 0)) fun (idx, cnt) _ =>
    let b := brightness[idx]!
    let req := requirement[idx]!
    (idx + 1, if b ≥ req then cnt + 1 else cnt)
    
  count
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def computeBrightness (n : Nat) (lights : List (Nat × Nat)) : List Nat :=
  let ranges := lights.map (fun ⟨pos, range⟩ =>
    (max 0 (pos - range), min (n - 1) (pos + range)))
  (List.range n).map (fun pos =>
    (ranges.filter (fun ⟨l, r⟩ => l ≤ pos ∧ pos ≤ r)).length)

-- Postcondition definitions
@[reducible, simp]
def meetRequirement_postcond (n : Nat) (lights : List (Nat × Nat)) (requirement : List Nat) (result: Nat) (h_precond : meetRequirement_precond (n) (lights) (requirement)) : Prop :=
  -- !benchmark @start postcond
  let brightness := computeBrightness n lights
  result = ((List.range n).filter (fun i =>
    brightness.get! i ≥ requirement.get! i)).length
  -- !benchmark @end postcond


-- Proof content
theorem meetRequirement_postcond_satisfied (n: Nat) (lights: List (Nat × Nat)) (requirement: List Nat) (h_precond : meetRequirement_precond (n) (lights) (requirement)) :
    meetRequirement_postcond (n) (lights) (requirement) (meetRequirement (n) (lights) (requirement) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1837_leetcode_2237