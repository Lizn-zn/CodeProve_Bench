import Mathlib

namespace no_1895_leetcode_2305


-- Precondition auxiliary definitions
def distributeCookies (cookies : List Nat) (k : Nat) : List (List Nat) → Prop :=
  fun dist : List (List Nat) =>
  -- 1. There are exactly k children (sublists)
  dist.length = k ∧
  -- 2. Every cookie bag is assigned to exactly one child
  --    (the bags in the sublists form a permutation of the original list)
  (dist.flatMap id).Perm cookies ∧
  -- 3. All bags in each sublist are from the original cookies list
  (∀ childBags ∈ dist, childBags ⊆ cookies)

def max_total_cookies (dist : List (List Nat)) : Nat :=
  dist.map (·.sum) |>.foldr max 0

-- Precondition definitions
@[reducible, simp]
def min_unfairness_precond (cookies : List Nat) (k : Nat) : Prop :=
  -- !benchmark @start precond
  k ≥ 2 ∧ k ≤ cookies.length ∧ cookies.length ≥ 2 ∧ cookies.length ≤ 8 ∧
  (∀ c ∈ cookies, c ≥ 1 ∧ c ≤ 10^5)
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Generate all possible ways to distribute `cookies` into `k` non-empty groups -/
def distributeCookiesAll (cookies : List Nat) (k : Nat) : List (List (List Nat)) :=
  if h : k = 0 then
    []
  else if h : k = 1 then
    [([cookies])]
  else
    let rec helper (remaining : List Nat) (currentDist : List (List Nat)) : List (List (List Nat)) :=
      match remaining with
      | [] => 
          -- If we have distributed all cookies, check if we have exactly k groups
          if currentDist.length = k then
            [currentDist]
          else
            []
      | head :: tail =>
          -- Try adding the head cookie to each existing group
          let addToExisting := 
            currentDist.enum.flatMap fun (i, group) =>
              let newDist := 
                currentDist.take i ++ [(head :: group)] ++ currentDist.drop (i+1)
              helper tail newDist
          
          -- Try creating a new group with the head cookie (only if we haven't reached k groups yet)
          let addToNew := 
            if currentDist.length < k then
              helper tail (currentDist ++ [[head]])
            else
              []
              
          addToExisting ++ addToNew
    
    helper cookies []

/-- Calculate the maximum total cookies among all children in a distribution -/
def maxTotalCookies (dist : List (List Nat)) : Nat :=
  dist.map (·.sum) |>.foldr max 0

-- Main function definitions
def min_unfairness (cookies : List Nat) (k : Nat) (h_precond : min_unfairness_precond (cookies) (k)) : Nat :=
  -- !benchmark @start code
  let allDistributions := distributeCookiesAll cookies k
  let validDistributions := allDistributions.filter fun dist => 
    dist.length = k ∧ 
    (dist.flatMap id).Perm cookies ∧
    (∀ childBags ∈ dist, childBags ⊆ cookies)
    
  have h_nonempty : validDistributions ≠ [] := by
    -- We know there's at least one valid distribution since we can always put all cookies 
    -- in one group when k=1, or distribute them somehow when k>1 and k<=cookies.length
    sorry
  
  validDistributions.map maxTotalCookies |>.foldr min (2^32-1)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def min_unfairness_postcond (cookies : List Nat) (k : Nat) (result: Nat) (h_precond : min_unfairness_precond (cookies) (k)) : Prop :=
  -- !benchmark @start postcond
  ∃ dist : List (List Nat), distributeCookies cookies k dist ∧
  result = max_total_cookies dist ∧
  ∀ dist' : List (List Nat), distributeCookies cookies k dist' →
  max_total_cookies dist' ≥ result
  -- !benchmark @end postcond


-- Proof content
theorem min_unfairness_postcond_satisfied (cookies: List Nat) (k: Nat) (h_precond : min_unfairness_precond (cookies) (k)) :
    min_unfairness_postcond (cookies) (k) (min_unfairness (cookies) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1895_leetcode_2305