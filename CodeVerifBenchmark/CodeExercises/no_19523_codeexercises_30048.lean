import Mathlib

namespace no_19523_codeexercises_30048


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def find_present_students_precond (students : List (String × List String)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Get the set of all subjects mentioned in the dictionary
def all_subjects (students : List (String × List String)) : List String :=
  let subjects_lists := students.map Prod.snd
  let flattened := subjects_lists.flatMap id
  List.dedup flattened

-- Check if a student is studying all subjects
def studies_all_subjects (student_subjects : List String) (all_subjects_list : List String) : Bool :=
  all_subjects_list.all (λ subject => student_subjects.elem subject)

-- Main function definitions
def find_present_students (students : List (String × List String)) (h_precond : find_present_students_precond (students)) : List String :=
  -- !benchmark @start code
  let all_subjects_list := all_subjects students
  students.filterMap (λ (student_name, student_subjects) => 
      if studies_all_subjects student_subjects all_subjects_list then
        some student_name
      else
        none
    )
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Postcondition version of studies_all_subjects (Prop instead of Bool)
def studies_all_subjects_prop (student_subjects : List String) (all_subjects_list : List String) : Prop :=
  ∀ subject, subject ∈ all_subjects_list → subject ∈ student_subjects

-- Postcondition definitions
@[reducible, simp]
def find_present_students_postcond (students : List (String × List String)) (result: List String) (h_precond : find_present_students_precond (students)) : Prop :=
  -- !benchmark @start postcond
  let all_subjects_list := all_subjects students
  ∀ student_name, 
    student_name ∈ result ↔ 
      ∃ student_subjects, 
        (student_name, student_subjects) ∈ students ∧ 
        studies_all_subjects_prop student_subjects all_subjects_list
  -- !benchmark @end postcond


-- Proof content
theorem find_present_students_postcond_satisfied (students: List (String × List String)) (h_precond : find_present_students_precond (students)) :
    find_present_students_postcond (students) (find_present_students (students) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_19523_codeexercises_30048