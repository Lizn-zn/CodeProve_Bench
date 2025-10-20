import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_firefighter_break_precond (firefighters : List Firefighter) (target : Firefighter) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
structure Firefighter where
  id : Nat
  name : String
  deriving BEq, Repr

instance : DecidableEq Firefighter :=
  λ a b => if h : a.id = b.id ∧ a.name = b.name then isTrue (by
    cases a; cases b; simp at h; simp [h.left, h.right])
  else isFalse (by
    intro h_eq
    cases a; cases b
    simp at h_eq
    simp [h_eq] at h)

-- Helper function to find firefighter with early termination
partial def find_firefighter_break_aux (firefighters : List Firefighter) (target : Firefighter) : Option Firefighter :=
  match firefighters with
  | [] => none
  | f :: rest =>
    if f == target then some f
    else find_firefighter_break_aux rest target

-- Main function definitions
def find_firefighter_break (firefighters : List Firefighter) (target : Firefighter) (h_precond : find_firefighter_break_precond (firefighters) (target)) : Option Firefighter :=
  -- !benchmark @start code
  find_firefighter_break_aux firefighters target
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def List.contains_firefighter (l : List Firefighter) (target : Firefighter) : Bool :=
  l.any (λ f => f == target)

-- Postcondition definitions
@[reducible, simp]
def find_firefighter_break_postcond (firefighters : List Firefighter) (target : Firefighter) (result: Option Firefighter) (h_precond : find_firefighter_break_precond (firefighters) (target)) : Prop :=
  -- !benchmark @start postcond
  match result with
  | none => ¬(firefighters.contains_firefighter target)
  | some found => found == target ∧ ∃ i, firefighters.get? i = some found
  -- !benchmark @end postcond


-- Proof content
theorem find_firefighter_break_postcond_satisfied (firefighters: List Firefighter) (target: Firefighter) (h_precond : find_firefighter_break_precond (firefighters) (target)) :
    find_firefighter_break_postcond (firefighters) (target) (find_firefighter_break (firefighters) (target) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
