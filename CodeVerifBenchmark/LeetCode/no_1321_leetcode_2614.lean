import Mathlib

namespace no_1321_leetcode_2614


-- Precondition auxiliary definitions
/-- Check if a natural number is prime -/
def isPrime : Nat → Prop
  | 0 => False
  | 1 => False
  | n + 2 => ∀ m, 2 ≤ m → m ≤ n → m ∣ n → m = n

/-- Get the elements on the main diagonal of a square matrix -/
def mainDiagonal (nums : List (List Nat)) : List Nat :=
  match nums with
  | [] => []
  | row :: rows => 
    match row with
    | [] => []
    | head :: _ => head :: mainDiagonal (List.drop 1 <$> rows)
decreasing_by sorry

/-- Get the elements on the anti-diagonal of a square matrix -/
def antiDiagonal (nums : List (List Nat)) : List Nat :=
  let n := nums.length
  if n = 0 then []
  else
    List.mapIdx (fun i row => 
      if i < row.length then
        row.get! (row.length - i - 1)
      else 0) nums

/-- Check if a list is non-empty -/
def NonEmpty (l : List α) : Prop := l ≠ []

/-- Check if all rows have the same length as the number of rows -/
def isSquareMatrix (nums : List (List Nat)) : Prop :=
  let n := nums.length
  ∀ row ∈ nums, row.length = n

-- Precondition definitions
@[reducible, simp]
def largestPrimeOnDiagonal_precond (nums : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  NonEmpty nums ∧ isSquareMatrix nums
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Check if a natural number is prime -/
def isPrimeDecide : Nat → Bool
  | 0 => false
  | 1 => false
  | n + 2 => 
    let upperBound := Nat.sqrt (n + 2)
    !(List.range (upperBound - 2 + 1)).any fun i => 
      let m := i + 2
      (n + 2) % m = 0

/-- Get the elements on the main diagonal of a square matrix -/
def mainDiagonal' (nums : List (List Nat)) : List Nat :=
  match nums with
  | [] => []
  | row :: rows => 
    match row with
    | [] => []
    | head :: _ => head :: mainDiagonal' (List.drop 1 <$> rows)
decreasing_by sorry

/-- Get the elements on the anti-diagonal of a square matrix -/
def antiDiagonal' (nums : List (List Nat)) : List Nat :=
  let n := nums.length
  if n = 0 then []
  else
    List.mapIdx (fun i row => 
      if i < row.length then
        row.get! (row.length - i - 1)
      else 0) nums

/-- Find the maximum prime in a list, return 0 if none exists -/
def maxPrimeInList' (lst : List Nat) : Nat :=
  let primes := lst.filter (fun x => isPrimeDecide x)
  if primes = [] then 0 else primes.foldl max 0

/-- Get all diagonal elements from a square matrix -/
def diagonalElements' (nums : List (List Nat)) : List Nat :=
  mainDiagonal' nums ++ antiDiagonal' nums

-- Main function definitions
def largestPrimeOnDiagonal (nums : List (List Nat)) (h_precond : largestPrimeOnDiagonal_precond (nums)) : Nat :=
  -- !benchmark @start code
  maxPrimeInList' (diagonalElements' nums)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Get all diagonal elements from a square matrix -/
def diagonalElements (nums : List (List Nat)) : List Nat :=
  mainDiagonal nums ++ antiDiagonal nums

/-- Find the maximum prime in a list, return 0 if none exists -/
def maxPrimeInList (lst : List Nat) : Nat :=
  let primes := lst.filter (fun x => isPrimeDecide x)
  if primes = [] then 0 else primes.foldl max 0

-- Postcondition definitions
@[reducible, simp]
def largestPrimeOnDiagonal_postcond (nums : List (List Nat)) (result: Nat) (h_precond : largestPrimeOnDiagonal_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result = maxPrimeInList (diagonalElements nums)
  -- !benchmark @end postcond


-- Proof content
theorem largestPrimeOnDiagonal_postcond_satisfied (nums: List (List Nat)) (h_precond : largestPrimeOnDiagonal_precond (nums)) :
    largestPrimeOnDiagonal_postcond (nums) (largestPrimeOnDiagonal (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1321_leetcode_2614