import Mathlib

namespace no_39580_codeexercises_139580


-- Precondition definitions
@[reducible, simp]
def get_population_precond (nested_terrain : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def sum_nested_list : List (List Nat) → Nat
  | [] => 0
  | hd :: tl => (hd.foldl (λ acc x => acc + x) 0) + sum_nested_list tl

-- Main function definitions
def get_population (nested_terrain : List (List Nat)) (h_precond : get_population_precond (nested_terrain)) : Nat :=
  -- !benchmark @start code
  match nested_terrain with
  | [] => 0
  | hd :: tl => (hd.foldl (λ acc x => acc + x) 0) + get_population tl h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sum_nested_list_post : List (List Nat) → Nat
  | [] => 0
  | hd :: tl => (hd.foldl (λ acc x => acc + x) 0) + sum_nested_list_post tl

-- Postcondition definitions
@[reducible, simp]
def get_population_postcond (nested_terrain : List (List Nat)) (result: Nat) (h_precond : get_population_precond (nested_terrain)) : Prop :=
  -- !benchmark @start postcond
  result = sum_nested_list_post nested_terrain
  -- !benchmark @end postcond


-- Proof content
theorem get_population_postcond_satisfied (nested_terrain: List (List Nat)) (h_precond : get_population_precond (nested_terrain)) :
    get_population_postcond (nested_terrain) (get_population (nested_terrain) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_39580_codeexercises_139580