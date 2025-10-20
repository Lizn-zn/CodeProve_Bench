import Mathlib

namespace no_2010_p02972


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def solveBoxBallProblem_precond (n : Nat) (a : Array Nat) : Prop :=
  -- !benchmark @start precond
  a.size = n ∧ n ≥ 1 ∧ ∀ i : Fin n, a[i]! = 0 ∨ a[i]! = 1
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to check if a box should have a ball
-- Working backwards from n to 1
def shouldPlaceBall (i : Nat) (a : Array Nat) (boxes : Array Bool) : Bool :=
  if h : i = 0 ∨ i > a.size then
    false
  else
    have h_idx : i - 1 < a.size := by
      omega
    let required := a[i - 1]!
    -- Count balls already placed in multiples of i
    let count := Id.run do
      let mut cnt := 0
      for j in [i : a.size + 1] do
        if j % i == 0 && j ≤ a.size && boxes[j]! then
          cnt := cnt + 1
      return cnt
    count % 2 != required

-- Build the solution array by iterating backwards
partial def buildSolution (n : Nat) (a : Array Nat) : Array Nat :=
  let boxes := Array.mkArray (n + 1) false
  let (boxes', result) := Id.run do
    let mut boxes := boxes
    let mut result := #[]
    for i in [1 : n + 1] do
      let idx := n + 1 - i  -- iterate from n down to 1
      if idx ≥ 1 && idx ≤ n then
        -- Count balls in multiples of idx
        let mut count := 0
        for j in [idx : n + 1] do
          if j % idx == 0 && boxes[j]! then
            count := count + 1
        -- Check if we need to place a ball at idx
        if h_idx : idx - 1 < a.size then
          if count % 2 != a[idx - 1]! then
            boxes := boxes.set! idx true
            result := result.push idx
    return (boxes, result)
  result.reverse

-- Main function definitions
def solveBoxBallProblem (n : Nat) (a : Array Nat) (h_precond : solveBoxBallProblem_precond (n) (a)) : Option (Array Nat) :=
  -- !benchmark @start code
  let solution := buildSolution n a
    -- Verify the solution is valid
    let isValid := Id.run do
      let mut valid := true
      for i in [0 : n] do
        let mut count := 0
        for box in solution do
          if box % (i + 1) == 0 then
            count := count + 1
        if h : i < a.size then
          if count % 2 != a[i]! then
            valid := false
            break
        else
          valid := false
          break
      return valid
    
    if isValid then
      some solution
    else
      none
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if j is a multiple of i (1-indexed)
def isMultiple (j i : Nat) : Bool :=
  i > 0 && j % i == 0

-- Count balls in boxes whose indices are multiples of i (1-indexed)
def countBallsAtMultiples (boxes : Array Nat) (i : Nat) : Nat :=
  boxes.foldl (fun count box => if isMultiple box i then count + 1 else count) 0

-- Check if a solution satisfies the constraints
def isValidSolution (n : Nat) (a : Array Nat) (boxes : Array Nat) : Prop :=
  (∀ box ∈ boxes.toList, 1 ≤ box ∧ box ≤ n) ∧
  (∀ i : Fin n, (countBallsAtMultiples boxes (i.val + 1)) % 2 = a[i]!)

-- Postcondition definitions
@[reducible, simp]
def solveBoxBallProblem_postcond (n : Nat) (a : Array Nat) (result: Option (Array Nat)) (h_precond : solveBoxBallProblem_precond (n) (a)) : Prop :=
  -- !benchmark @start postcond
  match result with
    | none => ¬∃ (boxes : Array Nat), isValidSolution n a boxes
    | some boxes => 
        isValidSolution n a boxes ∧
        (∀ i j : Fin boxes.size, i ≠ j → boxes[i]! ≠ boxes[j]!)
  -- !benchmark @end postcond


-- Proof content
theorem solveBoxBallProblem_postcond_satisfied (n: Nat) (a: Array Nat) (h_precond : solveBoxBallProblem_precond (n) (a)) :
    solveBoxBallProblem_postcond (n) (a) (solveBoxBallProblem (n) (a) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2010_p02972