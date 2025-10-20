import Mathlib

namespace no_9469_codeexercises_14504


-- Precondition definitions
@[reducible, simp]
def access_elements_modulus_precond (athlete_list : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the main implementation

-- Main function definitions
def access_elements_modulus (athlete_list : List Int) (h_precond : access_elements_modulus_precond (athlete_list)) : List (Sum Int String) :=
  -- !benchmark @start code
  let rec loop (remaining : List Int) (acc : List (Sum Int String)) : List (Sum Int String) :=
    match remaining with
    | [] => acc.reverse
    | score :: rest =>
      if score % 3 = 0 then
        loop rest (Sum.inr "Great!" :: acc)
      else
        loop rest (Sum.inl score :: acc)
  loop athlete_list []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_divisible_by_three (n : Int) : Bool := n % 3 = 0

def replace_divisible_by_three (input : List Int) : List (Sum Int String) :=
  input.map (λ x => if is_divisible_by_three x then Sum.inr "Great!" else Sum.inl x)

-- Postcondition definitions
@[reducible, simp]
def access_elements_modulus_postcond (athlete_list : List Int) (result: List (Sum Int String)) (h_precond : access_elements_modulus_precond (athlete_list)) : Prop :=
  -- !benchmark @start postcond
  result = replace_divisible_by_three athlete_list
  -- !benchmark @end postcond


-- Proof content
theorem access_elements_modulus_postcond_satisfied (athlete_list: List Int) (h_precond : access_elements_modulus_precond (athlete_list)) :
    access_elements_modulus_postcond (athlete_list) (access_elements_modulus (athlete_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_9469_codeexercises_14504