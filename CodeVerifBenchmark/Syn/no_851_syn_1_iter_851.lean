import Mathlib

-- Precondition definitions
@[reducible, simp]
def compute_parity_precond (s : Finset Nat) (arr : Array Nat) (p : Nat × Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute parity as UInt8
def parityUInt8 (n : Nat) : UInt8 :=
  if n % 2 == 0 then 0 else 1

-- Main function definitions
def compute_parity (s : Finset Nat) (arr : Array Nat) (p : Nat × Nat) (h_precond : compute_parity_precond (s) (arr) (p)) : UInt8 :=
  -- !benchmark @start code
  let set_sum := s.sum id
  let arr_sum := arr.foldl (λ acc x => acc + x) 0
  let pair_prod := p.1 * p.2
  let total := set_sum + arr_sum + pair_prod
  parityUInt8 total
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sumSet (s : Finset Nat) : Nat := s.sum id

def sumArray (arr : Array Nat) : Nat := arr.foldl (λ acc x => acc + x) 0

def productPair (p : Nat × Nat) : Nat := p.1 * p.2

def totalSum (s : Finset Nat) (arr : Array Nat) (p : Nat × Nat) : Nat :=
  sumSet s + sumArray arr + productPair p

def isEven (n : Nat) : Bool := n % 2 == 0

-- Postcondition definitions
@[reducible, simp]
def compute_parity_postcond (s : Finset Nat) (arr : Array Nat) (p : Nat × Nat) (result: UInt8) (h_precond : compute_parity_precond (s) (arr) (p)) : Prop :=
  -- !benchmark @start postcond
  (result = 0 ∧ isEven (totalSum s arr p)) ∨ (result = 1 ∧ ¬isEven (totalSum s arr p))
  -- !benchmark @end postcond


-- Proof content
theorem compute_parity_postcond_satisfied (s: Finset Nat) (arr: Array Nat) (p: Nat × Nat) (h_precond : compute_parity_precond (s) (arr) (p)) :
    compute_parity_postcond (s) (arr) (p) (compute_parity (s) (arr) (p) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

