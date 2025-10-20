import Mathlib

namespace no_37683_codeexercises_137683


-- Precondition definitions
@[reducible, simp]
def filter_data_precond (data_list : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def isEven (n : Nat) : Bool := n % 2 == 0

-- Main function definitions
def filter_data (data_list : List Nat) (h_precond : filter_data_precond (data_list)) : Prod (List Nat) (List Nat) :=
  -- !benchmark @start code
  let filtered := data_list.filter isEven
  let remaining := data_list.filter (λ x => ¬ isEven x)
  Prod.mk filtered remaining
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- isEven is now defined above

-- Postcondition definitions
@[reducible, simp]
def filter_data_postcond (data_list : List Nat) (result : Prod (List Nat) (List Nat)) (h_precond : filter_data_precond (data_list)) : Prop :=
  -- !benchmark @start postcond
  let (filtered, remaining) := result
  filtered = data_list.filter isEven ∧ 
  remaining = data_list.filter (λ x => ¬ isEven x) ∧
  filtered.length + remaining.length = data_list.length
  -- !benchmark @end postcond


-- Proof content
theorem filter_data_postcond_satisfied (data_list : List Nat) (h_precond : filter_data_precond (data_list)) :
    filter_data_postcond data_list (filter_data data_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_37683_codeexercises_137683