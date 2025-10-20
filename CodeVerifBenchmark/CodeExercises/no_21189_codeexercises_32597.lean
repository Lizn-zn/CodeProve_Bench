import Mathlib

namespace no_21189_codeexercises_32597


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def calculate_volume_of_concrete_section_precond (dimension_dict : List (String × Float)) : Prop :=
  -- !benchmark @start precond
  let keys := dimension_dict.map Prod.fst
  "length" ∈ keys ∧ "width" ∈ keys ∧ "height" ∈ keys ∧
  (∀ (key : String) (value : Float), (key, value) ∈ dimension_dict → 
    (key = "length" ∨ key = "width" ∨ key = "height") → value ≥ 0)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the implementation

-- Main function definitions
def calculate_volume_of_concrete_section (dimension_dict : List (String × Float)) (h_precond : calculate_volume_of_concrete_section_precond (dimension_dict)) : Float :=
  -- !benchmark @start code
  let length := (dimension_dict.lookup "length").get!
  let width := (dimension_dict.lookup "width").get!
  let height := (dimension_dict.lookup "height").get!
  length * width * height
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- No auxiliary definitions needed for postcondition

-- Postcondition definitions
@[reducible, simp]
def calculate_volume_of_concrete_section_postcond (dimension_dict : List (String × Float)) (result: Float) (h_precond : calculate_volume_of_concrete_section_precond (dimension_dict)) : Prop :=
  -- !benchmark @start postcond
  let length_opt := dimension_dict.lookup "length"
  let width_opt := dimension_dict.lookup "width" 
  let height_opt := dimension_dict.lookup "height"
  match length_opt, width_opt, height_opt with
  | some length, some width, some height => result = length * width * height
  | _, _, _ => False
  -- !benchmark @end postcond


-- Proof content
theorem calculate_volume_of_concrete_section_postcond_satisfied (dimension_dict: List (String × Float)) (h_precond : calculate_volume_of_concrete_section_precond (dimension_dict)) :
    calculate_volume_of_concrete_section_postcond (dimension_dict) (calculate_volume_of_concrete_section (dimension_dict) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_21189_codeexercises_32597