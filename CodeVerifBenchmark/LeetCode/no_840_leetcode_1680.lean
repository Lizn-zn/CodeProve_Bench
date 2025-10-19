import Mathlib

-- Precondition auxiliary definitions
def binLen (n : Nat) : Nat :=
  if n = 0 then 1 else n.log2 + 1

def concatBinVal (n : Nat) : Nat :=
  if n = 0 then 0 else
    let prev := concatBinVal (n - 1)
    let len := binLen n
    (prev * 2^len + n) % (10^9 + 7)

-- Precondition definitions
@[reducible, simp]
def concatenatedBinary_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def modVal : Nat := 1000000007

/-- Calculate the bit length of a natural number -/
def bitLength (n : Nat) : Nat :=
  if n = 0 then 1 else
  n.log2 + 1

/-- Fast exponentiation modulo modVal -/
def powMod (base exp : Nat) : Nat :=
  if exp = 0 then 1 else
  let rec helper (b e acc : Nat) : Nat :=
    if e = 0 then acc else
    if e % 2 = 1 then 
      helper ((b * b) % modVal) (e / 2) ((acc * b) % modVal)
    else 
      helper ((b * b) % modVal) (e / 2) acc
  helper base exp 1

-- Main function definitions
def concatenatedBinary (n : Nat) (h_precond : concatenatedBinary_precond (n)) : Nat :=
  -- !benchmark @start code
  let rec loop (i result : Nat) : Nat :=
    if i > n then result else
    let bitLen := bitLength i
    let shifted := (result * powMod 2 bitLen) % modVal
    let newValue := (shifted + i) % modVal
    loop (i + 1) newValue
  termination_by n.succ - i
  decreasing_by
    omega
  loop 1 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def concatenatedBinary_postcond (n : Nat) (result: Nat) (h_precond : concatenatedBinary_precond (n)) : Prop :=
  -- !benchmark @start postcond
  result = concatBinVal n
  -- !benchmark @end postcond


-- Proof content
theorem concatenatedBinary_postcond_satisfied (n: Nat) (h_precond : concatenatedBinary_precond (n)) :
    concatenatedBinary_postcond (n) (concatenatedBinary (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof