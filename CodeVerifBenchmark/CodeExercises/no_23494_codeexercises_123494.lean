import Mathlib

namespace no_23494_codeexercises_123494


-- Precondition definitions
@[reducible, simp]
def get_dancers_with_even_index_precond (dancers : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def get_dancers_with_even_index (dancers : List String) (h_precond : get_dancers_with_even_index_precond (dancers)) : List String :=
  -- !benchmark @start code
  match dancers with
  | [] => []
  | [x] => [x]
  | x::y::xs => x :: get_dancers_with_even_index xs h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def get_even_index_elements (l : List String) : List String :=
  l.enum.filter (λ (i, _) => i % 2 = 0) |>.map Prod.snd

-- Postcondition definitions
@[reducible, simp]
def get_dancers_with_even_index_postcond (dancers : List String) (result: List String) (h_precond : get_dancers_with_even_index_precond (dancers)) : Prop :=
  -- !benchmark @start postcond
  result = get_even_index_elements dancers
  -- !benchmark @end postcond


-- Proof content
theorem get_dancers_with_even_index_postcond_satisfied (dancers: List String) (h_precond : get_dancers_with_even_index_precond (dancers)) :
    get_dancers_with_even_index_postcond (dancers) (get_dancers_with_even_index (dancers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_23494_codeexercises_123494