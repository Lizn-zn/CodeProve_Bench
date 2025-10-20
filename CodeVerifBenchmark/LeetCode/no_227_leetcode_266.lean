import Mathlib

def String.hasPalindromicPermutation (s : String) : Prop :=
  ∃ perm : List Char,
    perm.Perm s.data ∧
    perm = perm.reverse

namespace no_227_leetcode_266

-- Precondition auxiliary definitions
def Char.count (c : Char) (s : String) : Nat :=
  s.data.filter (· = c) |>.length

-- Precondition definitions
@[reducible, simp]
def canPermutePalindrome_precond (s : String) : Prop :=
  -- !benchmark @start precond
  1 ≤ s.length ∧ s.length ≤ 5000 ∧ s.data.all (· ∈ ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'])
  -- !benchmark @end precond


-- Code auxiliary definitions
def CharCount := List (Char × Nat)

def CharCount.count (cc : CharCount) (c : Char) : Nat :=
  match cc with
  | [] => 0
  | (c', n) :: rest => if c = c' then n else count rest c

def CharCount.ofList : List Char → CharCount
  | [] => []
  | c :: cs =>
    let rest := ofList cs
    match rest with
    | [] => [(c, 1)]
    | (c', n) :: rest' =>
      if c = c' then
        (c', n + 1) :: rest'
      else
        (c, 1) :: rest

def CharCount.countOdd (cc : CharCount) : Nat :=
  cc.filter (fun (_, n) => n % 2 = 1) |>.length

-- Main function definitions
def canPermutePalindrome (s : String) (h_precond : canPermutePalindrome_precond (s)) : Bool :=
  -- !benchmark @start code
  let charCounts := CharCount.ofList s.data
  let oddCount := charCounts.countOdd
  oddCount ≤ 1
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def canPermutePalindrome_postcond (s : String) (result: Bool) (h_precond : canPermutePalindrome_precond (s)) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ s.hasPalindromicPermutation
  -- !benchmark @end postcond


-- Proof content
theorem canPermutePalindrome_postcond_satisfied (s: String) (h_precond : canPermutePalindrome_precond (s)) :
    canPermutePalindrome_postcond (s) (canPermutePalindrome (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_227_leetcode_266
