import Mathlib

namespace no_640_leetcode_1246


-- Precondition auxiliary definitions
def IsPalindromicSubarray (arr : List Nat) (i j : Nat) : Prop :=
  i ≤ j ∧ j < arr.length ∧
  let subarray := List.drop i arr |>.take (j - i + 1)
  subarray = subarray.reverse

def CanRemovePalindromicSubarray (arr : List Nat) (i j : Nat) : Prop :=
  IsPalindromicSubarray arr i j

def minMovesDP (arr : List Nat) : Nat :=
  if arr = [] then 0
  else
    let n := arr.length
    -- Create a 2D array for DP, initialized to a large value
    let max_val := n + 1
    let dp : List (List Nat) := List.range n |> List.map (fun _ => List.replicate n max_val)
    -- Fill the DP table
    let dp := List.foldl (fun dp' len =>
      List.foldl (fun dp'' i =>
        let j := i + len - 1
        if j >= n then dp'' else
        if len = 1 then
          let row := dp''.get! i
          let updatedRow := row.set j 1
          dp''.set i updatedRow
        else
          let cost := if arr.get! i = arr.get! j then
            if len = 2 then 1 else dp''.get! (i+1) |>.get! (j-1)
          else
            max_val
          let min_cost := List.foldl (fun acc k =>
            let c := (dp''.get! i |>.get! k) + (dp''.get! (k+1) |>.get! j)
            if c < acc then c else acc
          ) max_val (List.range (j - i))
          let final_cost := if cost < min_cost then cost else min_cost
          let row := dp''.get! i
          let updatedRow := row.set j final_cost
          dp''.set i updatedRow
      ) dp' (List.range (n - len + 1))
    ) dp (List.range n |>.map (· + 1))

    dp.get! 0 |>.get! (n - 1)

-- Precondition definitions
@[reducible, simp]
def min_moves_to_remove_palindromes_precond (arr : List Nat) : Prop :=
  -- !benchmark @start precond
  arr ≠ [] ∧ ∀ x ∈ arr, 1 ≤ x ∧ x ≤ 20
  -- !benchmark @end precond


-- Main function definitions
def min_moves_to_remove_palindromes (arr : List Nat) (h_precond : min_moves_to_remove_palindromes_precond (arr)) : Nat :=
  -- !benchmark @start code
  minMovesDP arr
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def min_moves_to_remove_palindromes_postcond (arr : List Nat) (result: Nat) (h_precond : min_moves_to_remove_palindromes_precond (arr)) : Prop :=
  -- !benchmark @start postcond
  result = minMovesDP arr
  -- !benchmark @end postcond


-- Proof content
theorem min_moves_to_remove_palindromes_postcond_satisfied (arr: List Nat) (h_precond : min_moves_to_remove_palindromes_precond (arr)) :
    min_moves_to_remove_palindromes_postcond (arr) (min_moves_to_remove_palindromes (arr) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_640_leetcode_1246