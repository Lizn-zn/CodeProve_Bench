import Mathlib

-- Precondition auxiliary definitions
def isUglyNumber (n : Int) : Prop :=
  0 < n ∧
  ∀ p : Nat, Nat.Prime p → p ∣ n.toNat → p = 2 ∨ p = 3 ∨ p = 5

-- Precondition definitions
@[reducible, simp]
def isUgly_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def removeFactor (n : Nat) (p : Nat) : Nat :=
  if p = 0 then n
  else
    Nat.rec n (fun _ acc => if acc % p = 0 then acc / p else acc) n

def isUglyNumber_nat (n : Nat) : Bool :=
  if n = 0 then false
  else
    let n2 := removeFactor n 2
    let n3 := removeFactor n2 3
    let n5 := removeFactor n3 5
    n5 = 1

-- Main function definitions
def isUgly (n : Int) (h_precond : isUgly_precond (n)) : Bool :=
  -- !benchmark @start code
  if n ≤ 0 then false else isUglyNumber_nat n.toNat
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def isUgly_postcond (n : Int) (result: Bool) (h_precond : isUgly_precond (n)) : Prop :=
  -- !benchmark @start postcond
  result = isUglyNumber n
  -- !benchmark @end postcond


-- Proof content
theorem isUgly_postcond_satisfied (n: Int) (h_precond : isUgly_precond (n)) :
    isUgly_postcond (n) (isUgly (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

