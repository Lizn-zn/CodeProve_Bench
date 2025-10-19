import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def ikaNumber_precond (k : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ k ∧ k ≤ 1000000000000000000
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Matrix multiplication for Fibonacci computation
def matMul (a b : (Nat × Nat) × (Nat × Nat)) (mod : Nat) : (Nat × Nat) × (Nat × Nat) :=
  let ((a00, a01), (a10, a11)) := a
  let ((b00, b01), (b10, b11)) := b
  ((((a00 * b00 + a01 * b10) % mod, (a00 * b01 + a01 * b11) % mod),
    ((a10 * b00 + a11 * b10) % mod, (a10 * b01 + a11 * b11) % mod)))

-- Fast Fibonacci using matrix exponentiation
def fibFast (n : Nat) (mod : Nat) : Nat :=
  if n = 0 then 0
  else if n = 1 then 1
  else
    let rec matPow (base : (Nat × Nat) × (Nat × Nat)) (exp : Nat) (acc : (Nat × Nat) × (Nat × Nat)) : (Nat × Nat) × (Nat × Nat) :=
      if exp = 0 then acc
      else if exp % 2 = 1 then
        matPow (matMul base base mod) (exp / 2) (matMul acc base mod)
      else
        matPow (matMul base base mod) (exp / 2) acc
    let baseMat := ((1, 1), (1, 0))
    let result := matPow baseMat (n - 1) ((1, 1), (1, 0))
    result.1.1 % mod

-- Binary search to find b such that b*(b+1) < k
def findB (k : Nat) : Nat :=
  let rec binarySearch (l r : Nat) : Nat :=
    if r - l ≤ 1 then l
    else
      let m := (l + r) / 2
      if m * (m + 1) < k then
        binarySearch m r
      else
        binarySearch l m
  binarySearch 0 k

-- Main function definitions
def ikaNumber (k : Nat) (h_precond : ikaNumber_precond (k)) : Nat :=
  -- !benchmark @start code
  let mod := 1000000007
    let b := findB k
    let ad := k - (b * (b + 1))
    let d := ((ad - 1) % (b + 1)) + 1
    let x := 2 * b + 1
    let y := 1
    let x := if ad - d > 0 then x + 1 else x
    let dd := if d ≤ (b + 1 + 1) / 2 then 
                d * 2 - 1 
              else 
                let dz := b + 1 - d
                dz * 2 + 2
    let x := x - (dd - 1)
    let y := y + (dd - 1)
    (fibFast (x - 1) mod * fibFast (y - 1) mod) % mod
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Fibonacci number computation
def fib : Nat → Nat
  | 0 => 0
  | 1 => 1
  | n + 2 => (fib (n + 1) + fib n) % 1000000007

-- Check if a number is an IkaNumber
-- An IkaNumber is the number of paths from Taro's house to Hanako's house
-- avoiding a carrot position, where jumps can be +1 or +2
-- For positions: Taro at 0, carrot at c, Hanako at c+d (where c ≥ 1, d ≥ 1)
-- The number of paths is: fib(c) * fib(d) where fib is Fibonacci
def isIkaNumber (n : Nat) : Prop :=
  ∃ (c d : Nat), c ≥ 1 ∧ d ≥ 1 ∧ n % 1000000007 = (fib c * fib d) % 1000000007

-- Get the k-th smallest IkaNumber
-- The algorithm finds the appropriate Fibonacci products in sorted order
def kthIkaNumber (k : Nat) : Nat :=
  -- Find b such that b*(b+1) < k ≤ (b+1)*(b+2)
  let b := Nat.sqrt k
  let b := if b * (b + 1) < k then b else b - 1
  -- Calculate position within the b-th group
  let ad := k - (b * (b + 1))
  let d := ((ad - 1) % (b + 1)) + 1
  -- Calculate x and y coordinates
  let x := 2 * b + 1
  let y := 1
  let x := if ad - d > 0 then x + 1 else x
  let dd := if d ≤ (b + 1 + 1) / 2 then 
              d * 2 - 1 
            else 
              let dz := b + 1 - d
              dz * 2 + 2
  let x := x - (dd - 1)
  let y := y + (dd - 1)
  (fib (x - 1) * fib (y - 1)) % 1000000007

-- Postcondition definitions
@[reducible, simp]
def ikaNumber_postcond (k : Nat) (result: Nat) (h_precond : ikaNumber_precond (k)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the k-th smallest IkaNumber modulo 1000000007
  result = kthIkaNumber k ∧
  -- The result is indeed an IkaNumber
  isIkaNumber result ∧
  -- There are exactly k-1 IkaNumbers smaller than result (modulo consideration)
  -- The result is less than the modulo
  result < 1000000007
  -- !benchmark @end postcond


-- Proof content
theorem ikaNumber_postcond_satisfied (k: Nat) (h_precond : ikaNumber_precond (k)) :
    ikaNumber_postcond (k) (ikaNumber (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

