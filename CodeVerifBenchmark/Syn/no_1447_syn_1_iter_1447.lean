import Mathlib

namespace no_1447_syn_1_iter_1447


-- Precondition definitions
@[reducible, simp]
def compute_filtered_sum_precond (n : UInt8) (arr : Array Nat) (pairs : List (Char × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def filteredArrayElements (n : UInt8) (arr : Array Nat) : List Nat :=
  arr.toList.filter (λ x => x < n.toNat)

def filteredPairElements (n : UInt8) (pairs : List (Char × Nat)) : List Nat :=
  pairs.filterMap (λ (c, x) => if (c.toNat : Nat) < n.toNat then some x else none)

def combinedList (n : UInt8) (arr : Array Nat) (pairs : List (Char × Nat)) : List Nat :=
  filteredArrayElements n arr ++ filteredPairElements n pairs

def computeSum (n : UInt8) (arr : Array Nat) (pairs : List (Char × Nat)) : Nat :=
  let combined := combinedList n arr pairs
  if combined.isEmpty then 0 else combined.foldl (· + ·) 0

-- Main function definitions
def compute_filtered_sum (n : UInt8) (arr : Array Nat) (pairs : List (Char × Nat)) (h_precond : compute_filtered_sum_precond (n) (arr) (pairs)) : Nat :=
  -- !benchmark @start code
  let filtered_arr := arr.filter (λ x => x < n.toNat) |>.toList
  let filtered_pairs := pairs.filterMap (λ (c, x) => if (c.toNat : Nat) < n.toNat then some x else none)
  let combined := filtered_arr ++ filtered_pairs
  if combined.isEmpty then 0 else combined.foldl (λ acc x => acc + x) 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions (renamed to avoid conflicts)
def filteredArrayElements_post (n : UInt8) (arr : Array Nat) : List Nat :=
  arr.toList.filter (λ x => x < n.toNat)

def filteredPairElements_post (n : UInt8) (pairs : List (Char × Nat)) : List Nat :=
  pairs.filterMap (λ (c, x) => if (c.toNat : Nat) < n.toNat then some x else none)

def combinedList_post (n : UInt8) (arr : Array Nat) (pairs : List (Char × Nat)) : List Nat :=
  filteredArrayElements_post n arr ++ filteredPairElements_post n pairs

def computeSum_post (n : UInt8) (arr : Array Nat) (pairs : List (Char × Nat)) : Nat :=
  let combined := combinedList_post n arr pairs
  if combined.isEmpty then 0 else combined.foldl (· + ·) 0

-- Postcondition definitions
@[reducible, simp]
def compute_filtered_sum_postcond (n : UInt8) (arr : Array Nat) (pairs : List (Char × Nat)) (result: Nat) (h_precond : compute_filtered_sum_precond (n) (arr) (pairs)) : Prop :=
  -- !benchmark @start postcond
  result = computeSum_post n arr pairs
  -- !benchmark @end postcond


-- Proof content
theorem compute_filtered_sum_postcond_satisfied (n: UInt8) (arr: Array Nat) (pairs: List (Char × Nat)) (h_precond : compute_filtered_sum_precond (n) (arr) (pairs)) :
    compute_filtered_sum_postcond (n) (arr) (pairs) (compute_filtered_sum (n) (arr) (pairs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1447_syn_1_iter_1447