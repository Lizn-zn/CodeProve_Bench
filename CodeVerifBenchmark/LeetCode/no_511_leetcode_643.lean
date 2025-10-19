import Mathlib

-- Precondition auxiliary definitions
def sumSubarray (nums : List Int) (start : Nat) (len : Nat) : Int :=
  (List.drop start nums).take len |>.foldl (· + ·) 0

def averageSubarray (nums : List Int) (start : Nat) (len : Nat) : Float :=
  (sumSubarray nums start len).toNat.toFloat / len.toFloat

-- Precondition definitions
@[reducible, simp]
def findMaxAverage_precond (nums : List Int) (k : Nat) : Prop :=
  -- !benchmark @start precond
  k > 0 ∧ k ≤ nums.length
  -- !benchmark @end precond


-- Code auxiliary definitions
def findMaxAverage_aux (nums : List Int) (k : Nat) (h_precond : findMaxAverage_precond nums k) : Float :=
  let arr := nums.toArray
  let initialSum := (Array.range k).foldl (fun acc i => acc + arr[i]!) 0
  let maxSum := (Array.range (arr.size - k)).foldl
    (fun (maxSum, currentSum) i =>
      let newSum := currentSum - arr[i]! + arr[i + k]!
      (max maxSum newSum, newSum))
    (initialSum, initialSum)
    |> Prod.fst
  maxSum.toNat.toFloat / k.toFloat

-- Main function definitions
def findMaxAverage (nums : List Int) (k : Nat) (h_precond : findMaxAverage_precond (nums) (k)) : Float :=
  -- !benchmark @start code
  findMaxAverage_aux nums k h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def isMaxAverage (nums : List Int) (k : Nat) (avg : Float) : Prop :=
  ∃ start : Nat, start + k ≤ nums.length ∧ avg = averageSubarray nums start k ∧
    ∀ start' : Nat, start' + k ≤ nums.length → averageSubarray nums start' k ≤ avg

-- Postcondition definitions
@[reducible, simp]
def findMaxAverage_postcond (nums : List Int) (k : Nat) (result: Float) (h_precond : findMaxAverage_precond (nums) (k)) : Prop :=
  -- !benchmark @start postcond
  isMaxAverage nums k result
  -- !benchmark @end postcond


-- Proof content
theorem findMaxAverage_postcond_satisfied (nums: List Int) (k: Nat) (h_precond : findMaxAverage_precond (nums) (k)) :
    findMaxAverage_postcond (nums) (k) (findMaxAverage (nums) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof