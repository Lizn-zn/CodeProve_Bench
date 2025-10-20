import Mathlib

namespace no_9296_syn_1_iter_9296


-- Precondition definitions
@[reducible, simp]
def convert_strings_to_codepoints_precond (strings : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def string_to_codepoints (s : String) : Array Nat :=
  s.data.map (λ c => c.val.toNat) |>.toArray

-- Main function definitions
noncomputable def convert_strings_to_codepoints (strings : List String) (h_precond : convert_strings_to_codepoints_precond (strings)) : List (Array Nat) :=
  -- !benchmark @start code
  strings.map string_to_codepoints
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def string_to_codepoints_post (s : String) : Array Nat :=
  s.data.map (λ c => c.val.toNat) |>.toArray

-- Postcondition definitions
@[reducible, simp]
def convert_strings_to_codepoints_postcond (strings : List String) (result: List (Array Nat)) (h_precond : convert_strings_to_codepoints_precond (strings)) : Prop :=
  -- !benchmark @start postcond
  result = strings.map string_to_codepoints_post
  -- !benchmark @end postcond


-- Proof content
theorem convert_strings_to_codepoints_postcond_satisfied (strings: List String) (h_precond : convert_strings_to_codepoints_precond (strings)) :
    convert_strings_to_codepoints_postcond (strings) (convert_strings_to_codepoints (strings) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_9296_syn_1_iter_9296