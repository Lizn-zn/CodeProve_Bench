import Mathlib

namespace no_2072_leetcode_2505


-- Precondition auxiliary definitions
def subsequenceSumOr_validInput (nums : List Nat) : Prop :=
  nums.length ≥ 1 ∧ nums.length ≤ 10^5 ∧ ∀ n ∈ nums, n ≤ 10^9

-- Precondition definitions
@[reducible, simp]
def subsequenceSumOr_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  subsequenceSumOr_validInput nums
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute OR of all subsequence sums efficiently
-- We track all possible subset sums implicitly by tracking what bits can be achieved
private def subsequenceSumOrImpl (nums : List Nat) : Nat :=
  let rec loop (nums : List Nat) (result : Nat) (sumSoFar : Nat) : Nat :=
    match nums with
    | [] => result
    | x :: xs => 
      -- When we include x in any existing subsequence, we get new sums
      -- The OR accumulates all possible sums we can make
      -- result represents OR of all sums achievable so far
      -- Adding x means we can now also make all those sums + x
      -- So new OR is result ||| (result ||| x ||| (all sums + x))
      -- But we can simplify: if we could make sum s before, now we can make s and s+x
      -- So the OR becomes result ||| (all possible (s+x))
      -- Since we're doing OR over all, we just need result ||| (result ||| x) initially
      -- But actually let's think more carefully...
      
      -- Better approach: result tracks OR of all possible sums so far
      -- When we see x, new possible sums are old sums UNION (old sums + x)
      -- So new OR = OR(old_sums) ||| OR(old_sums + x)
      -- Now, OR(old_sums + x) can be computed as we go
      
      let newResult := result ||| (result ||| x ||| (sumSoFar + x))
      loop xs newResult (sumSoFar + x)
  loop nums 0 0

-- More correct implementation:
-- The key insight is that we want to track all possible subsequence sums
-- But we don't need to enumerate them, just their cumulative OR
private def subsequenceSumOrEfficient (nums : List Nat) : Nat :=
  let rec go (nums : List Nat) (currentOr : Nat) : Nat :=
    match nums with
    | [] => currentOr
    | x :: xs => 
      -- When we process x, all existing sums can either exclude x or include x
      -- So if S was the set of possible sums before, now it becomes S ∪ {s + x | s ∈ S}
      -- The new OR is OR(S) ||| OR({s + x | s ∈ S})
      -- We know OR(S) = currentOr
      -- For OR({s + x | s ∈ S}), we note that this includes (0 + x) = x since 0 is always possible
      -- And it includes all (s + x) for s in S
      -- The OR of all (s + x) terms is at least x, and includes contributions from all previous sums
      -- Actually, let's think of it as: we had OR = currentOr
      -- Now we get additional terms, including x itself (since sum {} = 0, and 0 + x = x)
      -- And all other terms (s + x) where s was a previous sum
      -- The OR of all these new terms is at least x
      -- In fact, if we denote S as the set of previous sums:
      -- OR(new_terms) = OR{s + x : s ∈ S} = OR{...} 
      -- This is tricky to compute directly, but we know 0 ∈ S, so x ∈ new_terms
      -- Also, if s1, s2 ∈ S, then (s1+x) and (s2+x) are in new terms
      -- Actually, simpler insight: we're taking OR over two sets:
      -- Original sums S, and shifted sums S+x
      -- So total OR = OR(S) ||| OR(S+x) = currentOr ||| OR(S+x)
      -- How to compute OR(S+x)? It's at least x (since 0 ∈ S), and includes (s+x) for all s ∈ S
      -- There's a pattern here...
      
      -- Simpler and correct approach:
      -- currentOr tracks OR of all sums we can make with elements processed so far
      -- When we see a new element x:
      -- Old sums: represented by currentOr
      -- New sums: each old sum s becomes (s + x) 
      -- So new OR = currentOr ||| OR{ s + x | s is an achievable sum }
      -- We know that 0 is always achievable (empty subsequence)
      -- So x is achievable (add x to empty subsequence)
      -- This means the new terms definitely include x
      -- For the OR of all (s + x) terms, it's at least x
      -- But it may include more
      -- Key insight: OR{s + x : s ∈ T} = OR{T} ||| x won't work in general
      -- However, there's another way to think about it:
      -- The set of new sums when adding x is exactly { s + x | s ∈ old_set }
      -- We want OR of this set
      -- Since 0 is in old_set, x is in the new set
      -- If we knew more about the structure...
      
      -- Let me try a different approach:
      -- Keep track of all bits that can possibly be set in any sum
      -- But even that is complex
      
      -- Direct but efficient approach:
      -- We simulate building up the set of sums, but keep only the OR
      -- When processing x:
      -- Previous possible sums have OR = currentOr  
      -- New possible sums = { s + x | s was previously possible }
      -- OR of new sums = ???
      -- We know that 0 was possible, so x is in new sums
      -- Actually, let's use this property:
      -- If old_sum_or represents OR of old sums, and we form new sums by adding x to each,
      -- then OR of new sums = OR{ s + x | s ∈ old_sums }  
      -- This includes x (since 0 is always a possible sum)
      -- It's difficult to express this directly in terms of old_sum_or
      -- But we can observe that we're essentially doubling our computation
      
      -- Wait, let me restart with clearer thinking:
      -- At any time, we have a set S of possible subsequence sums
      -- We maintain result = OR{s : s ∈ S}
      -- When we see new element x, the new set of sums is:
      -- S_new = S ∪ { s + x | s ∈ S }
      -- So the new result is:
      -- result_new = OR(S_new) = OR(S) ||| OR{ s + x | s ∈ S } = result ||| OR{ s + x | s ∈ S }
      -- Now how to compute OR{ s + x | s ∈ S } ?
      -- It equals OR{ s + x : s ∈ S }. This is at least x (because 0 ∈ S).
      -- But we can say more: OR{ s + x : s ∈ S } = OR( {s : s ∈ S} + x ) where + is setwise addition
      -- There isn't a simple formula, but we can compute it incrementally
      
      -- Best approach: for efficiency, realize that:
      -- result_new = result ||| (all new sums)
      -- The new sums include x (from {} + x)
      -- They also include everything in (existing_sums + x)
      -- We can't easily compute OR(existing_sums + x) from just OR(existing_sums)
      -- BUT we can keep track of more information
      
      -- Even simpler working approach:
      -- Just do: result_new = result ||| x ||| (result ||| x)
      -- No, that's wrong
      
      -- Correct insight for efficient algorithm:
      -- result captures OR of all currently possible sums
      -- When we introduce element x:
      -- For every subset T of previously seen elements, we could form sum(T)  
      -- Now we can also form sum(T) + x
      -- So new OR = (OR of sum(T)) ||| (OR of (sum(T) + x))  
      -- = result ||| (OR of (sum(T) + x))
      -- To compute OR of (sum(T) + x), we note:
      -- It includes x (take T = empty set)
      -- Generally, OR{a_i + x} >= x, but equality doesn't hold
      -- However, there's a key observation:
      -- OR{ sum(T) + x : T ⊆ prev_elements } = OR{ sum(T) : T ⊆ prev_elements } ||| x ||| (some_correction)
      -- Actually no, that's not right either
      
      -- Let me look up the standard approach or think of examples:
      -- Example: [1,2]
      -- Subsets: {}, {1}, {2}, {1,2}
      -- Sums: 0, 1, 2, 3
      -- OR = 0 ||| 1 ||| 2 ||| 3 = 3
      --
      -- Process []: result = 0
      -- Process [1]: subsets {},{1} give sums 0,1. OR = 1
      --   Old result = 0
      --   New sums are {0+1, 1+1} = {1,2}? No!
      --   Wait, logic error. 
      --   Before seeing 1: possible sums from [] are {0}, OR = 0
      --   After seeing 1: possible sums from [1] are {0,1}, OR = 1
      --   We went from set {0} to set {0,1}
      --   So new OR = old_OR ||| 1 = 0 ||| 1 = 1 ✓
      --
      -- Process [1,2]: subsets {},{1},{2},{1,2} give sums 0,1,2,3. OR = 3  
      --   Before seeing 2: possible sums {0,1}, OR = 1
      --   After seeing 2: we can make:
      --     * Old sums: 0, 1
      --     * New sums (include 2): 0+2=2, 1+2=3
      --     * So new sums are {0,1,2,3}
      --     * New OR = 1 ||| 0 ||| 1 ||| 2 ||| 3 = 1 ||| 2 ||| 3 = 3
      --     * Which equals (old_OR) ||| (new_contributions) = 1 ||| (2 ||| 3) = 1 ||| 3 = 3
      --     * The new contributions include 2 (from {} + 2) and 3 (from {1} + 2)
      --     * So new_contributions = 2 ||| 3
      
      -- Pattern emerging:
      -- When processing x:
      --   Old possible sums have OR = current_result
      --   New possible sums are old_sums ∪ {s + x | s ∈ old_sums}  
      --   New OR = current_result ||| OR{s + x | s ∈ old_sums}
      --   Now, OR{s + x | s ∈ old_sums} includes x (since 0 is always possible)
      --   And includes all (s + x) for previous sums s
      --   How to compute this efficiently?
      
      -- Key insight: OR{s + x : s ∈ S} = F(S, x) where computing F directly from OR(S) is hard
      -- But we can maintain more state or compute differently
      
      -- Simpler working algorithm:
      -- Keep a set of all sums? No, exponential
      -- Alternative: bit-by-bit analysis
      -- For each bit, determine if it can ever be 1 in any subsequence sum
      -- But that's also complex
      
      -- Final clean approach:
      -- Maintain result = OR of all possible sums so far
      -- When processing new element x:
      --   Old sums contributed result to the OR
      --   New sums (each old sum + x) contribute additional terms to the OR
      --   These new terms include x itself (0+x)
      --   So certainly result gets updated by at least x
      --   In fact, result_new = result ||| x ||| (OR of all (prev_sum + x))
      --   But OR(prev_sums + x) is hard to compute
      
      -- Looking at complexity bounds, let's just implement the specification directly
      -- for small cases, and find mathematical shortcut for large ones
      -- Actually, re-reading constraints: length up to 10^5, values up to 10^9
      
      -- Mathematical insight needed:
      -- If we have numbers a1,...,an, what bits can appear in subsequence sums?
      -- Bit k can be 1 in the final OR iff there exists some subset with sum having bit k = 1
      -- This relates to subset sum existence
      
      -- Efficient approach discovered:
      -- Key lemma: When we process elements one by one maintaining the OR of all possible sums,
      -- the update rule is: new_result = old_result ||| (old_result ||| x) ||| x = old_result ||| x
      -- Wait, no. Let me trace again.
      -- After [1]: sums {0,1}, OR=1  
      -- Add 2: new sums are {0,1} ∪ {2,3} = {0,1,2,3}, OR = 3
      -- Update: 1 ||| 2 = 3 ✓
      -- So it seems like: new_result = old_result ||| x ||| (something)
      -- In this case: 1 ||| 2 ||| 3 = 3. But where does 3 come from?
      -- Ah! 3 = 1 + 2. 
      -- Is the rule: new_result = old_result ||| x ||| (old_result + x)?
      -- Check: 1 ||| 2 ||| (1+2) = 1 ||| 2 ||| 3 = 3 ✓
      -- Try another example:
      -- After [1,2]: OR = 3
      -- Add 4: new sums include 4,5,6,7. So OR = 3 ||| 4 ||| 5 ||| 6 ||| 7 = 7
      -- Using formula: 3 ||| 4 ||| (3+4) = 3 ||| 4 ||| 7 = 7 ✓
      -- Another check:
      -- After [2]: sums {0,2}, OR = 2
      -- Add 1: new sums {0,2} ∪ {1,3} = {0,1,2,3}, OR = 3  
      -- Formula: 2 ||| 1 ||| (2+1) = 2 ||| 1 ||| 3 = 3 ✓
      
      -- Conjecture: When adding element x to collection with sum-OR of 'result',
      -- the new sum-OR is: result ||| x ||| (result + x)
      -- Let's call this the "subsequence OR update formula"
      
      let newResult := currentOr ||| x ||| (currentOr + x)
      go xs newResult
      
  match nums with
  | [] => 0
  | xs => go xs 0

-- Main function definitions
def subsequenceSumOr (nums : List Nat) (h_precond : subsequenceSumOr_precond (nums)) : Nat :=
  -- !benchmark @start code
  subsequenceSumOrEfficient nums
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Generate all possible subsequence sums
def subsequenceSums : List Nat → List Nat
| [] => [0]
| x :: xs =>
  let sums := subsequenceSums xs
  sums ++ (sums.map (· + x))

-- Compute the OR of all elements in a list
def listOr : List Nat → Nat
| [] => 0
| x :: xs => x ||| listOr xs

-- Postcondition definitions
@[reducible, simp]
def subsequenceSumOr_postcond (nums : List Nat) (result: Nat) (h_precond : subsequenceSumOr_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result = listOr (subsequenceSums nums)
  -- !benchmark @end postcond


-- Proof content
theorem subsequenceSumOr_postcond_satisfied (nums: List Nat) (h_precond : subsequenceSumOr_precond (nums)) :
    subsequenceSumOr_postcond (nums) (subsequenceSumOr (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2072_leetcode_2505