import Mathlib

-- Precondition auxiliary definitions
/-- The least common multiple of two natural numbers. -/
def lcm (x y : Nat) : Nat :=
  if x = 0 ∨ y = 0 then 0 else x * y / Nat.gcd x y

/-- The least common multiple of three natural numbers. -/
def lcm3 (x y z : Nat) : Nat :=
  Nat.lcm (Nat.lcm x y) z

/-- Count how many numbers <= k are divisible by a, b, or c using inclusion-exclusion principle. -/
def countUgly (k : Nat) (a : Nat) (b : Nat) (c : Nat) : Nat :=
  let lab := Nat.lcm a b
  let lac := Nat.lcm a c
  let lbc := Nat.lcm b c
  let labc := lcm3 a b c
  k / a + k / b + k / c - k / lab - k / lac - k / lbc + k / labc

-- Precondition definitions
@[reducible, simp]
def nthUglyNumber_precond (n : Nat) (a : Nat) (b : Nat) (c : Nat) : Prop :=
  -- !benchmark @start precond
  n > 0 ∧ a > 0 ∧ b > 0 ∧ c > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Binary search for the nth ugly number. -/
def nthUglyNumber.search (n : Nat) (a : Nat) (b : Nat) (c : Nat) (low : Nat) (high : Nat) : Nat :=
  if low ≥ high then
    low
  else
    let mid := (low + high) / 2
    let count := countUgly mid a b c
    if count < n then
      nthUglyNumber.search n a b c (mid + 1) high
    else
      nthUglyNumber.search n a b c low mid

-- Main function definitions
def nthUglyNumber (n : Nat) (a : Nat) (b : Nat) (c : Nat) (h_precond : nthUglyNumber_precond (n) (a) (b) (c)) : Nat :=
  -- !benchmark @start code
  let maxVal := 2 * 10^9
  nthUglyNumber.search n a b c 1 maxVal
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def nthUglyNumber_postcond (n : Nat) (a : Nat) (b : Nat) (c : Nat) (result: Nat) (h_precond : nthUglyNumber_precond (n) (a) (b) (c)) : Prop :=
  -- !benchmark @start postcond
  result > 0 ∧
  countUgly result a b c = n ∧
  ∀ k : Nat, k < result → countUgly k a b c < n
  -- !benchmark @end postcond


-- Proof content
theorem nthUglyNumber_postcond_satisfied (n: Nat) (a: Nat) (b: Nat) (c: Nat) (h_precond : nthUglyNumber_precond (n) (a) (b) (c)) :
    nthUglyNumber_postcond (n) (a) (b) (c) (nthUglyNumber (n) (a) (b) (c) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof