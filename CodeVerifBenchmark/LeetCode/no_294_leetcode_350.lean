import Mathlib

namespace no_294_leetcode_350


-- Precondition auxiliary definitions
def count_occurrences (lst : List Nat) (x : Nat) : Nat :=
  lst.filter (fun y => y = x) |>.length

def is_subbag (lst1 lst2 : List Nat) : Prop :=
  ∀ x : Nat, count_occurrences lst1 x ≤ count_occurrences lst2 x

-- Precondition definitions
@[reducible, simp]
def intersection_precond (nums1 : List Nat) (nums2 : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def count_and_remove (lst : List Nat) (x : Nat) : Nat × List Nat :=
  let count := count_occurrences lst x
  let remaining := lst.filter (fun y => y ≠ x)
  (count, remaining)

def take_elements (lst : List Nat) (x : Nat) (n : Nat) : List Nat :=
  match n with
  | 0 => []
  | n' + 1 => x :: take_elements lst x n'

def insert_element (map : List (Nat × Nat)) (x : Nat) : List (Nat × Nat) :=
  match map with
  | [] => [(x, 1)]
  | (y, count) :: rest =>
    if x = y then
      (y, count + 1) :: rest
    else
      (y, count) :: insert_element rest x

def build_count_map (lst : List Nat) : List (Nat × Nat) :=
  lst.foldl insert_element []

def lookup_count (map : List (Nat × Nat)) (x : Nat) : Nat :=
  match map.find? (fun pair => pair.fst = x) with
  | some (_, count) => count
  | none => 0

-- Main function definitions
def intersection (nums1 : List Nat) (nums2 : List Nat) (h_precond : intersection_precond (nums1) (nums2)) : List Nat :=
  -- !benchmark @start code
  let map1 := build_count_map nums1
  let map2 := build_count_map nums2
  let common_elements := map1.filter (fun (x, _) => lookup_count map2 x > 0)
  let result := common_elements.flatMap (fun (x, count1) =>
    let count2 := lookup_count map2 x
    take_elements [] x (min count1 count2)
  )
  result
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def intersection_postcond (nums1 : List Nat) (nums2 : List Nat) (result: List Nat) (h_precond : intersection_precond (nums1) (nums2)) : Prop :=
  -- !benchmark @start postcond
  is_subbag result nums1 ∧ is_subbag result nums2 ∧
  ∀ x : Nat, count_occurrences result x = min (count_occurrences nums1 x) (count_occurrences nums2 x)
  -- !benchmark @end postcond


-- Proof content
theorem intersection_postcond_satisfied (nums1: List Nat) (nums2: List Nat) (h_precond : intersection_precond (nums1) (nums2)) :
    intersection_postcond (nums1) (nums2) (intersection (nums1) (nums2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_294_leetcode_350