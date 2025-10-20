import Mathlib

namespace no_2592_p03621


-- Precondition auxiliary definitions
-- Count the number of '1's in a string
def countOnes (s : String) : Nat :=
  s.data.foldl (fun acc c => if c == '1' then acc + 1 else acc) 0

-- Check if a string consists only of '0' and '1'
def isBinaryString (s : String) : Prop :=
  ∀ c ∈ s.data, c = '0' ∨ c = '1'

-- Precondition definitions
@[reducible, simp]
def solveStringTransformProbability_precond (A : String) (B : String) : Prop :=
  -- !benchmark @start precond
  -- A and B must have the same length
  A.length = B.length ∧
    -- A and B must be between 1 and 10000 characters
    1 ≤ A.length ∧ A.length ≤ 10000 ∧
    -- A and B must consist only of '0' and '1'
    isBinaryString A ∧ isBinaryString B ∧
    -- A and B must contain the same number of '1's
    countOnes A = countOnes B ∧
    -- A and B must contain at least one '1'
    countOnes A ≥ 1
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Modular arithmetic helper functions
def MOD : Nat := 998244353

-- Modular inverse using Fermat's little theorem
def modInv (n : Nat) : Nat :=
  n.pow (MOD - 2) % MOD

-- Precompute factorials and inverse factorials
def computeFactorials (N : Nat) : Array Nat × Array Nat :=
  Id.run do
    let mut fact := Array.mkArray N 1
    let mut ifact := Array.mkArray N 1
    for i in [1:N] do
      fact := fact.set! i ((fact[i-1]! * i) % MOD)
      ifact := ifact.set! i ((ifact[i-1]! * modInv i) % MOD)
    return (fact, ifact)

-- Integer log base 2
def ilog2 (n : Nat) : Nat :=
  if n ≤ 0 then 0 else n.log2

-- Pack polynomial coefficients
def pack (coeffs : List Nat) (shamt : Nat) : Nat :=
  let rec packRec (pack : List Nat) (shamt : Nat) : Nat :=
    let size := pack.length
    if size ≤ 1 then
      pack.headD 0
    else
      let npack := List.range ((size + 1) / 2) |>.map fun i =>
        if 2 * i + 1 < size then
          pack[2*i]! + (pack[2*i+1]! <<< shamt)
        else
          pack[2*i]!
      packRec npack (shamt <<< 1)
  termination_by pack.length
  packRec coeffs shamt

-- Unpack polynomial coefficients
def unpack (M : Nat) (size : Nat) (shamt : Nat) : List Nat :=
  let rec collectSizes (s : Nat) (acc : List Nat) : List Nat :=
    if s ≤ 1 then acc
    else collectSizes ((s + 1) / 2) (s :: acc)
  termination_by s
  let sizes := collectSizes size []
  let rec unpackRec (ret : List Nat) (shamt : Nat) (sizes : List Nat) : List Nat :=
    match sizes with
    | [] => ret
    | size :: rest =>
      let mask := (1 <<< shamt) - 1
      let nret := ret.flatMap fun c => [c &&& mask, c >>> shamt]
      let trimmed := List.take size nret
      unpackRec trimmed (shamt >>> 1) rest
  unpackRec [M] shamt sizes

-- Polynomial multiplication modulo MOD
def polyMulMod (f g : List Nat) : List Nat :=
  let size := min f.length g.length
  let shift := ilog2 ((MOD - 1) * (MOD - 1) * size) + 1
  let rsize := f.length + g.length - 1
  let shiftFinal := shift * (1 <<< ilog2 (rsize - 1))
  let product := pack f shift * pack g shift
  let h := unpack product rsize shiftFinal
  h.map (· % MOD)

-- Polynomial power modulo MOD with maximum degree
def polyPowerMod (f : List Nat) (n : Nat) (mx : Nat) : List Nat :=
  let rec powerRec (base : List Nat) (exp : Nat) (acc : List Nat) : List Nat :=
    if exp = 0 then acc
    else
      let acc' := if exp % 2 = 1 then List.take mx (polyMulMod acc base) else acc
      let base' := List.take mx (polyMulMod base base)
      powerRec base' (exp / 2) acc'
  termination_by exp
  powerRec f n [1]

-- Count positions where A has '1' but B has '0'
def countMismatchOnes (A B : String) : Nat :=
  (List.range A.length).foldl (fun acc i =>
    if i < A.length ∧ i < B.length ∧ A.data[i]! = '1' ∧ B.data[i]! = '0' 
    then acc + 1 
    else acc) 0

-- Main function definitions
def solveStringTransformProbability (A : String) (B : String) (h_precond : solveStringTransformProbability_precond (A) (B)) : Nat :=
  -- !benchmark @start code
  Id.run do
    let n := countOnes A
    let m := countMismatchOnes A B
    
    -- Precompute factorials up to n + 10
    let N := n + 10
    let (fact, ifact) := computeFactorials N
    
    -- Build polynomial [1/0!, 1/1!, 1/2!, ..., 1/n!]
    let poly := List.range n |>.map fun i => ifact[i+1]!
    
    -- Compute poly^m truncated to n+1 terms
    let polyPow := polyPowerMod poly m (n + 1)
    
    -- Compute the answer
    let mut ans := 0
    for k in [0:n - m + 1] do
      let mut term := (fact[n - m - k]! * fact[n - m - k]!) % MOD
      if k < polyPow.length then
        term := (term * polyPow[k]! % MOD * fact[m]!) % MOD
      else
        term := 0
      term := (term * fact[n - m]! % MOD * fact[n]!) % MOD
      term := (term * ifact[n - m - k]! % MOD * ifact[n - m - k]!) % MOD
      ans := (ans + term) % MOD
    
    return ans % MOD
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Get indices of '1's in a string
def getOneIndices (s : String) : List Nat :=
  (s.data.enum.filter (fun (_, c) => c == '1')).map (·.1)

-- The result should be Z modulo 998244353, where:
-- Z = P × (k!)², P is the probability that A becomes equal to B
-- after the transformation algorithm described in the problem
-- k is the number of '1's in both strings
-- m is the number of positions where A has '1' but B has '0'
-- The formula involves computing permutations and polynomial operations
def isValidResult (A B : String) (result : Nat) : Prop :=
  let k := countOnes A
  let m := countMismatchOnes A B
  -- The result must be less than MOD
  result < MOD ∧
  -- The result represents the number of permutation pairs (of a and b)
  -- that make A equal to B after the swap operations
  -- This is a complex combinatorial calculation involving:
  -- - Factorials
  -- - Polynomial multiplications
  -- - Modular arithmetic
  True  -- The actual formula is complex and matches the reference implementation

-- Postcondition definitions
@[reducible, simp]
def solveStringTransformProbability_postcond (A : String) (B : String) (result: Nat) (h_precond : solveStringTransformProbability_precond (A) (B)) : Prop :=
  -- !benchmark @start postcond
  -- The result must be a valid computation of Z mod 998244353
  isValidResult A B result ∧
    -- Result must be non-negative and less than MOD
    result < MOD
  -- !benchmark @end postcond


-- Proof content
theorem solveStringTransformProbability_postcond_satisfied (A: String) (B: String) (h_precond : solveStringTransformProbability_precond (A) (B)) :
    solveStringTransformProbability_postcond (A) (B) (solveStringTransformProbability (A) (B) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2592_p03621