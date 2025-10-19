import Mathlib

-- Precondition definitions
@[reducible, simp]
def maxCardPairs_precond (n : Nat) (m : Nat) (cards : List Nat) : Prop :=
  -- !benchmark @start precond
  n ≥ 2 ∧ m ≥ 1 ∧ cards.length = n ∧ (∀ x ∈ cards, x ≥ 1)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Count occurrences of each card value
def countCards (cards : List Nat) : List (Nat × Nat) :=
  cards.foldl (fun acc x =>
    match acc.find? (fun p => p.1 = x) with
    | some (v, c) => (v, c + 1) :: acc.filter (fun p => p.1 ≠ x)
    | none => (x, 1) :: acc
  ) []

-- Count cards by their modulo value
def countByMod (cards : List Nat) (m : Nat) : Array Nat :=
  let counts := Array.mkArray m 0
  cards.foldl (fun arr x =>
    let idx := x % m
    arr.set! idx (arr[idx]! + 1)
  ) counts

-- Count same-value pairs by modulo
def countSamePairsByMod (cards : List Nat) (m : Nat) : Array Nat :=
  let cardCounts := countCards cards
  let pairCounts := Array.mkArray m 0
  cardCounts.foldl (fun arr (val, cnt) =>
    let idx := val % m
    arr.set! idx (arr[idx]! + cnt / 2)
  ) pairCounts

-- Main function definitions
def maxCardPairs (n : Nat) (m : Nat) (cards : List Nat) (h_precond : maxCardPairs_precond (n) (m) (cards)) : Nat :=
  -- !benchmark @start code
  let modCounts := countByMod cards m
  let samePairs := countSamePairsByMod cards m
  
  -- Process complementary pairs (i and m-i)
  let ans := Id.run do
    let mut ans := 0
    for i in [1:(m + 1) / 2] do
      let p1 := modCounts[i]!
      let p2 := modCounts[m - i]!
      let q1 := samePairs[i]!
      let q2 := samePairs[m - i]!
      
      let (minP, maxP, minQ, maxQ) := 
        if p1 > p2 then (p2, p1, q2, q1) else (p1, p2, q1, q2)
      
      ans := ans + minP
      ans := ans + min ((maxP - minP) / 2) maxQ
    return ans
  
  -- Add pairs from mod 0
  let ans := ans + modCounts[0]! / 2
  
  -- Add pairs from mod m/2 if m is even
  let ans := if m % 2 = 0 then
    ans + modCounts[m / 2]! / 2
  else
    ans
  
  ans
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- A valid pairing is a list of pairs of indices into the cards list
def ValidPairing (cards : List Nat) (m : Nat) (pairing : List (Nat × Nat)) : Prop :=
  -- All indices are valid
  (∀ p ∈ pairing, p.1 < cards.length ∧ p.2 < cards.length ∧ p.1 ≠ p.2) ∧
  -- No index is used more than once
  (∀ idx < cards.length, (pairing.filter (fun p => p.1 = idx ∨ p.2 = idx)).length ≤ 1) ∧
  -- Each pair satisfies the pairing condition
  (∀ p ∈ pairing, cards[p.1]! = cards[p.2]! ∨ (cards[p.1]! + cards[p.2]!) % m = 0)

-- Postcondition definitions
@[reducible, simp]
def maxCardPairs_postcond (n : Nat) (m : Nat) (cards : List Nat) (result: Nat) (h_precond : maxCardPairs_precond (n) (m) (cards)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the maximum number of valid pairs
  (∃ pairing : List (Nat × Nat), ValidPairing cards m pairing ∧ pairing.length = result) ∧
  (∀ pairing : List (Nat × Nat), ValidPairing cards m pairing → pairing.length ≤ result)
  -- !benchmark @end postcond


-- Proof content
theorem maxCardPairs_postcond_satisfied (n: Nat) (m: Nat) (cards: List Nat) (h_precond : maxCardPairs_precond (n) (m) (cards)) :
    maxCardPairs_postcond (n) (m) (cards) (maxCardPairs (n) (m) (cards) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof