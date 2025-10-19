import Mathlib

-- Precondition definitions
@[reducible, simp]
def calculate_total_sales_precond (sales_data : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def sum_list : List Nat → Nat
  | [] => 0
  | h :: t => h + sum_list t

-- Main function definitions
def calculate_total_sales (sales_data : List (List Nat)) (h_precond : calculate_total_sales_precond (sales_data)) : List Nat :=
  -- !benchmark @start code
  sales_data.map sum_list
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sum_list_post : List Nat → Nat
  | [] => 0
  | h :: t => h + sum_list_post t

-- Postcondition definitions
@[reducible, simp]
def calculate_total_sales_postcond (sales_data : List (List Nat)) (result: List Nat) (h_precond : calculate_total_sales_precond (sales_data)) : Prop :=
  -- !benchmark @start postcond
  result = sales_data.map sum_list_post
  -- !benchmark @end postcond


-- Proof content
theorem calculate_total_sales_postcond_satisfied (sales_data: List (List Nat)) (h_precond : calculate_total_sales_precond (sales_data)) :
    calculate_total_sales_postcond (sales_data) (calculate_total_sales (sales_data) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof