import Mathlib

namespace no_1737_leetcode_3435


-- Precondition auxiliary definitions
def isValidWordList (words : List String) : Prop :=
  let charSet := words.foldl (fun acc word => acc ∪ word.toList.toFinset) ∅
  words.length > 0 ∧ words.length ≤ 256 ∧ charSet.card ≤ 16 ∧
  words.Forall (fun w => w.length = 2) ∧
  words.Nodup

def isSubsequence (s t : String) : Prop :=
  let sChars := s.toList
  let tChars := t.toList
  ∃ indices : List Nat,
    indices.Sorted (· ≤ ·) ∧
    indices.length = sChars.length ∧
    ∀ i, i < sChars.length →
      indices.get! i < tChars.length ∧
      sChars.get! i = tChars.get! (indices.get! i)

def isCommonSupersequence (words : List String) (s : String) : Prop :=
  words.Forall (fun word => isSubsequence word s)

def countFreq (s : String) : Array Nat :=
  let arr := Array.mkArray 26 0
  s.foldl (fun acc c =>
    if c.val < 'a'.val ∨ c.val > 'z'.val then
      acc
    else
      let idx := (c.val - 'a'.val).toNat
      let current := arr[idx]!
      acc.set! idx (current + 1)
  ) arr

def isPermutation (freq1 freq2 : Array Nat) : Prop :=
  Array.toList freq1 = Array.toList freq2

def Array.NodupUpToPermutation (freqs : List (Array Nat)) : Prop :=
  ∀ x y, x ∈ freqs → y ∈ freqs → x ≠ y → ¬ (isPermutation x y)

def scsLength (words : List String) : Nat :=
  -- This is a simplified estimation; a precise implementation would require dynamic programming
  -- For this task, we'll assume that the length of the SCS is at least the max length of any word
  -- and at most the sum of lengths of all words.
  -- The actual minimal length needs to be computed by the implementation.
  -- We define it here for specification purposes.
  -- For simplicity in specification, we define it as the sum of lengths.
  words.foldl (fun acc word => acc + word.length) 0

-- Precondition definitions
@[reducible, simp]
def findSCSFrequencies_precond (words : List String) : Prop :=
  -- !benchmark @start precond
  isValidWordList words
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to convert a character to its index (0-25)
def charToIndex (c : Char) : Option Nat :=
  if c.val >= 'a'.val ∧ c.val <= 'z'.val then
    some ((c.val - 'a'.val).toNat)
  else
    none

-- Helper function to increment frequency at a given index
def incrementFreq (freq : Array Nat) (idx : Nat) : Array Nat :=
  if idx < 26 then
    let current := freq[idx]!
    freq.set! idx (current + 1)
  else
    freq

-- Helper function to compute frequency array of a string
def stringToFreq (s : String) : Array Nat :=
  let arr := Array.mkArray 26 0
  s.foldl (fun acc c =>
    match charToIndex c with
    | some idx => incrementFreq acc idx
    | none => acc
  ) arr

-- Helper function to check if two frequency arrays are equal
def freqEqual (freq1 freq2 : Array Nat) : Bool :=
  Array.toList freq1 == Array.toList freq2

-- Helper function to check if a list of frequency arrays contains a permutation of a given frequency array
def containsPermutation (freqs : List (Array Nat)) (freq : Array Nat) : Bool :=
  freqs.any (fun f => freqEqual f freq)

-- Helper function to generate all possible interleavings of two strings
def interleave (s1 s2 : String) : List String :=
  let rec interleave' (l1 l2 : List Char) (acc : String) : List String :=
    match l1, l2 with
    | [], _ => [acc ++ String.mk l2]
    | _, [] => [acc ++ String.mk l1]
    | c1::t1, c2::t2 =>
      let s1' := interleave' t1 l2 (acc ++ String.singleton c1)
      let s2' := interleave' l1 t2 (acc ++ String.singleton c2)
      s1' ++ s2'
  decreasing_by
    simp_wf
    all_goals sorry
  interleave' s1.toList s2.toList ""

-- Helper function to generate all SCS of a list of strings
def generateSCS (words : List String) : List String :=
  match words with
  | [] => [""]
  | [w] => [w]
  | w1 :: w2 :: rest =>
    let scs12 := interleave w1 w2
    let restSCS := generateSCS rest
    let result := scs12.flatMap (fun s => 
      if rest.isEmpty then [s] else
        restSCS.flatMap (fun r => interleave s r)
    )
    -- Deduplicate the result
    result.eraseDup

-- Helper function to filter only the shortest SCS
def filterShortest (strings : List String) : List String :=
  match strings with
  | [] => []
  | s :: ss =>
    let minLength := ss.foldl (fun minLen str => min minLen str.length) s.length
    strings.filter (fun str => str.length = minLength)

-- Main function definitions
def findSCSFrequencies (words : List String) (h_precond : findSCSFrequencies_precond (words)) : List (Array Nat) :=
  -- !benchmark @start code
  -- Generate all possible SCS
  let allSCS := generateSCS words
  
  -- Filter to keep only the shortest ones
  let shortestSCS := filterShortest allSCS
  
  -- Convert each SCS to its frequency array
  let freqArrays := shortestSCS.map stringToFreq
  
  -- Remove permutations: keep only one representative from each permutation class
  let uniqueFreqArrays := freqArrays.foldl (fun acc freq =>
    if containsPermutation acc freq then
      acc
    else
      acc ++ [freq]
  ) []
  
  uniqueFreqArrays
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def isValidFreqArray (freq : Array Nat) : Prop :=
  freq.size = 26 ∧ (Array.toList freq).Forall (fun n => n ≥ 0)

def isShortestCommonSupersequence (words : List String) (s : String) : Prop :=
  isCommonSupersequence words s ∧
  ¬ (∃ s' : String, isCommonSupersequence words s' ∧ s'.length < s.length)

def representsSCS (words : List String) (freq : Array Nat) : Prop :=
  isValidFreqArray freq ∧
  ∃ s : String,
    isShortestCommonSupersequence words s ∧
    Array.toList freq = (countFreq s |>.toList)

-- Postcondition definitions
@[reducible, simp]
def findSCSFrequencies_postcond (words : List String) (result: List (Array Nat)) (h_precond : findSCSFrequencies_precond (words)) : Prop :=
  -- !benchmark @start postcond
  -- The result must be a list of frequency arrays
  result.Forall (fun freq => isValidFreqArray freq) ∧
  -- Each frequency array must represent a valid SCS
  result.Forall (fun freq => representsSCS words freq) ∧
  -- The result must not contain permutations of each other
  result.Nodup ∧
  Array.NodupUpToPermutation result ∧
  -- The result must contain all such unique (up to permutation) SCS frequency arrays
  -- This is a complex semantic condition that is hard to fully specify without the implementation.
  -- We can say that for every valid SCS, there exists an element in the result that is its frequency array,
  -- and that frequency array is not a permutation of any other in the result.
  ∀ freq, representsSCS words freq → freq ∈ result
  -- !benchmark @end postcond


-- Proof content
theorem findSCSFrequencies_postcond_satisfied (words: List String) (h_precond : findSCSFrequencies_precond (words)) :
    findSCSFrequencies_postcond (words) (findSCSFrequencies (words) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1737_leetcode_3435