import Mathlib

-- Precondition auxiliary definitions
def minWithIndex (l : List (Nat × Nat)) : Option (Nat × Nat) :=
  l.foldl (fun (acc : Option (Nat × Nat)) (x : Nat × Nat) =>
    match acc with
    | none => some x
    | some (c_acc, i_acc) =>
      let (c_x, i_x) := x
      if c_x < c_acc ∨ (c_x = c_acc ∧ i_x < i_acc) then
        some x
      else
        some (c_acc, i_acc)
  ) none

-- Helper function to remove an element at a specific index from a list
def List.removeAt (l : List α) (idx : Nat) : List α :=
  let rec go (l : List α) (i : Nat) (acc : List α) : List α :=
    match l with
    | [] => acc.reverse
    | hd :: tl =>
      if i = idx then
        acc.reverse ++ tl
      else
        go tl (i+1) (hd :: acc)
  go l 0 []

-- Helper function to get elements with their indices
def List.withIndex (l : List α) : List (α × Nat) :=
  let rec go (l : List α) (i : Nat) : List (α × Nat) :=
    match l with
    | [] => []
    | hd :: tl => (hd, i) :: go tl (i+1)
  go l 0

-- Precondition definitions
@[reducible, simp]
def hireWorkers_precond (costs : List Nat) (k : Nat) (candidates : Nat) : Prop :=
  -- !benchmark @start precond
  0 < k ∧ k ≤ costs.length ∧ 0 < candidates
  -- !benchmark @end precond


-- Code auxiliary definitions
-- !benchmark @start code_aux
def hireWorkers_loop (costs : List Nat) (remaining : Nat) (total_cost : Nat) (candidates : Nat) : Nat :=
  if remaining = 0 then
    total_cost
  else
    let indexed_costs := costs.withIndex
    let len := costs.length
    let front_size := min candidates len
    let back_size := min candidates (len - front_size)
    let front := indexed_costs.take front_size
    let back := indexed_costs.drop (len - back_size)
    let pool := front ++ back
    let chosen := minWithIndex pool
    match chosen with
    | none => total_cost
    | some (cost, idx) =>
      let new_costs := costs.removeAt idx
      hireWorkers_loop new_costs (remaining - 1) (total_cost + cost) candidates
-- !benchmark @end code_aux

-- Main function definitions
def hireWorkers (costs : List Nat) (k : Nat) (candidates : Nat) (h_precond : hireWorkers_precond (costs) (k) (candidates)) : Nat :=
  -- !benchmark @start code
  -- !benchmark @start code
  hireWorkers_loop costs k 0 candidates
  -- !benchmark @end code
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def hireWorkers_spec (costs : List Nat) (k : Nat) (candidates : Nat) : Nat :=
  let rec loop (costs' : List Nat) (remaining : Nat) (total_cost : Nat) : Nat :=
    if remaining = 0 then
      total_cost
    else
      let indexed_costs := costs'.withIndex
      let len := costs'.length
      let front_size := min candidates len
      let back_size := min candidates (len - front_size)
      let front := indexed_costs.take front_size
      let back := indexed_costs.drop (len - back_size)
      let pool := front ++ back
      let chosen := minWithIndex pool
      match chosen with
      | none => total_cost
      | some (cost, idx) =>
        let new_costs := costs'.removeAt idx
        loop new_costs (remaining - 1) (total_cost + cost)
  loop costs k 0

-- Postcondition definitions
@[reducible, simp]
def hireWorkers_postcond (costs : List Nat) (k : Nat) (candidates : Nat) (result: Nat) (h_precond : hireWorkers_precond (costs) (k) (candidates)) : Prop :=
  -- !benchmark @start postcond
  result = hireWorkers_spec costs k candidates
  -- !benchmark @end postcond


-- Proof content
theorem hireWorkers_postcond_satisfied (costs: List Nat) (k: Nat) (candidates: Nat) (h_precond : hireWorkers_precond (costs) (k) (candidates)) :
    hireWorkers_postcond (costs) (k) (candidates) (hireWorkers (costs) (k) (candidates) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

