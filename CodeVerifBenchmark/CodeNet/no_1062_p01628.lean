import Mathlib

namespace no_1062_p01628


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def compressAmidakuji_precond (n : Nat) (m : Nat) (bars : List Nat) : Prop :=
  -- !benchmark @start precond
  -- n is the number of vertical bars (2 <= n <= 8)
    -- m is the number of horizontal bars (1 <= m <= 8)
    -- bars is the list of horizontal bar positions (1 <= bars[i] <= n-1)
    n >= 2 ∧ n <= 8 ∧
    m >= 1 ∧ m <= 8 ∧
    bars.length = m ∧
    (∀ i : Nat, i < bars.length → bars[i]! >= 1 ∧ bars[i]! <= n - 1)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to generate all permutations of a list
partial def permutations (l : List Nat) : List (List Nat) :=
  match l with
  | [] => [[]]
  | _ => l.flatMap fun x =>
    (permutations (l.erase x)).map (fun p => x :: p)

-- Helper function to trace a path through the amidakuji (executable version)
def traceAmidakujiExec (n : Nat) (bars : List Nat) (start : Nat) : Nat :=
  bars.foldl (fun pos bar =>
    if pos = bar - 1 then bar
    else if pos = bar then bar - 1
    else pos
  ) start

-- Check if a permutation of bars gives the same result as the original (executable version)
def sameResultExec (n : Nat) (originalBars : List Nat) (permutedBars : List Nat) : Bool :=
  permutedBars.length = originalBars.length &&
  (List.range n).all (fun i => traceAmidakujiExec n originalBars i = traceAmidakujiExec n permutedBars i)

-- Calculate the height of an amidakuji configuration (executable version)
def calculateHeightExec (n : Nat) (bars : List Nat) : Nat :=
  let heights := bars.foldl (fun (h : Array Nat) bar =>
    let leftHeight := if bar - 1 < h.size then h[bar - 1]! else 0
    let rightHeight := if bar < h.size then h[bar]! else 0
    let newHeight := max leftHeight rightHeight + 1
    h.set! (bar - 1) newHeight |>.set! bar newHeight
  ) (Array.mkArray n 0)
  heights.foldl max 0

-- Main function definitions
def compressAmidakuji (n : Nat) (m : Nat) (bars : List Nat) (h_precond : compressAmidakuji_precond (n) (m) (bars)) : Nat :=
  -- !benchmark @start code
  -- Generate all permutations of the bars
    let allPermutations := permutations bars
    -- Filter permutations that give the same result as the original
    let validPermutations := allPermutations.filter (fun perm => sameResultExec n bars perm)
    -- Calculate heights for all valid permutations
    let heights := validPermutations.map (fun perm => calculateHeightExec n perm)
    -- Return the minimum height (or m if no valid permutations found)
    match heights.foldl (fun acc h => min acc h) m with
    | minHeight => minHeight
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to trace a path through the amidakuji
-- Given a starting position and a permutation of bars, compute the final position
def traceAmidakuji (n : Nat) (bars : List Nat) (start : Nat) : Nat :=
  bars.foldl (fun pos bar =>
    if pos = bar - 1 then bar
    else if pos = bar then bar - 1
    else pos
  ) start

-- Check if a permutation of bars gives the same result as the original
def sameResult (n : Nat) (originalBars : List Nat) (permutedBars : List Nat) : Prop :=
  permutedBars.length = originalBars.length ∧
  (∀ i : Nat, i < n → traceAmidakuji n originalBars i = traceAmidakuji n permutedBars i)

-- Calculate the height of an amidakuji configuration
-- For each bar, compute the maximum height of the two vertical bars it connects, then add 1
def calculateHeight (n : Nat) (bars : List Nat) : Nat :=
  let (heights, _) := bars.foldl (fun (heights : Array Nat × Nat) bar =>
    let (h, _) := heights
    let leftHeight := if bar - 1 < h.size then h[bar - 1]! else 0
    let rightHeight := if bar < h.size then h[bar]! else 0
    let newHeight := max leftHeight rightHeight + 1
    let h' := h.set! (bar - 1) newHeight |>.set! bar newHeight
    (h', 0)
  ) (Array.mkArray n 0, 0)
  heights.foldl max 0

-- Check if a list is a permutation of another
def isPermutationOf (l1 l2 : List Nat) : Prop :=
  l1.length = l2.length ∧
  (∀ x, l1.count x = l2.count x)

-- Postcondition definitions
@[reducible, simp]
def compressAmidakuji_postcond (n : Nat) (m : Nat) (bars : List Nat) (result: Nat) (h_precond : compressAmidakuji_precond (n) (m) (bars)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the minimum height achievable among all valid permutations
    -- A valid permutation must produce the same tracing result as the original bars
    result > 0 ∧
    (∃ permutedBars : List Nat,
      isPermutationOf permutedBars bars ∧
      sameResult n bars permutedBars ∧
      calculateHeight n permutedBars = result) ∧
    (∀ permutedBars : List Nat,
      isPermutationOf permutedBars bars →
      sameResult n bars permutedBars →
      calculateHeight n permutedBars >= result)
  -- !benchmark @end postcond


-- Proof content
theorem compressAmidakuji_postcond_satisfied (n: Nat) (m: Nat) (bars: List Nat) (h_precond : compressAmidakuji_precond (n) (m) (bars)) :
    compressAmidakuji_postcond (n) (m) (bars) (compressAmidakuji (n) (m) (bars) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1062_p01628