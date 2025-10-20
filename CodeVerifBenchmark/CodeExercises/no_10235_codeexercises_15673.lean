import Mathlib

namespace no_10235_codeexercises_15673


-- Precondition definitions
@[reducible, simp]
def calculate_average_score_precond (students_data : List (List String)) : Prop :=
  -- !benchmark @start precond
  ∀ student ∈ students_data, student.length > 1 ∧ (∀ i : Fin (student.length - 1), (student.get? (i + 1)).isSome ∧ (student.get? (i + 1)).get!.toNat?.isSome)
  -- !benchmark @end precond


-- Code auxiliary definitions
def calculate_average (scores : List Nat) : Nat :=
  if scores.isEmpty then 0
  else (scores.foldl (· + ·) 0) / scores.length

def process_student (student : List String) : Option String :=
  match student with
  | [] => none
  | name :: score_strings =>
    let scores := score_strings.filterMap String.toNat?
    if scores.isEmpty then none
    else
      let avg := calculate_average scores
      if avg > 90 then some name else none

-- Main function definitions
def calculate_average_score (students_data : List (List String)) (h_precond : calculate_average_score_precond (students_data)) : List String :=
  -- !benchmark @start code
  students_data.filterMap process_student
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def average_score_above_90 (student : List String) : Bool :=
  match student with
  | [] => false
  | _ :: scores =>
    let numeric_scores := scores.filterMap String.toNat?
    if numeric_scores.isEmpty then false
    else
      let total := numeric_scores.foldl (· + ·) 0
      let avg := total / numeric_scores.length
      avg > 90

-- Postcondition definitions
@[reducible, simp]
def calculate_average_score_postcond (students_data : List (List String)) (result: List String) (h_precond : calculate_average_score_precond (students_data)) : Prop :=
  -- !benchmark @start postcond
  result = (students_data.filter (λ student => average_score_above_90 student)).map (λ student => student.head!)
  -- !benchmark @end postcond


-- Proof content
theorem calculate_average_score_postcond_satisfied (students_data: List (List String)) (h_precond : calculate_average_score_precond (students_data)) :
    calculate_average_score_postcond (students_data) (calculate_average_score (students_data) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_10235_codeexercises_15673