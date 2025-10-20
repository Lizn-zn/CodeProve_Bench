import Mathlib

namespace no_50902_codeexercises_150902


-- Precondition definitions
@[reducible, simp]
def print_numbers_excluding_multiples_precond  : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- We'll use IO to print the numbers, but since this is a pure function returning Unit,
-- we'll simulate the behavior by creating a list and verifying it matches expected_output

-- Postcondition auxiliary definitions
def expected_output : List Nat :=
  List.filter (λ n => ¬(n % 3 = 0) ∧ ¬(n % 7 = 0)) (List.range 21).tail!

-- Main function definitions
def print_numbers_excluding_multiples  (h_precond : print_numbers_excluding_multiples_precond) : Unit :=
  -- !benchmark @start code
  let result_list : List Nat :=
    (List.range 21).tail!.filter fun n => ¬(n % 3 = 0) ∧ ¬(n % 7 = 0)
  have h : result_list = expected_output := by
    native_decide
  ()
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def print_numbers_excluding_multiples_postcond  (result: Unit) (h_precond : print_numbers_excluding_multiples_precond) : Prop :=
  -- !benchmark @start postcond
  ∃ (output : List Nat), 
    output = expected_output ∧
    (∀ n ∈ output, 1 ≤ n ∧ n ≤ 20 ∧ n % 3 ≠ 0 ∧ n % 7 ≠ 0) ∧
    (∀ n : Nat, 1 ≤ n → n ≤ 20 → n % 3 ≠ 0 → n % 7 ≠ 0 → n ∈ output)
  -- !benchmark @end postcond


-- Proof content
theorem print_numbers_excluding_multiples_postcond_satisfied (h_precond : print_numbers_excluding_multiples_precond) :
    print_numbers_excluding_multiples_postcond (print_numbers_excluding_multiples h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_50902_codeexercises_150902