import Mathlib

-- Precondition definitions
@[reducible, simp]
def combine_lists_precond (xs : List Int) (ys : List (Nat × Nat)) (zs : List (Int × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
inductive CombinedType where
  | from_xs : Int → CombinedType
  | from_ys : Nat × Nat → CombinedType
  | from_zs : Int × Nat → CombinedType

def toSumType : CombinedType → (Int ⊕ (Nat × Nat) ⊕ (Int × Nat)) := λ
  | .from_xs x => Sum.inl x
  | .from_ys y => Sum.inr (Sum.inl y)
  | .from_zs z => Sum.inr (Sum.inr z)

-- Main function definitions
def combine_lists (xs : List Int) (ys : List (Nat × Nat)) (zs : List (Int × Nat)) (h_precond : combine_lists_precond xs ys zs) : List (Int ⊕ (Nat × Nat) ⊕ (Int × Nat)) :=
  -- !benchmark @start code
  let combined_list : List CombinedType := 
    (xs.map CombinedType.from_xs) ++ 
    (ys.map CombinedType.from_ys) ++ 
    (zs.map CombinedType.from_zs)
  combined_list.map toSumType
  -- !benchmark @end code


-- Postcondition auxiliary definitions
inductive CombinedTypePost where
  | from_xs : Int → CombinedTypePost
  | from_ys : Nat × Nat → CombinedTypePost
  | from_zs : Int × Nat → CombinedTypePost

def toSumTypePost : CombinedTypePost → (Int ⊕ (Nat × Nat) ⊕ (Int × Nat)) := λ
  | .from_xs x => Sum.inl x
  | .from_ys y => Sum.inr (Sum.inl y)
  | .from_zs z => Sum.inr (Sum.inr z)

-- Postcondition definitions
@[reducible, simp]
def combine_lists_postcond (xs : List Int) (ys : List (Nat × Nat)) (zs : List (Int × Nat)) (result: List (Int ⊕ (Nat × Nat) ⊕ (Int × Nat))) (h_precond : combine_lists_precond xs ys zs) : Prop :=
  -- !benchmark @start postcond
  let expected : List (Int ⊕ (Nat × Nat) ⊕ (Int × Nat)) := 
    (xs.map (λ x => Sum.inl x)) ++ 
    (ys.map (λ y => Sum.inr (Sum.inl y))) ++ 
    (zs.map (λ z => Sum.inr (Sum.inr z)))
  result = expected
  -- !benchmark @end postcond


-- Proof content
theorem combine_lists_postcond_satisfied (xs: List Int) (ys: List (Nat × Nat)) (zs: List (Int × Nat)) (h_precond : combine_lists_precond xs ys zs) :
    combine_lists_postcond xs ys zs (combine_lists xs ys zs h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof