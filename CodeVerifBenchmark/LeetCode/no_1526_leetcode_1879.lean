import Mathlib

-- Precondition auxiliary definitions
def IsPermutation (l1 l2 : List Nat) : Prop :=
  l1.length = l2.length ∧
  ∀ x, x ∈ l1 ↔ x ∈ l2

def XorSum (l1 l2 : List Nat) : Nat :=
  (List.zip l1 l2).map (fun (a, b) => a.xor b) |>.sum

-- Precondition definitions
@[reducible, simp]
def minimizeXorSum_precond (nums1 : List Nat) (nums2 : List Nat) : Prop :=
  -- !benchmark @start precond
  nums1.length = nums2.length ∧ nums1.length ≥ 1 ∧ nums1.length ≤ 14
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Generate all permutations of a list -/
def permutations : List Nat → List (List Nat)
  | [] => [[]]
  | xs => xs.flatMap (fun x => (permutations (xs.erase x)).map (fun ys => x :: ys))
  decreasing_by sorry

/-- Check if two lists are permutations of each other -/
def isPermutation (l1 l2 : List Nat) : Bool :=
  l1.length == l2.length && l1.all (fun x => l2.contains x) && l2.all (fun x => l1.contains x)

/-- Calculate XOR sum of two lists -/
def xorSum (l1 l2 : List Nat) : Nat :=
  (List.zip l1 l2).map (fun (a, b) => a.xor b) |>.sum

-- Main function definitions
def minimizeXorSum (nums1 : List Nat) (nums2 : List Nat) (h_precond : minimizeXorSum_precond (nums1) (nums2)) : Nat :=
  -- !benchmark @start code
  let perms := permutations nums2
  let valid_perms := perms.filter (fun p => isPermutation p nums2)
  let xor_sums := valid_perms.map (xorSum nums1 ·)
  xor_sums.foldl (·.min ·) 1000000000
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def minimizeXorSum_postcond (nums1 : List Nat) (nums2 : List Nat) (result: Nat) (h_precond : minimizeXorSum_precond (nums1) (nums2)) : Prop :=
  -- !benchmark @start postcond
  ∃ (perm : List Nat), IsPermutation nums2 perm ∧
    result = XorSum nums1 perm ∧
    ∀ (other_perm : List Nat), IsPermutation nums2 other_perm →
      XorSum nums1 other_perm ≥ result
  -- !benchmark @end postcond


-- Proof content
theorem minimizeXorSum_postcond_satisfied (nums1: List Nat) (nums2: List Nat) (h_precond : minimizeXorSum_precond (nums1) (nums2)) :
    minimizeXorSum_postcond (nums1) (nums2) (minimizeXorSum (nums1) (nums2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof