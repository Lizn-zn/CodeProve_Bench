import Mathlib

namespace no_1764_leetcode_2155


-- Precondition auxiliary definitions
def IsBinaryList (l : List Nat) : Prop :=
  ∀ x ∈ l, x = 0 ∨ x = 1

def countZeros (l : List Nat) : Nat :=
  l.filter (fun x => x = 0) |>.length

def countOnes (l : List Nat) : Nat :=
  l.filter (fun x => x = 1) |>.length

def divisionScore (nums : List Nat) (i : Nat) : Nat :=
  let left := nums.take i
  let right := nums.drop i
  countZeros left + countOnes right

-- Precondition definitions
@[reducible, simp]
def maxScoreIndices_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  IsBinaryList nums ∧ nums.length > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
def countZerosFromStart (nums : List Nat) : List Nat :=
  let rec go (l : List Nat) (count : Nat) : List Nat :=
    match l with
    | [] => [count]
    | x :: xs => count :: go xs (if x = 0 then count + 1 else count)
  go nums 0

def countOnesFromEnd (nums : List Nat) : List Nat :=
  let rec go (l : List Nat) (count : Nat) : List Nat :=
    match l with
    | [] => [count]
    | x :: xs => go xs (if x = 1 then count + 1 else count) ++ [count]
  go nums 0

def zipWithAdd (l1 l2 : List Nat) : List Nat :=
  match l1, l2 with
  | [], _ => []
  | _, [] => []
  | x :: xs, y :: ys => (x + y) :: zipWithAdd xs ys

-- Main function definitions
def maxScoreIndices (nums : List Nat) (h_precond : maxScoreIndices_precond (nums)) : List Nat :=
  -- !benchmark @start code
  let n := nums.length
    let zerosLeft := countZerosFromStart nums
    let onesRight := countOnesFromEnd nums
    let scores := zipWithAdd zerosLeft onesRight
    let maxScore := scores.foldl (fun maxVal x => if x > maxVal then x else maxVal) 0
    let indices := List.range (n + 1)
    indices.filter (fun i => scores.get! i = maxScore)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def maxDivisionScore (nums : List Nat) : Nat :=
  let scores := List.range (nums.length + 1) |>.map (divisionScore nums ·)
  scores.foldl (fun max_score score => if score > max_score then score else max_score) 0

-- Postcondition definitions
@[reducible, simp]
def maxScoreIndices_postcond (nums : List Nat) (result: List Nat) (h_precond : maxScoreIndices_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  let expected_length := nums.length + 1
  let scores := List.range expected_length |>.map (divisionScore nums ·)
  let max_score := maxDivisionScore nums
  result.Forall (fun i => i < expected_length ∧ divisionScore nums i = max_score) ∧
  (List.range expected_length).Forall (fun i =>
    (divisionScore nums i = max_score → result.elem i) ∧
    (divisionScore nums i < max_score → ¬result.elem i))
  -- !benchmark @end postcond


-- Proof content
theorem maxScoreIndices_postcond_satisfied (nums: List Nat) (h_precond : maxScoreIndices_precond (nums)) :
    maxScoreIndices_postcond (nums) (maxScoreIndices (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1764_leetcode_2155