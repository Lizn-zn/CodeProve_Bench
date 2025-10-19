import Mathlib

-- Precondition definitions
@[reducible, simp]
def hanafudaShuffle_precond (n : Nat) (r : Nat) (operations : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  -- n is the number of cards (1 <= n <= 50)
    -- r is the number of operations (1 <= r <= 50)
    -- operations is a list of r pairs (p, c) where p + c <= n + 1
    1 <= n && n <= 50 &&
    1 <= r && r <= 50 &&
    operations.length = r &&
    (∀ op ∈ operations, 1 <= op.1 && 1 <= op.2 && op.1 + op.2 <= n + 1)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to apply a single cut operation
def applyCutImpl (deck : Array Nat) (p : Nat) (c : Nat) : Array Nat :=
  let extracted := deck.extract (p - 1) (p - 1 + c)
  let before := deck.extract 0 (p - 1)
  let after := deck.extract (p - 1 + c) deck.size
  extracted ++ before ++ after

-- Apply all cutting operations using an array for efficiency
def applyAllCutsImpl (deck : Array Nat) (operations : List (Nat × Nat)) : Array Nat :=
  operations.foldl (fun deck (p, c) => applyCutImpl deck p c) deck

-- Create initial deck as an array
def initialDeckArray (n : Nat) : Array Nat :=
  Array.range n |>.map (· + 1) |>.reverse

-- Main function definitions
def hanafudaShuffle (n : Nat) (r : Nat) (operations : List (Nat × Nat)) (h_precond : hanafudaShuffle_precond (n) (r) (operations)) : Nat :=
  -- !benchmark @start code
  let initialDeck := initialDeckArray n
    let finalDeck := applyAllCutsImpl initialDeck operations
    finalDeck[0]!
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Simulate a single cutting operation on a deck
def applyCut (deck : List Nat) (p : Nat) (c : Nat) : List Nat :=
  let extracted := deck.drop (p - 1) |>.take c
  let before := deck.take (p - 1)
  let after := deck.drop (p - 1 + c)
  extracted ++ before ++ after

-- Apply all cutting operations in sequence
def applyAllCuts (deck : List Nat) (operations : List (Nat × Nat)) : List Nat :=
  operations.foldl (fun deck (p, c) => applyCut deck p c) deck

-- Initial deck configuration: numbered from 1 to n, from bottom to top
-- So the top card is n, and bottom card is 1
def initialDeck (n : Nat) : List Nat :=
  List.range n |>.map (· + 1) |>.reverse

-- Postcondition definitions
@[reducible, simp]
def hanafudaShuffle_postcond (n : Nat) (r : Nat) (operations : List (Nat × Nat)) (result: Nat) (h_precond : hanafudaShuffle_precond (n) (r) (operations)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the top card after applying all operations
    -- The initial deck has cards numbered 1 to n from bottom to top (so reversed)
    let finalDeck := applyAllCuts (initialDeck n) operations
    finalDeck.length > 0 && result = finalDeck.head!
  -- !benchmark @end postcond


-- Proof content
theorem hanafudaShuffle_postcond_satisfied (n: Nat) (r: Nat) (operations: List (Nat × Nat)) (h_precond : hanafudaShuffle_precond (n) (r) (operations)) :
    hanafudaShuffle_postcond (n) (r) (operations) (hanafudaShuffle (n) (r) (operations) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof