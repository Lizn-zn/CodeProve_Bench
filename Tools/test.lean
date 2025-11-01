import Mathlib

-- Precondition definitions
@[reducible, simp]
def test_Array_append_Nat_precond (arr1 : Array Nat) (arr2 : Array Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Function definition
def test_Array_append_Nat (arr1 : Array Nat) (arr2 : Array Nat) : Array Nat :=
  Array.append arr1 arr2

-- Postcondition auxiliary definitions
def append_result_eq (arr1 arr2 result : Array Nat) : Prop :=
  result.size = arr1.size + arr2.size ∧
  (∀ (i : Nat) (h : i < arr1.size), result[i]! = arr1[i]!) ∧
  (∀ (j : Nat) (h : j < arr2.size), result[arr1.size + j]! = arr2[j]!)

-- Postcondition definitions
@[reducible, simp]
def test_Array_append_Nat_postcond (arr1 : Array Nat) (arr2 : Array Nat) (result: Array Nat) (h_precond : test_Array_append_Nat_precond (arr1) (arr2)) : Prop :=
  -- !benchmark @start postcond
  append_result_eq arr1 arr2 result
  -- !benchmark @end postcond

instance : Decidable (append_result_eq arr1 arr2 result) := by
  delta
  infer_instance

-- Proof content
theorem test_Array_append_Nat_postcond_satisfied (arr1: Array Nat) (arr2: Array Nat) (h_precond : test_Array_append_Nat_precond (arr1) (arr2)) :
    test_Array_append_Nat_postcond (arr1) (arr2) (test_Array_append_Nat (arr1) (arr2)) h_precond := by
  -- !benchmark @start proof
  plausible
  -- !benchmark @end proof


-- Precondition definitions
@[reducible, simp]
def test_Array_back_Nat_precond (arr : Array Nat) : Prop :=
  -- !benchmark @start precond
  ¬arr.isEmpty
  -- !benchmark @end precond


-- Function definition
def test_Array_back_Nat := @Array.back Nat

elab "#print_signature" e:term : command => do
  try
    liftTermElabM do
      let expr ← Term.elabTerm e.raw none
      let typeExpr ← Meta.inferType expr
      let sigStr ← Meta.ppExpr typeExpr
      IO.println "===SIGNATURE_START==="
      IO.println sigStr.pretty
      IO.println "===SIGNATURE_END==="
  catch _ =>
    IO.println "===NO_SIGNATURE==="

#print_signature test_Array_back_Nat

-- Postcondition definitions
@[reducible, simp]
def test_Array_back_Nat_postcond (arr : Array Nat) (result: Nat) (h_precond : test_Array_back_Nat_precond (arr)) : Prop :=
  -- !benchmark @start postcond
  result = arr[arr.size - 1]!
  -- !benchmark @end postcond


-- Proof content
theorem test_Array_back_Nat_postcond_satisfied (arr: Array Nat) (h_precond : test_Array_back_Nat_precond (arr)) :
    test_Array_back_Nat_postcond (arr) (test_Array_back_Nat (arr) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
