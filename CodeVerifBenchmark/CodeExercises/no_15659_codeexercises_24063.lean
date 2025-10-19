import Mathlib

-- Precondition auxiliary definitions
def is_sorted (l : List Nat) : Prop :=
  ∀ i j, i < j → j < l.length → l[i]! ≤ l[j]!

-- Precondition definitions
@[reducible, simp]
def find_common_elements_precond (nums1 : List Nat) (nums2 : List Nat) : Prop :=
  -- !benchmark @start precond
  is_sorted nums1 ∧ is_sorted nums2
  -- !benchmark @end precond


-- Code auxiliary definitions
def find_common_elements_aux (nums1 : List Nat) (nums2 : List Nat) : List Nat :=
  match nums1, nums2 with
  | [], _ => []
  | _, [] => []
  | x::xs, y::ys =>
    if x < y then
      find_common_elements_aux xs (y::ys)
    else if x > y then
      find_common_elements_aux (x::xs) ys
    else
      x :: find_common_elements_aux xs ys

-- Helper function to remove duplicates from a sorted list
def remove_duplicates (l : List Nat) : List Nat :=
  match l with
  | [] => []
  | [x] => [x]
  | x::y::xs =>
    if x = y then
      remove_duplicates (y::xs)
    else
      x :: remove_duplicates (y::xs)

-- Main function definitions
def find_common_elements (nums1 : List Nat) (nums2 : List Nat) (h_precond : find_common_elements_precond nums1 nums2) : List Nat :=
  -- !benchmark @start code
  let result := find_common_elements_aux nums1 nums2
  remove_duplicates result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_sorted_unique (l : List Nat) : Prop :=
  is_sorted l ∧ ∀ i j, i < j → j < l.length → l[i]! < l[j]!

def is_common_elements (nums1 nums2 result : List Nat) : Prop :=
  ∀ x, x ∈ result ↔ (x ∈ nums1 ∧ x ∈ nums2) ∧ ∀ y, y ∈ result → y = x → y = x

-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond (nums1 : List Nat) (nums2 : List Nat) (result: List Nat) (h_precond : find_common_elements_precond nums1 nums2) : Prop :=
  -- !benchmark @start postcond
  is_sorted_unique result ∧ is_common_elements nums1 nums2 result
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied (nums1: List Nat) (nums2: List Nat) (h_precond : find_common_elements_precond nums1 nums2) :
    find_common_elements_postcond nums1 nums2 (find_common_elements nums1 nums2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof