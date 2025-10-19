import Mathlib

-- Precondition definitions
@[reducible, simp]
def maxJewelValue_precond (N : Nat) (K : Nat) (V : List Int) : Prop :=
  -- !benchmark @start precond
  N ≥ 1 ∧ N ≤ 50 ∧ K ≥ 1 ∧ K ≤ 100 ∧ V.length = N ∧ (∀ v ∈ V, -10^7 ≤ v ∧ v ≤ 10^7)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to get the minimum of two natural numbers
def natMin (a b : Nat) : Nat := if a ≤ b then a else b

-- Helper function to compute sum of a list of integers
def listSum (l : List Int) : Int := l.foldl (· + ·) 0

-- Helper function to take last n elements from a list
def takeLast {α : Type} (n : Nat) (l : List α) : List α :=
  l.reverse.take n |>.reverse

-- Helper function to filter negative elements
def filterNegatives (l : List Int) : List Int :=
  l.filter (· < 0)

-- Helper function to sort list in ascending order
def sortAscending (l : List Int) : List Int :=
  l.insertionSort (· ≤ ·)

-- Main function definitions
def maxJewelValue (N : Nat) (K : Nat) (V : List Int) (h_precond : maxJewelValue_precond (N) (K) (V)) : Int :=
  -- !benchmark @start code
  let R := natMin V.length K
    let results := (List.range (R + 1)).map (fun i =>
      (List.range (i + 1)).map (fun a =>
        -- Take a jewels from left and (i-a) from right
        let hand := if i = a then 
                      V.take a 
                    else 
                      V.take a ++ takeLast (i - a) V
        -- Find negative jewels that can be put back
        let negatives := sortAscending (filterNegatives hand)
        -- We can put back at most K - i jewels
        let trashCount := natMin (K - i) negatives.length
        -- Sum of jewels to put back (they are negative, so subtracting them increases total)
        let trashSum := listSum (negatives.take trashCount)
        -- Total value: sum of hand minus the negative jewels we put back
        let point := listSum hand - trashSum
        point
      ) |>.foldl max 0
    ) |>.foldl max 0
    results
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Represents a state: (deque, hand, operations_remaining)
-- where deque is the current jewels in D, hand is jewels in hand, operations_remaining is K - operations_used
def State := List Int × List Int × Nat

-- Check if a state is reachable from initial state (V, [], K) with valid operations
def validOperationSequence (V : List Int) (K : Nat) (final : State) : Prop :=
  ∃ (steps : Nat), steps ≤ K ∧ 
  ∃ (path : Fin (steps + 1) → State),
    path 0 = (V, [], K) ∧
    path (Fin.last steps) = final ∧
    (∀ i : Fin steps, 
      let (deque, hand, ops) := path i.castSucc
      let (deque', hand', ops') := path i.succ
      ops' + 1 = ops ∧
      (-- Operation A: take from left
       (deque.length > 0 ∧ deque' = deque.tail ∧ hand' = deque.head! :: hand) ∨
       -- Operation B: take from right
       (deque.length > 0 ∧ ∃ init last, deque = init ++ [last] ∧ deque' = init ∧ hand' = last :: hand) ∨
       -- Operation C: insert to left
       (hand.length > 0 ∧ ∃ j h_rest, hand = j :: h_rest ∧ deque' = j :: deque ∧ hand' = h_rest) ∨
       -- Operation D: insert to right
       (hand.length > 0 ∧ ∃ j h_rest, hand = j :: h_rest ∧ deque' = deque ++ [j] ∧ hand' = h_rest)))

-- Maximum sum achievable
def maxAchievableSum (V : List Int) (K : Nat) : Int :=
  -- Take i jewels from left (0 ≤ i ≤ min(N, K))
  -- Take j jewels from right (0 ≤ j ≤ min(N, K) - i)
  -- Put back at most K - (i + j) negative jewels
  let R := min V.length K
  (List.range (R + 1)).foldl (fun max_val i =>
    (List.range (i + 1)).foldl (fun max_val' a =>
      let hand := if i = a then V.take a else V.take a ++ V.reverse.take (i - a)
      let negatives := (hand.filter (· < 0)).insertionSort (· ≤ ·)
      let trash_count := min (K - i) negatives.length
      let trash_sum := (negatives.take trash_count).sum
      let point := hand.sum - trash_sum
      max max_val' point
    ) max_val
  ) 0

-- Postcondition definitions
@[reducible, simp]
def maxJewelValue_postcond (N : Nat) (K : Nat) (V : List Int) (result: Int) (h_precond : maxJewelValue_precond (N) (K) (V)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the maximum sum of jewels that can be in hand after at most K operations
  result = maxAchievableSum V K ∧
  -- The result is non-negative or represents the best achievable outcome
  (∀ (final : State), validOperationSequence V K final → 
    let (_, hand, _) := final
    hand.sum ≤ result)
  -- !benchmark @end postcond


-- Proof content
theorem maxJewelValue_postcond_satisfied (N: Nat) (K: Nat) (V: List Int) (h_precond : maxJewelValue_precond (N) (K) (V)) :
    maxJewelValue_postcond (N) (K) (V) (maxJewelValue (N) (K) (V) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

