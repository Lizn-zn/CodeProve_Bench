import Mathlib

namespace no_3746_syn_1_iter_3746


-- Precondition definitions
@[reducible, simp]
def longest_string_length_precond (strings : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function to find the maximum length in a list of strings -/
def max_length_aux : List String → ℕ → ℕ
  | [], maxSoFar => maxSoFar
  | s :: rest, maxSoFar => 
    let currentMax := max maxSoFar s.length
    max_length_aux rest currentMax

-- Main function definitions
def longest_string_length (strings : List String) (h_precond : longest_string_length_precond (strings)) : UInt8 :=
  -- !benchmark @start code
  match strings with
  | [] => 0
  | s :: rest =>
    let initialMax := s.length
    let finalMax := max_length_aux rest initialMax
    finalMax.toUInt8
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def max_length (strings : List String) : ℕ :=
  match strings with
  | [] => 0
  | _ => (strings.map String.length).foldl max 0

-- Postcondition definitions
@[reducible, simp]
def longest_string_length_postcond (strings : List String) (result: UInt8) (h_precond : longest_string_length_precond (strings)) : Prop :=
  -- !benchmark @start postcond
  result = (max_length strings).toUInt8 ∧
  ∀ (s : String), s ∈ strings → s.length ≤ max_length strings
  -- !benchmark @end postcond


-- Proof content
theorem longest_string_length_postcond_satisfied (strings: List String) (h_precond : longest_string_length_precond (strings)) :
    longest_string_length_postcond (strings) (longest_string_length (strings) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_3746_syn_1_iter_3746