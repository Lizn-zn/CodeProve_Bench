import Mathlib

-- Precondition definitions
@[reducible, simp]
def unique_animals_precond (students : List (Prod String (List String))) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed for this implementation

-- Main function definitions
def unique_animals (students : List (Prod String (List String))) (h_precond : unique_animals_precond students) : List String :=
  -- !benchmark @start code
  let all_animals_list := List.flatMap (λ student => student.2) students
  all_animals_list.eraseDups
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def all_animals (students : List (Prod String (List String))) : List String :=
  List.flatMap (λ student => student.2) students

def is_unique_list (l : List String) : Prop :=
  ∀ x, x ∈ l → l.count x = 1

-- Postcondition definitions
@[reducible, simp]
def unique_animals_postcond (students : List (Prod String (List String))) (result: List String) (h_precond : unique_animals_precond students) : Prop :=
  -- !benchmark @start postcond
  let all_animals_list := all_animals students
  is_unique_list result ∧ 
  ∀ (animal : String), animal ∈ result ↔ animal ∈ all_animals_list
  -- !benchmark @end postcond


-- Proof content
theorem unique_animals_postcond_satisfied (students: List (Prod String (List String))) (h_precond : unique_animals_precond students) :
    unique_animals_postcond students (unique_animals students h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof