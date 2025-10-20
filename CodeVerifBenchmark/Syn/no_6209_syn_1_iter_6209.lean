import Mathlib

namespace no_6209_syn_1_iter_6209


-- Precondition definitions
@[reducible, simp]
def compute_pair_analysis_precond (pairs : List (Int × Int)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def compute_abs_diff (a b : Int) : Nat :=
  if a ≥ b then (a - b).toNat else (b - a).toNat

def compute_direction (a b : Int) : Char :=
  if a > b then 'L' else if a < b then 'R' else 'E'

-- Main function definitions
def compute_pair_analysis (pairs : List (Int × Int)) (h_precond : compute_pair_analysis_precond (pairs)) : Nat × List (Char × Nat) :=
  -- !benchmark @start code
  match pairs with
  | [] => (0, [])
  | _ => 
    let results := pairs.map λ (a, b) => 
      let diff := compute_abs_diff a b
      let dir := compute_direction a b
      (diff, (dir, diff))
    let total_sum := results.map Prod.fst |>.foldl (· + ·) 0
    let dir_list := results.map Prod.snd
    (total_sum, dir_list)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def compute_pair_result (pair : Int × Int) : Nat × (Char × Nat) :=
  let (a, b) := pair
  let diff := compute_abs_diff a b
  let dir := compute_direction a b
  (diff, (dir, diff))

def expected_result (pairs : List (Int × Int)) : Nat × List (Char × Nat) :=
  let results := pairs.map compute_pair_result
  let total_sum := results.map Prod.fst |>.foldl (· + ·) 0
  let dir_list := results.map Prod.snd
  (total_sum, dir_list)

-- Postcondition definitions
@[reducible, simp]
def compute_pair_analysis_postcond (pairs : List (Int × Int)) (result: Nat × List (Char × Nat)) (h_precond : compute_pair_analysis_precond (pairs)) : Prop :=
  -- !benchmark @start postcond
  result = expected_result pairs
  -- !benchmark @end postcond


-- Proof content
theorem compute_pair_analysis_postcond_satisfied (pairs: List (Int × Int)) (h_precond : compute_pair_analysis_precond (pairs)) :
    compute_pair_analysis_postcond (pairs) (compute_pair_analysis (pairs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_6209_syn_1_iter_6209