import Mathlib

namespace no_8479_syn_1_iter_8479


-- Precondition definitions
@[reducible, simp]
def format_pairs_precond (pairs : List (Int × Int)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def format_pair (p : Int × Int) : String :=
  s!"({p.fst}, {p.snd})"

-- Main function definitions
def format_pairs (pairs : List (Int × Int)) (h_precond : format_pairs_precond (pairs)) : String :=
  -- !benchmark @start code
  match pairs with
  | [] => "[]"
  | [x] => s!"[{format_pair x}]"
  | x :: xs => 
    let inner := String.intercalate ", " (xs.map format_pair)
    s!"[{format_pair x}, {inner}]"
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def format_pairs_list (pairs : List (Int × Int)) : String :=
  match pairs with
  | [] => "[]"
  | [x] => s!"[{format_pair x}]"
  | x :: xs => 
    let inner := String.intercalate ", " (xs.map format_pair)
    s!"[{format_pair x}, {inner}]"

-- Postcondition definitions
@[reducible, simp]
def format_pairs_postcond (pairs : List (Int × Int)) (result: String) (h_precond : format_pairs_precond (pairs)) : Prop :=
  -- !benchmark @start postcond
  result = format_pairs_list pairs
  -- !benchmark @end postcond


-- Proof content
theorem format_pairs_postcond_satisfied (pairs: List (Int × Int)) (h_precond : format_pairs_precond (pairs)) :
    format_pairs_postcond (pairs) (format_pairs (pairs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_8479_syn_1_iter_8479