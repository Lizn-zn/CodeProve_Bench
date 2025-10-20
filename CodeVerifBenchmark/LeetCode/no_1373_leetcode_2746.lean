import Mathlib

namespace no_1373_leetcode_2746


-- Precondition auxiliary definitions
def join (x y : String) : String :=
  if x.isEmpty ∨ y.isEmpty then
    x ++ y
  else
    let xLast := x.get ⟨x.length - 1⟩
    let yFirst := y.get ⟨0⟩
    if xLast = yFirst then
      x ++ y.drop 1
    else
      x ++ y

def possibleLengths (words : List String) : List Nat :=
  match words with
  | [] => [0]
  | [w] => [w.length]
  | w :: ws =>
    let prevLengths := possibleLengths ws
    let currentLength := w.length
    -- For each previous length, we can either prepend or append the current word
    -- This is a simplified representation; a full dynamic programming approach would track first and last characters
    -- Here we just collect all possible lengths by simulating both operations
    -- However, for the precondition, we just need to ensure the input is valid
    -- So we don't need to compute all possible lengths here
    -- We can define this recursively, but for precondition, it's not necessary
    -- Let's just ensure that the list is non-empty and each word is non-empty
    -- This auxiliary function is not needed for the precondition
    []

-- The precondition does not require auxiliary definitions
-- !benchmark @end precond_aux

-- Precondition definitions
@[reducible, simp]
def minimizeConcatenatedLength_precond (words : List String) : Prop :=
  -- !benchmark @start precond
  words ≠ [] ∧ ∀ w ∈ words, w ≠ ""
  -- !benchmark @end precond


-- Code auxiliary definitions
-- We'll use a dynamic programming approach.
-- For each prefix of the words list, we'll track the minimum length achievable for each possible pair of first and last characters.
-- State: Array (Array (Option Nat)) indexed by first_char and last_char (0-25 for 'a'-'z')
-- dp[i][j] = Some len means there's a way to concatenate the first k words such that the resulting string starts with char i and ends with char j with length len.
-- None means it's not possible to achieve that character pair.
-- We'll use a List of Array (Array (Option Nat)) to represent the DP table.
-- The final answer is the minimum of all dp[fc][lc] where fc and lc range over all possible characters.

-- Helper function to get character index (0-25)
def charToIndex (c : Char) : Nat :=
  if 'a' ≤ c ∧ c ≤ 'z' then
    c.toNat - 'a'.toNat
  else
    0 -- Should not happen given precondition

-- Helper function to get character from index
def indexToChar (i : Nat) : Char :=
  Char.ofNat ('a'.toNat + i)

-- Initialize DP for a single word
def initDP (w : String) : Array (Array (Option Nat)) :=
  let len := w.length
  let firstChar := w.get ⟨0⟩
  let lastChar := w.get ⟨w.length - 1⟩
  let fcIdx := charToIndex firstChar
  let lcIdx := charToIndex lastChar
  let dp := Array.mkArray 26 (Array.mkArray 26 none)
  dp.set! fcIdx ((dp.get! fcIdx).set! lcIdx (some len))

-- Update DP when appending a word `w` to existing strings
def updateDPAppend (dp : Array (Array (Option Nat))) (w : String) : Array (Array (Option Nat)) :=
  let wFirstChar := w.get ⟨0⟩
  let wLastChar := w.get ⟨w.length - 1⟩
  let wLen := w.length
  let wFirstIdx := charToIndex wFirstChar
  let wLastIdx := charToIndex wLastChar
  let newDP := Array.mkArray 26 (Array.mkArray 26 none)
  let newDP := Id.run do
    let mut acc := newDP
    for fc in [0:26] do
      for lc in [0:26] do
        match dp.get! fc |>.get! lc with
        | none => continue
        | some len =>
          -- Case 1: Append w to string ending in lc
          let newLen := len + wLen - (if indexToChar lc == wFirstChar then 1 else 0)
          let currentVal := acc.get! fc |>.get! wLastIdx
          match currentVal with
          | none => acc := acc.set! fc ((acc.get! fc).set! wLastIdx (some newLen))
          | some v => if newLen < v then acc := acc.set! fc ((acc.get! fc).set! wLastIdx (some newLen))
    pure acc
  newDP

-- Update DP when prepending a word `w` to existing strings
def updateDPPrepend (dp : Array (Array (Option Nat))) (w : String) : Array (Array (Option Nat)) :=
  let wFirstChar := w.get ⟨0⟩
  let wLastChar := w.get ⟨w.length - 1⟩
  let wLen := w.length
  let wFirstIdx := charToIndex wFirstChar
  let wLastIdx := charToIndex wLastChar
  let newDP := Array.mkArray 26 (Array.mkArray 26 none)
  let newDP := Id.run do
    let mut acc := newDP
    for fc in [0:26] do
      for lc in [0:26] do
        match dp.get! fc |>.get! lc with
        | none => continue
        | some len =>
          -- Case 2: Prepend w to string starting with fc
          let newLen := wLen + len - (if wLastChar == indexToChar fc then 1 else 0)
          let currentVal := acc.get! wFirstIdx |>.get! lc
          match currentVal with
          | none => acc := acc.set! wFirstIdx ((acc.get! wFirstIdx).set! lc (some newLen))
          | some v => if newLen < v then acc := acc.set! wFirstIdx ((acc.get! wFirstIdx).set! lc (some newLen))
    pure acc
  newDP

-- Combine two DP states by taking the minimum for each (fc, lc) pair
def combineDP (dp1 dp2 : Array (Array (Option Nat))) : Array (Array (Option Nat)) :=
  let result := Array.mkArray 26 (Array.mkArray 26 none)
  let result := Id.run do
    let mut acc := result
    for fc in [0:26] do
      for lc in [0:26] do
        match dp1.get! fc |>.get! lc, dp2.get! fc |>.get! lc with
        | none, none => continue
        | some v, none => acc := acc.set! fc ((acc.get! fc).set! lc (some v))
        | none, some v => acc := acc.set! fc ((acc.get! fc).set! lc (some v))
        | some v1, some v2 =>
          if v1 <= v2 then
            acc := acc.set! fc ((acc.get! fc).set! lc (some v1))
          else
            acc := acc.set! fc ((acc.get! fc).set! lc (some v2))
    pure acc
  result

-- Update DP for a new word by considering both append and prepend
def updateDP (dp : Array (Array (Option Nat))) (w : String) : Array (Array (Option Nat)) :=
  let dpAppend := updateDPAppend dp w
  let dpPrepend := updateDPPrepend dp w
  combineDP dpAppend dpPrepend

-- Find the minimum value in a DP table
def minDP (dp : Array (Array (Option Nat))) : Nat :=
  let minLen := Id.run do
    let mut acc : Option Nat := none
    for fc in [0:26] do
      for lc in [0:26] do
        match dp.get! fc |>.get! lc with
        | none => continue
        | some len =>
          match acc with
          | none => acc := some len
          | some v => if len < v then acc := some len
    pure acc
  match minLen with
  | none => 0 -- Should not happen
  | some v => v


-- Main function definitions
def minimizeConcatenatedLength (words : List String) (h_precond : minimizeConcatenatedLength_precond (words)) : Nat :=
  -- !benchmark @start code
  match words with
    | [] => 0 -- By precondition, this case should not be reached
    | w :: ws =>
      let dp := initDP w
      let dp := List.foldl updateDP dp ws
      minDP dp
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- To define the postcondition correctly, we need to model the dynamic programming approach
-- We need to track for each prefix of words, the minimum length achievable for each possible first and last character
-- Let's define a state as a map from (first_char, last_char) to minimum length

-- However, defining this in Lean 4's type system is complex
-- Instead, we can characterize the result as the minimum length over all valid concatenation sequences
-- We define a relation that captures valid concatenation sequences and their lengths

inductive ConcatSequence : List String → String → Nat → Prop
  | base (w : String) :
    w ≠ "" →
    ConcatSequence [w] w w.length
  | append_right (words : List String) (str : String) (len : Nat) (w : String) (new_str : String) (new_len : Nat) :
    ConcatSequence words str len →
    w ≠ "" →
    new_str = join str w →
    new_len = len + w.length - (if str.get ⟨str.length - 1⟩ = w.get ⟨0⟩ then 1 else 0) →
    ConcatSequence (words ++ [w]) new_str new_len
  | prepend_left (words : List String) (str : String) (len : Nat) (w : String) (new_str : String) (new_len : Nat) :
    ConcatSequence words str len →
    w ≠ "" →
    new_str = join w str →
    new_len = w.length + len - (if w.get ⟨w.length - 1⟩ = str.get ⟨0⟩ then 1 else 0) →
    ConcatSequence (w :: words) new_str new_len

-- The postcondition states that result is the minimum length of any valid concatenation sequence
-- !benchmark @end postcond_aux

-- Postcondition definitions
@[reducible, simp]
def minimizeConcatenatedLength_postcond (words : List String) (result: Nat) (h_precond : minimizeConcatenatedLength_precond (words)) : Prop :=
  -- !benchmark @start postcond
  ∃ str, ConcatSequence words str result ∧
    ∀ str' len', ConcatSequence words str' len' → result ≤ len'
  -- !benchmark @end postcond


-- Proof content
theorem minimizeConcatenatedLength_postcond_satisfied (words: List String) (h_precond : minimizeConcatenatedLength_precond (words)) :
    minimizeConcatenatedLength_postcond (words) (minimizeConcatenatedLength (words) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1373_leetcode_2746