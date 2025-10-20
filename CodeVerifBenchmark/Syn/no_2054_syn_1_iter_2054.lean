import Mathlib

namespace no_2054_syn_1_iter_2054


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def build_char_array_precond (s : String) (chars : List Char) (indices : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  ∀ p ∈ indices, p.1 < s.length ∧ p.2 < chars.length
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Function to process indices and create a map of the last assignment for each index
def process_indices (chars : List Char) (indices : List (Nat × Nat)) : List (Nat × Char) :=
  let assignments := indices.map (λ (i, j) => (i, chars.getD j ' '))
  assignments.foldl (λ acc (i, c) => 
    match acc.find? (λ (idx, _) => idx = i) with
    | none => (i, c) :: acc
    | some _ => acc.map (λ (idx, c') => if idx = i then (i, c) else (idx, c'))
  ) []

-- Function to create the initial array filled with default character
def create_initial_array (length : Nat) : Array Char :=
  Array.mkArray length ' '

-- Function to apply assignments to the array
def apply_assignments (arr : Array Char) (assignments : List (Nat × Char)) : Array Char :=
  assignments.foldl (λ arr' (i, c) => 
    if i < arr'.size then arr'.set! i c else arr'
  ) arr

-- Main function definitions
def build_char_array (s : String) (chars : List Char) (indices : List (Nat × Nat)) (h_precond : build_char_array_precond (s) (chars) (indices)) : Array Char :=
  -- !benchmark @start code
  -- Create initial array filled with spaces
    let initial_array : Array Char := create_initial_array s.length
    
    -- Process indices to get the last assignments
    let processed_indices : List (Nat × Char) := process_indices chars indices
    
    -- Apply the assignments to the initial array
    apply_assignments initial_array processed_indices
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Function to get the last assignment for each index
def get_last_assignment (chars : List Char) (indices : List (Nat × Nat)) : Nat → Option Char :=
  λ i => 
    let assignments := indices.filter (λ (idx, _) => idx = i)
    match assignments.reverse.head? with
    | none => none
    | some (_, j) => chars.get? j

-- Postcondition definitions
@[reducible, simp]
def build_char_array_postcond (s : String) (chars : List Char) (indices : List (Nat × Nat)) (result: Array Char) (h_precond : build_char_array_precond (s) (chars) (indices)) : Prop :=
  -- !benchmark @start postcond
  result.size = s.length ∧
  ∀ (i : Nat) (h : i < result.size),
    match get_last_assignment chars indices i with
    | some c => result[i] = c
    | none => result[i] = ' '  -- default character is space
  -- !benchmark @end postcond


-- Proof content
theorem build_char_array_postcond_satisfied (s: String) (chars: List Char) (indices: List (Nat × Nat)) (h_precond : build_char_array_precond (s) (chars) (indices)) :
    build_char_array_postcond (s) (chars) (indices) (build_char_array (s) (chars) (indices) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2054_syn_1_iter_2054