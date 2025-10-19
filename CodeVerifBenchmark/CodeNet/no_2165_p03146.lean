import Mathlib

-- Precondition definitions
@[reducible, simp]
def findCyclePosition_precond (s : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ s ∧ s ≤ 100
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute f(n)
def f_impl (n : Nat) : Nat :=
  if n % 2 = 0 then n / 2 else 3 * n + 1

-- Helper function to check if a value exists in a list up to a certain index
def existsInList (lst : List Nat) (val : Nat) : Bool :=
  lst.contains val

-- Helper function to build the sequence until we find a cycle
partial def buildSequenceUntilCycle (s : Nat) : Nat :=
  let rec loop (current : Nat) (seen : List Nat) (index : Nat) : Nat :=
    if seen.contains current then
      index
    else
      let next := f_impl current
      loop next (seen ++ [current]) (index + 1)
  loop s [] 1

-- Main function definitions
def findCyclePosition (s : Nat) (h_precond : findCyclePosition_precond (s)) : Nat :=
  -- !benchmark @start code
  buildSequenceUntilCycle s
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Define the function f(n)
def f (n : Nat) : Nat :=
  if n % 2 = 0 then n / 2 else 3 * n + 1

-- Define the sequence a, where a(i) is the i-th term (1-indexed)
def a (s : Nat) : Nat → Nat
  | 0 => s  -- a(1) = s, but using 0-indexing
  | i + 1 => f (a s i)

-- Check if there exists a cycle at position m (1-indexed)
def hasCycleAt (s : Nat) (m : Nat) : Prop :=
  m ≥ 2 ∧ ∃ n : Nat, n < m ∧ a s (m - 1) = a s (n - 1)

-- Check if m is the minimum position where a cycle occurs
def isMinCyclePosition (s : Nat) (m : Nat) : Prop :=
  hasCycleAt s m ∧ ∀ k : Nat, k < m → ¬hasCycleAt s k

-- Postcondition definitions
@[reducible, simp]
def findCyclePosition_postcond (s : Nat) (result: Nat) (h_precond : findCyclePosition_precond (s)) : Prop :=
  -- !benchmark @start postcond
  isMinCyclePosition s result
  -- !benchmark @end postcond


-- Proof content
theorem findCyclePosition_postcond_satisfied (s: Nat) (h_precond : findCyclePosition_precond (s)) :
    findCyclePosition_postcond (s) (findCyclePosition (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

