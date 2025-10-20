import Mathlib

-- Precondition auxiliary definitions
def isPalindrome (s : String) : Bool :=
  s.data == s.data.reverse

def splitString (s : String) (i : Nat) : String × String :=
  (s.extract 0 (⟨s.length - i⟩ : String.Pos), s.extract ⟨s.length - i⟩ (⟨s.length⟩ : String.Pos))

def checkSplit (a b : String) (i : Nat) : Bool :=
  let (aprefix, asuffix) := splitString a i
  let (bprefix, bsuffix) := splitString b i
  isPalindrome (aprefix ++ bsuffix) || isPalindrome (bprefix ++ asuffix)

-- Precondition definitions
@[reducible, simp]
def checkPalindromeFormation_precond (a : String) (b : String) : Prop :=
  -- !benchmark @start precond
  a.length = b.length ∧ a.length > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
def minNat : Nat → Nat → Nat
  | 0, n => 0
  | n, 0 => 0
  | m, n => if m < n then m else n

def maxNat : Nat → Nat → Nat
  | 0, n => n
  | n, 0 => n
  | m, n => if m > n then m else n

def List.getOrEmpty [Inhabited α] : List α → Nat → α
  | [], _ => default
  | a::_, 0 => a
  | _::as, n+1 => getOrEmpty as n

def String.getCharOrZero (s : String) (i : Nat) : Char :=
  match s.data.get? i with
  | some c => c
  | none => Char.ofNat 0

def String.isPrefixPalindrome (s : String) (k : Nat) : Bool :=
  let len := s.length
  if k > len then false
  else
    let half := k / 2
    let rec loop (i : Nat) : Bool :=
      if i ≥ half then true
      else if s.getCharOrZero i != s.getCharOrZero (k - 1 - i) then false
           else loop (i+1)
    loop 0

def String.isSuffixPalindrome (s : String) (k : Nat) : Bool :=
  let len := s.length
  if k > len then false
  else
    let start := len - k
    let half := start + k / 2
    let rec loop (i : Nat) : Bool :=
      if i ≥ half then true
      else if s.getCharOrZero i != s.getCharOrZero (len - 1 - (i - start)) then false
           else loop (i+1)
    loop start

def findMaxMatchingPrefix (a b : String) : Nat :=
  let len := a.length
  let rec loop (i : Nat) : Nat :=
    if i ≥ len then len
    else if a.getCharOrZero i == b.getCharOrZero (len - 1 - i) then loop (i+1)
         else i
  loop 0

-- Main function definitions
def checkPalindromeFormation (a : String) (b : String) (h_precond : checkPalindromeFormation_precond (a) (b)) : Bool :=
  -- !benchmark @start code
  let len := a.length
    let x := findMaxMatchingPrefix a b
    let y := findMaxMatchingPrefix b a
    let maxMatch := maxNat x y
    if maxMatch * 2 ≥ len then true
    else
      let remainingA := len - 2 * maxMatch
      let midA := a.extract ⟨maxMatch⟩ ⟨maxMatch + remainingA⟩
      let midB := b.extract ⟨maxMatch⟩ ⟨maxMatch + remainingA⟩
      isPalindrome midA || isPalindrome midB
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def checkPalindromeFormation_postcond (a : String) (b : String) (result: Bool) (h_precond : checkPalindromeFormation_precond (a) (b)) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ ∃ (i : Nat), i ≤ a.length ∧ checkSplit a b i
  -- !benchmark @end postcond


-- Proof content
theorem checkPalindromeFormation_postcond_satisfied (a: String) (b: String) (h_precond : checkPalindromeFormation_precond (a) (b)) :
    checkPalindromeFormation_postcond (a) (b) (checkPalindromeFormation (a) (b) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
