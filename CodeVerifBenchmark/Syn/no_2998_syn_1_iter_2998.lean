import Mathlib

namespace no_2998_syn_1_iter_2998


-- Precondition definitions
@[reducible, simp]
def compute_normalized_distances_precond (coordinates : List (Nat × Nat)) (label : String) (frequencies : List (Char × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def sum_matching_frequencies (label : String) (frequencies : List (Char × Nat)) : Nat :=
  frequencies.foldl (λ sum (c, freq) => if label.contains c then sum + freq else sum) 0

def euclidean_distance (x y : Nat) : Float :=
  Float.sqrt (Float.ofNat (x * x + y * y))

def normalized_distance (x y : Nat) (norm_factor : Nat) : Float :=
  let dist := euclidean_distance x y
  if norm_factor = 0 then dist else dist / (Float.ofNat norm_factor)

-- Main function definitions
def compute_normalized_distances (coordinates : List (Nat × Nat)) (label : String) (frequencies : List (Char × Nat)) (h_precond : compute_normalized_distances_precond (coordinates) (label) (frequencies)) : List Float :=
  -- !benchmark @start code
  let norm_factor := sum_matching_frequencies label frequencies
  coordinates.map (λ (x, y) => normalized_distance x y norm_factor)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- (These are the same as the code auxiliary definitions, but kept separate for clarity)

-- Postcondition definitions
@[reducible, simp]
def compute_normalized_distances_postcond (coordinates : List (Nat × Nat)) (label : String) (frequencies : List (Char × Nat)) (result: List Float) (h_precond : compute_normalized_distances_precond (coordinates) (label) (frequencies)) : Prop :=
  -- !benchmark @start postcond
  let norm_factor := sum_matching_frequencies label frequencies
  result.length = coordinates.length ∧
     ∀ i : Fin result.length, 
       let (x, y) := coordinates.get! i
       let expected := normalized_distance x y norm_factor
       result.get! i = expected
  -- !benchmark @end postcond


-- Proof content
theorem compute_normalized_distances_postcond_satisfied (coordinates: List (Nat × Nat)) (label: String) (frequencies: List (Char × Nat)) (h_precond : compute_normalized_distances_precond (coordinates) (label) (frequencies)) :
    compute_normalized_distances_postcond (coordinates) (label) (frequencies) (compute_normalized_distances (coordinates) (label) (frequencies) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2998_syn_1_iter_2998