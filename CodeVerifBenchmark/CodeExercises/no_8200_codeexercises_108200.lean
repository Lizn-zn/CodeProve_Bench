import Mathlib.Data.List.Basic

namespace no_8200_codeexercises_108200


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def update_design_precond (design : List (String × α)) (update : List (String × α)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Auxiliary definition for code: merge lists of key-value pairs
def merge_dicts (d1 d2 : List (String × α)) : List (String × α) :=
  d2.foldl (fun acc (k, v) => 
    if acc.any (λ (k', _) => k' = k) then
      acc.map (λ (k', v') => if k' = k then (k, v) else (k', v'))
    else
      (k, v) :: acc) d1

-- Main function definitions
def update_design (design : List (String × α)) (update : List (String × α)) (h_precond : update_design_precond design update) : List (String × α) :=
  -- !benchmark @start code
  merge_dicts design update
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Auxiliary definition for postcondition: merge dictionaries
def merge_dicts_post (d1 d2 : List (String × α)) : List (String × α) :=
  d2.foldl (fun acc (k, v) => 
    if acc.any (λ (k', _) => k' = k) then
      acc.map (λ (k', v') => if k' = k then (k, v) else (k', v'))
    else
      (k, v) :: acc) d1

-- Postcondition definitions
@[reducible, simp]
def update_design_postcond (design : List (String × α)) (update : List (String × α)) (result: List (String × α)) (h_precond : update_design_precond design update) : Prop :=
  -- !benchmark @start postcond
  result = merge_dicts_post design update
  -- !benchmark @end postcond


-- Proof content
theorem update_design_postcond_satisfied (design: List (String × α)) (update: List (String × α)) (h_precond : update_design_precond design update) :
    update_design_postcond design update (update_design design update h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_8200_codeexercises_108200