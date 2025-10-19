import Mathlib

-- Precondition auxiliary definitions
def validShift (shift : Int × Int) : Prop :=
  let (dir, amount) := shift
  (dir = 0 ∨ dir = 1) ∧ amount ≥ 0

def allShiftsValid (shifts : List (Int × Int)) : Prop :=
  ∀ shift ∈ shifts, validShift shift

-- Precondition definitions
@[reducible, simp]
def performShifts_precond (s : String) (shift : List (Int × Int)) : Prop :=
  -- !benchmark @start precond
  s.length > 0 ∧ allShiftsValid shift
  -- !benchmark @end precond


-- Code auxiliary definitions
def shiftLeft (s : String) (amount : Nat) : String :=
  if s.length = 0 then s else
  let n := s.length
  let amount := amount % n
  if amount = 0 then s else
  let left := s.extract ⟨0⟩ ⟨amount⟩
  let right := s.extract ⟨amount⟩ ⟨n⟩
  right ++ left

def shiftRight (s : String) (amount : Nat) : String :=
  if s.length = 0 then s else
  let n := s.length
  let amount := amount % n
  if amount = 0 then s else
  let splitPoint := n - amount
  let left := s.extract ⟨0⟩ ⟨splitPoint⟩
  let right := s.extract ⟨splitPoint⟩ ⟨n⟩
  right ++ left

def applyShift (s : String) (shift : Int × Int) : String :=
  let (dir, amount) := shift
  if dir = 0 then
    shiftLeft s (amount.toNat)
  else
    shiftRight s (amount.toNat)

-- Main function definitions
def performShifts (s : String) (shift : List (Int × Int)) (h_precond : performShifts_precond (s) (shift)) : String :=
  -- !benchmark @start code
  performShifts.loop s shift
    where
      loop (s : String) (shifts : List (Int × Int)) : String :=
        match shifts with
        | [] => s
        | shift :: rest => loop (applyShift s shift) rest
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def computeNetShift (shifts : List (Int × Int)) : Int :=
  shifts.foldl (fun acc shift =>
    let (dir, amount) := shift
    if dir = 0 then acc - amount else acc + amount
  ) 0

def shiftString (s : String) (netShift : Int) : String :=
  if s.length = 0 then s else
  let n := s.length
  let normalizedShift := netShift % Int.ofNat n
  let effectiveShift := if normalizedShift < 0 then Int.ofNat n + normalizedShift else normalizedShift
  if effectiveShift = 0 then s else
  let splitPoint := n - effectiveShift.toNat
  let left := s.extract ⟨0⟩ ⟨splitPoint⟩
  let right := s.extract ⟨splitPoint⟩ ⟨n⟩
  right ++ left

-- Postcondition definitions
@[reducible, simp]
def performShifts_postcond (s : String) (shift : List (Int × Int)) (result: String) (h_precond : performShifts_precond (s) (shift)) : Prop :=
  -- !benchmark @start postcond
  result = shiftString s (computeNetShift shift)
  -- !benchmark @end postcond


-- Proof content
theorem performShifts_postcond_satisfied (s: String) (shift: List (Int × Int)) (h_precond : performShifts_precond (s) (shift)) :
    performShifts_postcond (s) (shift) (performShifts (s) (shift) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof