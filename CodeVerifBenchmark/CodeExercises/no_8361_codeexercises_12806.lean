import Mathlib

namespace no_8361_codeexercises_12806


-- Precondition definitions
@[reducible, simp]
def compare_tuples_precond (economics_data : List (Nat × Nat × Nat)) (value : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def Tuple.contains (t : Nat × Nat × Nat) (value : Nat) : Bool :=
  t.1 = value || (t.2.1 = value) || (t.2.2 = value)

-- Main function definitions
def compare_tuples (economics_data : List (Nat × Nat × Nat)) (value : Nat) (h_precond : compare_tuples_precond economics_data value) : List Nat :=
  -- !benchmark @start code
  let rec loop (i : Nat) (result : List Nat) : List Nat :=
    if h : i < economics_data.length then
      let tuple := economics_data.get ⟨i, h⟩
      if Tuple.contains tuple value then
        loop (i + 1) (i :: result)
      else
        loop (i + 1) result
    else
      result.reverse
  loop 0 []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def Tuple.contains_prop (t : Nat × Nat × Nat) (value : Nat) : Prop :=
  t.1 = value ∨ t.2.1 = value ∨ t.2.2 = value

-- Postcondition definitions
@[reducible, simp]
def compare_tuples_postcond (economics_data : List (Nat × Nat × Nat)) (value : Nat) (result: List Nat) (h_precond : compare_tuples_precond economics_data value) : Prop :=
  -- !benchmark @start postcond
  ∀ (i : Nat) (h : i < economics_data.length), 
    (i ∈ result ↔ Tuple.contains_prop (economics_data.get ⟨i, h⟩) value)
  -- !benchmark @end postcond


-- Proof content
theorem compare_tuples_postcond_satisfied (economics_data: List (Nat × Nat × Nat)) (value: Nat) (h_precond : compare_tuples_precond economics_data value) :
    compare_tuples_postcond economics_data value (compare_tuples economics_data value h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_8361_codeexercises_12806