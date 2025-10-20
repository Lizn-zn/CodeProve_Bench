import Mathlib

namespace no_57849_codeexercises_157849


-- Precondition definitions
@[reducible, simp]
def reverse_string_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def reverse_string (s : String) (h_precond : reverse_string_precond s) : String :=
  -- !benchmark @start code
  let rec aux : Nat → String → String := λ i acc =>
    if h : i < s.length then
      let c := s.get ⟨i⟩
      aux (i + 1) (c.toString ++ acc)
    else
      acc
  aux 0 ""
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def reverse_string_aux (s : String) : String :=
  s.foldr (fun c acc => acc.push c) ""

-- Postcondition definitions
@[reducible, simp]
def reverse_string_postcond (s : String) (result: String) (h_precond : reverse_string_precond s) : Prop :=
  -- !benchmark @start postcond
  result = reverse_string_aux s
  -- !benchmark @end postcond


-- Proof content
theorem reverse_string_postcond_satisfied (s : String) (h_precond : reverse_string_precond s) :
    reverse_string_postcond s (reverse_string s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_57849_codeexercises_157849