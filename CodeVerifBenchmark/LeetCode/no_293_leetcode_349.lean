import Mathlib

-- Precondition auxiliary definitions
def IsSubset (l₁ l₂ : List Nat) : Prop := ∀ x ∈ l₁, x ∈ l₂
def IsUnique (l : List Nat) : Prop := l.Nodup

-- Precondition definitions
@[reducible, simp]
def arrayIntersection_precond (nums1 : List Nat) (nums2 : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def mem_list_to_set (l : List Nat) : Std.HashSet Nat :=
  let set := Std.HashSet.empty
  l.foldl (fun s x => s.insert x) set

def list_inter_of_set (s1 s2 : Std.HashSet Nat) : List Nat :=
  s1.fold (fun acc x => if s2.contains x then x :: acc else acc) []

-- Main function definitions
def arrayIntersection (nums1 : List Nat) (nums2 : List Nat) (h_precond : arrayIntersection_precond (nums1) (nums2)) : List Nat :=
  -- !benchmark @start code
  let set1 := mem_list_to_set nums1
  let set2 := mem_list_to_set nums2
  list_inter_of_set set1 set2
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def arrayIntersection_postcond (nums1 : List Nat) (nums2 : List Nat) (result: List Nat) (h_precond : arrayIntersection_precond (nums1) (nums2)) : Prop :=
  -- !benchmark @start postcond
  IsUnique result ∧
  IsSubset result nums1 ∧
  IsSubset result nums2 ∧
  ∀ x, x ∈ result → x ∈ nums1 ∧ x ∈ nums2 ∧
  ∀ y, y ∈ nums1 ∧ y ∈ nums2 → y ∈ result
  -- !benchmark @end postcond


-- Proof content
theorem arrayIntersection_postcond_satisfied (nums1: List Nat) (nums2: List Nat) (h_precond : arrayIntersection_precond (nums1) (nums2)) :
    arrayIntersection_postcond (nums1) (nums2) (arrayIntersection (nums1) (nums2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

