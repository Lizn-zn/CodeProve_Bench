import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_unique_numbers_precond (numbers_list : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def count_occurrences (l : List Nat) : Nat → Nat :=
  λ x => l.filter (λ y => y = x) |>.length

def is_unique_in_list (x : Nat) (l : List Nat) : Bool :=
  count_occurrences l x = 1

-- Main function definitions
def find_unique_numbers (numbers_list : List Nat) (h_precond : find_unique_numbers_precond (numbers_list)) : List Nat :=
  -- !benchmark @start code
  let filtered := numbers_list.filter (λ x => is_unique_in_list x numbers_list)
  filtered
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_unique (l : List Nat) : Prop :=
  ∀ (x : Nat), x ∈ l → l.count x = 1

def same_elements (l1 l2 : List Nat) : Prop :=
  ∀ (x : Nat), x ∈ l1 ↔ x ∈ l2

-- Postcondition definitions
@[reducible, simp]
def find_unique_numbers_postcond (numbers_list : List Nat) (result: List Nat) (h_precond : find_unique_numbers_precond (numbers_list)) : Prop :=
  -- !benchmark @start postcond
  is_unique result ∧ same_elements result numbers_list
  -- !benchmark @end postcond


-- Proof content
theorem find_unique_numbers_postcond_satisfied (numbers_list: List Nat) (h_precond : find_unique_numbers_precond (numbers_list)) :
    find_unique_numbers_postcond (numbers_list) (find_unique_numbers (numbers_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

