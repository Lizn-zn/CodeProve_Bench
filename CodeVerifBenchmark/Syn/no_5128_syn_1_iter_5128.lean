import Mathlib

-- Precondition definitions
@[reducible, simp]
def process_char_nat_pairs_precond (input_list : List (Char × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def process_char_nat_pairs (input_list : List (Char × Nat)) (h_precond : process_char_nat_pairs_precond input_list) : (List (Int × Nat)) × (List Float) :=
  -- !benchmark @start code
  match input_list with
    | [] => ([], [])
    | (c, n) :: rest =>
      let (ascii_list, sqrt_list) := process_char_nat_pairs rest h_precond
      ((c.toNat, n) :: ascii_list, Float.sqrt (n.toFloat) :: sqrt_list)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def process_char_nat_pairs_postcond (input_list : List (Char × Nat)) (result : (List (Int × Nat)) × (List Float)) (h_precond : process_char_nat_pairs_precond input_list) : Prop :=
  -- !benchmark @start postcond
  let (ascii_list, sqrt_list) := result
  ascii_list = input_list.map (λ (p : Char × Nat) => ((p.1.toNat : Int), p.2)) ∧
  sqrt_list = input_list.map (λ (p : Char × Nat) => Float.sqrt (p.2.toFloat))
  -- !benchmark @end postcond


-- Proof content
theorem process_char_nat_pairs_postcond_satisfied (input_list : List (Char × Nat)) (h_precond : process_char_nat_pairs_precond input_list) :
    process_char_nat_pairs_postcond input_list (process_char_nat_pairs input_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof