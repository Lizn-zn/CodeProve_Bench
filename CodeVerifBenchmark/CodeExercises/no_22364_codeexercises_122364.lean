import Mathlib

namespace no_22364_codeexercises_122364


-- Precondition definitions
@[reducible, simp]
def calculate_total_sales_precond (sales_data : List (Prod String Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def calculate_total_sales (sales_data : List (Prod String Nat)) (h_precond : calculate_total_sales_precond (sales_data)) : Nat :=
  -- !benchmark @start code
  let rec helper (data : List (Prod String Nat)) (acc : Nat) : Nat :=
      match data with
      | [] => acc
      | (_, sale) :: rest => helper rest (acc + sale)
    helper sales_data 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def calculate_total_sales_postcond (sales_data : List (Prod String Nat)) (result: Nat) (h_precond : calculate_total_sales_precond (sales_data)) : Prop :=
  -- !benchmark @start postcond
  result = (sales_data.map Prod.snd).foldl (· + ·) 0
  -- !benchmark @end postcond


-- Proof content
theorem calculate_total_sales_postcond_satisfied (sales_data: List (Prod String Nat)) (h_precond : calculate_total_sales_precond (sales_data)) :
    calculate_total_sales_postcond (sales_data) (calculate_total_sales (sales_data) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_22364_codeexercises_122364