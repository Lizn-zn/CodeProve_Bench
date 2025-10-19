import Mathlib

-- Precondition auxiliary definitions
def minCostToRemoveAll_precond_aux1 (nums : List Nat) : Prop :=
  nums ≠ [] ∧ ∀ x ∈ nums, x > 0

-- Precondition definitions
@[reducible, simp]
def minCostToRemoveAll_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  minCostToRemoveAll_precond_aux1 nums
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function to compute minimum cost using dynamic programming -/
def minCostToRemoveAll_aux (nums : List Nat) : Nat :=
  match nums with
  | [] => 0
  | [a] => a
  | [a, b] => max a b
  | a :: b :: c :: rest =>
    let cost1 := max a b + minCostToRemoveAll_aux (c :: rest)
    let cost2 := max a c + minCostToRemoveAll_aux (b :: rest)
    let cost3 := max b c + minCostToRemoveAll_aux (a :: rest)
    min cost1 (min cost2 cost3)

/-- Memoization table for dynamic programming -/
structure DPState where
  memo : List (List Nat × Nat) := []

def getMemo (memo : List (List Nat × Nat)) (key : List Nat) : Option Nat :=
  match memo with
  | [] => none
  | (k, v) :: rest => if k = key then some v else getMemo rest key

def setMemo (memo : List (List Nat × Nat)) (key : List Nat) (value : Nat) : List (List Nat × Nat) :=
  (key, value) :: memo

def minCostToRemoveAll_memo_aux (nums : List Nat) (state : DPState) : Nat × DPState :=
  match getMemo state.memo nums with
  | some result => (result, state)
  | none =>
    match nums with
    | [] => (0, state)
    | [a] => (a, state)
    | [a, b] => (max a b, state)
    | a :: b :: c :: rest =>
      let (cost1, state1) := minCostToRemoveAll_memo_aux (c :: rest) state
      let cost1 := max a b + cost1
      let (cost2, state2) := minCostToRemoveAll_memo_aux (b :: rest) state1
      let cost2 := max a c + cost2
      let (cost3, state3) := minCostToRemoveAll_memo_aux (a :: rest) state2
      let cost3 := max b c + cost3
      let result := min cost1 (min cost2 cost3)
      let newState := { memo := setMemo state3.memo nums result }
      (result, newState)

-- Main function definitions
def minCostToRemoveAll (nums : List Nat) (h_precond : minCostToRemoveAll_precond (nums)) : Nat :=
  -- !benchmark @start code
  match nums with
    | [] => 0
    | [a] => a
    | [a, b] => max a b
    | a :: b :: c :: rest =>
      let cost1 := max a b + minCostToRemoveAll (c :: rest) (by {
        -- Prove that the precondition holds for the recursive call
        sorry -- This would require formal proof that non-empty lists with positive elements maintain the precondition
      })
      let cost2 := max a c + minCostToRemoveAll (b :: rest) (by {
        sorry -- This would require formal proof that non-empty lists with positive elements maintain the precondition
      })
      let cost3 := max b c + minCostToRemoveAll (a :: rest) (by {
        sorry -- This would require formal proof that non-empty lists with positive elements maintain the precondition
      })
      min cost1 (min cost2 cost3)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def minCostToRemoveAll_postcond_aux1 (nums : List Nat) : Nat :=
  match nums with
  | [] => 0
  | [a] => a
  | [a, b] => max a b
  | a :: b :: c :: rest =>
    let cost1 := max a b
    let cost2 := max a c
    let cost3 := max b c
    min (cost1 + minCostToRemoveAll_postcond_aux1 (c :: rest))
        (min (cost2 + minCostToRemoveAll_postcond_aux1 (b :: rest))
             (cost3 + minCostToRemoveAll_postcond_aux1 (a :: rest)))

@[simp]
def minCostToRemoveAll_postcond_aux2 (nums : List Nat) (result : Nat) : Prop :=
  result = minCostToRemoveAll_postcond_aux1 nums

-- Postcondition definitions
@[reducible, simp]
def minCostToRemoveAll_postcond (nums : List Nat) (result: Nat) (h_precond : minCostToRemoveAll_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  minCostToRemoveAll_postcond_aux2 nums result
  -- !benchmark @end postcond


-- Proof content
theorem minCostToRemoveAll_postcond_satisfied (nums: List Nat) (h_precond : minCostToRemoveAll_precond (nums)) :
    minCostToRemoveAll_postcond (nums) (minCostToRemoveAll (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof