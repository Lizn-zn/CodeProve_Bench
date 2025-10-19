import Mathlib

-- Precondition auxiliary definitions
def DivisibilityScore (nums : List Nat) (d : Nat) : Nat :=
  if d = 0 then 0 else
  nums.filter (fun x => x % d = 0) |>.length

def HasMaxScoreAndMinValue (nums divisors : List Nat) (d : Nat) : Prop :=
  d ∈ divisors ∧
  ∀ d' ∈ divisors, DivisibilityScore nums d' ≤ DivisibilityScore nums d ∧
    (DivisibilityScore nums d' = DivisibilityScore nums d → d ≤ d')

-- Precondition definitions
@[reducible, simp]
def maxDivScore_precond (nums : List Nat) (divisors : List Nat) : Prop :=
  -- !benchmark @start precond
  nums ≠ [] ∧ divisors ≠ []
  -- !benchmark @end precond


-- Code auxiliary definitions
def findMaxScoreAndMinValue (nums divisors : List Nat) : Nat × Nat :=
  let scores := divisors.map (fun d => (DivisibilityScore nums d, d))
  let maxScore := scores.foldl (fun acc pair => if acc.1 < pair.1 then pair else acc) (0, 0)
  let candidates := scores.filter (fun pair => pair.1 = maxScore.1)
  candidates.foldl (fun acc pair => if pair.2 < acc.2 then pair else acc) (0, 0)

-- Main function definitions
def maxDivScore (nums : List Nat) (divisors : List Nat) (h_precond : maxDivScore_precond (nums) (divisors)) : Nat :=
  -- !benchmark @start code
  findMaxScoreAndMinValue nums divisors |>.2
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def maxDivScore_postcond (nums : List Nat) (divisors : List Nat) (result: Nat) (h_precond : maxDivScore_precond (nums) (divisors)) : Prop :=
  -- !benchmark @start postcond
  HasMaxScoreAndMinValue nums divisors result
  -- !benchmark @end postcond


-- Proof content
theorem maxDivScore_postcond_satisfied (nums: List Nat) (divisors: List Nat) (h_precond : maxDivScore_precond (nums) (divisors)) :
    maxDivScore_postcond (nums) (divisors) (maxDivScore (nums) (divisors) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof