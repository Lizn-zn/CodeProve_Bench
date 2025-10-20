import Mathlib

namespace no_5825_syn_1_iter_5825


-- Precondition auxiliary definitions
inductive SumType where
  | char : Char → SumType
  | string : String → SumType
  | list : List (Int × Int) → SumType
  | finset : Finset Nat → SumType

-- Precondition definitions
@[reducible, simp]
def flatten_heterogeneous_list_precond (input_list : List SumType) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def flatten_heterogeneous_list (input_list : List SumType) (h_precond : flatten_heterogeneous_list_precond input_list) : List SumType :=
  -- !benchmark @start code
  input_list
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def toSumType : Char ⊕ String ⊕ List (Int × Int) ⊕ Finset Nat → SumType
  | .inl c => SumType.char c
  | .inr (.inl s) => SumType.string s
  | .inr (.inr (.inl l)) => SumType.list l
  | .inr (.inr (.inr f)) => SumType.finset f

-- Postcondition definitions
@[reducible, simp]
def flatten_heterogeneous_list_postcond (input_list : List SumType) (result: List SumType) (h_precond : flatten_heterogeneous_list_precond input_list) : Prop :=
  -- !benchmark @start postcond
  result = input_list.map (λ x => match x with
    | SumType.char c => SumType.char c
    | SumType.string s => SumType.string s
    | SumType.list l => SumType.list l
    | SumType.finset f => SumType.finset f)
  -- !benchmark @end postcond


-- Proof content
theorem flatten_heterogeneous_list_postcond_satisfied (input_list: List SumType) (h_precond : flatten_heterogeneous_list_precond input_list) :
    flatten_heterogeneous_list_postcond input_list (flatten_heterogeneous_list input_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_5825_syn_1_iter_5825