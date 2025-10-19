import Mathlib

-- Precondition auxiliary definitions
def countUniqueElements_precond (l : List Nat) : Nat :=
  (l.toFinset).card

def intersectionSize_precond (l1 l2 : List Nat) : Nat :=
  (l1.toFinset ∩ l2.toFinset).card

def unionSize_precond (l1 l2 : List Nat) : Nat :=
  (l1.toFinset ∪ l2.toFinset).card

-- Precondition definitions
@[reducible, simp]
def maximumSetSize_precond (nums1 : List Nat) (nums2 : List Nat) : Prop :=
  -- !benchmark @start precond
  nums1.length = nums2.length ∧
  nums1.length % 2 = 0 ∧
  nums1.length > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
def countUniqueElements (l : List Nat) : Nat :=
  (l.toFinset).card

def intersectionSize (l1 l2 : List Nat) : Nat :=
  (l1.toFinset ∩ l2.toFinset).card

def unionSize (l1 l2 : List Nat) : Nat :=
  (l1.toFinset ∪ l2.toFinset).card

-- Main function definitions
def maximumSetSize (nums1 : List Nat) (nums2 : List Nat) (h_precond : maximumSetSize_precond (nums1) (nums2)) : Nat :=
  -- !benchmark @start code
  let n := nums1.length
    let half := n / 2
    
    -- Unique elements in each array
    let unique1 := countUniqueElements nums1
    let unique2 := countUniqueElements nums2
    
    -- Size of intersection
    let intersection := intersectionSize nums1 nums2
    
    -- Elements exclusive to nums1 and nums2
    let only1 := unique1 - intersection
    let only2 := unique2 - intersection
    
    -- How many elements we can take from only1, only2, and intersection
    let takeOnly1 := min only1 half
    let takeOnly2 := min only2 half
    let remaining1 := half - takeOnly1
    let remaining2 := half - takeOnly2
    let takeIntersection := min intersection (remaining1 + remaining2)
    
    -- Total unique elements in the final set
    takeOnly1 + takeOnly2 + takeIntersection
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def maximumSetSize_postcond (nums1 : List Nat) (nums2 : List Nat) (result: Nat) (h_precond : maximumSetSize_precond (nums1) (nums2)) : Prop :=
  -- !benchmark @start postcond
  let n := nums1.length
  let half := n / 2
  let unique1 := countUniqueElements nums1
  let unique2 := countUniqueElements nums2
  let intersection := intersectionSize nums1 nums2
  let union := unionSize nums1 nums2
  
  -- Elements we can take from nums1 excluding common elements
  let only1 := unique1 - intersection
  -- Elements we can take from nums2 excluding common elements
  let only2 := unique2 - intersection
  
  -- How many elements we can take from the intersection
  let takeFromIntersection1 := min half (min unique1 (half - min half only1))
  let takeFromIntersection2 := min half (min unique2 (half - min half only2))
  
  -- Total unique elements we can collect
  let total := min half only1 + min half only2 + min intersection (half - (min half only1) + (half - (min half only2)))
  
  result = min union (min half only1 + min half only2 + min intersection (n - (min half only1) - (min half only2)))
  -- !benchmark @end postcond


-- Proof content
theorem maximumSetSize_postcond_satisfied (nums1: List Nat) (nums2: List Nat) (h_precond : maximumSetSize_precond (nums1) (nums2)) :
    maximumSetSize_postcond (nums1) (nums2) (maximumSetSize (nums1) (nums2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof