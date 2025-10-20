import Mathlib

namespace no_2263_p03251


-- Precondition definitions
@[reducible, simp]
def checkWarStatus_precond (n : Nat) (m : Nat) (x : Int) (y : Int) (xs : List Int) (ys : List Int) : Prop :=
  -- !benchmark @start precond
  -- The input constraints from the problem
    n ≥ 1 ∧ n ≤ 100 ∧
    m ≥ 1 ∧ m ≤ 100 ∧
    x < y ∧
    x ≥ -100 ∧ y ≤ 100 ∧
    xs.length = n ∧
    ys.length = m ∧
    (∀ xi ∈ xs, xi ≥ -100 ∧ xi ≤ 100 ∧ xi ≠ x) ∧
    (∀ yi ∈ ys, yi ≥ -100 ∧ yi ≤ 100 ∧ yi ≠ y) ∧
    xs.Nodup ∧
    ys.Nodup
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to find maximum of a list of integers
def maxList (l : List Int) : Option Int :=
  l.foldl (fun acc x => match acc with
    | none => some x
    | some a => some (max a x)) none

-- Helper function to find minimum of a list of integers
def minList (l : List Int) : Option Int :=
  l.foldl (fun acc x => match acc with
    | none => some x
    | some a => some (min a x)) none

-- Main function definitions
def checkWarStatus (n : Nat) (m : Nat) (x : Int) (y : Int) (xs : List Int) (ys : List Int) (h_precond : checkWarStatus_precond (n) (m) (x) (y) (xs) (ys)) : String :=
  -- !benchmark @start code
  -- Append x to xs and y to ys
    let xs_with_x := xs ++ [x]
    let ys_with_y := ys ++ [y]
    
    -- Find maximum of xs_with_x and minimum of ys_with_y
    let max_a := maxList xs_with_x
    let min_b := minList ys_with_y
    
    -- Check if war breaks out
    match max_a, min_b with
    | some max_val, some min_val =>
      if min_val <= max_val then
        "War"
      else
        "No War"
    | _, _ => "War"  -- This case shouldn't happen given preconditions
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def checkWarStatus_postcond (n : Nat) (m : Nat) (x : Int) (y : Int) (xs : List Int) (ys : List Int) (result: String) (h_precond : checkWarStatus_precond (n) (m) (x) (y) (xs) (ys)) : Prop :=
  -- !benchmark @start postcond
  -- War breaks out if and only if there exists no integer Z satisfying:
    -- 1. X < Z ≤ Y
    -- 2. All cities x_i < Z
    -- 3. All cities y_i ≥ Z
    -- 
    -- This is equivalent to: min(ys ++ [y]) > max(xs ++ [x])
    -- If min(ys ++ [y]) ≤ max(xs ++ [x]), then no valid Z exists, so war breaks out
    let max_a := (maxList (xs ++ [x])).getD x
    let min_b := (minList (ys ++ [y])).getD y
    (result = "War" ↔ min_b ≤ max_a) ∧
    (result = "No War" ↔ min_b > max_a)
  -- !benchmark @end postcond


-- Proof content
theorem checkWarStatus_postcond_satisfied (n: Nat) (m: Nat) (x: Int) (y: Int) (xs: List Int) (ys: List Int) (h_precond : checkWarStatus_precond (n) (m) (x) (y) (xs) (ys)) :
    checkWarStatus_postcond (n) (m) (x) (y) (xs) (ys) (checkWarStatus (n) (m) (x) (y) (xs) (ys) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2263_p03251