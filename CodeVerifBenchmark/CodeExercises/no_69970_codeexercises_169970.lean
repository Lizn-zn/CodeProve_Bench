import Mathlib

namespace no_69970_codeexercises_169970


-- Precondition definitions
@[reducible, simp]
def find_common_letters_precond (actor1 : String) (actor2 : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def is_letter (c : Char) : Bool :=
  ('a' ≤ c ∧ c ≤ 'z') ∨ ('A' ≤ c ∧ c ≤ 'Z')

-- Main function definitions
noncomputable def find_common_letters (actor1 : String) (actor2 : String) (h_precond : find_common_letters_precond actor1 actor2) : List Char :=
  -- !benchmark @start code
  let chars1 := actor1.toList.filter is_letter
  let chars2 := actor2.toList.filter is_letter
  let common_set := (chars1.toFinset ∩ chars2.toFinset).filter (λ c => is_letter c)
  common_set.toList.dedup
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def common_letters (s1 s2 : String) : Set Char :=
  let chars1 := s1.toList.toFinset
  let chars2 := s2.toList.toFinset
  chars1 ∩ chars2

-- Postcondition definitions
@[reducible, simp]
def find_common_letters_postcond (actor1 : String) (actor2 : String) (result: List Char) (h_precond : find_common_letters_precond actor1 actor2) : Prop :=
  -- !benchmark @start postcond
  let common_set := common_letters actor1 actor2
  let letter_set := {c | is_letter c}
  let result_set := result.toFinset
  result_set = common_set ∩ letter_set ∧
  ∀ c ∈ result, c ∈ result.toFinset ∧ result.count c = 1
  -- !benchmark @end postcond


-- Proof content
theorem find_common_letters_postcond_satisfied (actor1: String) (actor2: String) (h_precond : find_common_letters_precond actor1 actor2) :
    find_common_letters_postcond actor1 actor2 (find_common_letters actor1 actor2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_69970_codeexercises_169970