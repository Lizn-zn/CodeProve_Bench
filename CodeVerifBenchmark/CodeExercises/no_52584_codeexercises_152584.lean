import Mathlib

namespace no_52584_codeexercises_152584


-- Precondition definitions
@[reducible, simp]
def find_common_subjects_precond (photos1 : List String) (photos2 : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_common_subjects (photos1 : List String) (photos2 : List String) (h_precond : find_common_subjects_precond (photos1) (photos2)) : List String :=
  -- !benchmark @start code
  let unique1 := photos1.eraseDups
  let unique2 := photos2.eraseDups
  unique1.filter (λ x => unique2.contains x)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def CommonSubjects (photos1 photos2 result : List String) : Prop :=
  (∀ x, x ∈ result → x ∈ photos1 ∧ x ∈ photos2) ∧
  (∀ x, x ∈ photos1 → x ∈ photos2 → x ∈ result) ∧
  (∀ i j, i < j → j < result.length → result[i]! = result[j]! → i = j)

-- Postcondition definitions
@[reducible, simp]
def find_common_subjects_postcond (photos1 : List String) (photos2 : List String) (result: List String) (h_precond : find_common_subjects_precond (photos1) (photos2)) : Prop :=
  -- !benchmark @start postcond
  CommonSubjects photos1 photos2 result
  -- !benchmark @end postcond


-- Proof content
theorem find_common_subjects_postcond_satisfied (photos1: List String) (photos2: List String) (h_precond : find_common_subjects_precond (photos1) (photos2)) :
    find_common_subjects_postcond (photos1) (photos2) (find_common_subjects (photos1) (photos2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_52584_codeexercises_152584