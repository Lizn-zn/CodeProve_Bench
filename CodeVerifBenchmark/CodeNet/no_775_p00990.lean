import Mathlib

-- Precondition definitions
@[reducible, simp]
def countValidIDs_precond (n : Nat) (idString : String) (m : Nat) (candidates : List Nat) : Prop :=
  -- !benchmark @start precond
  n ≥ 1 ∧ n ≤ 100000 ∧
    m ≥ 1 ∧ m ≤ 10 ∧
    idString.length = n ∧
    candidates.length = m ∧
    (∀ c ∈ candidates, c ≤ 9) ∧
    (∀ ch ∈ idString.data, ch.isDigit ∨ ch = '*') ∧
    (idString.data.filter (· = '*')).length ≥ 1 ∧
    (idString.data.filter (· = '*')).length ≤ 7
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to convert a digit character to a natural number
def charToNat (c : Char) : Nat :=
  if c.isDigit then c.toNat - '0'.toNat else 0

-- Helper function to apply the ID validation rule to a single digit
-- position is 1-indexed from the right
def processDigit (digit : Nat) (position : Nat) : Nat :=
  if position % 2 = 0 then
    let doubled := digit * 2
    doubled / 10 + doubled % 10
  else
    digit

-- Dynamic programming approach to count valid combinations
-- We track the sum modulo 10 for each position
def countValidIDsDP (idString : String) (candidates : List Nat) : Nat :=
  let chars := idString.data.reverse
  let n := chars.length
  
  -- Initialize DP table: dp[i] represents count of ways to achieve sum ≡ i (mod 10)
  let initialDP : Array Nat := Array.mkArray 10 0 |>.set! 0 1
  
  let (finalDP, _) := chars.enum.foldl (fun (dp, pos) (idx, ch) =>
    let position := idx + 1  -- 1-indexed from right
    let newDP := Array.mkArray 10 0
    
    let digitsToTry := if ch = '*' then candidates else [charToNat ch]
    
    let result := digitsToTry.foldl (fun accDP digit =>
      let contribution := processDigit digit position
      -- For each previous sum, add this digit's contribution
      Array.range 10 |>.foldl (fun dp' prevSum =>
        let prevCount := dp[prevSum]!
        if prevCount > 0 then
          let newSum := (prevSum + contribution) % 10
          dp'.set! newSum (dp'[newSum]! + prevCount)
        else
          dp'
      ) accDP
    ) newDP
    
    (result, pos)
  ) (initialDP, 0)
  
  finalDP[0]!

-- Main function definitions
def countValidIDs (n : Nat) (idString : String) (m : Nat) (candidates : List Nat) (h_precond : countValidIDs_precond (n) (idString) (m) (candidates)) : Nat :=
  -- !benchmark @start code
  countValidIDsDP idString candidates
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if an ID is valid
def isValidID (id : List Nat) : Bool :=
  let sum := id.enum.foldl (fun acc (idx, digit) =>
    acc + processDigit digit (id.length - idx)
  ) 0
  sum % 10 = 0

-- Generate all possible IDs by replacing '*' with candidates
def generateAllIDs (idString : String) (candidates : List Nat) : List (List Nat) :=
  let chars := idString.data
  let rec helper (remaining : List Char) (current : List Nat) : List (List Nat) :=
    match remaining with
    | [] => [current.reverse]
    | ch :: rest =>
      if ch = '*' then
        candidates.flatMap (fun c => helper rest (c :: current))
      else
        helper rest (charToNat ch :: current)
  helper chars []

-- Count valid IDs among all generated IDs
def countValidIDsSpec (idString : String) (candidates : List Nat) : Nat :=
  let allIDs := generateAllIDs idString candidates
  allIDs.filter isValidID |>.length

-- Postcondition definitions
@[reducible, simp]
def countValidIDs_postcond (n : Nat) (idString : String) (m : Nat) (candidates : List Nat) (result: Nat) (h_precond : countValidIDs_precond (n) (idString) (m) (candidates)) : Prop :=
  -- !benchmark @start postcond
  result = countValidIDsSpec idString candidates
  -- !benchmark @end postcond


-- Proof content
theorem countValidIDs_postcond_satisfied (n: Nat) (idString: String) (m: Nat) (candidates: List Nat) (h_precond : countValidIDs_precond (n) (idString) (m) (candidates)) :
    countValidIDs_postcond (n) (idString) (m) (candidates) (countValidIDs (n) (idString) (m) (candidates) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof