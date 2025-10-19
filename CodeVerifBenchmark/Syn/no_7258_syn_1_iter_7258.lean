import Mathlib

-- Precondition definitions
@[reducible, simp]
def convert_pairs_precond (input_list : List (Int × Int)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this task

-- Main function definitions
def convert_pairs (input_list : List (Int × Int)) (h_precond : convert_pairs_precond (input_list)) : Array (Nat × Int) :=
  -- !benchmark @start code
  let result : Array (Nat × Int) := Array.mkEmpty input_list.length
  let idx : Nat := 0
  input_list.foldl (init := (result, idx)) (fun (acc, idx') pair =>
    let (a, b) := pair
    (acc.push (Int.toNat a, b), idx' + 1)
  ) |>.1
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def convert_pairs_postcond (input_list : List (Int × Int)) (result: Array (Nat × Int)) (h_precond : convert_pairs_precond (input_list)) : Prop :=
  -- !benchmark @start postcond
  result.size = input_list.length ∧
  ∀ (i : Fin result.size), 
    let (a, b) := (input_list.get? i.val).get!
    result[i] = (Int.toNat a, b)
  -- !benchmark @end postcond


-- Proof content
theorem convert_pairs_postcond_satisfied (input_list: List (Int × Int)) (h_precond : convert_pairs_precond (input_list)) :
    convert_pairs_postcond (input_list) (convert_pairs (input_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof