import Mathlib

-- Precondition definitions
@[reducible, simp]
def findSmallestBase_precond (n : Nat) (s : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ n ∧ n ≤ 10^11 ∧ 1 ≤ s ∧ s ≤ 10^11
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute digit sum iteratively
def digitSumIter (n : Nat) (b : Nat) : Nat :=
  let rec loop (m : Nat) (acc : Nat) (fuel : Nat) : Nat :=
    match fuel with
    | 0 => acc
    | fuel' + 1 =>
      if m = 0 then acc
      else loop (m / b) (acc + m % b) fuel'
  if b ≤ 1 then 0
  else loop n 0 (n + 1)

-- Helper function to find the smallest base by checking candidates
def findBaseBruteForce (n : Nat) (s : Nat) (limit : Nat) : Option Nat :=
  let rec loop (b : Nat) (fuel : Nat) : Option Nat :=
    match fuel with
    | 0 => none
    | fuel' + 1 =>
      if b > limit then none
      else if digitSumIter n b = s then some b
      else loop (b + 1) fuel'
  loop 2 (limit + 1)

-- Helper function to check specific base candidates derived from equation
def checkLargeBases (n : Nat) (s : Nat) (sqrtN : Nat) : Option Nat :=
  if n ≤ s then none
  else
    let rec loop (p : Nat) (bestSoFar : Option Nat) (fuel : Nat) : Option Nat :=
      match fuel with
      | 0 => bestSoFar
      | fuel' + 1 =>
        if p > sqrtN then bestSoFar
        else
          let b := (n - s) / p + 1
          let newBest := 
            if b ≥ 2 && digitSumIter n b = s then
              match bestSoFar with
              | none => some b
              | some curr => some (min curr b)
            else bestSoFar
          let newBest2 :=
            if b ≥ 1 && digitSumIter n (b + 1) = s then
              match newBest with
              | none => some (b + 1)
              | some curr => some (min curr (b + 1))
            else newBest
          loop (p + 1) newBest2 fuel'
    loop 1 none (sqrtN + 2)

-- Compute integer square root
def isqrt (n : Nat) : Nat :=
  let rec loop (x : Nat) (fuel : Nat) : Nat :=
    match fuel with
    | 0 => x
    | fuel' + 1 =>
      if x = 0 then 0
      else
        let y := (x + n / x) / 2
        if y < x then loop y fuel'
        else x
  if n = 0 then 0
  else loop n (n + 1)

-- Main function definitions
def findSmallestBase (n : Nat) (s : Nat) (h_precond : findSmallestBase_precond (n) (s)) : Int :=
  -- !benchmark @start code
  if n = s then
      (n + 1 : Int)
    else
      let sqrtN := isqrt n
      -- First check small bases from 2 to sqrt(n)
      let smallBase := findBaseBruteForce n s sqrtN
      match smallBase with
      | some b => (b : Int)
      | none =>
        -- Check large bases derived from the equation
        match checkLargeBases n s sqrtN with
        | some b => (b : Int)
        | none => -1
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Compute the sum of digits of n in base b
def digitSum (n : Nat) (b : Nat) : Nat :=
  if b ≤ 1 then 0
  else if n < b then n
  else digitSum (n / b) b + (n % b)
  decreasing_by sorry

-- Check if there exists a base b ≥ 2 such that digitSum(n, b) = s
def existsBase (n : Nat) (s : Nat) : Prop :=
  ∃ b : Nat, b ≥ 2 ∧ digitSum n b = s

-- Postcondition definitions
@[reducible, simp]
def findSmallestBase_postcond (n : Nat) (s : Nat) (result: Int) (h_precond : findSmallestBase_precond (n) (s)) : Prop :=
  -- !benchmark @start postcond
  (result = -1 → ¬existsBase n s) ∧
    (result ≥ 2 → 
      digitSum n result.toNat = s ∧ 
      (∀ b : Nat, b ≥ 2 ∧ b < result.toNat → digitSum n b ≠ s))
  -- !benchmark @end postcond


-- Proof content
theorem findSmallestBase_postcond_satisfied (n: Nat) (s: Nat) (h_precond : findSmallestBase_precond (n) (s)) :
    findSmallestBase_postcond (n) (s) (findSmallestBase (n) (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof