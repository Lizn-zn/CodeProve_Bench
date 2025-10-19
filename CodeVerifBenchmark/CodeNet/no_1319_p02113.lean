import Mathlib

-- Precondition definitions
@[reducible, simp]
def findLongestPalindrome_precond (n : Nat) (l : Nat) (strings : List String) : Prop :=
  -- !benchmark @start precond
  strings.length = n ∧ 
    n ≥ 1 ∧ n ≤ 1000 ∧
    l ≥ 1 ∧ l ≤ 30 ∧
    ∀ s ∈ strings, s.length = l ∧ s.all (fun c => c.isLower)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to reverse a string
def reverseString (s : String) : String :=
  ⟨s.data.reverse⟩

-- Helper function to count occurrences in a list
def countInList (s : String) (lst : List String) : Nat :=
  lst.filter (· = s) |>.length

-- Helper function to build a frequency map
def buildFreqMap (strings : List String) : List (String × Nat) :=
  let unique := strings.eraseDups
  unique.map (fun s => (s, countInList s strings))

-- Helper function to get count from freq map
def getCount (s : String) (freqMap : List (String × Nat)) : Nat :=
  match freqMap.find? (fun p => p.1 = s) with
  | some (_, count) => count
  | none => 0

-- Helper function to update freq map
def updateFreqMap (s : String) (delta : Int) (freqMap : List (String × Nat)) : List (String × Nat) :=
  freqMap.map (fun p => 
    if p.1 = s then 
      (p.1, Int.toNat (p.2 + delta))
    else p)

-- Process pairs and palindromes
def processPairs (sortedUnique : List String) (freqMap : List (String × Nat)) : 
    List (String × Nat) × String × String :=
  sortedUnique.foldl (fun acc s =>
    let (currentFreq, leftPart, middle) := acc
    let rev := reverseString s
    let count := getCount s currentFreq
    if s = rev then
      -- Self-palindrome
      let pairs := count / 2
      let remaining := count % 2
      let newMiddle := if remaining > 0 && s.length > middle.length then s else middle
      let newFreq := updateFreqMap s (-(2 * pairs)) currentFreq
      (newFreq, leftPart ++ String.join (List.replicate pairs s), newMiddle)
    else if rev < s then
      -- Already processed as the reverse
      acc
    else
      -- Process pair
      let revCount := getCount rev currentFreq
      let pairCount := min count revCount
      let newFreq1 := updateFreqMap s (-pairCount) currentFreq
      let newFreq2 := updateFreqMap rev (-pairCount) newFreq1
      (newFreq2, leftPart ++ String.join (List.replicate pairCount s), middle)
  ) (freqMap, "", "")

-- Main function definitions
def findLongestPalindrome (n : Nat) (l : Nat) (strings : List String) (h_precond : findLongestPalindrome_precond (n) (l) (strings)) : String :=
  -- !benchmark @start code
  let freqMap := buildFreqMap strings
    let sortedUnique := strings.eraseDups.toArray.qsort (· < ·) |>.toList
    let (_, leftPart, middle) := processPairs sortedUnique freqMap
    let rightPart := reverseString leftPart
    leftPart ++ middle ++ rightPart
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if a string is a palindrome
def isPalindrome (s : String) : Bool :=
  s.data = s.data.reverse

-- Helper function to count occurrences of a string in a list
def countOccurrences (str : String) (strings : List String) : Nat :=
  strings.filter (· = str) |>.length

-- Helper function to check if result uses only strings from the input list
def usesOnlyInputStrings (result : String) (l : Nat) (strings : List String) : Prop :=
  ∃ (parts : List String), 
    parts.all (fun s => s ∈ strings) ∧
    parts.all (fun s => s.length = l) ∧
    String.join parts = result ∧
    -- Each string is used at most as many times as it appears in the input
    ∀ s ∈ strings.eraseDups, (parts.filter (· = s)).length ≤ countOccurrences s strings

-- Check if there exists a longer palindrome
def existsLongerPalindrome (result : String) (l : Nat) (strings : List String) : Prop :=
  ∃ (longer : String), 
    longer.length > result.length ∧
    isPalindrome longer ∧
    usesOnlyInputStrings longer l strings

-- Check if there exists a lexicographically smaller palindrome of the same length
def existsSmallerPalindrome (result : String) (l : Nat) (strings : List String) : Prop :=
  ∃ (smaller : String),
    smaller.length = result.length ∧
    smaller < result ∧
    isPalindrome smaller ∧
    usesOnlyInputStrings smaller l strings

-- Postcondition definitions
@[reducible, simp]
def findLongestPalindrome_postcond (n : Nat) (l : Nat) (strings : List String) (result: String) (h_precond : findLongestPalindrome_precond (n) (l) (strings)) : Prop :=
  -- !benchmark @start postcond
  -- The result is a palindrome (or empty if no palindrome can be formed)
    isPalindrome result ∧
    -- The result uses only strings from the input list
    usesOnlyInputStrings result l strings ∧
    -- The result is maximal in length
    ¬existsLongerPalindrome result l strings ∧
    -- Among palindromes of maximal length, result is lexicographically smallest
    ¬existsSmallerPalindrome result l strings ∧
    -- If result is empty, no palindrome can be formed
    (result = "" → ∀ (candidate : String), 
      candidate ≠ "" → isPalindrome candidate → ¬usesOnlyInputStrings candidate l strings)
  -- !benchmark @end postcond


-- Proof content
theorem findLongestPalindrome_postcond_satisfied (n: Nat) (l: Nat) (strings: List String) (h_precond : findLongestPalindrome_precond (n) (l) (strings)) :
    findLongestPalindrome_postcond (n) (l) (strings) (findLongestPalindrome (n) (l) (strings) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof