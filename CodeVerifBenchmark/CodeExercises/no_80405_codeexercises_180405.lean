import Mathlib

namespace no_80405_codeexercises_180405


-- Precondition definitions
@[reducible, simp]
def get_sales_report_precond (sales_data : List (String × List Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def sum_list (l : List Nat) : Nat :=
  match l with
  | [] => 0
  | h :: t => h + sum_list t

-- Main function definitions
def get_sales_report (sales_data : List (String × List Nat)) (h_precond : get_sales_report_precond (sales_data)) : List (String × Nat) :=
  -- !benchmark @start code
  let rec process_categories (data : List (String × List Nat)) : List (String × Nat) :=
    match data with
    | [] => []
    | (category, sales) :: rest =>
      let total_sales := sum_list sales
      (category, total_sales) :: process_categories rest
  process_categories sales_data
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sum_list_post (l : List Nat) : Nat :=
  match l with
  | [] => 0
  | h :: t => h + sum_list_post t

def list_to_dict (l : List (String × Nat)) : List (String × Nat) := l

-- Postcondition definitions
@[reducible, simp]
def get_sales_report_postcond (sales_data : List (String × List Nat)) (result: List (String × Nat)) (h_precond : get_sales_report_precond (sales_data)) : Prop :=
  -- !benchmark @start postcond
  let expected := sales_data.map (λ (cat_sales : String × List Nat) => 
    match cat_sales with
    | (category, sales) => (category, sum_list_post sales))
  result = expected
  -- !benchmark @end postcond


-- Proof content
theorem get_sales_report_postcond_satisfied (sales_data: List (String × List Nat)) (h_precond : get_sales_report_precond (sales_data)) :
    get_sales_report_postcond (sales_data) (get_sales_report (sales_data) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_80405_codeexercises_180405