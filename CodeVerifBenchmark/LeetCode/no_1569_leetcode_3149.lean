import Mathlib

-- Precondition auxiliary definitions
def IsPermutationOfRange (l : List Nat) : Prop :=
  let n := l.length
  l.Perm (List.range n)

-- Precondition definitions
@[reducible, simp]
def findMinScorePermutation_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  IsPermutationOfRange nums ∧ nums.length ≥ 2 ∧ nums.length ≤ 14
  -- !benchmark @end precond


-- Code auxiliary definitions
def Permutations (n : Nat) : List (List Nat) :=
  if n = 0 then
    [[]]
  else
    let prev_perms := Permutations (n - 1)
    let indices := List.range n
    indices.flatMap fun i =>
      prev_perms.map fun perm =>
        let (before, after) := List.splitAt i perm
        before ++ [n - 1] ++ after

def absDiff (a b : Nat) : Nat :=
  if a ≥ b then a - b else b - a

def EvaluatePermutation (perm : List Nat) (nums_array : Array Nat) : Nat :=
  let n := perm.length
  if n = 0 then
    0
  else
    let perm_array := perm.toArray
    let indices := List.range n
    indices.map (fun i =>
      let curr_elem := perm_array[i]!
      let next_index_in_perm := perm_array[(i + 1) % n]!
      let val_at_next_index := nums_array[next_index_in_perm]!
      absDiff curr_elem val_at_next_index
    ) |> List.sum

-- Main function definitions
def findMinScorePermutation (nums : List Nat) (h_precond : findMinScorePermutation_precond nums) : List Nat :=
  -- !benchmark @start code
  let n := nums.length
  let nums_array := nums.toArray
  let all_perms := Permutations n
  let scores_and_perms := all_perms.map (fun p => (EvaluatePermutation p nums_array, p))
  let min_score := scores_and_perms.map Prod.fst |> List.foldl min 0
  let candidates_with_min_score := scores_and_perms.filter (fun (s, _) => s = min_score)
  let perms_with_min_score := candidates_with_min_score.map Prod.snd
  perms_with_min_score.head? |>.getD []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def Score (perm : List Nat) (nums : List Nat) : Nat :=
  let n := perm.length
  if h : perm.length = nums.length then
    let perm_array := perm.toArray
    let nums_array := nums.toArray
    let f (i : Nat) : Nat :=
      if hi : i < n then
        let next_index := perm_array[(i + 1) % n]!
        let val_at_next := nums_array[next_index]!
        absDiff (perm_array[i]!) val_at_next
      else
        0
    List.range n |> List.map f |> List.sum
  else
    0

-- Postcondition definitions
@[reducible, simp]
def findMinScorePermutation_postcond (nums : List Nat) (result: List Nat) (h_precond : findMinScorePermutation_precond nums) : Prop :=
  -- !benchmark @start postcond
  IsPermutationOfRange result ∧
  result.length = nums.length ∧
  let min_score := Score result nums
  (∀ p : List Nat, IsPermutationOfRange p → p.length = nums.length →
    let score_p := Score p nums
    min_score ≤ score_p ∧
    (min_score = score_p → result ≤ p))
  -- !benchmark @end postcond


-- Proof content
theorem findMinScorePermutation_postcond_satisfied (nums: List Nat) (h_precond : findMinScorePermutation_precond nums) :
    findMinScorePermutation_postcond nums (findMinScorePermutation nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof