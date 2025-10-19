import Mathlib

-- Precondition definitions
@[reducible, simp]
def calculate_sales_precond (sales_per_day : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def accumulate_sales (sales : List Nat) : Nat :=
  match sales with
  | [] => 0
  | h :: t => h + accumulate_sales t

def find_cumulative_sales (sales : List Nat) : Nat :=
  match sales with
  | [] => 0
  | h :: t => 
    let running_total := h + find_cumulative_sales t
    if running_total ≥ 50000 then running_total else find_cumulative_sales t

-- Main function definitions
def calculate_sales (sales_per_day : List Nat) (h_precond : calculate_sales_precond (sales_per_day)) : Nat :=
  -- !benchmark @start code
  let rec helper (remaining : List Nat) (current_total : Nat) : Nat :=
    match remaining with
    | [] => current_total
    | h :: t => 
      let new_total := current_total + h
      if new_total ≥ 50000 then new_total else helper t new_total
  helper sales_per_day 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def accumulate_sales_post (sales : List Nat) : Nat :=
  match sales with
  | [] => 0
  | h :: t => h + accumulate_sales_post t

def find_cumulative_sales_post (sales : List Nat) : Nat :=
  match sales with
  | [] => 0
  | h :: t => 
    let running_total := h + find_cumulative_sales_post t
    if running_total ≥ 50000 then running_total else find_cumulative_sales_post t

-- Postcondition definitions
@[reducible, simp]
def calculate_sales_postcond (sales_per_day : List Nat) (result: Nat) (h_precond : calculate_sales_precond (sales_per_day)) : Prop :=
  -- !benchmark @start postcond
  result = find_cumulative_sales_post sales_per_day
  -- !benchmark @end postcond


-- Proof content
theorem calculate_sales_postcond_satisfied (sales_per_day: List Nat) (h_precond : calculate_sales_precond (sales_per_day)) :
    calculate_sales_postcond (sales_per_day) (calculate_sales (sales_per_day) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof