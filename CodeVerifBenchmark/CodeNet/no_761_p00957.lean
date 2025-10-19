import Mathlib

-- Precondition definitions
@[reducible, simp]
def countChocolatePoles_precond (l : Nat) (k : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ l ∧ l ≤ 100 ∧ 2 ≤ k ∧ k ≤ 10
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def countChocolatePoles (l : Nat) (k : Nat) (h_precond : countChocolatePoles_precond (l) (k)) : Nat :=
  -- !benchmark @start code
  Id.run do
    let mut d := Array.mkArray (l + 1) (0, 0)
    d := d.set! 0 (0, 1)
    let mut s := 0
    for i in [1:l+1] do
      let (prevDark, prevWhite) := d[i - 1]!
      let newWhite := prevDark
      let darkFromThick := if i >= k then d[i - k]!.2 else 0
      let newDark := prevWhite + darkFromThick
      d := d.set! i (newDark, newWhite)
      s := s + newDark
    return s
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if a pole configuration is valid
def isValidPole (pole : List Nat) (l : Nat) (k : Nat) : Bool :=
  -- pole is represented as a list of disk thicknesses (1 for thin, k for thick)
  -- where each element also encodes color: odd index = white thin, even index = dark
  pole.length > 0 ∧ 
  pole.sum ≤ l ∧
  -- Implementation note: We'll use a different representation
  true

-- Represents the state: (thickness, endsWithWhite)
-- d[i][0] = number of poles of thickness i ending with dark disk
-- d[i][1] = number of poles of thickness i ending with white disk
def countPolesDP (l : Nat) (k : Nat) : Nat :=
  let rec computeDP (i : Nat) (d : Array (Nat × Nat)) : Nat :=
    if i > l then
      -- Sum all poles ending with dark disk (valid poles)
      (List.range (l + 1)).foldl (fun acc idx => acc + (d[idx]!.1)) 0
    else
      let darkFromWhite := if i ≥ 1 then d[i - 1]!.2 else 0
      let whiteFromDark := if i ≥ 1 then d[i - 1]!.1 else 0
      let darkFromThick := if i ≥ k then d[i - k]!.2 else 0
      let newDark := darkFromWhite + darkFromThick
      let newWhite := whiteFromDark
      let d' := d.set! i (newDark, newWhite)
      computeDP (i + 1) d'
  termination_by (l + 1 - i)
  -- Initialize: d[0] = (0, 1) means we start with "nothing" which can be followed by either color
  -- Actually, d[0][1] = 1 means we have a virtual white disk of thickness 0 to start
  let initialDP := Array.mkArray (l + 1) (0, 0) |>.set! 0 (0, 1)
  computeDP 1 initialDP

-- Alternative cleaner definition matching the algorithm
def countPolesDP' (l : Nat) (k : Nat) : Nat :=
  let rec loop (i : Nat) (d : Array (Nat × Nat)) (s : Nat) : Nat :=
    if i > l then s
    else
      let (prevDark, prevWhite) := d[i - 1]!
      let newWhite := prevDark
      let newDark := prevWhite + (if i ≥ k then d[i - k]!.2 else 0)
      let d' := d.set! i (newDark, newWhite)
      loop (i + 1) d' (s + newDark)
  termination_by (l + 1 - i)
  let initialDP := Array.mkArray (l + 1) (0, 0) |>.set! 0 (0, 1)
  loop 1 initialDP 0

-- Postcondition definitions
@[reducible, simp]
def countChocolatePoles_postcond (l : Nat) (k : Nat) (result: Nat) (h_precond : countChocolatePoles_precond (l) (k)) : Prop :=
  -- !benchmark @start postcond
  result = countPolesDP' l k
  -- !benchmark @end postcond


-- Proof content
theorem countChocolatePoles_postcond_satisfied (l: Nat) (k: Nat) (h_precond : countChocolatePoles_precond (l) (k)) :
    countChocolatePoles_postcond (l) (k) (countChocolatePoles (l) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof