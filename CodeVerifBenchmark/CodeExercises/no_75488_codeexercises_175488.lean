import Mathlib

namespace no_75488_codeexercises_175488


-- Precondition definitions
@[reducible, simp]
def format_designers_info_precond (designers : List (String × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def format_designers_info (designers : List (String × Nat)) (h_precond : format_designers_info_precond (designers)) : String :=
  -- !benchmark @start code
  match designers with
  | [] => ""
  | (name, age) :: rest =>
    let formatted := s!"Name: {name}, Age: {age}"
    let rest_formatted := format_designers_info rest h_precond
    if rest_formatted.isEmpty then
      formatted
    else
      formatted ++ "\n" ++ rest_formatted
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def format_single_designer (name : String) (age : Nat) : String :=
  s!"Name: {name}, Age: {age}"

def format_all_designers (designers : List (String × Nat)) : String :=
  String.intercalate "\n" (designers.map (λ ⟨name, age⟩ => format_single_designer name age))

-- Postcondition definitions
@[reducible, simp]
def format_designers_info_postcond (designers : List (String × Nat)) (result: String) (h_precond : format_designers_info_precond (designers)) : Prop :=
  -- !benchmark @start postcond
  result = format_all_designers designers
  -- !benchmark @end postcond


-- Proof content
theorem format_designers_info_postcond_satisfied (designers: List (String × Nat)) (h_precond : format_designers_info_precond (designers)) :
    format_designers_info_postcond (designers) (format_designers_info (designers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_75488_codeexercises_175488