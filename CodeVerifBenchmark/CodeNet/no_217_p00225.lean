import Mathlib

namespace no_217_p00225


-- Precondition auxiliary definitions
-- Helper function to check if a string is non-empty and contains only lowercase English letters
def isValidWord (s : String) : Prop :=
  s.length > 0 ∧ s.length ≤ 32 ∧ s.all (fun c => c.isLower ∧ c.isAlpha)

-- Precondition definitions
@[reducible, simp]
def canFormShiritori_precond (words : List String) : Prop :=
  -- !benchmark @start precond
  -- The list should have at least 2 words and at most 10000 words
    -- Each word should be valid (non-empty, at most 32 chars, lowercase English letters only)
    2 ≤ words.length ∧ words.length ≤ 10000 ∧ 
    (∀ w ∈ words, isValidWord w)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper to get first character of a string
def firstChar (s : String) : Char :=
  s.get ⟨0⟩

-- Helper to get last character of a string
def lastChar (s : String) : Char :=
  s.get ⟨s.length - 1⟩

-- Helper function to convert character to index (0-25 for 'a'-'z')
def charToIndex (c : Char) : Nat :=
  c.toNat - 'a'.toNat

-- DFS to count reachable nodes from a starting index
def searchNode (start : Nat) (adj : Array (Array Nat)) : Nat :=
  let rec dfs (i : Nat) (visited : Array Bool) : Array Bool :=
    if visited[i]! then visited
    else
      let visited' := visited.set! i true
      let neighbors := adj[i]!
      neighbors.foldl (fun vis j => dfs j vis) visited'
  termination_by (26 - (visited.toList.filter id).length)
  decreasing_by sorry
  let visited := dfs start (Array.mkArray 26 false)
  visited.foldl (fun count b => if b then count + 1 else count) 0

-- Count number of unique characters used
def countUniqueChars (startCounts : Array Nat) : Nat :=
  startCounts.foldl (fun count c => if c > 0 then count + 1 else count) 0

-- Main function definitions
def canFormShiritori (words : List String) (h_precond : canFormShiritori_precond (words)) : Bool :=
  -- !benchmark @start code
  -- Build adjacency information
    let startCounts := words.foldl (fun arr w =>
      let idx := charToIndex (firstChar w)
      arr.set! idx (arr[idx]! + 1)
    ) (Array.mkArray 26 0)
    
    let endCounts := words.foldl (fun arr w =>
      let idx := charToIndex (lastChar w)
      arr.set! idx (arr[idx]! + 1)
    ) (Array.mkArray 26 0)
    
    -- Build adjacency list for connectivity check
    let adjList := words.foldl (fun arr w =>
      let startIdx := charToIndex (firstChar w)
      let endIdx := charToIndex (lastChar w)
      let neighbors := arr[startIdx]!
      if neighbors.contains endIdx then arr
      else arr.set! startIdx (neighbors.push endIdx)
    ) (Array.mkArray 26 #[])
    
    -- Check if in-degree equals out-degree for all characters
    let balanced := (List.range 26).all (fun i =>
      startCounts[i]! == endCounts[i]!
    )
    
    if !balanced then false
    else
      -- Find a starting character (any character that appears)
      let startCharOpt := (List.range 26).find? (fun i => startCounts[i]! > 0)
      match startCharOpt with
      | none => false  -- No words (shouldn't happen given precondition)
      | some startChar =>
        -- Check connectivity: all used characters should be reachable
        let reachable := searchNode startChar adjList
        let uniqueChars := countUniqueChars startCounts
        reachable == uniqueChars
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Count occurrences of a character as first character in the word list
def countFirst (words : List String) (c : Char) : Nat :=
  words.filter (fun w => firstChar w = c) |>.length

-- Count occurrences of a character as last character in the word list
def countLast (words : List String) (c : Char) : Nat :=
  words.filter (fun w => lastChar w = c) |>.length

-- Check if all characters have balanced in-degree and out-degree
def hasBalancedDegrees (words : List String) : Prop :=
  ∀ c : Char, c.isLower → c.isAlpha → countFirst words c = countLast words c

-- Get all unique characters that appear as first or last character
def getRelevantChars (words : List String) : List Char :=
  let firsts := words.map firstChar
  let lasts := words.map lastChar
  (firsts ++ lasts).eraseDups

-- Check if the graph formed by words is connected
-- This is a simplified connectivity check: all relevant characters should form one connected component
def isConnected (words : List String) : Prop :=
  -- If there's at least one word, we need the graph to be connected
  -- For a directed graph where in-degree = out-degree for all vertices,
  -- it forms an Eulerian circuit iff it's connected
  -- We model this as: there exists a permutation of words that forms a valid shiritori
  ∃ (perm : List String), perm.Perm words ∧ 
    (∀ i : Fin (perm.length - 1), lastChar (perm[i]!) = firstChar (perm[i.val + 1]!)) ∧
    (perm.length > 0 → lastChar (perm[perm.length - 1]!) = firstChar (perm[0]!))

-- Postcondition definitions
@[reducible, simp]
def canFormShiritori_postcond (words : List String) (result: Bool) (h_precond : canFormShiritori_precond (words)) : Prop :=
  -- !benchmark @start postcond
  -- The result is true iff:
    -- 1. All characters have balanced in-degree and out-degree (necessary condition)
    -- 2. The graph is connected and forms a valid circular shiritori (sufficient condition)
    result = true ↔ (hasBalancedDegrees words ∧ isConnected words)
  -- !benchmark @end postcond


-- Proof content
theorem canFormShiritori_postcond_satisfied (words: List String) (h_precond : canFormShiritori_precond (words)) :
    canFormShiritori_postcond (words) (canFormShiritori (words) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_217_p00225