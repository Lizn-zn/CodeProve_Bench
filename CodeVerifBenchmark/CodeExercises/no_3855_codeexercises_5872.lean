import Mathlib

-- Precondition definitions
@[reducible, simp]
def calculate_total_crops_precond (farmer_list : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def sum_list_code (l : List Nat) : Nat :=
  match l with
  | [] => 0
  | h :: t => h + sum_list_code t

def map_sum_code (l : List (List Nat)) : List Nat :=
  match l with
  | [] => []
  | h :: t => sum_list_code h :: map_sum_code t

-- Main function definitions
def calculate_total_crops (farmer_list : List (List Nat)) (h_precond : calculate_total_crops_precond (farmer_list)) : List Nat :=
  -- !benchmark @start code
  match farmer_list with
  | [] => []
  | h :: t => sum_list_code h :: map_sum_code t
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sum_list_post (l : List Nat) : Nat :=
  match l with
  | [] => 0
  | h :: t => h + sum_list_post t

def map_sum_post (l : List (List Nat)) : List Nat :=
  match l with
  | [] => []
  | h :: t => sum_list_post h :: map_sum_post t

-- Postcondition definitions
@[reducible, simp]
def calculate_total_crops_postcond (farmer_list : List (List Nat)) (result: List Nat) (h_precond : calculate_total_crops_precond (farmer_list)) : Prop :=
  -- !benchmark @start postcond
  result = map_sum_post farmer_list
  -- !benchmark @end postcond


-- Proof content
theorem calculate_total_crops_postcond_satisfied (farmer_list: List (List Nat)) (h_precond : calculate_total_crops_precond (farmer_list)) :
    calculate_total_crops_postcond (farmer_list) (calculate_total_crops (farmer_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof