import Mathlib

-- Precondition auxiliary definitions
def countDigits (digits : List Nat) : List Nat :=
  let counts := List.replicate 10 0
  digits.foldl (fun counts d => counts.set d (counts.get! d + 1)) counts

def validDigitCount (digits : List Nat) : Prop :=
  let counts := countDigits digits
  ∀ d, 0 ≤ d → d ≤ 9 → counts.get! d ≥ 0

def hasEvenDigit (digits : List Nat) : Prop :=
  digits.any (fun d => d % 2 = 0)

-- Precondition definitions
@[reducible, simp]
def findEvenNumbers_precond (digits : List Nat) : Prop :=
  -- !benchmark @start precond
  3 ≤ digits.length ∧ digits.length ≤ 100 ∧
    digits.all (fun d => 0 ≤ d ∧ d ≤ 9) ∧
    validDigitCount digits ∧
    hasEvenDigit digits
  -- !benchmark @end precond


-- Code auxiliary definitions
def range3DigitEven : List Nat :=
  List.range 900 |>.map (· + 100) |>.filter (· % 2 = 0)

def toStringList (n : Nat) : List Nat :=
  toString n |>.toList |>.map (fun c => c.toNat - '0'.toNat)

def isSubMultiset (l1 l2 : List Nat) : Bool :=
  let counts1 := countDigits l1
  let counts2 := countDigits l2
  List.range 10 |>.all (fun i => counts1.get! i ≤ counts2.get! i)

-- Main function definitions
def findEvenNumbers (digits : List Nat) (h_precond : findEvenNumbers_precond (digits)) : List Nat :=
  -- !benchmark @start code
  range3DigitEven.filter fun n =>
    isSubMultiset (toStringList n) digits
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def isValidNumber (digits : List Nat) (n : Nat) : Prop :=
  let s := toString n
  s.length = 3 ∧
  s.get! 0 ≠ '0' ∧
  n % 2 = 0 ∧
  let ds := s.toList.map (fun c => c.toNat - '0'.toNat)
  let counts := countDigits digits
  let ncounts := countDigits ds
  ∀ d, 0 ≤ d → d ≤ 9 → ncounts.get! d ≤ counts.get! d

def allValidNumbers (digits : List Nat) : Set Nat :=
  { n : Nat | isValidNumber digits n }

def isSortedUnique (l : List Nat) : Prop :=
  l.Pairwise (· < ·) ∧ l.Nodup

-- Postcondition definitions
@[reducible, simp]
def findEvenNumbers_postcond (digits : List Nat) (result: List Nat) (h_precond : findEvenNumbers_precond (digits)) : Prop :=
  -- !benchmark @start postcond
  result.Forall (fun n => isValidNumber digits n) ∧
  result.Sorted (· ≤ ·) ∧
  result.Nodup ∧
  (∀ n, isValidNumber digits n → n ∈ result)
  -- !benchmark @end postcond


-- Proof content
theorem findEvenNumbers_postcond_satisfied (digits: List Nat) (h_precond : findEvenNumbers_precond (digits)) :
    findEvenNumbers_postcond (digits) (findEvenNumbers (digits) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof