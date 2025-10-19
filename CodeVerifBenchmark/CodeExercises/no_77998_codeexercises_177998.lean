import Mathlib

-- Precondition definitions
@[reducible, simp]
def calculate_average_temperature_precond (temperatures : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute sum using while loop
def sum_list_while (temperatures : List Nat) : Nat :=
  let rec loop (lst : List Nat) (acc : Nat) : Nat :=
    match lst with
    | [] => acc
    | h :: t => loop t (acc + h)
  loop temperatures 0

-- Helper function to compute count using while loop
def count_list_while (temperatures : List Nat) : Nat :=
  let rec loop (lst : List Nat) (acc : Nat) : Nat :=
    match lst with
    | [] => acc
    | _ :: t => loop t (acc + 1)
  loop temperatures 0

-- Main function definitions
def calculate_average_temperature (temperatures : List Nat) (h_precond : calculate_average_temperature_precond temperatures) : Float :=
  -- !benchmark @start code
  let total := sum_list_while temperatures
  let count := count_list_while temperatures
  if count = 0 then 0.0 else (Float.ofNat total) / (Float.ofNat count)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sum_list : List Nat → Nat
  | [] => 0
  | h :: t => h + sum_list t

def count_list : List Nat → Nat
  | [] => 0
  | _ :: t => 1 + count_list t

-- Postcondition definitions
@[reducible, simp]
def calculate_average_temperature_postcond (temperatures : List Nat) (result: Float) (h_precond : calculate_average_temperature_precond temperatures) : Prop :=
  -- !benchmark @start postcond
  let total := sum_list temperatures
  let count := count_list temperatures
  result = if count = 0 then 0.0 else (Float.ofNat total) / (Float.ofNat count)
  -- !benchmark @end postcond


-- Proof content
theorem calculate_average_temperature_postcond_satisfied (temperatures: List Nat) (h_precond : calculate_average_temperature_precond temperatures) :
    calculate_average_temperature_postcond temperatures (calculate_average_temperature temperatures h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof