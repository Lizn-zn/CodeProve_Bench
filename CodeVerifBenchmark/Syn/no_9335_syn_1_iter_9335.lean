import Mathlib

namespace no_9335_syn_1_iter_9335


-- Precondition definitions
@[reducible, simp]
def process_list_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def distinct_elements (lst : List Int) : Set Int :=
  {x | x ∈ lst}

def find_max_and_count (lst : List Int) : Prod Int Nat :=
  match lst with
  | [] => (0, 0)
  | hd :: tl =>
    let (max_val, max_count) := find_max_and_count tl
    if hd > max_val then (hd, 1)
    else if hd = max_val then (max_val, max_count + 1)
    else (max_val, max_count)

-- Main function definitions
def process_list (lst : List Int) (h_precond : process_list_precond (lst)) : Prod (Set Int) (Prod Int Nat) :=
  -- !benchmark @start code
  let distinct_set := distinct_elements lst
  let (max_val, max_count) := find_max_and_count lst
  (distinct_set, (max_val, max_count))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def find_max_and_count_post (lst : List Int) : Prod Int Nat :=
  match lst with
  | [] => (0, 0)
  | hd :: tl =>
    let (max_val, max_count) := find_max_and_count_post tl
    if hd > max_val then (hd, 1)
    else if hd = max_val then (max_val, max_count + 1)
    else (max_val, max_count)

-- Postcondition definitions
@[reducible, simp]
def process_list_postcond (lst : List Int) (result: Prod (Set Int) (Prod Int Nat)) (h_precond : process_list_precond (lst)) : Prop :=
  -- !benchmark @start postcond
  let (max_val, max_count) := find_max_and_count_post lst
  let distinct_set : Set Int := {x | x ∈ lst}
  result.1 = distinct_set ∧ result.2.1 = max_val ∧ result.2.2 = max_count
  -- !benchmark @end postcond


-- Proof content
theorem process_list_postcond_satisfied (lst: List Int) (h_precond : process_list_precond (lst)) :
    process_list_postcond (lst) (process_list (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_9335_syn_1_iter_9335