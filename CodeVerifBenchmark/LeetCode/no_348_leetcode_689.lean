import Mathlib

-- Precondition auxiliary definitions
def subarraySum (nums : List Nat) (start : Nat) (len : Nat) : Nat :=
  (List.drop start nums).take len |>.sum

def isValidIndex (nums : List Nat) (k : Nat) (i : Nat) : Prop :=
  i + k ≤ nums.length

def isValidTriple (nums : List Nat) (k : Nat) (i j l : Nat) : Prop :=
  isValidIndex nums k i ∧
  isValidIndex nums k j ∧
  isValidIndex nums k l ∧
  i + k ≤ j ∧
  j + k ≤ l

def tripleSum (nums : List Nat) (k : Nat) (i j l : Nat) : Nat :=
  subarraySum nums i k + subarraySum nums j k + subarraySum nums l k

-- Precondition definitions
@[reducible]
def maxSumOfThreeSubarrays_precond (nums : List Nat) (k : Nat) : Prop :=
  -- !benchmark @start precond
  k > 0 ∧ k * 3 ≤ nums.length
  -- !benchmark @end precond


-- Code auxiliary definitions
def computePrefixSums (nums : List Nat) : List Nat :=
  let rec go (acc : Nat) (lst : List Nat) : List Nat :=
    match lst with
    | [] => []
    | x :: xs => acc :: go (acc + x) xs
  go 0 nums

def subarraySumFromPrefix (prefixSums : List Nat) (start : Nat) (len : Nat) : Nat :=
  prefixSums.get! (start + len) - prefixSums.get! start

def maxSumOfThreeSubarraysAux (nums : List Nat) (k : Nat) (prefixSums : List Nat) : List Nat :=
  let n := nums.length
  let maxIndex := n - k * 3

  -- Precompute sums of all subarrays of length k
  let windowSums := List.range (n - k + 1) |>.map fun i => subarraySumFromPrefix prefixSums i k

  -- Precompute leftMax: for each index i, the index of the maximum window sum in [0..i]
  let leftMax := 
    let rec goLeft (i : Nat) (currentMaxIndex : Nat) (acc : List Nat) : List Nat :=
      if i ≥ windowSums.length then
        acc.reverse
      else
        let newMaxIndex := if windowSums.get! i > windowSums.get! currentMaxIndex then i else currentMaxIndex
        goLeft (i+1) newMaxIndex (newMaxIndex :: acc)
    goLeft 0 0 []

  -- Precompute rightMax: for each index i, the index of the maximum window sum in [i..end]
  let rightMax := 
    let lastIndex := windowSums.length - 1
    let rec goRight (i : Nat) (currentMaxIndex : Nat) (acc : List Nat) : List Nat :=
      if i = 0 then
        (if windowSums.get! 0 ≥ windowSums.get! currentMaxIndex then 0 else currentMaxIndex) :: acc
      else
        let newMaxIndex := if windowSums.get! i ≥ windowSums.get! currentMaxIndex then i else currentMaxIndex
        goRight (i-1) newMaxIndex (newMaxIndex :: acc)
    termination_by i
    decreasing_by
      all_goals omega
    goRight lastIndex lastIndex []

  -- Iterate over middle window positions
  let validMiddleRange := List.range (n - 2*k + 1) |>.drop k |>.take (n - 3*k + 1)
  
  let maxSum := 0
  let resultIndices := [0, k, 2*k]
  
  let state := (maxSum, resultIndices)
  let finalState := validMiddleRange.foldl (fun (maxSum, resultIndices) j =>
    let i := leftMax.get! (j - k)
    let l := rightMax.get! (j + k)
    let currentSum := windowSums.get! i + windowSums.get! j + windowSums.get! l
    if currentSum > maxSum ∨ 
       (currentSum = maxSum ∧ 
        (i < resultIndices.get! 0 ∨ 
         (i = resultIndices.get! 0 ∧ (j < resultIndices.get! 1 ∨ 
                                      (j = resultIndices.get! 1 ∧ l < resultIndices.get! 2))))) then
      (currentSum, [i, j, l])
    else
      (maxSum, resultIndices)
  ) state
  
  finalState.2

-- Main function definitions
def maxSumOfThreeSubarrays (nums : List Nat) (k : Nat) (h_precond : maxSumOfThreeSubarrays_precond (nums) (k)) : List Nat :=
  -- !benchmark @start code
  let prefixSums := computePrefixSums nums
  maxSumOfThreeSubarraysAux nums k prefixSums
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def isLexicographicallySmaller (a b : List Nat) : Prop :=
  match a, b with
  | [], [] => False
  | [], _ :: _ => True
  | _ :: _, [] => False
  | h1 :: t1, h2 :: t2 =>
    if h1 < h2 then True
    else if h1 > h2 then False
    else isLexicographicallySmaller t1 t2

def hasMaximumSum (nums : List Nat) (k : Nat) (indices : List Nat) : Prop :=
  ∃ i j l,
    indices = [i, j, l] ∧
    isValidTriple nums k i j l ∧
    ∀ i' j' l',
      isValidTriple nums k i' j' l' →
      tripleSum nums k i' j' l' ≤ tripleSum nums k i j l

def satisfiesProblemConstraint (nums : List Nat) (k : Nat) (indices : List Nat) : Prop :=
  match indices with
  | [i, j, l] =>
    isValidTriple nums k i j l ∧
    let s1 := subarraySum nums i k
    let s2 := subarraySum nums j k
    let s3 := subarraySum nums l k
    -- All subarrays have length k
    ((List.drop i nums).take k).length = k ∧
    ((List.drop j nums).take k).length = k ∧
    ((List.drop l nums).take k).length = k
  | _ => False

-- Postcondition definitions
@[reducible]
def maxSumOfThreeSubarrays_postcond (nums : List Nat) (k : Nat) (result: List Nat) (h_precond : maxSumOfThreeSubarrays_precond (nums) (k)) : Prop :=
  -- !benchmark @start postcond
  result.length = 3 ∧
  satisfiesProblemConstraint nums k result ∧
  hasMaximumSum nums k result ∧
  (∀ other_result,
    satisfiesProblemConstraint nums k other_result →
    hasMaximumSum nums k other_result →
    ¬isLexicographicallySmaller other_result result)
  -- !benchmark @end postcond


-- Proof content
theorem maxSumOfThreeSubarrays_postcond_satisfied (nums: List Nat) (k: Nat) (h_precond : maxSumOfThreeSubarrays_precond (nums) (k)) :
    maxSumOfThreeSubarrays_postcond (nums) (k) (maxSumOfThreeSubarrays (nums) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof