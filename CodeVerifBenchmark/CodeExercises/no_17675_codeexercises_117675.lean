import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_first_mismatch_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_first_mismatch (nums : List Nat) (h_precond : find_first_mismatch_precond (nums)) : Option Nat :=
  -- !benchmark @start code
  let rec loop (nums : List Nat) (index : Nat) : Option Nat :=
    match nums with
    | [] => none
    | h :: t => 
      if h ≠ index then
        some h
      else
        loop t (index + 1)
  loop nums 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def find_first_mismatch_postcond (nums : List Nat) (result: Option Nat) (h_precond : find_first_mismatch_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  match result with
  | none => ∀ (i : Fin nums.length), nums.get i = i.val
  | some n => ∃ (i : Fin nums.length), nums.get i ≠ i.val ∧ n = nums.get i ∧ ∀ (j : Fin nums.length), j.val < i.val → nums.get j = j.val
  -- !benchmark @end postcond


-- Proof content
theorem find_first_mismatch_postcond_satisfied (nums: List Nat) (h_precond : find_first_mismatch_precond (nums)) :
    find_first_mismatch_postcond (nums) (find_first_mismatch (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof