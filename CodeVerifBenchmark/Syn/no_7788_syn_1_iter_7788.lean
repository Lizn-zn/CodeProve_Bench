import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def process_string_and_pairs_precond (s : String) (k : Int) (n : Nat) (lst : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def parseStringAsInts (s : String) : Option (List Int) :=
  let parts := s.split (λ c => c = ',')
  let parsed := parts.mapM String.toInt?
  match parsed with
  | some ints => some ints
  | none => none

def computeTransformedValues (k : Int) (n : Nat) (ints : List Int) : List Int :=
  ints.map (λ x => k * x + (n : Int))

def filterPairsBySum (targetSums : List Int) (lst : List (Nat × Nat)) : List (Nat × Nat) :=
  lst.filter (λ (a, b) => targetSums.contains ((a : Int) + (b : Int)))

def transformPairs (pairs : List (Nat × Nat)) : List (Int × Int) :=
  pairs.map (λ (a, b) => ((a : Int) - (b : Int), (b : Int) - (a : Int)))

-- Main function definitions
def process_string_and_pairs (s : String) (k : Int) (n : Nat) (lst : List (Nat × Nat)) (h_precond : process_string_and_pairs_precond (s) (k) (n) (lst)) : List (Int × Int) :=
  -- !benchmark @start code
  match parseStringAsInts s with
  | none => []
  | some ints =>
    let transformed := computeTransformedValues k n ints
    let filtered := filterPairsBySum transformed lst
    transformPairs filtered
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- (Definitions moved to code auxiliary definitions section)

-- Postcondition definitions
@[reducible, simp]
def process_string_and_pairs_postcond (s : String) (k : Int) (n : Nat) (lst : List (Nat × Nat)) (result: List (Int × Int)) (h_precond : process_string_and_pairs_precond (s) (k) (n) (lst)) : Prop :=
  -- !benchmark @start postcond
  match parseStringAsInts s with
  | none => result = []
  | some ints =>
    let transformed := computeTransformedValues k n ints
    let filtered := filterPairsBySum transformed lst
    result = transformPairs filtered
  -- !benchmark @end postcond


-- Proof content
theorem process_string_and_pairs_postcond_satisfied (s: String) (k: Int) (n: Nat) (lst: List (Nat × Nat)) (h_precond : process_string_and_pairs_precond (s) (k) (n) (lst)) :
    process_string_and_pairs_postcond (s) (k) (n) (lst) (process_string_and_pairs (s) (k) (n) (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof