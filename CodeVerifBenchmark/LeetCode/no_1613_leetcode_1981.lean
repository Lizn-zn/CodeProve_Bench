import Mathlib

-- Precondition auxiliary definitions
/-- The set of all possible sums obtained by choosing one element from each row of the matrix. -/
def possibleSums (mat : List (List Int)) : List Int :=
  mat.foldl (fun acc row => acc.flatMap fun sum => row.map (sum + ·)) [0]

/-- The minimal absolute difference between the target and any possible sum. -/
def minAbsDifference (possibleSums : List Int) (target : Int) : Int :=
  match possibleSums with
  | [] => 0
  | h :: t => (possibleSums.map (· - target |> Int.natAbs)).foldl min (h - target |> Int.natAbs)

-- Precondition definitions
@[reducible, simp]
def minimize_absolute_difference_precond (mat : List (List Int)) (target : Int) : Prop :=
  -- !benchmark @start precond
  mat ≠ [] ∧ mat.Forall (· ≠ [])
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- The set of all possible sums obtained by choosing one element from each row of the matrix. -/
def possibleSums' (mat : List (List Int)) : List Int :=
  mat.foldl (fun acc row => acc.flatMap fun sum => row.map (sum + ·)) [0]

/-- The minimal absolute difference between the target and any possible sum. -/
def minAbsDifference' (possibleSums : List Int) (target : Int) : Int :=
  match possibleSums with
  | [] => 0
  | h :: t => (possibleSums.map (· - target |> Int.natAbs)).foldl min (h - target |> Int.natAbs)

-- Main function definitions
def minimize_absolute_difference (mat : List (List Int)) (target : Int) (h_precond : minimize_absolute_difference_precond (mat) (target)) : Int :=
  -- !benchmark @start code
  minAbsDifference' (possibleSums' mat) target
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def minimize_absolute_difference_postcond (mat : List (List Int)) (target : Int) (result: Int) (h_precond : minimize_absolute_difference_precond (mat) (target)) : Prop :=
  -- !benchmark @start postcond
  result = minAbsDifference (possibleSums mat) target
  -- !benchmark @end postcond


-- Proof content
theorem minimize_absolute_difference_postcond_satisfied (mat: List (List Int)) (target: Int) (h_precond : minimize_absolute_difference_precond (mat) (target)) :
    minimize_absolute_difference_postcond (mat) (target) (minimize_absolute_difference (mat) (target) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof