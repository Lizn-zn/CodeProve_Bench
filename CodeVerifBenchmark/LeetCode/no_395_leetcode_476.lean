import Mathlib

namespace no_395_leetcode_476


-- Precondition definitions
@[reducible, simp]
def complement_precond (num : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ num ∧ num < 2^31
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Compute the number of bits needed to represent a number in binary (ignoring leading zeros) -/
def numBits (n : Nat) : Nat :=
  if n = 0 then 1 else
    let rec loop (m : Nat) (acc : Nat) : Nat :=
      if m = 0 then acc else loop (m / 2) (acc + 1)
    loop n 0

/-- Create a mask with `n` bits set to 1 -/
def mask (n : Nat) : Nat :=
  2^n - 1

-- Main function definitions
def complement (num : Nat) (h_precond : complement_precond (num)) : Nat :=
  -- !benchmark @start code
  let bits := numBits num
  let m := mask bits
  m - num
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Convert a natural number to its binary representation as a list of bits (LSB first) -/
def toBinary (n : Nat) : List Bool :=
  if n = 0 then [false] else
    let rec loop (m : Nat) : List Bool :=
      if m = 0 then [] else
        (m % 2 = 1) :: loop (m / 2)
    loop n

/-- Convert a list of bits (LSB first) to a natural number -/
def ofBinary (bits : List Bool) : Nat :=
  bits.enum.foldl (fun acc (i, b) => acc + (if b then 2^i else 0)) 0

/-- Flip all bits in a boolean list -/
def flipBits : List Bool → List Bool
  | [] => []
  | b :: bs => (!b) :: flipBits bs

-- Postcondition definitions
@[reducible, simp]
def complement_postcond (num : Nat) (result: Nat) (h_precond : complement_precond (num)) : Prop :=
  -- !benchmark @start postcond
  let bits := toBinary num
    let flipped := flipBits bits
    result = ofBinary flipped
  -- !benchmark @end postcond


-- Proof content
theorem complement_postcond_satisfied (num: Nat) (h_precond : complement_precond (num)) :
    complement_postcond (num) (complement (num) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_395_leetcode_476