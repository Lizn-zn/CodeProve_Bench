import Mathlib

namespace no_4850_syn_1_iter_4850


-- Precondition definitions
@[reducible, simp]
def listToString_precond (l : List α) (toStringFn : α → String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def listToString (l : List α) (toStringFn : α → String) (h_precond : listToString_precond (l) (toStringFn)) : String :=
  -- !benchmark @start code
  match l with
  | [] => "[]"
  | x :: xs => 
    let inner := String.join (List.intersperse ", " (l.map toStringFn))
    "[" ++ inner ++ "]"
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def listToString_expected (l : List α) (toStringFn : α → String) : String :=
  match l with
  | [] => "[]"
  | x :: xs => "[" ++ toStringFn x ++ String.join (xs.map (λ a => ", " ++ toStringFn a)) ++ "]"

-- Postcondition definitions
@[reducible, simp]
def listToString_postcond (l : List α) (toStringFn : α → String) (result: String) (h_precond : listToString_precond (l) (toStringFn)) : Prop :=
  -- !benchmark @start postcond
  result = listToString_expected l toStringFn
  -- !benchmark @end postcond


-- Proof content
theorem listToString_postcond_satisfied (l: List α) (toStringFn: α → String) (h_precond : listToString_precond (l) (toStringFn)) :
    listToString_postcond (l) (toStringFn) (listToString (l) (toStringFn) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_4850_syn_1_iter_4850