import Mathlib

-- Precondition auxiliary definitions
def IsGoodSubsequence (seq : List Nat) (k : Nat) : Prop :=
  let changes := seq.dropLast.zipWith (fun a b => decide (a ≠ b)) seq.tail
  changes.count true ≤ k

-- Precondition definitions
@[reducible, simp]
def maximumLengthOfGoodSubsequence_precond (nums : List Nat) (k : Nat) : Prop :=
  -- !benchmark @start precond
  0 < nums.length ∧ 0 ≤ k ∧ k ≤ nums.length ∧ k ≤ 25
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- `dp[i][j]` stores the maximum length of a good subsequence ending at index `i` with at most `j` changes. -/
def DpTable (nums : List Nat) (k : Nat) : List (List Nat) :=
  let n := nums.length
  -- Initialize a 2D list of size n x (k+1) with all zeros
  List.replicate n (List.replicate (k + 1) 0)

/-- Helper function to update dp table -/
def updateDp (dp : List (List Nat)) (i j new_val : Nat) : List (List Nat) :=
  dp.set i ((dp.get! i).set j new_val)

/-- Helper function to get value from dp table -/
def getDp (dp : List (List Nat)) (i j : Nat) : Nat :=
  if h : i < dp.length ∧ j < (dp.get! i).length then
    (dp.get! i).get! j
  else
    0

-- Main function definitions
def maximumLengthOfGoodSubsequence (nums : List Nat) (k : Nat) (h_precond : maximumLengthOfGoodSubsequence_precond nums k) : Nat :=
  -- !benchmark @start code
  let n := nums.length
    -- Base case: if k >= n-1, we can take the whole array as subsequence
    if k + 1 ≥ n then
      n
    else
      let nums_array := nums.toArray
      -- Initialize DP table
      let dp := DpTable nums k
      
      -- Base case: every single element is a valid subsequence
      let dp1 := 
        List.range n |>.foldl (fun dp_acc i => 
          updateDp dp_acc i 0 1) dp
      
      -- Fill DP table
      let dp2 := 
        (List.range n).foldl (fun dp_acc i =>
          (List.range (k+1)).foldl (fun dp_acc2 j =>
            let current_val := nums_array.get! i
            -- Extend subsequences ending at previous indices
            (List.range i).foldl (fun dp_acc3 prev_i =>
              let prev_val := nums_array.get! prev_i
              let changes := if current_val = prev_val then 0 else 1
              let new_changes := changes + j
              if new_changes ≤ k then
                let candidate_length := getDp dp_acc3 prev_i j + 1
                if candidate_length > getDp dp_acc3 i new_changes then
                  updateDp dp_acc3 i new_changes candidate_length
                else
                  dp_acc3
              else
                dp_acc3
            ) dp_acc2
          ) dp_acc
        ) dp1
      
      -- Find maximum among all positions and change counts
      (List.range n).foldl (fun result i =>
        (List.range (k+1)).foldl (fun res j =>
          let val := getDp dp2 i j
          if val > res then val else res
        ) result
      ) 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def Subsequence (s t : List Nat) : Prop := ∃ indices : List ℕ, List.Chain' (· < ·) indices ∧ (indices.all (fun i => i < t.length)) ∧ s = indices.map (fun i => t.get! i)

-- Postcondition definitions
@[reducible, simp]
def maximumLengthOfGoodSubsequence_postcond (nums : List Nat) (k : Nat) (result: Nat) (h_precond : maximumLengthOfGoodSubsequence_precond nums k) : Prop :=
  -- !benchmark @start postcond
  ∃ subseq : List Nat, Subsequence subseq nums ∧ IsGoodSubsequence subseq k ∧ subseq.length = result ∧
  ∀ subseq' : List Nat, Subsequence subseq' nums ∧ IsGoodSubsequence subseq' k → subseq'.length ≤ result
  -- !benchmark @end postcond


-- Proof content
theorem maximumLengthOfGoodSubsequence_postcond_satisfied (nums: List Nat) (k: Nat) (h_precond : maximumLengthOfGoodSubsequence_precond nums k) :
    maximumLengthOfGoodSubsequence_postcond nums k (maximumLengthOfGoodSubsequence nums k h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof