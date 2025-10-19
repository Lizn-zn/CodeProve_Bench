import Mathlib

-- Precondition auxiliary definitions
-- Helper to check if a character is a digit
def isDigit (c : Char) : Bool :=
  c.toNat >= '0'.toNat && c.toNat <= '9'.toNat

-- Helper to check if a character is a nonzero digit
def isNonzeroDigit (c : Char) : Bool :=
  c.toNat >= '1'.toNat && c.toNat <= '9'.toNat

-- Helper to check if a character is a shift operation
def isShift (c : Char) : Bool :=
  c = 'L' || c = 'R' || c = 'U' || c = 'D'

-- Mutual recursive validation of the BNF grammar
mutual
  partial def validSequence (s : String) (pos : Nat) : Option Nat :=
    if pos >= s.length then some pos
    else
      match validRepetition s pos with
      | some pos' => if pos' > pos then validSequence s pos' else validOperation s pos >>= validSequence s
      | none => validOperation s pos >>= validSequence s

  partial def validRepetition (s : String) (pos : Nat) : Option Nat :=
    if pos >= s.length || s.get ⟨pos⟩ != '(' then none
    else
      match validSequence s (pos + 1) with
      | some pos' =>
        if pos' >= s.length || s.get ⟨pos'⟩ != ')' then none
        else validNumber s (pos' + 1)
      | none => none

  partial def validOperation (s : String) (pos : Nat) : Option Nat :=
    if pos >= s.length || !isShift (s.get ⟨pos⟩) then none
    else validNumber s (pos + 1)

  partial def validNumber (s : String) (pos : Nat) : Option Nat :=
    if pos >= s.length || !isNonzeroDigit (s.get ⟨pos⟩) then none
    else validNumberTail s (pos + 1)

  partial def validNumberTail (s : String) (pos : Nat) : Option Nat :=
    if pos >= s.length || !isDigit (s.get ⟨pos⟩) then some pos
    else validNumberTail s (pos + 1)
end

-- Precondition definitions
@[reducible, simp]
def shiftMatrix_precond (N : Nat) (S : String) : Prop :=
  -- !benchmark @start precond
  N ≥ 1 ∧ N ≤ 100 ∧
    S.length ≥ 2 ∧ S.length ≤ 1000 ∧
    validSequence S 0 = some S.length
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper functions for parsing and matrix operations

-- Parse a number from string starting at position pos
partial def parseNumberHelper (s : String) (pos : Nat) : Nat × Nat :=
  if pos >= s.length || !isDigit (s.get ⟨pos⟩) then (0, pos)
  else
    let (rest, newPos) := parseNumberHelper s (pos + 1)
    ((s.get ⟨pos⟩).toNat - '0'.toNat + 10 * rest, newPos)

-- Apply a permutation to an index array
def applyPermutation (perm : Array Nat) (arr : Array Nat) : Array Nat :=
  arr.map (fun i => perm[i]!)

-- Compute f^n using fast exponentiation
partial def fastPowHelper (f : Array Nat) (n : Nat) (N : Nat) : Array Nat :=
  let identity := Array.range (N * N)
  let rec loop (base : Array Nat) (exp : Nat) (acc : Array Nat) : Array Nat :=
    if exp = 0 then acc
    else
      let acc' := if exp % 2 = 1 then applyPermutation base acc else acc
      let base' := applyPermutation base base
      loop base' (exp / 2) acc'
  loop f n identity

-- Create a permutation for a single shift operation
partial def createShift (shift : Char) (idx : Nat) (N : Nat) : Array Nat :=
  let identity := Array.range (N * N)
  if shift = 'L' then
    let row := idx - 1
    identity.mapIdx (fun i v =>
      let r := i / N
      let c := i % N
      if r = row then row * N + (c + 1) % N
      else v)
  else if shift = 'R' then
    let row := idx - 1
    identity.mapIdx (fun i v =>
      let r := i / N
      let c := i % N
      if r = row then row * N + (c + N - 1) % N
      else v)
  else if shift = 'U' then
    let col := idx - 1
    identity.mapIdx (fun i v =>
      let r := i / N
      let c := i % N
      if c = col then ((r + 1) % N) * N + col
      else v)
  else -- 'D'
    let col := idx - 1
    identity.mapIdx (fun i v =>
      let r := i / N
      let c := i % N
      if c = col then ((r + N - 1) % N) * N + col
      else v)

-- Parse and evaluate the expression
partial def parseAndEval (s : String) (pos : Nat) (N : Nat) : Array Nat × Nat :=
  let identity := Array.range (N * N)
  let rec loop (currentPerm : Array Nat) (currentPos : Nat) : Array Nat × Nat :=
    if currentPos >= s.length then (currentPerm, currentPos)
    else if s.get ⟨currentPos⟩ = '(' then
      let (innerPerm, pos1) := parseAndEval s (currentPos + 1) N
      if pos1 >= s.length || s.get ⟨pos1⟩ != ')' then (currentPerm, currentPos)
      else
        let (num, pos2) := parseNumberHelper s (pos1 + 1)
        let repeated := fastPowHelper innerPerm num N
        loop (applyPermutation repeated currentPerm) pos2
    else if isShift (s.get ⟨currentPos⟩) then
      let shift := s.get ⟨currentPos⟩
      let (idx, pos1) := parseNumberHelper s (currentPos + 1)
      let perm := createShift shift idx N
      loop (applyPermutation perm currentPerm) pos1
    else (currentPerm, currentPos)
  loop identity pos

-- Main function definitions
def shiftMatrix (N : Nat) (S : String) (h_precond : shiftMatrix_precond (N) (S)) : Array (Array Nat) :=
  -- !benchmark @start code
  let (perm, _) := parseAndEval S 0 N
    let initial := Array.range (N * N) |>.map (· + 1)
    let final := perm.map (fun i => initial[i]!)
    Array.range N |>.map (fun i => Array.range N |>.map (fun j => final[i * N + j]!))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Parse and execute the operation sequence to compute the final matrix
mutual
  partial def parseNumber (s : String) (pos : Nat) : Nat × Nat :=
    if pos >= s.length || !isDigit (s.get ⟨pos⟩) then (0, pos)
    else
      let (rest, newPos) := parseNumber s (pos + 1)
      ((s.get ⟨pos⟩).toNat - '0'.toNat + 10 * rest, newPos)

  -- Apply a permutation to an index array
  partial def applyPerm (perm : Array Nat) (arr : Array Nat) : Array Nat :=
    arr.map (fun i => perm[i]!)

  -- Compute f^n using fast exponentiation
  partial def fastPow (f : Array Nat) (n : Nat) (N : Nat) : Array Nat :=
    let identity := Array.range (N * N)
    let rec loop (base : Array Nat) (exp : Nat) (acc : Array Nat) : Array Nat :=
      if exp = 0 then acc
      else
        let acc' := if exp % 2 = 1 then applyPerm base acc else acc
        let base' := applyPerm base base
        loop base' (exp / 2) acc'
    loop f n identity

  partial def parseExpr (s : String) (pos : Nat) (N : Nat) : Array Nat × Nat :=
    let identity := Array.range (N * N)
    let rec loop (currentPerm : Array Nat) (currentPos : Nat) : Array Nat × Nat :=
      if currentPos >= s.length then (currentPerm, currentPos)
      else if s.get ⟨currentPos⟩ = '(' then
        let (innerPerm, pos1) := parseExpr s (currentPos + 1) N
        if pos1 >= s.length || s.get ⟨pos1⟩ != ')' then (currentPerm, currentPos)
        else
          let (num, pos2) := parseNumber s (pos1 + 1)
          let repeated := fastPow innerPerm num N
          loop (applyPerm repeated currentPerm) pos2
      else if isShift (s.get ⟨currentPos⟩) then
        let shift := s.get ⟨currentPos⟩
        let (idx, pos1) := parseNumber s (currentPos + 1)
        let perm := createShiftPerm shift idx N
        loop (applyPerm perm currentPerm) pos1
      else (currentPerm, currentPos)
    loop identity pos

  partial def createShiftPerm (shift : Char) (idx : Nat) (N : Nat) : Array Nat :=
    let identity := Array.range (N * N)
    if shift = 'L' then
      -- Left shift row idx (1-based)
      let row := idx - 1
      identity.mapIdx (fun i v =>
        let r := i / N
        let c := i % N
        if r = row then row * N + (c + 1) % N
        else v)
    else if shift = 'R' then
      -- Right shift row idx (1-based)
      let row := idx - 1
      identity.mapIdx (fun i v =>
        let r := i / N
        let c := i % N
        if r = row then row * N + (c + N - 1) % N
        else v)
    else if shift = 'U' then
      -- Up shift column idx (1-based)
      let col := idx - 1
      identity.mapIdx (fun i v =>
        let r := i / N
        let c := i % N
        if c = col then ((r + 1) % N) * N + col
        else v)
    else -- 'D'
      -- Down shift column idx (1-based)
      let col := idx - 1
      identity.mapIdx (fun i v =>
        let r := i / N
        let c := i % N
        if c = col then ((r + N - 1) % N) * N + col
        else v)
end

def computeFinalMatrix (N : Nat) (S : String) : Array (Array Nat) :=
  let (perm, _) := parseExpr S 0 N
  let initial := Array.range (N * N) |>.map (· + 1)
  let final := perm.map (fun i => initial[i]!)
  Array.range N |>.map (fun i => Array.range N |>.map (fun j => final[i * N + j]!))

-- Postcondition definitions
@[reducible, simp]
def shiftMatrix_postcond (N : Nat) (S : String) (result: Array (Array Nat)) (h_precond : shiftMatrix_precond (N) (S)) : Prop :=
  -- !benchmark @start postcond
  result.size = N ∧
    (∀ i : Fin N, result[i]!.size = N) ∧
    result = computeFinalMatrix N S
  -- !benchmark @end postcond


-- Proof content
theorem shiftMatrix_postcond_satisfied (N: Nat) (S: String) (h_precond : shiftMatrix_precond (N) (S)) :
    shiftMatrix_postcond (N) (S) (shiftMatrix (N) (S) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof