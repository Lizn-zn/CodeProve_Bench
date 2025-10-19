import Mathlib

-- Precondition auxiliary definitions
def countFreq (nums : Array Nat) : Array Nat :=
  let counts := nums.foldl (fun (acc : Array Nat) (num : Nat) =>
    let idx := num.min (acc.size - 1)
    if num < acc.size then
      acc.set! idx (acc.get! idx + 1)
    else
      -- Extend the array to accommodate the new number
      let extended := acc.push 1
      extended
  ) (mkArray (nums.foldl (max · ·) 0 + 1) 0)
  counts

def freqCount (counts : Array Nat) : Array Nat :=
  let maxCount := counts.foldl (max · ·) 0
  let freqCounts := mkArray (maxCount + 1) 0
  counts.foldl (fun (acc : Array Nat) (count : Nat) =>
    if count > 0 then
      let idx := count.min (acc.size - 1)
      acc.set! idx (acc.get! idx + 1)
    else
      acc
  ) freqCounts

def isValidPrefix (nums : Array Nat) (k : Nat) : Prop :=
  let prefixArr := nums.extract 0 k
  let counts := countFreq prefixArr
  let frequencies := freqCount counts
  -- Check conditions for valid prefix
  let nonZeroFreqCount := frequencies.extract 1 frequencies.size
  let uniqueNonZeroFreq := nonZeroFreqCount.filter (· > 0)
  if uniqueNonZeroFreq.size = 0 then
    True
  else if uniqueNonZeroFreq.size = 1 then
    let freq := uniqueNonZeroFreq.get! 0
    -- Replace indexOf with a manual search
    let count := (List.range frequencies.size).find? (fun i => i > 0 ∧ frequencies.get! i = freq)
    match count with
    | some idx => (idx = 1 ∧ freq = 1) ∨ (frequencies.get! 1 = k - 1 ∧ idx * freq = k - 1)
    | none => False
  else if uniqueNonZeroFreq.size = 2 then
    let freq1 := uniqueNonZeroFreq.get! 0
    let freq2 := uniqueNonZeroFreq.get! 1
    let count1 := (List.range frequencies.size).find? (fun i => i > 0 ∧ frequencies.get! i = freq1)
    let count2 := (List.range frequencies.size).find? (fun i => i > 0 ∧ frequencies.get! i = freq2)
    match count1, count2 with
    | some idx1, some idx2 =>
      (idx1 = 1 ∧ (freq1 = 1 ∨ freq1 = freq2 + 1)) ∨
      (idx2 = 1 ∧ (freq2 = 1 ∨ freq2 = freq1 + 1))
    | _, _ => False
  else
    False

-- Precondition definitions
@[reducible, simp]
def maxEqualFreq_precond (nums : Array Nat) : Prop :=
  -- !benchmark @start precond
  nums.size ≥ 2 ∧ nums.all (· > 0)
  -- !benchmark @end precond


-- Code auxiliary definitions
def countFreq' (nums : Array Nat) : Array Nat :=
  let counts := nums.foldl (fun (acc : Array Nat) (num : Nat) =>
    let idx := num.min (acc.size - 1)
    if h : num < acc.size then
      acc.set! idx (acc.get! idx + 1)
    else
      -- Extend the array to accommodate the new number
      let extended := acc.push 1
      extended
  ) (mkArray (nums.foldl (max · ·) 0 + 1) 0)
  counts

def freqCount' (counts : Array Nat) : Array Nat :=
  let maxCount := counts.foldl (max · ·) 0
  let freqCounts := mkArray (maxCount + 1) 0
  counts.foldl (fun (acc : Array Nat) (count : Nat) =>
    if count > 0 then
      let idx := count.min (acc.size - 1)
      acc.set! idx (acc.get! idx + 1)
    else
      acc
  ) freqCounts

def isValidPrefix' (nums : Array Nat) (k : Nat) : Bool :=
  if k = 0 then true else
    let prefixArr := nums.extract 0 k
    let counts := countFreq' prefixArr
    let frequencies := freqCount' counts
    -- Check conditions for valid prefix
    let maxFreq := frequencies.size - 1
    let nonZeroFreqCount := frequencies.extract 1 frequencies.size
    let uniqueNonZeroFreq := nonZeroFreqCount.filter (· > 0)
    if uniqueNonZeroFreq.size = 0 then
      true
    else if uniqueNonZeroFreq.size = 1 then
      let freq := uniqueNonZeroFreq.get! 0
      let count := (List.range frequencies.size).find? (fun i => i > 0 ∧ frequencies.get! i = freq)
      match count with
      | some idx =>
        (idx = 1 ∧ freq = 1) ∨ (frequencies.get! 1 = k - 1 ∧ idx * freq = k - 1)
      | none => false
    else if uniqueNonZeroFreq.size = 2 then
      let freq1 := uniqueNonZeroFreq.get! 0
      let freq2 := uniqueNonZeroFreq.get! 1
      let count1 := (List.range frequencies.size).find? (fun i => i > 0 ∧ frequencies.get! i = freq1)
      let count2 := (List.range frequencies.size).find? (fun i => i > 0 ∧ frequencies.get! i = freq2)
      match count1, count2 with
      | some idx1, some idx2 =>
        (idx1 = 1 ∧ (freq1 = 1 ∨ freq1 = freq2 + 1)) ∨
        (idx2 = 1 ∧ (freq2 = 1 ∨ freq2 = freq1 + 1))
      | _, _ => false
    else
      false

-- Main function definitions
def maxEqualFreq (nums : Array Nat) (h_precond : maxEqualFreq_precond nums) : Nat :=
  -- !benchmark @start code
  let rec loop (i : Nat) (maxLen : Nat) : Nat :=
    if h : i ≤ nums.size then
      if isValidPrefix' nums i then
        loop (i+1) i
      else
        loop (i+1) maxLen
    else
      maxLen
  termination_by nums.size - i
  decreasing_by
    all_goals sorry
  loop 0 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def maxEqualFreq_postcond (nums : Array Nat) (result: Nat) (h_precond : maxEqualFreq_precond nums) : Prop :=
  -- !benchmark @start postcond
  result ≤ nums.size ∧
    (result = 0 ∨ isValidPrefix nums result) ∧
    ∀ k : Nat, k > result → ¬isValidPrefix nums k
  -- !benchmark @end postcond


-- Proof content
theorem maxEqualFreq_postcond_satisfied (nums: Array Nat) (h_precond : maxEqualFreq_precond nums) :
    maxEqualFreq_postcond (nums) (maxEqualFreq (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof