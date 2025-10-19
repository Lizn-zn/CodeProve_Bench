import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_matching_colors_precond (colors_list : List String) (target_color : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_matching_colors (colors_list : List String) (target_color : String) (h_precond : find_matching_colors_precond (colors_list) (target_color)) : List Nat :=
  -- !benchmark @start code
  let rec loop (i : Nat) (acc : List Nat) : List Nat :=
    if h : i < colors_list.length then
      let current_color := colors_list.get ⟨i, h⟩
      let new_acc := if current_color = target_color then i :: acc else acc
      loop (i + 1) new_acc
    else
      acc.reverse
  loop 0 []
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def find_matching_colors_postcond (colors_list : List String) (target_color : String) (result: List Nat) (h_precond : find_matching_colors_precond (colors_list) (target_color)) : Prop :=
  -- !benchmark @start postcond
  result = (List.range colors_list.length).filter (λ i => colors_list.get? i = some target_color)
  -- !benchmark @end postcond


-- Proof content
theorem find_matching_colors_postcond_satisfied (colors_list: List String) (target_color: String) (h_precond : find_matching_colors_precond (colors_list) (target_color)) :
    find_matching_colors_postcond (colors_list) (target_color) (find_matching_colors (colors_list) (target_color) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

