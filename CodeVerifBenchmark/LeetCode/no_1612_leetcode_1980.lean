import Mathlib

-- Precondition auxiliary definitions
def isValidBinaryString (s : String) : Bool :=
  s.data.all (fun c => c = '0' ∨ c = '1')

def hasLengthN (s : String) (n : Nat) : Bool :=
  s.length = n

def allUnique (l : List String) : Prop :=
  l.Pairwise (· ≠ ·)

-- Precondition definitions
@[reducible, simp]
def findDifferentBinaryString_precond (nums : List String) : Prop :=
  -- !benchmark @start precond
  let n := nums.length
  n > 0 ∧ n ≤ 16 ∧
  nums.all (hasLengthN · n) ∧
  nums.all isValidBinaryString ∧
  allUnique nums
  -- !benchmark @end precond


-- Code auxiliary definitions
def flipBit : Char → Char
  | '0' => '1'
  | '1' => '0'
  | _   => '0'  -- default case, though precondition ensures only '0' or '1'

def flipStringBits : List Char → List Char
  | [] => []
  | c :: cs => flipBit c :: flipStringBits cs

def listToString : List Char → String
  | l => ⟨l⟩

def buildDiagonalString : List (List Char) → Nat → List Char
  | [], _ => []
  | row :: rows, 0 => row.head! :: buildDiagonalString rows 0
  | row :: rows, Nat.succ k => buildDiagonalString (row.tail! :: rows) k

-- This function constructs a string by flipping the i-th bit of the i-th string
def constructCantorString : List (List Char) → List Char
  | [] => []
  | rows => 
    let n := rows.length
    let diag := buildDiagonalString rows 0
    flipStringBits diag

-- Main function definitions
def findDifferentBinaryString (nums : List String) (h_precond : findDifferentBinaryString_precond (nums)) : String :=
  -- !benchmark @start code
  let n := nums.length
    -- Convert each string to a list of characters
    let charLists := nums.map (fun s => s.data)
    -- Construct the cantor string by flipping diagonal bits
    let cantorCharList := constructCantorString charLists
    -- Convert back to string
    listToString cantorCharList
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def stringNotInList (s : String) (l : List String) : Prop :=
  ¬ l.contains s

-- Postcondition definitions
@[reducible, simp]
def findDifferentBinaryString_postcond (nums : List String) (result: String) (h_precond : findDifferentBinaryString_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  let n := nums.length
  result.length = n ∧
  isValidBinaryString result ∧
  stringNotInList result nums
  -- !benchmark @end postcond


-- Proof content
theorem findDifferentBinaryString_postcond_satisfied (nums: List String) (h_precond : findDifferentBinaryString_precond (nums)) :
    findDifferentBinaryString_postcond (nums) (findDifferentBinaryString (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof