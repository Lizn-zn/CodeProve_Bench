import Mathlib

-- Precondition auxiliary definitions
def divisorsSum (n : Nat) : Nat :=
  if n = 0 then 0 else
  List.sum (List.filter (fun d => n % d = 0) (List.range n))

-- Precondition definitions
@[reducible, simp]
def isPerfectNumber_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ n ∧ n ≤ 10^8
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Efficiently computes the sum of proper divisors of `n` -/
def properDivisorsSum (n : Nat) : Nat :=
  match n with
  | 0 => 0
  | 1 => 0
  | n + 2 =>
    let upperBound := Nat.sqrt (n + 2)
    let rec loop (i : Nat) (acc : Nat) : Nat :=
      if i > upperBound then acc
      else if (n + 2) % i = 0 then
        let otherDivisor := (n + 2) / i
        if i = otherDivisor then
          loop (i + 1) (acc + i)
        else if otherDivisor = n + 2 then
          loop (i + 1) (acc + i)
        else
          loop (i + 1) (acc + i + otherDivisor)
      else
        loop (i + 1) acc
    decreasing_by
      all_goals sorry
    loop 1 0

-- Main function definitions
def isPerfectNumber (n : Nat) (h_precond : isPerfectNumber_precond (n)) : Bool :=
  -- !benchmark @start code
  properDivisorsSum n = n
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def isPerfectNumber_postcond (n : Nat) (result: Bool) (h_precond : isPerfectNumber_precond (n)) : Prop :=
  -- !benchmark @start postcond
  result = (divisorsSum n = n)
  -- !benchmark @end postcond


-- Proof content
theorem isPerfectNumber_postcond_satisfied (n: Nat) (h_precond : isPerfectNumber_precond (n)) :
    isPerfectNumber_postcond (n) (isPerfectNumber (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof