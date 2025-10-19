import Mathlib

-- Precondition definitions
@[reducible, simp]
def get_popular_colors_precond (color_list : List String) (min_count : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to count occurrences of a color in the list
def count_occurrences_impl (colors : List String) (color : String) : Nat :=
  colors.filter (λ c => c = color) |>.length

-- Helper function to get unique colors from the list
def get_unique_colors (colors : List String) : List String :=
  colors.eraseDups

-- Helper function to check if a color meets the minimum count requirement
def meets_min_count (colors : List String) (min_count : Nat) (color : String) : Bool :=
  count_occurrences_impl colors color ≥ min_count

-- Main function definitions
def get_popular_colors (color_list : List String) (min_count : Nat) (h_precond : get_popular_colors_precond (color_list) (min_count)) : List String :=
  -- !benchmark @start code
  -- First, get all unique colors from the input list
  let unique_colors := get_unique_colors color_list
  
  -- Filter the unique colors to only include those that meet the minimum count requirement
  unique_colors.filter (λ color => meets_min_count color_list min_count color)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_occurrences (colors : List String) (color : String) : Nat :=
  (colors.filter (λ c => c = color)).length

def is_popular_color (colors : List String) (min_count : Nat) (color : String) : Prop :=
  count_occurrences colors color ≥ min_count

-- Postcondition definitions
@[reducible, simp]
def get_popular_colors_postcond (color_list : List String) (min_count : Nat) (result: List String) (h_precond : get_popular_colors_precond (color_list) (min_count)) : Prop :=
  -- !benchmark @start postcond
  let popular_colors := {c | is_popular_color color_list min_count c}
  result.toFinset = popular_colors ∧ result.Nodup
  -- !benchmark @end postcond


-- Proof content
theorem get_popular_colors_postcond_satisfied (color_list: List String) (min_count: Nat) (h_precond : get_popular_colors_precond (color_list) (min_count)) :
    get_popular_colors_postcond (color_list) (min_count) (get_popular_colors (color_list) (min_count) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof