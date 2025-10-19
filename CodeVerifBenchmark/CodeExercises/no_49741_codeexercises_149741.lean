import Mathlib

-- Precondition definitions
@[reducible, simp]
def remove_specific_elements_precond (numbers : List Nat) (target : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def remove_specific_elements (numbers : List Nat) (target : Nat) (h_precond : remove_specific_elements_precond numbers target) : List Nat :=
  -- !benchmark @start code
  let rec loop (lst : List Nat) : List Nat :=
    match lst with
    | [] => []
    | h :: t => 
      if h = target then loop t
      else h :: loop t
  loop numbers
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def remove_specific_elements_aux (numbers : List Nat) (target : Nat) : List Nat :=
  numbers.filter (λ x => x ≠ target)

-- Postcondition definitions
@[reducible, simp]
def remove_specific_elements_postcond (numbers : List Nat) (target : Nat) (result: List Nat) (h_precond : remove_specific_elements_precond numbers target) : Prop :=
  -- !benchmark @start postcond
  result = remove_specific_elements_aux numbers target
  -- !benchmark @end postcond


-- Proof content
theorem remove_specific_elements_postcond_satisfied (numbers: List Nat) (target: Nat) (h_precond : remove_specific_elements_precond numbers target) :
    remove_specific_elements_postcond numbers target (remove_specific_elements numbers target h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof