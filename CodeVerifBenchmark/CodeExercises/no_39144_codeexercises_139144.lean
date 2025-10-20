import Mathlib

namespace no_39144_codeexercises_139144


-- Precondition definitions
@[reducible, simp]
def find_unique_colors_precond (clothing : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_unique_colors (clothing : List String) (h_precond : find_unique_colors_precond clothing) : List String :=
  -- !benchmark @start code
  let colors := clothing.eraseDups
  colors
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_unique_list (l : List String) : Prop :=
  ∀ (x : String), x ∈ l → l.count x = 1

def is_subset_of_colors (result : List String) (clothing : List String) : Prop :=
  ∀ (color : String), color ∈ result → color ∈ clothing

def contains_all_colors (result : List String) (clothing : List String) : Prop :=
  ∀ (color : String), color ∈ clothing → color ∈ result

-- Postcondition definitions
@[reducible, simp]
def find_unique_colors_postcond (clothing : List String) (result: List String) (h_precond : find_unique_colors_precond clothing) : Prop :=
  -- !benchmark @start postcond
  is_unique_list result ∧ 
  is_subset_of_colors result clothing ∧ 
  contains_all_colors result clothing
  -- !benchmark @end postcond


-- Proof content
theorem find_unique_colors_postcond_satisfied (clothing: List String) (h_precond : find_unique_colors_precond clothing) :
    find_unique_colors_postcond clothing (find_unique_colors clothing h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_39144_codeexercises_139144