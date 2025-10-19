import Mathlib

-- Precondition definitions
@[reducible, simp]
def capitalize_nurse_names_precond (names : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def capitalize_first (s : String) : String :=
  match s.data with
  | [] => s
  | c :: cs => ⟨Char.toUpper c :: cs⟩

-- Main function definitions
def capitalize_nurse_names (names : List String) (h_precond : capitalize_nurse_names_precond (names)) : List String :=
  -- !benchmark @start code
  let rec loop (i : Nat) (result : List String) : List String :=
    if h : i < names.length then
      let name := names[i]!
      let capitalized_name := capitalize_first name
      loop (i + 1) (result ++ [capitalized_name])
    else
      result
  loop 0 []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Removed duplicate definition of capitalize_first

-- Postcondition definitions
@[reducible, simp]
def capitalize_nurse_names_postcond (names : List String) (result: List String) (h_precond : capitalize_nurse_names_precond (names)) : Prop :=
  -- !benchmark @start postcond
  result = names.map capitalize_first
  -- !benchmark @end postcond


-- Proof content
theorem capitalize_nurse_names_postcond_satisfied (names: List String) (h_precond : capitalize_nurse_names_precond (names)) :
    capitalize_nurse_names_postcond (names) (capitalize_nurse_names (names) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof