import Mathlib

namespace no_24311_codeexercises_37446


-- Precondition definitions
@[reducible, simp]
def get_output_precond (inputs : List Bool) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def get_output (inputs : List Bool) (h_precond : get_output_precond (inputs)) : Bool :=
  -- !benchmark @start code
  match inputs with
  | [] => false
  | [x] => x
  | x :: xs => xor x (get_output xs (by simp [get_output_precond]))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def xor_list : List Bool → Bool
  | [] => false
  | [x] => x
  | x :: xs => xor x (xor_list xs)

-- Postcondition definitions
@[reducible, simp]
def get_output_postcond (inputs : List Bool) (result: Bool) (h_precond : get_output_precond (inputs)) : Prop :=
  -- !benchmark @start postcond
  result = xor_list inputs
  -- !benchmark @end postcond


-- Proof content
theorem get_output_postcond_satisfied (inputs: List Bool) (h_precond : get_output_precond (inputs)) :
    get_output_postcond (inputs) (get_output (inputs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_24311_codeexercises_37446