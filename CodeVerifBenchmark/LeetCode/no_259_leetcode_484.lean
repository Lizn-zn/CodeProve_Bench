import Mathlib

-- Precondition auxiliary definitions
/-- Check if a character is either 'I' or 'D'. -/
def isIDChar (c : Char) : Prop := c = 'I' ∨ c = 'D'

/-- Check if all characters in a string are either 'I' or 'D'. -/
def isValidString (s : String) : Prop := ∀ i : String.Pos, i < s.endPos → isIDChar (s.get i)

-- Precondition definitions
@[reducible, simp]
def reconstructPermutation_precond (s : String) : Prop :=
  -- !benchmark @start precond
  isValidString s
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Compare two lists of natural numbers lexicographically. -/
def compareLexicographically : List Nat → List Nat → Ordering
  | [], [] => Ordering.eq
  | [], _ :: _ => Ordering.lt
  | _ :: _, [] => Ordering.gt
  | x :: xs, y :: ys =>
    if x < y then Ordering.lt
    else if x > y then Ordering.gt
    else compareLexicographically xs ys

/-- Reverse a list in place. -/
def reverseList (l : List Nat) : List Nat :=
  l.reverse

/-- Generate a list containing numbers from 1 to n. -/
def rangeList (n : Nat) : List Nat :=
  List.range (n + 1) |>.drop 1 |>.reverse

/-- Helper function to reverse segments based on 'D' sequences. -/
def processSegments (s : String) (perm : List Nat) : List Nat :=
  let chars := s.data
  let rec loop (i : Nat) (acc : List Nat) (start : Option Nat) : List Nat :=
    if i ≥ chars.length then
      match start with
      | none => acc
      | some st =>
        let segment := List.drop st (List.take (i + 1) perm)
        let reversedSegment := reverseList segment
        let prefixPart := List.take st perm
        let suffixPart := List.drop (i + 1) perm
        prefixPart ++ reversedSegment ++ suffixPart
    else
      let c := chars[i]!
      match c, start with
      | 'D', none => loop (i + 1) acc (some i)
      | 'D', some _ => loop (i + 1) acc start
      | 'I', none => loop (i + 1) acc none
      | 'I', some st =>
        let segment := List.drop st (List.take (i + 1) perm)
        let reversedSegment := reverseList segment
        let prefixPart := List.take st perm
        let suffixPart := List.drop (i + 1) perm
        let newPerm := prefixPart ++ reversedSegment ++ suffixPart
        loop (i + 1) newPerm none
      | _, _ => loop (i + 1) acc start
  loop 0 perm none


-- Main function definitions
def reconstructPermutation (s : String) (h_precond : reconstructPermutation_precond (s)) : List Nat :=
  -- !benchmark @start code
  let n := s.length + 1
  let initialPerm := rangeList n
  processSegments s initialPerm
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Check if a list of natural numbers is a permutation of [1, ..., n]. -/
def isPermutationOfRange (l : List Nat) (n : Nat) : Prop :=
  l.length = n ∧
  (∀ x ∈ l, 1 ≤ x ∧ x ≤ n) ∧
  (∀ x y, x ∈ l → y ∈ l → x ≠ y → x ≠ y) -- This line ensures all elements are distinct.

/-- Get the pattern of a permutation as a string of 'I's and 'D's. -/
def getPattern (perm : List Nat) : String :=
  match perm with
  | [] => ""
  | [_] => ""
  | a :: b :: rest =>
    let firstChar := if a < b then 'I' else 'D'
    let restPerm := b :: rest
    let restPattern := getPattern restPerm
    String.mk (firstChar :: restPattern.data)

-- Postcondition definitions
@[reducible, simp]
def reconstructPermutation_postcond (s : String) (result: List Nat) (h_precond : reconstructPermutation_precond (s)) : Prop :=
  -- !benchmark @start postcond
  isPermutationOfRange result (s.length + 1) ∧
  getPattern result = s ∧
  (∀ otherPerm : List Nat,
    isPermutationOfRange otherPerm (s.length + 1) →
    getPattern otherPerm = s →
    compareLexicographically result otherPerm ≠ Ordering.gt)
  -- !benchmark @end postcond


-- Proof content
theorem reconstructPermutation_postcond_satisfied (s: String) (h_precond : reconstructPermutation_precond (s)) :
    reconstructPermutation_postcond (s) (reconstructPermutation (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof