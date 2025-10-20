import Mathlib

namespace no_209_p00217


-- Precondition definitions
@[reducible, simp]
def findLongestWalker_precond (datasets : List (List (Nat × Nat × Nat))) : Prop :=
  -- !benchmark @start precond
  -- Each dataset is non-empty
    ∀ ds ∈ datasets, ds ≠ []
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to process a single dataset and find the walker with longest distance
def processDataset (ds : List (Nat × Nat × Nat)) : Nat × Nat :=
  match ds with
  | [] => (0, 0)
  | hd :: tl =>
    let (pid, d1, d2) := hd
    let initMax := (pid, d1 + d2)
    tl.foldl (fun (maxPid, maxDist) (p, dist1, dist2) =>
      let currDist := dist1 + dist2
      if currDist > maxDist then (p, currDist) else (maxPid, maxDist)
    ) initMax

-- Main function definitions
def findLongestWalker (datasets : List (List (Nat × Nat × Nat))) (h_precond : findLongestWalker_precond (datasets)) : List (Nat × Nat) :=
  -- !benchmark @start code
  datasets.map processDataset
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to compute total distance for a patient
def totalDistance (p : Nat × Nat × Nat) : Nat :=
  p.2.1 + p.2.2

-- Helper function to find the patient with maximum total distance in a dataset
def findMaxWalker (ds : List (Nat × Nat × Nat)) : Nat × Nat :=
  match ds with
  | [] => (0, 0)  -- This case won't occur given the precondition
  | hd :: tl =>
    let (pid, d1, d2) := hd
    let initMax := (pid, d1 + d2)
    tl.foldl (fun (maxPid, maxDist) (p, dist1, dist2) =>
      let currDist := dist1 + dist2
      if currDist > maxDist then (p, currDist) else (maxPid, maxDist)
    ) initMax

-- Postcondition definitions
@[reducible, simp]
def findLongestWalker_postcond (datasets : List (List (Nat × Nat × Nat))) (result: List (Nat × Nat)) (h_precond : findLongestWalker_precond (datasets)) : Prop :=
  -- !benchmark @start postcond
  -- The result has the same length as the input datasets
    result.length = datasets.length ∧
    -- For each dataset, the corresponding result contains the patient ID and total distance
    -- of the patient who walked the longest distance
    ∀ i : Fin datasets.length,
      let ds := datasets[i]!
      let (maxPid, maxDist) := result[i]!
      -- The result matches the patient with maximum total distance
      (maxPid, maxDist) = findMaxWalker ds ∧
      -- There exists a patient in the dataset with this ID and distance
      (∃ (d1 d2 : Nat), (maxPid, d1, d2) ∈ ds ∧ maxDist = d1 + d2 ∧
      -- This patient has the maximum total distance
      ∀ p ∈ ds, totalDistance p ≤ maxDist)
  -- !benchmark @end postcond


-- Proof content
theorem findLongestWalker_postcond_satisfied (datasets: List (List (Nat × Nat × Nat))) (h_precond : findLongestWalker_precond (datasets)) :
    findLongestWalker_postcond (datasets) (findLongestWalker (datasets) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_209_p00217