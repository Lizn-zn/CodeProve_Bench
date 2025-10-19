import Mathlib

-- Precondition definitions
@[reducible, simp]
def maxContests_precond (nMath : Nat) (nGreedy : Nat) (nGeometry : Nat) (nDP : Nat) (nGraph : Nat) (nOther : Nat) : Prop :=
  -- !benchmark @start precond
  nMath + nGreedy + nGeometry + nDP + nGraph + nOther ≤ 100000000
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute maximum contests
-- We group problems into three pairs: (Math+DP), (Greedy+Graph), (Geometry+Other)
-- For each pair, we can make specialized contests (3 problems from that pair)
-- or contribute to balanced contests (1 problem from each pair)

def computeMaxContests (n0 n1 n2 : Nat) : Nat :=
  -- n0, n1, n2 are the total problems in each of the three pairs
  -- First, greedily make specialized contests from each pair
  let specialized0 := n0 / 3
  let specialized1 := n1 / 3
  let specialized2 := n2 / 3
  let rem0 := n0 % 3
  let rem1 := n1 % 3
  let rem2 := n2 % 3
  
  -- Count remainders
  let count_rem := [rem0, rem1, rem2].filter (· > 0) |>.length
  let count_rem2 := [rem0, rem1, rem2].filter (· == 2) |>.length
  
  -- Calculate additional balanced contests from remainders
  let additional := 
    if rem0 == 0 && rem1 == 0 && rem2 == 0 then 0
    else if count_rem2 == 2 then
      -- Two pairs have remainder 2, one has 0 - can make 1 balanced if any had ≥3
      if specialized0 > 0 || specialized1 > 0 || specialized2 > 0 then 1 else 0
    else if count_rem == 1 then 0  -- Only one pair has remainder, can't make balanced
    else if count_rem == 2 then 1  -- Two pairs have remainder (at least 1 each), make 1 balanced
    else 2  -- All three have remainder, make 2 balanced contests
  
  specialized0 + specialized1 + specialized2 + additional

-- Main function definitions
def maxContests (nMath : Nat) (nGreedy : Nat) (nGeometry : Nat) (nDP : Nat) (nGraph : Nat) (nOther : Nat) (h_precond : maxContests_precond (nMath) (nGreedy) (nGeometry) (nDP) (nGraph) (nOther)) : Nat :=
  -- !benchmark @start code
  let n0 := nMath + nDP
    let n1 := nGreedy + nGraph
    let n2 := nGeometry + nOther
    computeMaxContests n0 n1 n2
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- A valid contest configuration is one of:
-- 1. Math contest: uses 3 problems from (Math + DP)
-- 2. Algorithm contest: uses 3 problems from (Greedy + Graph)
-- 3. Implementation contest: uses 3 problems from (Geometry + Other)
-- 4. Balanced contest: uses 1 from (Math or DP), 1 from (Greedy or Graph), 1 from (Geometry or Other)

-- Represents a distribution of problems into contests
structure ContestDistribution where
  mathContests : Nat  -- Type 1: Math + DP contests
  algoContests : Nat  -- Type 2: Greedy + Graph contests
  implContests : Nat  -- Type 3: Geometry + Other contests
  balancedContests : Nat  -- Type 4: Balanced contests
  -- How balanced contests use problems from each category pair
  balancedFromMathDP : Nat  -- problems from Math+DP used in balanced
  balancedFromGreedyGraph : Nat  -- problems from Greedy+Graph used in balanced
  balancedFromGeometryOther : Nat  -- problems from Geometry+Other used in balanced

def ContestDistribution.isValid (d : ContestDistribution) 
  (nMath nGreedy nGeometry nDP nGraph nOther : Nat) : Prop :=
  -- Each balanced contest uses exactly 1 from each pair
  d.balancedFromMathDP = d.balancedContests ∧
  d.balancedFromGreedyGraph = d.balancedContests ∧
  d.balancedFromGeometryOther = d.balancedContests ∧
  -- Total problems used doesn't exceed available
  3 * d.mathContests + d.balancedFromMathDP ≤ nMath + nDP ∧
  3 * d.algoContests + d.balancedFromGreedyGraph ≤ nGreedy + nGraph ∧
  3 * d.implContests + d.balancedFromGeometryOther ≤ nGeometry + nOther

def ContestDistribution.totalContests (d : ContestDistribution) : Nat :=
  d.mathContests + d.algoContests + d.implContests + d.balancedContests

-- Postcondition definitions
@[reducible, simp]
def maxContests_postcond (nMath : Nat) (nGreedy : Nat) (nGeometry : Nat) (nDP : Nat) (nGraph : Nat) (nOther : Nat) (result: Nat) (h_precond : maxContests_precond (nMath) (nGreedy) (nGeometry) (nDP) (nGraph) (nOther)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the maximum number of contests that can be organized
  (∃ (d : ContestDistribution), 
    d.isValid nMath nGreedy nGeometry nDP nGraph nOther ∧ 
    d.totalContests = result) ∧
  (∀ (d : ContestDistribution), 
    d.isValid nMath nGreedy nGeometry nDP nGraph nOther → 
    d.totalContests ≤ result)
  -- !benchmark @end postcond


-- Proof content
theorem maxContests_postcond_satisfied (nMath: Nat) (nGreedy: Nat) (nGeometry: Nat) (nDP: Nat) (nGraph: Nat) (nOther: Nat) (h_precond : maxContests_precond (nMath) (nGreedy) (nGeometry) (nDP) (nGraph) (nOther)) :
    maxContests_postcond (nMath) (nGreedy) (nGeometry) (nDP) (nGraph) (nOther) (maxContests (nMath) (nGreedy) (nGeometry) (nDP) (nGraph) (nOther) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

