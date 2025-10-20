import Mathlib

namespace no_589_leetcode_738


-- Precondition auxiliary definitions
def digits : Nat → List Nat
  | 0 => [0]
  | n@(Nat.succ _) => Nat.digits 10 n

def IsMonotoneIncreasing (l : List Nat) : Prop :=
  ∀ (i j : Fin l.length), i < j → l.get i ≤ l.get j

def fromDigits (l : List Nat) : Nat :=
  l.enum.reverse.foldl (fun (acc : Nat) (pos, digit) => 
    acc + digit * (10 ^ pos)
  ) 0

-- Precondition definitions
@[reducible, simp]
def monotoneIncreasingDigits_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  0 ≤ n ∧ n ≤ 10^9
  -- !benchmark @end precond


-- Code auxiliary definitions
def findDecreasingIndex (l : List Nat) : Option Nat :=
  let rec go (l : List Nat) (i : Nat) : Option Nat :=
    match l with
    | [] => none
    | [_] => none
    | a :: b :: rest =>
      if a > b then
        some i
      else
        go (b :: rest) (i + 1)
  go l 0

def decreaseAndFill (l : List Nat) (idx : Nat) : List Nat :=
  let rec updateList (l : List Nat) (i : Nat) (idx : Nat) : List Nat :=
    match l with
    | [] => []
    | x :: xs =>
      if i = idx then
        (x - 1) :: List.replicate (l.length - i - 1) 9
      else
        x :: updateList xs (i + 1) idx
  updateList l 0 idx

-- Main function definitions
def monotoneIncreasingDigits (n : Nat) (h_precond : monotoneIncreasingDigits_precond (n)) : Nat :=
  -- !benchmark @start code
  let digitList := digits n
  let decIdx := findDecreasingIndex digitList
  match decIdx with
  | none => n
  | some idx =>
    let modifiedList := decreaseAndFill digitList idx
    fromDigits modifiedList
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def monotoneIncreasingDigits_postcond (n : Nat) (result: Nat) (h_precond : monotoneIncreasingDigits_precond (n)) : Prop :=
  -- !benchmark @start postcond
  result ≤ n ∧ 
  (IsMonotoneIncreasing (digits result)) ∧
  (∀ (m : Nat), m ≤ n → IsMonotoneIncreasing (digits m) → m ≤ result)
  -- !benchmark @end postcond


-- Proof content
theorem monotoneIncreasingDigits_postcond_satisfied (n: Nat) (h_precond : monotoneIncreasingDigits_precond (n)) :
    monotoneIncreasingDigits_postcond (n) (monotoneIncreasingDigits (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_589_leetcode_738