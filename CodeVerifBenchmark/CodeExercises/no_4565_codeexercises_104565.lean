import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def check_crops_precond (farmer_name : String) (crops : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Checks if a string has any odd-indexed characters missing -/
def has_missing_odd_chars (s : String) : Bool :=
  let chars := s.toList
  chars.enum.any (λ ⟨i, c⟩ => i % 2 == 1 ∧ c == ' ')

-- Main function definitions
def check_crops (farmer_name : String) (crops : List String) (h_precond : check_crops_precond (farmer_name) (crops)) : Bool :=
  -- !benchmark @start code
  crops.any has_missing_odd_chars
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Checks if a string has any odd-indexed characters missing (postcondition version) -/
def has_missing_odd_chars_post (s : String) : Bool :=
  let chars := s.toList
  chars.enum.any (λ ⟨i, c⟩ => i % 2 == 1 ∧ c == ' ')

-- Postcondition definitions
@[reducible, simp]
def check_crops_postcond (farmer_name : String) (crops : List String) (result: Bool) (h_precond : check_crops_precond (farmer_name) (crops)) : Prop :=
  -- !benchmark @start postcond
  result = crops.any has_missing_odd_chars_post
  -- !benchmark @end postcond


-- Proof content
theorem check_crops_postcond_satisfied (farmer_name: String) (crops: List String) (h_precond : check_crops_precond (farmer_name) (crops)) :
    check_crops_postcond (farmer_name) (crops) (check_crops (farmer_name) (crops) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof