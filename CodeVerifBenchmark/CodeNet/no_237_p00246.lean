import Mathlib

namespace no_237_p00246


-- Precondition definitions
@[reducible, simp]
def maxBarabaraManju_precond (weights : List Nat) : Prop :=
  -- !benchmark @start precond
  -- Each weight must be between 1 and 9
  weights.length ≥ 2 ∧ weights.all (fun w => 1 ≤ w ∧ w ≤ 9)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to count occurrences of a weight in a list
def countWeightImpl (weights : List Nat) (w : Nat) : Nat :=
  weights.filter (· = w) |>.length

-- Helper function to try forming a bag with target sum using available weights
partial def tryFormBag (target : Nat) (counter : Array Nat) : Option (Array Nat) :=
  if target = 0 then
    some counter
  else
    let rec loop (i : Nat) : Option (Array Nat) :=
      if i = 0 then
        none
      else if i > target then
        loop (i - 1)
      else
        if counter[i]! > 0 then
          let newCounter := counter.set! i (counter[i]! - 1)
          match tryFormBag (target - i) newCounter with
          | some result => some result
          | none => loop (i - 1)
        else
          loop (i - 1)
    loop 9

-- Main algorithm: greedy approach starting from largest weights
partial def maxBarabaraManjuImpl (counter : Array Nat) (maxNum : Nat) (acc : Nat) : Nat :=
  if maxNum = 0 then
    acc
  else
    let target := 10 - maxNum
    let deleteNum := counter[maxNum]!
    let rec processWeight (counter : Array Nat) (remaining : Nat) (acc : Nat) : Nat :=
      if remaining = 0 then
        maxBarabaraManjuImpl counter (maxNum - 1) acc
      else
        let newCounter := counter.set! maxNum (counter[maxNum]! - 1)
        match tryFormBag target newCounter with
        | some resultCounter =>
          processWeight resultCounter (remaining - 1) (acc + 1)
        | none =>
          maxBarabaraManjuImpl counter (maxNum - 1) acc
    processWeight counter deleteNum acc

-- Main function definitions
def maxBarabaraManju (weights : List Nat) (h_precond : maxBarabaraManju_precond (weights)) : Nat :=
  -- !benchmark @start code
  -- Initialize counter array (index 0-9, where index i stores count of weight i)
    let counter := Array.mkArray 10 0
    let counter := weights.foldl (fun arr w => 
      if w < 10 then arr.set! w (arr[w]! + 1) else arr) counter
    maxBarabaraManjuImpl counter 9 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper to check if a multiset of weights can form a bag with total weight exactly 10
def canFormBag (weights : List Nat) : Prop :=
  weights.sum = 10 ∧ weights.all (fun w => 1 ≤ w ∧ w ≤ 9)

-- Helper to count occurrences of each weight in a list
def countWeight (weights : List Nat) (w : Nat) : Nat :=
  weights.filter (· = w) |>.length

-- A valid partition is a list of bags (each bag is a list of weights)
-- such that each bag sums to 10 and uses only available weights
def isValidPartition (weights : List Nat) (partition : List (List Nat)) : Prop :=
  -- Each bag must sum to 10
  (∀ bag ∈ partition, canFormBag bag) ∧
  -- The total count of each weight used across all bags must not exceed available count
  (∀ w : Nat, 1 ≤ w → w ≤ 9 → 
    (partition.map (fun bag => countWeight bag w)).sum ≤ countWeight weights w)

-- Postcondition definitions
@[reducible, simp]
def maxBarabaraManju_postcond (weights : List Nat) (result: Nat) (h_precond : maxBarabaraManju_precond (weights)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the maximum number of bags that can be formed
  -- such that each bag has total weight exactly 10
  (∃ partition : List (List Nat), 
    isValidPartition weights partition ∧ 
    partition.length = result) ∧
  (∀ partition : List (List Nat), 
    isValidPartition weights partition → 
    partition.length ≤ result)
  -- !benchmark @end postcond


-- Proof content
theorem maxBarabaraManju_postcond_satisfied (weights: List Nat) (h_precond : maxBarabaraManju_precond (weights)) :
    maxBarabaraManju_postcond (weights) (maxBarabaraManju (weights) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_237_p00246