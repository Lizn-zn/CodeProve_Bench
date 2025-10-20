import Mathlib

namespace no_1014_leetcode_2049


-- Precondition auxiliary definitions
def isValidBinaryTree (parents : List Int) : Prop :=
  let n := parents.length
  n ≥ 2 ∧
  parents.get! 0 = -1 ∧
  (List.range n).all (fun i => if i = 0 then true else 0 ≤ parents.get! i ∧ parents.get! i < n) ∧
  -- Check that each node has at most two children (since it's a binary tree)
  let childrenCount := (List.range n).map (fun i => ((List.range n).filter (fun j => parents.get! j = i)).length)
  (childrenCount.all (fun x => x ≤ 2))

-- Precondition definitions
@[reducible, simp]
def countHighestScoreNodes_precond (parents : List Int) : Prop :=
  -- !benchmark @start precond
  parents.length ≥ 2 ∧
  parents.get! 0 = -1 ∧
  (List.range parents.length).all (fun i => if i = 0 then true else 0 ≤ parents.get! i ∧ parents.get! i < parents.length) ∧
  isValidBinaryTree parents
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Build children list for each node
def buildChildren (parents : List Int) : List (List Nat) :=
  let n := parents.length
  (List.range n).map fun i =>
    (List.range n).filter fun j => parents.get! j = i

-- Compute subtree sizes using DFS
def dfsSubtreeSize (children : List (List Nat)) (node : Nat) (visited : List Bool) : Nat :=
  if node ≥ children.length ∨ visited.get! node then 0
  else
    let newVisited := visited.set node true
    1 + ((children.get! node).map (fun child => dfsSubtreeSize children child newVisited)).sum
  decreasing_by sorry

-- Compute all subtree sizes
def computeAllSubtreeSizes (parents : List Int) : List Nat :=
  let n := parents.length
  let children := buildChildren parents
  let visitedInit := List.replicate n false
  (List.range n).map fun i => dfsSubtreeSize children i visitedInit

-- More efficient subtree size computation using dynamic programming
def computeSubtreeSizes (children : List (List Nat)) (n : Nat) : List Nat :=
  let rec dfs (node : Nat) (sizes : List Nat) : List Nat :=
    let childSizes := (children.get! node).foldl (fun acc child => 
      if child < sizes.length ∧ sizes.get! child = 0 then dfs child sizes
      else sizes) sizes
    let mySize := 1 + ((children.get! node).map (fun c => 
      if c < childSizes.length then childSizes.get! c else 0)).sum
    childSizes.set node mySize
  decreasing_by sorry
  let initialSizes := List.replicate n 0
  (List.range n).foldl (fun sizes node =>
    if sizes.get! node = 0 then dfs node sizes else sizes) initialSizes

-- Even better approach: post-order traversal
def computeSubtreeSizesEfficient (parents : List Int) : List Nat :=
  let n := parents.length
  let children := buildChildren parents
  let rec postOrder (node : Nat) (sizes : List Nat) : List Nat :=
    let childResults := (children.get! node).foldl (fun acc child =>
      postOrder child acc) sizes
    let mySize := 1 + ((children.get! node).map (fun c => 
      if c < childResults.length then childResults.get! c else 0)).sum
    childResults.set node mySize
  decreasing_by sorry
  -- Start with leaves and work up
  let initialSizes := List.replicate n 0
  let rec processAll (nodes : List Nat) (sizes : List Nat) : List Nat :=
    match nodes with
    | [] => sizes
    | node :: rest =>
      if sizes.get! node = 0 then
        processAll rest (postOrder node sizes)
      else
        processAll rest sizes
  processAll (List.range n) initialSizes

-- Simple recursive approach that should work
def subtreeSizeAux (children : List (List Nat)) (node : Nat) : Nat :=
  1 + ((children.get! node).map (subtreeSizeAux children ·)).sum
  decreasing_by sorry

def computeSubtreeSizesSimple (parents : List Int) : List Nat :=
  let n := parents.length
  let children := buildChildren parents
  (List.range n).map (subtreeSizeAux children ·)

-- Calculate score for a node
def calculateScore (parents : List Int) (subtreeSizes : List Nat) (node : Nat) : Nat :=
  let n := parents.length
  -- Size of parent subtree (if not root)
  let parentContribution := if node = 0 then 1 else
    n - subtreeSizes.get! node
  -- Sizes of children subtrees
  let children := (List.range n).filter (fun i => parents.get! i = node)
  let childrenContributions := children.map (fun child => subtreeSizes.get! child)
  -- Product of all contributions
  parentContribution * childrenContributions.foldl (· * ·) 1

-- Calculate all scores
def calculateAllScores (parents : List Int) (subtreeSizes : List Nat) : List Nat :=
  (List.range parents.length).map (calculateScore parents subtreeSizes ·)

-- Main function definitions
def countHighestScoreNodes (parents : List Int) (h_precond : countHighestScoreNodes_precond (parents)) : Nat :=
  -- !benchmark @start code
  let n := parents.length
    -- Build children list for efficient access
    let children := (List.range n).map fun i =>
      (List.range n).filter fun j => parents.get! j = i
    -- Compute subtree sizes using simple recursion
    let subtreeSizes := (List.range n).map fun node =>
      let rec dfs (currentNode : Nat) : Nat :=
        1 + ((children.get! currentNode).map dfs).sum
      decreasing_by sorry
      dfs node
    -- Calculate scores for each node
    let scores := (List.range n).map fun node =>
      -- Parent subtree size (if not root)
      let parentSize := if node = 0 then 1 else n - subtreeSizes.get! node
      -- Children subtree sizes
      let childrenSizes := (children.get! node).map (fun child => subtreeSizes.get! child)
      -- Product of all subtree sizes
      parentSize * childrenSizes.foldl (· * ·) 1
    -- Find maximum score
    let maxScore := scores.foldl (max · ·) 0
    -- Count nodes with maximum score
    scores.filter (· = maxScore) |>.length
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def subtreeSize (parents : List Int) (node : Nat) (visited : List Bool) : Nat :=
  if node ≥ parents.length ∨ visited.get! node then 0
  else
    let newVisited := visited.set node true
    1 + ((List.range parents.length).filter (fun i => parents.get! i = node) |>.map (fun child => subtreeSize parents child newVisited)).sum
  decreasing_by sorry

def computeScores (parents : List Int) : List Nat :=
  let n := parents.length
  let visitedInit := List.replicate n false
  (List.range n).map fun node =>
    -- Removing node splits the tree into subtrees
    -- One subtree is the parent subtree (if node is not root)
    let parentSubtreeSize := if node = 0 then 1 else
      let parent := parents.get! node
      subtreeSize parents (Int.toNat parent) (visitedInit.set node true)
    -- Other subtrees are the children subtrees
    let children := (List.range n).filter (fun i => parents.get! i = node)
    let childrenSizes := children.map (fun child => subtreeSize parents child (visitedInit.set node true))
    -- Product of all subtree sizes
    (if node ≠ 0 then parentSubtreeSize else 1) * childrenSizes.foldl (· * ·) 1

-- Postcondition definitions
@[reducible, simp]
def countHighestScoreNodes_postcond (parents : List Int) (result: Nat) (h_precond : countHighestScoreNodes_precond (parents)) : Prop :=
  -- !benchmark @start postcond
  let scores := computeScores parents
  let maxScore := scores.foldl (·.max ·) 0
  result = (scores.filter (· = maxScore)).length
  -- !benchmark @end postcond


-- Proof content
theorem countHighestScoreNodes_postcond_satisfied (parents: List Int) (h_precond : countHighestScoreNodes_precond (parents)) :
    countHighestScoreNodes_postcond (parents) (countHighestScoreNodes (parents) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1014_leetcode_2049