import Mathlib

namespace no_32731_codeexercises_50462


-- Precondition definitions
@[reducible, simp]
def modify_names_precond (names : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the implementation

-- Main function definitions
def modify_names (names : List String) (h_precond : modify_names_precond (names)) : List String :=
  -- !benchmark @start code
  let rec loop (i : Nat) (result : List String) : List String :=
    if h : i < names.length then
      let name := names[i]!
      let modified_name := (name.replace " " "").toLower
      loop (i + 1) (result ++ [modified_name])
    else
      result
  loop 0 []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def remove_spaces_and_lowercase (s : String) : String :=
  (s.replace " " "").toLower

-- Postcondition definitions
@[reducible, simp]
def modify_names_postcond (names : List String) (result: List String) (h_precond : modify_names_precond (names)) : Prop :=
  -- !benchmark @start postcond
  result = names.map remove_spaces_and_lowercase
  -- !benchmark @end postcond


-- Proof content
theorem modify_names_postcond_satisfied (names: List String) (h_precond : modify_names_precond (names)) :
    modify_names_postcond (names) (modify_names (names) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_32731_codeexercises_50462