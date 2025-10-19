import Mathlib

-- Precondition auxiliary definitions
def count (nums : List Nat) (x : Nat) : Nat :=
  nums.filter (· = x) |>.length

def isLonely (nums : List Nat) (x : Nat) : Prop :=
  count nums x = 1 ∧ count nums (x - 1) = 0 ∧ count nums (x + 1) = 0

-- Precondition definitions
@[reducible, simp]
def findLonely_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def isLonelyB (nums : List Nat) (x : Nat) : Bool :=
  count nums x = 1 ∧ count nums (x - 1) = 0 ∧ count nums (x + 1) = 0

-- Main function definitions
def findLonely (nums : List Nat) (h_precond : findLonely_precond (nums)) : List Nat :=
  -- !benchmark @start code
  
    let unique_nums := nums.eraseDups
    unique_nums.filter (fun x => isLonelyB nums x)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def findLonely_postcond (nums : List Nat) (result: List Nat) (h_precond : findLonely_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  ∀ x : Nat, (x ∈ result ↔ x ∈ nums ∧ isLonely nums x)
  -- !benchmark @end postcond


-- Proof content
theorem findLonely_postcond_satisfied (nums: List Nat) (h_precond : findLonely_precond (nums)) :
    findLonely_postcond (nums) (findLonely (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof