import Mathlib

namespace no_53113_codeexercises_153113


-- Precondition auxiliary definitions
def is_voltage_string (s : String) : Prop :=
  s.endsWith "V" ∧ (s.dropRight 1).toNat?.isSome

-- Precondition definitions
@[reducible, simp]
def multiply_voltage_precond (nested_tuples : List (List String)) : Prop :=
  -- !benchmark @start precond
  ∀ (inner : List String), inner ∈ nested_tuples → ∀ (s : String), s ∈ inner → is_voltage_string s
  -- !benchmark @end precond


-- Code auxiliary definitions
def multiply_voltage_string (s : String) : String :=
  match s.dropRight 1 with
  | num_str => 
    match num_str.toNat? with
    | some n => toString (n * 10) ++ "V"
    | none => s

-- Main function definitions
def multiply_voltage (nested_tuples : List (List String)) (h_precond : multiply_voltage_precond (nested_tuples)) : List (List String) :=
  -- !benchmark @start code
  List.map (λ inner => List.map multiply_voltage_string inner) nested_tuples
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- multiply_voltage_string is already defined above

-- Postcondition definitions
@[reducible, simp]
def multiply_voltage_postcond (nested_tuples : List (List String)) (result: List (List String)) (h_precond : multiply_voltage_precond (nested_tuples)) : Prop :=
  -- !benchmark @start postcond
  result.length = nested_tuples.length ∧
  ∀ i : Fin nested_tuples.length, 
    let inner := nested_tuples[i]!
    let result_inner := result[i]!
    result_inner.length = inner.length ∧
    ∀ j : Fin inner.length,
      result_inner[j]! = multiply_voltage_string (inner[j]!)
  -- !benchmark @end postcond


-- Proof content
theorem multiply_voltage_postcond_satisfied (nested_tuples: List (List String)) (h_precond : multiply_voltage_precond (nested_tuples)) :
    multiply_voltage_postcond (nested_tuples) (multiply_voltage (nested_tuples) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_53113_codeexercises_153113