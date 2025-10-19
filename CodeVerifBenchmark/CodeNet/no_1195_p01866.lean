import Mathlib

-- Precondition definitions
@[reducible, simp]
def maxHammingDistance_precond (n : Nat) (x : String) (d : Nat) : Prop :=
  -- !benchmark @start precond
  n ≥ 1 ∧ d ≤ n ∧ x.length = n ∧ (∀ c ∈ x.data, c = '0' ∨ c = '1')
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to convert a character to a bit
def charToBit (c : Char) : Nat :=
  if c = '1' then 1 else 0

-- Helper function to convert a bit to a character
def bitToChar (b : Nat) : Char :=
  if b = 1 then '1' else '0'

-- Helper function to flip a character in a binary string
def flipChar (c : Char) : Char :=
  if c = '0' then '1' else '0'

-- Helper function to set a character at a specific index in a list
def setAt (l : List Char) (i : Nat) (c : Char) : List Char :=
  match i, l with
  | 0, _ :: xs => c :: xs
  | i+1, x :: xs => x :: setAt xs i c
  | _, [] => []

-- Main function definitions
def maxHammingDistance (n : Nat) (x : String) (d : Nat) (h_precond : maxHammingDistance_precond (n) (x) (d)) : String :=
  -- !benchmark @start code
  let ans := x.data.toArray
    let n_nat := n
    
    -- First pass: flip '0' to '1' from left to right
    let rec firstPass (i : Nat) (arr : Array Char) (remaining : Nat) (done : Array Bool) : Array Char × Array Bool × Nat :=
      if i >= n_nat then (arr, done, remaining)
      else if remaining = 0 then (arr, done, remaining)
      else
        if arr[i]! = '0' then
          let newArr := arr.set! i '1'
          let newDone := done.set! i true
          firstPass (i + 1) newArr (remaining - 1) newDone
        else
          firstPass (i + 1) arr remaining done
    
    let doneArray := Array.mkArray n_nat false
    let (ans1, done1, d1) := firstPass 0 ans d doneArray
    
    -- Second pass: flip '1' to '0' from right to left (only if not already flipped)
    let rec secondPass (i : Nat) (arr : Array Char) (remaining : Nat) (done : Array Bool) : Array Char × Nat :=
      if remaining = 0 then (arr, remaining)
      else if i = 0 then
        if arr[0]! = '1' && !done[0]! then
          (arr.set! 0 '0', remaining - 1)
        else
          (arr, remaining)
      else
        let idx := i - 1
        if arr[idx]! = '1' && !done[idx]! then
          let newArr := arr.set! idx '0'
          secondPass idx newArr (remaining - 1) done
        else
          secondPass idx arr remaining done
    
    let (ans2, _) := secondPass n_nat ans1 d1 done1
    
    String.mk ans2.toList
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to compute Hamming distance between two binary strings
def hammingDistance (s1 s2 : String) : Nat :=
  (s1.data.zip s2.data).filter (fun (c1, c2) => c1 ≠ c2) |>.length

-- Helper function to check if a string is a valid binary representation
def isBinaryString (s : String) : Prop :=
  ∀ c ∈ s.data, c = '0' ∨ c = '1'

-- Helper function to compare binary strings lexicographically (as numbers)
-- Returns true if s1 represents a larger or equal number than s2
def binaryStringGE (s1 s2 : String) : Prop :=
  s1.length = s2.length ∧ 
  isBinaryString s1 ∧ 
  isBinaryString s2 ∧
  (∀ s3 : String, s3.length = s1.length → isBinaryString s3 → 
    hammingDistance s2 s3 = hammingDistance s2 s1 → 
    -- s1 is lexicographically >= s3 (represents larger or equal value)
    (s1.data.zip s3.data).all (fun (c1, c3) => c1 = '1' ∨ c3 = '0' ∨ c1 = c3) ∨ s1 = s3)

-- Postcondition definitions
@[reducible, simp]
def maxHammingDistance_postcond (n : Nat) (x : String) (d : Nat) (result: String) (h_precond : maxHammingDistance_precond (n) (x) (d)) : Prop :=
  -- !benchmark @start postcond
  -- The result has the correct length
  result.length = n ∧
  -- The result is a valid binary string
  isBinaryString result ∧
  -- The Hamming distance between x and result is exactly d
  hammingDistance x result = d ∧
  -- The result is the maximum value among all binary strings with Hamming distance d from x
  (∀ y : String, y.length = n → isBinaryString y → hammingDistance x y = d → 
    -- result represents a value >= y
    (result.data.zip y.data).all (fun (r, c) => r = '1' ∨ c = '0' ∨ r = c) ∨ result = y)
  -- !benchmark @end postcond


-- Proof content
theorem maxHammingDistance_postcond_satisfied (n: Nat) (x: String) (d: Nat) (h_precond : maxHammingDistance_precond (n) (x) (d)) :
    maxHammingDistance_postcond (n) (x) (d) (maxHammingDistance (n) (x) (d) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

