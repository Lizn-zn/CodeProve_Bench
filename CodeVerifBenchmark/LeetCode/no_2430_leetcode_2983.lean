import Mathlib

-- Precondition auxiliary definitions
def halfLength (s : String) : Nat :=
  s.length / 2

def isPalindrome (s : String) : Bool :=
  s.data == s.data.reverse

def charCount (s : String) : List (Char × Nat) :=
  s.data.foldl (fun acc c =>
    match acc.find? (fun (c', _) => c' = c) with
    | some (_, n) => acc.eraseP (fun (c', _) => c' = c) ++ [(c, n + 1)]
    | none => acc ++ [(c, 1)]
  ) []

def canRearrangeToMatch (s1 s2 : String) : Bool :=
  charCount s1 == charCount s2

def overlapInterval (a b c d : Nat) : Bool :=
  b.succ ≥ c ∧ a ≤ d.succ

def intersectInterval (a b c d : Nat) : Option (Nat × Nat) :=
  if overlapInterval a b c d then
    some (max a c, min b d)
  else
    none

def isPrefixMatch (s : String) (len : Nat) : Bool :=
  let left := s.extract (String.Pos.mk 0) (String.Pos.mk len)
  let right := s.extract (String.Pos.mk (s.length - len)) (String.Pos.mk s.length)
  left.data.reverse == right.data

def isSuffixMatch (s : String) (len : Nat) : Bool :=
  let left := s.extract (String.Pos.mk (s.length / 2 - len)) (String.Pos.mk (s.length / 2))
  let right := s.extract (String.Pos.mk (s.length / 2)) (String.Pos.mk (s.length / 2 + len))
  left.data == right.data.reverse

-- Precondition definitions
@[reducible, simp]
def canMakePalindromeQueries_precond (s : String) (queries : List (List Nat)) : Prop :=
  s.length % 2 = 0 ∧
  queries.all (fun q => q.length = 4 ∧
    let a := q[0]!
    let b := q[1]!
    let c := q[2]!
    let d := q[3]!
    a ≤ b ∧ b < s.length / 2 ∧
    s.length / 2 ≤ c ∧ c ≤ d ∧ d < s.length)

-- Code auxiliary definitions
def getStringRange (s : String) (start : Nat) (endPos : Nat) : String :=
  s.extract (String.Pos.mk start) (String.Pos.mk endPos)

def getLeftHalf (s : String) : String :=
  getStringRange s 0 (s.length / 2)

def getRightHalf (s : String) : String :=
  getStringRange s (s.length / 2) s.length

def reverseString (s : String) : String :=
  String.mk s.data.reverse

def charsEqualUpTo (s1 s2 : String) (len : Nat) : Bool :=
  let s1Prefix := getStringRange s1 0 (min len s1.length)
  let s2Prefix := getStringRange s2 0 (min len s2.length)
  s1Prefix == s2Prefix

def charsEqualFrom (s1 s2 : String) (pos : Nat) : Bool :=
  let len1 := s1.length
  let len2 := s2.length
  let s1Suffix := getStringRange s1 (min pos len1) len1
  let s2Suffix := getStringRange s2 (min pos len2) len2
  s1Suffix == s2Suffix

-- Main function definitions
noncomputable def canMakePalindromeQueries (s : String) (queries : List (List Nat)) (h_precond : canMakePalindromeQueries_precond s queries) : List Bool :=
  let halfLen := halfLength s
  let leftHalf := getLeftHalf s
  let rightHalf := getRightHalf s
  let reversedRight := reverseString rightHalf
  
  queries.map fun q =>
    let a := q[0]!
    let b := q[1]!
    let c := q[2]!
    let d := q[3]!
    
    -- Convert right indices to left half coordinates
    let c' := c - halfLen
    let d' := d - halfLen
    
    -- Check prefix match (before rearrangement areas)
    let prefixEnd := min a (halfLen - d.succ)
    let prefixMatch := charsEqualUpTo leftHalf reversedRight prefixEnd
    
    -- Check suffix match (after rearrangement areas)
    let suffixStartLeft := max b.succ (halfLen - c')
    let suffixStartRight := max c' (halfLen - a)
    let suffixMatch := 
      if suffixStartLeft < halfLen ∧ suffixStartRight < halfLen then
        let leftSuffix := getStringRange leftHalf suffixStartLeft halfLen
        let rightSuffix := getStringRange reversedRight suffixStartRight halfLen
        leftSuffix == rightSuffix
      else
        true
    
    if !(prefixMatch && suffixMatch) then
      false
    else
      -- Get the ranges that need to be checked for character matching
      let leftRearrangeStart := a
      let leftRearrangeEnd := b
      let rightRearrangeStart := c'
      let rightRearrangeEnd := d'
      
      -- Calculate intersection of rearrangeable areas in terms of their influence
      let leftInfluenceStart := leftRearrangeStart
      let leftInfluenceEnd := leftRearrangeEnd
      let rightInfluenceStart := halfLen - rightRearrangeEnd.succ
      let rightInfluenceEnd := halfLen - rightRearrangeStart.succ
      
      -- Check if we can make it work based on coverage and character counts
      let leftSegment := getStringRange leftHalf leftRearrangeStart (leftRearrangeEnd.succ)
      let rightSegment := getStringRange reversedRight rightRearrangeStart (rightRearrangeEnd.succ)
      
      canRearrangeToMatch leftSegment rightSegment

-- Postcondition auxiliary definitions
def canMakePalindrome (s : String) (a b c d : Nat) : Bool :=
  let n := s.length
  let half := n / 2
  let left := getStringRange s 0 half
  let right := getStringRange s half n
  let rightRev := String.mk (right.data.reverse)

  -- Characters that must match without rearrangement
  let prefixLen := min a (n - d.succ)
  let suffixLen := min (c - half) (half - b.succ)
  let prefixMatch := isPrefixMatch s prefixLen
  let suffixMatch := isSuffixMatch s suffixLen

  if !(prefixMatch && suffixMatch) then
    false
  else
    -- Get the segments that can be rearranged
    let leftSeg := getStringRange s a (b.succ)
    let rightSeg := getStringRange s c (d.succ)
    let rightSegRev := String.mk (rightSeg.data.reverse)

    -- Check if the rearrangeable segments have matching character counts
    canRearrangeToMatch leftSeg rightSegRev

-- Postcondition definitions
@[reducible, simp]
def canMakePalindromeQueries_postcond (s : String) (queries : List (List Nat)) (result: List Bool) (h_precond : canMakePalindromeQueries_precond s queries) : Prop :=
  result.length = queries.length ∧
  ∀ (i : Nat), i < result.length →
    let q := queries[i]!
    let a := q[0]!
    let b := q[1]!
    let c := q[2]!
    let d := q[3]!
    result[i]! = canMakePalindrome s a b c d

-- Proof content
theorem canMakePalindromeQueries_postcond_satisfied (s: String) (queries: List (List Nat)) (h_precond : canMakePalindromeQueries_precond s queries) :
    canMakePalindromeQueries_postcond s queries (canMakePalindromeQueries s queries h_precond) h_precond := by
  sorry