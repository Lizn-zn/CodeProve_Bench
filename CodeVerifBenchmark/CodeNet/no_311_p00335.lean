import Mathlib

namespace no_311_p00335


-- Precondition definitions
@[reducible, simp]
def minPancakeFlips_precond (n : Nat) (required_flips : Array Nat) : Prop :=
  -- !benchmark @start precond
  n ≥ 3 ∧ n ≤ 5000 ∧ required_flips.size = n ∧ ∀ i : Fin n, required_flips[i]! ≤ 3
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Dynamic programming solution
-- State: (position, flips_at_position)
-- Returns minimum total flips from this position onwards
partial def solve (n : Nat) (required : Array Nat) : Nat :=
  let rec dfs (memo : Std.HashMap (Nat × Nat) Nat) (pos : Nat) (t : Nat) : Nat × Std.HashMap (Nat × Nat) Nat :=
    if pos = n - 1 then
      (t, memo.insert (pos, t) t)
    else
      match memo.findEntry? (pos, t) with
      | some (_, result) => (result, memo)
      | none =>
        -- When at position pos with t flips needed here,
        -- we need to flip positions pos and pos+1 together t times
        -- This gives us t flips at pos, and t flips at pos+1
        -- Position pos+1 needs max(0, required[pos+1] - t) more flips
        let next_needed := if pos + 1 < n then
          let req := required[pos + 1]!
          if req > t then req - t else 0
        else 0
        let (next_result, memo') := dfs memo (pos + 1) next_needed
        let result := next_result + t * 2
        (result, memo'.insert (pos, t) result)
  
  -- Try all possible initial flips for position 0 (from 0 to required[0])
  let rec findMin (i : Nat) (best : Nat) (memo : Std.HashMap (Nat × Nat) Nat) : Nat :=
    if i > required[0]! then best
    else
      let needed := required[0]! - i
      let (res, memo') := dfs memo 0 needed
      let total := res + i
      findMin (i + 1) (min best total) memo'
  
  findMin 0 (n * 4) Std.HashMap.empty

-- Main function definitions
def minPancakeFlips (n : Nat) (required_flips : Array Nat) (h_precond : minPancakeFlips_precond (n) (required_flips)) : Nat :=
  -- !benchmark @start code
  solve n required_flips
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- A valid flipping strategy is a sequence of operations
-- Each operation flips either:
-- 1. A single pancake at position 0 or n-1 (endpoints)
-- 2. Two adjacent pancakes at positions i and i+1

-- Count how many times each pancake is flipped in a strategy
def countFlips (n : Nat) (operations : List (Fin n × Bool)) : Array Nat :=
  operations.foldl (fun counts (pos, single) =>
    if single then
      -- Single flip at endpoint
      counts.modify pos.val (· + 1)
    else
      -- Double flip at pos and pos+1
      if pos.val + 1 < n then
        counts.modify pos.val (· + 1) |>.modify (pos.val + 1) (· + 1)
      else
        counts
  ) (Array.mkArray n 0)

-- Check if a strategy satisfies all requirements
def isValidStrategy (n : Nat) (required_flips : Array Nat) (operations : List (Fin n × Bool)) : Prop :=
  let flips := countFlips n operations
  ∀ i : Fin n, flips[i]! ≥ required_flips[i]!

-- Total number of flips in a strategy
def totalFlips (n : Nat) (operations : List (Fin n × Bool)) : Nat :=
  let flips := countFlips n operations
  (List.range n).foldl (fun sum i => sum + flips[i]!) 0

-- Postcondition definitions
@[reducible, simp]
def minPancakeFlips_postcond (n : Nat) (required_flips : Array Nat) (result: Nat) (h_precond : minPancakeFlips_precond (n) (required_flips)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the minimum total number of flips needed
  ∃ (operations : List (Fin n × Bool)),
    isValidStrategy n required_flips operations ∧
    totalFlips n operations = result ∧
    (∀ (ops' : List (Fin n × Bool)),
      isValidStrategy n required_flips ops' →
      totalFlips n ops' ≥ result)
  -- !benchmark @end postcond


-- Proof content
theorem minPancakeFlips_postcond_satisfied (n: Nat) (required_flips: Array Nat) (h_precond : minPancakeFlips_precond (n) (required_flips)) :
    minPancakeFlips_postcond (n) (required_flips) (minPancakeFlips (n) (required_flips) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_311_p00335