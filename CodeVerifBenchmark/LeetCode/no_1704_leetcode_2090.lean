import Mathlib

-- Precondition auxiliary definitions
def validIndex (nums : List Nat) (k : Nat) (i : Nat) : Prop :=
  k ≤ i ∧ i + k < nums.length

instance (nums : List Nat) (k i : Nat) : Decidable (validIndex nums k i) :=
  inferInstanceAs (Decidable (k ≤ i ∧ i + k < nums.length))

def subarraySum (nums : List Nat) (k : Nat) (i : Nat) : Int :=
  if h : validIndex nums k i then
    let start := i - k
    let finish := i + k
    (List.take (finish + 1) nums |>.drop start).foldl (· + ·) 0
  else
    0

def kRadiusAverage (nums : List Nat) (k : Nat) (i : Nat) : Int :=
  if h : validIndex nums k i then
    let count := 2 * k + 1
    (subarraySum nums k i) / count
  else
    -1

-- Precondition definitions
@[reducible, simp]
def getAverages_precond (nums : List Nat) (k : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def computeAveragesHelper (nums : List Nat) (k : Nat) (index : Nat) : List Int :=
  if index ≥ nums.length then
    []
  else
    let avg := kRadiusAverage nums k index
    avg :: computeAveragesHelper nums k (index + 1)

-- Main function definitions
def getAverages (nums : List Nat) (k : Nat) (h_precond : getAverages_precond (nums) (k)) : List Int :=
  -- !benchmark @start code
  computeAveragesHelper nums k 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def getAverages_postcond (nums : List Nat) (k : Nat) (result: List Int) (h_precond : getAverages_precond (nums) (k)) : Prop :=
  -- !benchmark @start postcond
  result.length = nums.length ∧
    ∀ (i : Nat), i < result.length →
      result[i]! = kRadiusAverage nums k i
  -- !benchmark @end postcond


-- Proof content
theorem getAverages_postcond_satisfied (nums: List Nat) (k: Nat) (h_precond : getAverages_precond (nums) (k)) :
    getAverages_postcond (nums) (k) (getAverages (nums) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof