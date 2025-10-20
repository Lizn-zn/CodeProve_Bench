import Mathlib

namespace no_2005_leetcode_2433


-- Precondition auxiliary definitions
def xorScan (arr : List Nat) : List Nat :=
  match arr with
  | [] => []
  | [a] => [a]
  | a :: b :: rest => a :: xorScan (a ^ b :: rest)
decreasing_by sorry

def xorScanEq (pref : List Nat) (arr : List Nat) : Prop :=
  pref = xorScan arr

-- Precondition definitions
@[reducible, simp]
def findArray_precond (pref : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function to compute the original array from prefix XOR array -/
def findArrayCore : List Nat → List Nat
  | [] => []
  | [x] => [x]
  | x :: y :: rest => x :: findArrayCore (y :: rest)

/-- Alternative implementation using zipWith for better performance -/
def findArrayAux (pref : List Nat) : List Nat :=
  match pref with
  | [] => []
  | head :: tail => head :: (List.zipWith (· ^ ·) (head :: tail) tail)

-- Main function definitions
def findArray (pref : List Nat) (h_precond : findArray_precond (pref)) : List Nat :=
  -- !benchmark @start code
  match pref with
    | [] => []
    | head :: tail =>
      let rec buildResult (prev : Nat) (remaining : List Nat) : List Nat :=
        match remaining with
        | [] => []
        | curr :: rest => (prev ^ curr) :: buildResult curr rest
      head :: buildResult head tail
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def findArray_postcond (pref : List Nat) (result: List Nat) (h_precond : findArray_precond (pref)) : Prop :=
  -- !benchmark @start postcond
  result.length = pref.length ∧
    ∀ i, 0 ≤ i → i < pref.length →
      (i = 0 → result[i]! = pref[i]!) ∧
      (i > 0 → result[i]! = pref[i-1]! ^ pref[i]!)
  -- !benchmark @end postcond


-- Proof content
theorem findArray_postcond_satisfied (pref: List Nat) (h_precond : findArray_precond (pref)) :
    findArray_postcond (pref) (findArray (pref) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2005_leetcode_2433