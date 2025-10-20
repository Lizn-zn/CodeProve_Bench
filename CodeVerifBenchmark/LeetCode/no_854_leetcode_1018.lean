import Mathlib

namespace no_854_leetcode_1018


-- Precondition auxiliary definitions
def isBinaryNat : Nat → Prop
  | 0 => True
  | 1 => True
  | _ => False

def isBinaryList : List Nat → Prop
  | [] => True
  | x :: xs => isBinaryNat x ∧ isBinaryList xs

-- Precondition definitions
@[reducible, simp]
def prefixesDivByFive_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  isBinaryList nums ∧ nums ≠ []
  -- !benchmark @end precond


-- Code auxiliary definitions
def prefixesDivByFiveCore : List Nat → Nat → List Bool
  | [], _ => []
  | b :: bs, acc =>
    let newAcc := (2 * acc + b) % 5
    (newAcc = 0) :: prefixesDivByFiveCore bs newAcc

-- Main function definitions
def prefixesDivByFive (nums : List Nat) (h_precond : prefixesDivByFive_precond (nums)) : List Bool :=
  -- !benchmark @start code
  prefixesDivByFiveCore nums 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def prefixesDivByFive_helper : List Nat → List Nat
  | [] => []
  | [x] => [x]
  | x :: xs =>
    let ys := prefixesDivByFive_helper xs
    let last := ys.getLast!
    x :: (2 * last + x) :: ys.dropLast

def convertBinaryList : List Nat → Nat
  | [] => 0
  | xs => xs.foldl (fun acc b => acc * 2 + b) 0

def prefixesDivByFive_expected : List Nat → List Bool
  | [] => []
  | nums =>
    let prefixes := List.range nums.length |>.map (fun i => nums.take (i+1))
    let values := prefixes.map convertBinaryList
    values.map (fun v => v % 5 = 0)

-- Postcondition definitions
@[reducible, simp]
def prefixesDivByFive_postcond (nums : List Nat) (result: List Bool) (h_precond : prefixesDivByFive_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result = prefixesDivByFive_expected nums
  -- !benchmark @end postcond


-- Proof content
theorem prefixesDivByFive_postcond_satisfied (nums: List Nat) (h_precond : prefixesDivByFive_precond (nums)) :
    prefixesDivByFive_postcond (nums) (prefixesDivByFive (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_854_leetcode_1018