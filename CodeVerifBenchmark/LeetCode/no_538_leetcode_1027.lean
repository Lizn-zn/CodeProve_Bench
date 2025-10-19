import Mathlib

-- Precondition auxiliary definitions
def IsArithmeticSequence (lst : List Nat) : Prop :=
  match lst with
  | [] => True
  | [_] => True
  | a :: b :: [] => True
  | a :: b :: c :: rest =>
    let diff := b - a
    (c - b = diff) ∧ IsArithmeticSequence (b :: c :: rest)

def Subsequence (sub seq : List Nat) : Prop :=
  match sub with
  | [] => True
  | h :: t =>
    match seq with
    | [] => False
    | h' :: t' =>
      if h = h' then Subsequence t t'
      else Subsequence sub t'

-- Precondition definitions
@[reducible, simp]
def longestArithSeqLength_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  2 ≤ nums.length ∧ nums.length ≤ 1000 ∧ ∀ x ∈ nums, x ≤ 500
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- A map from (index, difference) to the length of the longest arithmetic subsequence ending at that index with that difference. -/
def DPEntry := Nat × Nat → Nat

/-- Initialize a DP table with default value 1. -/
def initDP : DPEntry := fun _ => 1

/-- Update the DP table with a new entry. -/
def updateDP (dp : DPEntry) (key : Nat × Nat) (value : Nat) : DPEntry :=
  fun k => if k = key then value else dp k

/-- Get the value from the DP table. -/
def getDP (dp : DPEntry) (key : Nat × Nat) : Nat := dp key

/-- Convert a list to an array with indices. -/
def List.toArrayWithIndex (lst : List Nat) : Array (Nat × Nat) :=
  let arr := lst.toArray
  Array.range arr.size |> Array.map (fun i => (i, arr[i]!))

/-- Compute the difference between two numbers, adjusted to be within a fixed range to avoid negative indexing. -/
def diffToKey (diff : Int) : Nat := (diff + 500).toNat

/-- Convert a key back to a difference. -/
def keyToDiff (key : Nat) : Int := (key : Int) - 500

/-- Helper function to compute the longest arithmetic subsequence using dynamic programming. -/
def longestArithSeqLengthDP (nums : List Nat) : Nat := Id.run do
  let arr := nums.toArray
  let n := arr.size
  if n ≤ 2 then
    n
  else
    let mut dp : DPEntry := initDP
    let mut maxLen : Nat := 2

    for i in [0:n] do
      for j in [0:i] do
        let diff := (arr[i]! : Int) - (arr[j]! : Int)
        let diffKey := diffToKey diff
        let key := (i, diffKey)
        let prevKey := (j, diffKey)
        let newLen := getDP dp prevKey + 1
        dp := updateDP dp key newLen
        maxLen := max maxLen newLen

    maxLen

-- Main function definitions
def longestArithSeqLength (nums : List Nat) (h_precond : longestArithSeqLength_precond (nums)) : Nat :=
  -- !benchmark @start code
  longestArithSeqLengthDP nums
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def longestArithSeqLength_postcond (nums : List Nat) (result: Nat) (h_precond : longestArithSeqLength_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  ∃ sub : List Nat, Subsequence sub nums ∧ IsArithmeticSequence sub ∧ result = sub.length ∧
  ∀ other_sub : List Nat, Subsequence other_sub nums ∧ IsArithmeticSequence other_sub → other_sub.length ≤ result
  -- !benchmark @end postcond


-- Proof content
theorem longestArithSeqLength_postcond_satisfied (nums: List Nat) (h_precond : longestArithSeqLength_precond (nums)) :
    longestArithSeqLength_postcond (nums) (longestArithSeqLength (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof