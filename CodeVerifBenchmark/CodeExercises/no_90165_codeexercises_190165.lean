import Mathlib

namespace no_90165_codeexercises_190165


-- Precondition definitions
@[reducible, simp]
def calculate_salary_precond (actor_name : String) (num_movies : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def calculate_salary (actor_name : String) (num_movies : Nat) (h_precond : calculate_salary_precond (actor_name) (num_movies)) : Nat :=
  -- !benchmark @start code
  match actor_name.get? 0 with
    | some 'A' => num_movies * 5000
    | some 'B' => num_movies * 4000
    | some 'C' => num_movies * 3000
    | _ => num_movies * 2000
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def calculate_salary_postcond (actor_name : String) (num_movies : Nat) (result: Nat) (h_precond : calculate_salary_precond (actor_name) (num_movies)) : Prop :=
  -- !benchmark @start postcond
  match actor_name.get? 0 with
    | some 'A' => result = num_movies * 5000
    | some 'B' => result = num_movies * 4000
    | some 'C' => result = num_movies * 3000
    | _ => result = num_movies * 2000
  -- !benchmark @end postcond


-- Proof content
theorem calculate_salary_postcond_satisfied (actor_name: String) (num_movies: Nat) (h_precond : calculate_salary_precond (actor_name) (num_movies)) :
    calculate_salary_postcond (actor_name) (num_movies) (calculate_salary (actor_name) (num_movies) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_90165_codeexercises_190165