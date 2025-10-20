import Mathlib

namespace no_1099_leetcode_2201


-- Precondition auxiliary definitions
def countExtractableArtifacts_precond_aux (n : Nat) (artifacts : List (Nat × Nat × Nat × Nat)) (dig : List (Nat × Nat)) : Prop :=
  -- Check that n is positive
  1 ≤ n ∧
  -- All artifact coordinates are within bounds
  artifacts.all (fun art => 
    let (r1, c1, r2, c2) := art
    r1 < n ∧ c1 < n ∧ r2 < n ∧ c2 < n ∧ r1 ≤ r2 ∧ c1 ≤ c2) ∧
  -- All dig coordinates are within bounds
  dig.all (fun d => let (r, c) := d; r < n ∧ c < n) ∧
  -- No two artifacts overlap (this is given in the problem statement, so we assume it)
  -- Each artifact covers at most 4 cells (this is given in the problem statement, so we assume it)
  -- The entries of dig are unique (this is given in the problem statement, so we assume it)
  True

-- Precondition definitions
@[reducible, simp]
def countExtractableArtifacts_precond (n : Nat) (artifacts : List (Nat × Nat × Nat × Nat)) (dig : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  countExtractableArtifacts_precond_aux n artifacts dig
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Convert the list of dug cells into a set for O(1) lookup
def dugSet (dig : List (Nat × Nat)) : Std.HashSet (Nat × Nat) :=
  let set := Std.HashSet.empty (α := Nat × Nat)
  dig.foldl (fun s cell => s.insert cell) set

-- Check if a cell (r, c) is in the dug set
def isDug (r c : Nat) (set : Std.HashSet (Nat × Nat)) : Bool :=
  set.contains (r, c)

-- Main function definitions
def countExtractableArtifacts (n : Nat) (artifacts : List (Nat × Nat × Nat × Nat)) (dig : List (Nat × Nat)) (h_precond : countExtractableArtifacts_precond (n) (artifacts) (dig)) : Nat :=
  -- !benchmark @start code
  let set := dugSet dig
  artifacts.foldl (fun acc art =>
    let (r1, c1, r2, c2) := art
    -- Check if all cells in the rectangle [r1..r2][c1..c2] are dug
    let allDug := 
      (List.range (r2 + 1 - r1)).map (fun dr => r1 + dr) |>.all
        (fun r => 
          (List.range (c2 + 1 - c1)).map (fun dc => c1 + dc) |>.all
            (fun c => isDug r c set))
    if allDug then acc + 1 else acc) 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def countExtractableArtifacts_postcond_aux (n : Nat) (artifacts : List (Nat × Nat × Nat × Nat)) (dig : List (Nat × Nat)) (result : Nat) : Prop :=
  -- Convert dig list to a set for efficient lookup using List membership
  -- Count how many artifacts are fully uncovered
  let count := artifacts.foldl (fun acc art =>
    let (r1, c1, r2, c2) := art
    -- Check if all cells of this artifact are dug
    let allDug := (r1 ≤ r2) ∧ (c1 ≤ c2) ∧ 
      ((List.range (r2 - r1 + 1)).map (fun dr => r1 + dr) |>.all
        (fun r => (List.range (c2 - c1 + 1)).map (fun dc => c1 + dc) |>.all
          (fun c => dig.contains (r, c))))
    if allDug then acc + 1 else acc) 0
  count = result

-- Postcondition definitions
@[reducible, simp]
def countExtractableArtifacts_postcond (n : Nat) (artifacts : List (Nat × Nat × Nat × Nat)) (dig : List (Nat × Nat)) (result: Nat) (h_precond : countExtractableArtifacts_precond (n) (artifacts) (dig)) : Prop :=
  -- !benchmark @start postcond
  countExtractableArtifacts_postcond_aux n artifacts dig result
  -- !benchmark @end postcond


-- Proof content
theorem countExtractableArtifacts_postcond_satisfied (n: Nat) (artifacts: List (Nat × Nat × Nat × Nat)) (dig: List (Nat × Nat)) (h_precond : countExtractableArtifacts_precond (n) (artifacts) (dig)) :
    countExtractableArtifacts_postcond (n) (artifacts) (dig) (countExtractableArtifacts (n) (artifacts) (dig) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1099_leetcode_2201