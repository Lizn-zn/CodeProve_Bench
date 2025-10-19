import Mathlib

-- Precondition definitions
@[reducible, simp]
def solveMikoMiString_precond (s : String) : Prop :=
  -- !benchmark @start precond
  s.length ≥ 1 ∧ s.all (fun c => c.isAlpha)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Rolling hash implementation for string matching
structure RollingHash where
  base : Nat := 100
  mod1 : Nat := 1000000007
  mod2 : Nat := 2147483647
  hash1 : Array Nat
  hash2 : Array Nat

-- Build rolling hash arrays for a string
def buildRollingHash (s : String) : RollingHash :=
  let base := 100
  let mod1 := 1000000007
  let mod2 := 2147483647
  let chars := s.toList
  let (h1, h2) := chars.foldl (fun (acc1, acc2) c =>
    let i := c.toNat
    let new_acc1 := (acc1.back! * base + i) % mod1
    let new_acc2 := (acc2.back! * base + i) % mod2
    (acc1.push new_acc1, acc2.push new_acc2)
  ) (#[0], #[0])
  { base := base, mod1 := mod1, mod2 := mod2, hash1 := h1, hash2 := h2 }

-- Calculate hash of substring [left, right)
def calcHash (rh : RollingHash) (left right : Nat) : Nat × Nat :=
  let xlen := right - left
  let pow1 := Nat.pow rh.base xlen % rh.mod1
  let pow2 := Nat.pow rh.base xlen % rh.mod2
  let h1 := (rh.hash1[right]! + rh.mod1 - (rh.hash1[left]! * pow1) % rh.mod1) % rh.mod1
  let h2 := (rh.hash2[right]! + rh.mod2 - (rh.hash1[left]! * pow2) % rh.mod2) % rh.mod2
  (h1, h2)

-- Check if string matches ABABA pattern using rolling hash
def checkMikoMiPattern (s : String) (alen blen : Nat) (rh : RollingHash) : Bool :=
  let ha1 := calcHash rh 0 alen
  let ha2 := calcHash rh (alen + blen) (2 * alen + blen)
  if ha1 ≠ ha2 then false
  else
    let ha3 := calcHash rh (2 * alen + 2 * blen) (3 * alen + 2 * blen)
    if ha1 ≠ ha3 then false
    else
      let hb1 := calcHash rh alen (alen + blen)
      let hb2 := calcHash rh (2 * alen + blen) (2 * alen + 2 * blen)
      hb1 = hb2

-- Main function definitions
def solveMikoMiString (s : String) (h_precond : solveMikoMiString_precond (s)) : String :=
  -- !benchmark @start code
  let n := s.length
  let rh := buildRollingHash s
  let rec findSolution (alen : Nat) : String :=
    if alen > n / 3 then "mitomerarenaiWA"
    else
      -- Check if valid blen exists
      if (n - 3 * alen) % 2 ≠ 0 then findSolution (alen + 1)
      else
        let blen := (n - 3 * alen) / 2
        if blen ≤ 0 then findSolution (alen + 1)
        else
          -- Use rolling hash to check pattern
          if checkMikoMiPattern s alen blen rh then
            let ab := s.extract ⟨0⟩ ⟨alen + blen⟩
            "Love " ++ ab ++ "!"
          else
            findSolution (alen + 1)
  termination_by (n / 3 + 1 - alen)
  findSolution 1
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if a string can be decomposed as ABABA
def isMikoMiString (s A B : String) : Prop :=
  A.length > 0 ∧ B.length > 0 ∧ s = A ++ B ++ A ++ B ++ A

-- Helper function to find if there exists a valid decomposition
def existsMikoMiDecomposition (s : String) : Prop :=
  ∃ (A B : String), isMikoMiString s A B

-- Helper function to get the AB concatenation with minimum length
def getMinimalAB (s : String) : Option String :=
  -- For a string of length n to be decomposable as ABABA:
  -- n = 3*|A| + 2*|B|
  -- We need |A| ≥ 1 and |B| ≥ 1
  -- Iterate from smallest possible |AB| = |A| + |B|
  let n := s.length
  let rec findMinimal (alen : Nat) : Option String :=
    if alen > n / 3 then none
    else
      -- Calculate blen from: n = 3*alen + 2*blen
      if (n - 3 * alen) % 2 ≠ 0 then findMinimal (alen + 1)
      else
        let blen := (n - 3 * alen) / 2
        if blen ≤ 0 then findMinimal (alen + 1)
        else
          -- Check if the decomposition is valid
          let A := s.extract ⟨0⟩ ⟨alen⟩
          let B := s.extract ⟨alen⟩ ⟨alen + blen⟩
          let A2 := s.extract ⟨alen + blen⟩ ⟨2 * alen + blen⟩
          let B2 := s.extract ⟨2 * alen + blen⟩ ⟨2 * alen + 2 * blen⟩
          let A3 := s.extract ⟨2 * alen + 2 * blen⟩ ⟨3 * alen + 2 * blen⟩
          if A = A2 ∧ A = A3 ∧ B = B2 then
            some (A ++ B)
          else
            findMinimal (alen + 1)
  termination_by (n / 3 + 1 - alen)
  findMinimal 1

-- Postcondition definitions
@[reducible, simp]
def solveMikoMiString_postcond (s : String) (result: String) (h_precond : solveMikoMiString_precond (s)) : Prop :=
  -- !benchmark @start postcond
  match getMinimalAB s with
    | some ab => result = "Love " ++ ab ++ "!"
    | none => result = "mitomerarenaiWA"
  -- !benchmark @end postcond


-- Proof content
theorem solveMikoMiString_postcond_satisfied (s: String) (h_precond : solveMikoMiString_precond (s)) :
    solveMikoMiString_postcond (s) (solveMikoMiString (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof