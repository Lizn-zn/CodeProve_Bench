import Mathlib

-- Precondition auxiliary definitions
def IsDivisibleSubset (s : List Nat) : Prop :=
  ∀ i j, i < s.length → j < s.length → s.get! i ∣ s.get! j ∨ s.get! j ∣ s.get! i

-- Precondition definitions
@[reducible, simp]
def largestDivisibleSubset_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  nums ≠ [] ∧ nums.Forall (· > 0)
  -- !benchmark @end precond


-- Code auxiliary definitions
def sortedInsert (l : List Nat) (x : Nat) : List Nat :=
  match l with
  | [] => [x]
  | y :: ys => if x ≤ y then x :: y :: ys else y :: sortedInsert ys x

def insertSorted (l : List Nat) (x : Nat) : List Nat :=
  sortedInsert l x

def sortInsertion (l : List Nat) : List Nat :=
  l.foldl insertSorted []

def divides (a b : Nat) : Prop := a ∣ b

theorem Nat.divides_def {a b : Nat} : a ∣ b ↔ ∃ k, b = a * k := Iff.rfl

def getDpIndex (dp : List (List Nat)) (x : Nat) : Option Nat :=
  let indices := List.range dp.length
  let validIndices := indices.filter (fun i => (dp.get! i).getLast! ∣ x)
  if validIndices = [] then none else some (List.foldl (·.max ·) 0 validIndices)

def extendSubset (subset : List Nat) (x : Nat) : List Nat :=
  subset ++ [x]

def updateDp (dp : List (List Nat)) (x : Nat) : List (List Nat) :=
  match getDpIndex dp x with
  | none => let newList : List Nat := [x]; newList :: dp
  | some i =>
    let bestSubset := dp.get! i
    let newSubset := extendSubset bestSubset x
    let insertIndex := newSubset.length - 1
    if insertIndex < dp.length then
      let before := dp.take insertIndex
      let after := dp.drop (insertIndex + 1)
      before ++ [newSubset] ++ after
    else
      dp ++ [newSubset]

def findMaxSubset (dp : List (List Nat)) : List Nat :=
  match dp.foldl (fun maxSubset current => if current.length > maxSubset.length then current else maxSubset) [] with
  | subset => subset

-- Main function definitions
def largestDivisibleSubset (nums : List Nat) (h_precond : largestDivisibleSubset_precond (nums)) : List Nat :=
  -- !benchmark @start code
  let sortedNums := sortInsertion nums
  let dp := sortedNums.foldl updateDp []
  findMaxSubset dp
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def IsMaximalDivisibleSubset (nums : List Nat) (s : List Nat) : Prop :=
  s ⊆ nums ∧ IsDivisibleSubset s ∧
  ∀ t, t ⊆ nums → IsDivisibleSubset t → t.length ≤ s.length

-- Postcondition definitions
@[reducible, simp]
def largestDivisibleSubset_postcond (nums : List Nat) (result: List Nat) (h_precond : largestDivisibleSubset_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result ⊆ nums ∧ IsDivisibleSubset result ∧
  ∀ t, t ⊆ nums → IsDivisibleSubset t → t.length ≤ result.length
  -- !benchmark @end postcond


-- Proof content
theorem largestDivisibleSubset_postcond_satisfied (nums: List Nat) (h_precond : largestDivisibleSubset_precond (nums)) :
    largestDivisibleSubset_postcond (nums) (largestDivisibleSubset (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof