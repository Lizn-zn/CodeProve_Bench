import Mathlib

-- Precondition definitions
@[reducible, simp]
def create_negative_integer_list_precond (size : Nat) : Prop :=
  -- !benchmark @start precond
  size > 0
  -- !benchmark @end precond


-- Main function definitions
def create_negative_integer_list (size : Nat) (h_precond : create_negative_integer_list_precond (size)) : List Int :=
  -- !benchmark @start code
  let rec aux : Nat → List Int → List Int := λ n acc =>
      match n with
      | 0 => acc
      | m + 1 => aux m ((-(m + 1) : Int) :: acc)
  aux size []
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def create_negative_integer_list_postcond (size : Nat) (result: List Int) (h_precond : create_negative_integer_list_precond (size)) : Prop :=
  -- !benchmark @start postcond
  result.length = size ∧
  ∀ (i : Nat), i < size → result[i]! = -((i + 1) : Int)
  -- !benchmark @end postcond


-- Proof content
theorem create_negative_integer_list_postcond_satisfied (size: Nat) (h_precond : create_negative_integer_list_precond (size)) :
    create_negative_integer_list_postcond (size) (create_negative_integer_list (size) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof