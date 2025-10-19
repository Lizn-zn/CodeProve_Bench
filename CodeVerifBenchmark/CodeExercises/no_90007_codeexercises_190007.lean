import Mathlib.Data.List.Basic
import Mathlib.Data.List.OfFn

-- Precondition auxiliary definitions
structure CommonKeyValue (α β γ δ : Type) where
  key1 : α
  key2 : β
  value1 : γ
  value2 : δ

-- Precondition definitions
@[reducible, simp]
def find_common_key_value_precond (tup1 : List α) (tup2 : List β) (dict1 : α → Option γ) (dict2 : β → Option δ) : Prop :=
  -- !benchmark @start precond
  List.length tup1 = List.length tup2
  -- !benchmark @end precond


-- Code auxiliary definitions
namespace List
  def zipWithIndex (l : List α) : List (Nat × α) :=
    let rec aux : Nat → List α → List (Nat × α)
      | _, [] => []
      | i, x :: xs => (i, x) :: aux (i + 1) xs
    aux 0 l
end List

-- Main function definitions
def find_common_key_value (tup1 : List α) (tup2 : List β) (dict1 : α → Option γ) (dict2 : β → Option δ) (h_precond : find_common_key_value_precond (tup1) (tup2) (dict1) (dict2)) : List (Prod (Prod α β) (Prod γ δ)) :=
  -- !benchmark @start code
  let pairs := List.flatMap (λ ⟨i, key1⟩ =>
    match List.get? tup2 i, dict1 key1 with
    | some key2, some value1 =>
      match dict2 key2 with
      | some value2 => [((key1, key2), (value1, value2))]
      | none => []
    | _, _ => []) (List.zipWithIndex tup1)
  pairs
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_common_key_value_pair (tup1 : List α) (tup2 : List β) (dict1 : α → Option γ) (dict2 : β → Option δ) 
  (pair : Prod (Prod α β) (Prod γ δ)) : Prop :=
  let ⟨⟨key1, key2⟩, ⟨value1, value2⟩⟩ := pair
  (∃ i, List.get? tup1 i = some key1 ∧ List.get? tup2 i = some key2) ∧
  dict1 key1 = some value1 ∧
  dict2 key2 = some value2

-- Postcondition definitions
@[reducible, simp]
def find_common_key_value_postcond (tup1 : List α) (tup2 : List β) (dict1 : α → Option γ) (dict2 : β → Option δ) (result: List (Prod (Prod α β) (Prod γ δ))) (h_precond : find_common_key_value_precond (tup1) (tup2) (dict1) (dict2)) : Prop :=
  -- !benchmark @start postcond
  ∀ pair, pair ∈ result ↔ is_common_key_value_pair tup1 tup2 dict1 dict2 pair
  -- !benchmark @end postcond


-- Proof content
theorem find_common_key_value_postcond_satisfied (tup1: List α) (tup2: List β) (dict1: α → Option γ) (dict2: β → Option δ) (h_precond : find_common_key_value_precond (tup1) (tup2) (dict1) (dict2)) :
    find_common_key_value_postcond (tup1) (tup2) (dict1) (dict2) (find_common_key_value (tup1) (tup2) (dict1) (dict2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof