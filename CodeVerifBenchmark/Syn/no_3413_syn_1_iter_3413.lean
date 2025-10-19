import Mathlib

-- Precondition definitions
@[reducible, simp]
def sum_mod_256_precond (lst : List UInt8) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def sum_mod_256 (lst : List UInt8) (h_precond : sum_mod_256_precond (lst)) : UInt8 :=
  -- !benchmark @start code
  match lst with
    | [] => 0
    | h :: t => 
      let rec_sum := sum_mod_256 t h_precond
      (h + rec_sum) % 256
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sum_mod_256_aux (lst : List UInt8) : UInt8 :=
  match lst with
  | [] => 0
  | h :: t => (h + sum_mod_256_aux t) % 256

-- Postcondition definitions
@[reducible, simp]
def sum_mod_256_postcond (lst : List UInt8) (result: UInt8) (h_precond : sum_mod_256_precond (lst)) : Prop :=
  -- !benchmark @start postcond
  result = sum_mod_256_aux lst
  -- !benchmark @end postcond


-- Proof content
theorem sum_mod_256_postcond_satisfied (lst: List UInt8) (h_precond : sum_mod_256_precond (lst)) :
    sum_mod_256_postcond (lst) (sum_mod_256 (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

