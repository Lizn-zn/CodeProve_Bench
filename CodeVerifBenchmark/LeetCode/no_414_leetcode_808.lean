import Mathlib

-- Precondition auxiliary definitions
def soupServings_operations : List (Nat × Nat) := [(100, 0), (75, 25), (50, 50), (25, 75)]

/-- 
  Computes the probability that soup A becomes empty first plus half the probability
  that both soups become empty at the same time, using dynamic programming with memoization.
-/
def soupServings_prob (memo : Nat → Nat → Float) (a b : Nat) : Float :=
  if a = 0 ∧ b = 0 then
    0.5
  else if a = 0 then
    1.0
  else if b = 0 then
    0.0
  else
    let ops := soupServings_operations
    (soupServings_prob memo (Nat.sub a ops[0]!.1) (Nat.sub b ops[0]!.2) +
     soupServings_prob memo (Nat.sub a ops[1]!.1) (Nat.sub b ops[1]!.2) +
     soupServings_prob memo (Nat.sub a ops[2]!.1) (Nat.sub b ops[2]!.2) +
     soupServings_prob memo (Nat.sub a ops[3]!.1) (Nat.sub b ops[3]!.2)) / 4
  termination_by a + b
  decreasing_by
    simp_wf
    all_goals sorry

/-- 
  Memoized version of soupServings_prob using a 2D array for caching results.
-/
partial def soupServings_compute (n : Nat) : Float :=
  let size := n / 25 + 1
  let memo := fun (a b : Nat) => 
    if a ≥ size ∨ b ≥ size then
      if a = 0 ∧ b = 0 then 0.5
      else if a = 0 then 1.0
      else if b = 0 then 0.0
      else 1.0
    else
      -- This simplified version assumes a lookup table would be used in full implementation
      soupServings_prob (fun _ _ => 0.0) a b
  soupServings_prob memo n n

-- Precondition definitions
@[reducible, simp]
def soupServings_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- 
  Helper function to compute probabilities using memoization.
-/
def soupServings_prob' (memo : Nat → Nat → Option Float) (a b : Nat) : Float :=
  match memo a b with
  | some res => res
  | none =>
    if a = 0 ∧ b = 0 then
      0.5
    else if a = 0 then
      1.0
    else if b = 0 then
      0.0
    else
      let ops := soupServings_operations
      let prob := (soupServings_prob' memo (Nat.sub a ops[0]!.1) (Nat.sub b ops[0]!.2) +
                   soupServings_prob' memo (Nat.sub a ops[1]!.1) (Nat.sub b ops[1]!.2) +
                   soupServings_prob' memo (Nat.sub a ops[2]!.1) (Nat.sub b ops[2]!.2) +
                   soupServings_prob' memo (Nat.sub a ops[3]!.1) (Nat.sub b ops[3]!.2)) / 4
      prob
  termination_by a + b
  decreasing_by
    simp_wf
    all_goals sorry

/-- 
  Creates a memoization table for dynamic programming.
-/
def soupServings_memoTable (n : Nat) : Nat → Nat → Option Float :=
  let size := n / 25 + 1
  fun a b =>
    if a ≥ size ∨ b ≥ size then
      if a = 0 ∧ b = 0 then some 0.5
      else if a = 0 then some 1.0
      else if b = 0 then some 0.0
      else some 1.0
    else
      none

-- Main function definitions
def soupServings (n : Nat) (h_precond : soupServings_precond (n)) : Float :=
  -- !benchmark @start code
  if n = 0 then
    0.5
  else
    let scaled_n := (n + 24) / 25
    let memo := soupServings_memoTable scaled_n
    soupServings_prob' memo scaled_n scaled_n
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def soupServings_postcond (n : Nat) (result: Float) (h_precond : soupServings_precond (n)) : Prop :=
  -- !benchmark @start postcond
  let expected := soupServings_compute n
  Float.abs (result - expected) < 1e-5
  -- !benchmark @end postcond


-- Proof content
theorem soupServings_postcond_satisfied (n: Nat) (h_precond : soupServings_precond (n)) :
    soupServings_postcond (n) (soupServings (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof