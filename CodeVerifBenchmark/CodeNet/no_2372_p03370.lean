import Mathlib

-- Precondition definitions
@[reducible, simp]
def maxDoughnuts_precond (n : Nat) (x : Nat) (costs : List Nat) : Prop :=
  -- !benchmark @start precond
  -- n is at least 2 and at most 100
    2 ≤ n ∧ n ≤ 100 ∧
    -- costs list has exactly n elements
    costs.length = n ∧
    -- each cost is between 1 and 1000
    (∀ m ∈ costs, 1 ≤ m ∧ m ≤ 1000) ∧
    -- total cost is at most x, and x is at most 10^5
    costs.sum ≤ x ∧ x ≤ 100000
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to find minimum of a non-empty list
def List.minimum? (l : List Nat) : Option Nat :=
  match l with
  | [] => none
  | x :: xs => some (xs.foldl min x)

-- Helper lemma: minimum exists for non-empty lists
def List.minimum?_isSome_of_ne_nil : ∀ (l : List Nat), l ≠ [] → (l.minimum?).isSome
  | [], h => absurd rfl h
  | _ :: _, _ => rfl

-- Main function definitions
def maxDoughnuts (n : Nat) (x : Nat) (costs : List Nat) (h_precond : maxDoughnuts_precond (n) (x) (costs)) : Nat :=
  -- !benchmark @start code
  match costs.minimum? with
    | none => n  -- Should not happen given preconditions
    | some minCost => n + (x - costs.sum) / minCost
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if we can make a valid distribution of doughnuts
def canMakeDoughnuts (costs : List Nat) (x : Nat) (total : Nat) : Prop :=
  ∃ (distribution : List Nat),
    distribution.length = costs.length ∧
    (∀ i : Fin costs.length, distribution[i]! ≥ 1) ∧
    (List.sum (List.zipWith (· * ·) costs distribution) ≤ x) ∧
    distribution.sum = total

-- Postcondition definitions
@[reducible, simp]
def maxDoughnuts_postcond (n : Nat) (x : Nat) (costs : List Nat) (result: Nat) (h_precond : maxDoughnuts_precond (n) (x) (costs)) : Prop :=
  -- !benchmark @start postcond
  -- The result is at least n (one of each kind)
    result ≥ n ∧
    -- We can actually make 'result' doughnuts with the given constraints
    canMakeDoughnuts costs x result ∧
    -- 'result' is the maximum: we cannot make more doughnuts
    (∀ total : Nat, total > result → ¬canMakeDoughnuts costs x total) ∧
    -- The result follows the formula: n + (x - sum(costs)) / min(costs)
    -- This is the greedy strategy: make one of each, then use remaining material for cheapest
    (∃ minCost ∈ costs, (∀ m ∈ costs, minCost ≤ m) ∧
      result = n + (x - costs.sum) / minCost)
  -- !benchmark @end postcond


-- Proof content
theorem maxDoughnuts_postcond_satisfied (n: Nat) (x: Nat) (costs: List Nat) (h_precond : maxDoughnuts_precond (n) (x) (costs)) :
    maxDoughnuts_postcond (n) (x) (costs) (maxDoughnuts (n) (x) (costs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
