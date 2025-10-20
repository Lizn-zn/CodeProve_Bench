import Mathlib

namespace no_1180_leetcode_2361


-- Precondition auxiliary definitions
def List.length_eq : List Nat → List Nat → Prop
  | [], [] => True
  | _ :: xs, _ :: ys => List.length_eq xs ys
  | _, _ => False

instance : Decidable (List.length_eq [] []) := 
  isTrue trivial

instance (bs : List Nat) : Decidable (List.length_eq [] bs) := 
  match bs with
  | [] => isTrue trivial
  | _ :: _ => isFalse (by simp [List.length_eq])

instance (a : Nat) (as : List Nat) : Decidable (List.length_eq (a :: as) []) := 
  isFalse (by simp [List.length_eq])

instance (a : Nat) (as : List Nat) (b : Nat) (bs : List Nat) [Decidable (List.length_eq as bs)] : Decidable (List.length_eq (a :: as) (b :: bs)) := 
  if h : List.length_eq as bs then
    isTrue (by simp [List.length_eq, h])
  else
    isFalse (by simp [List.length_eq, h])

-- Precondition definitions
@[reducible, simp]
def minimumCosts_precond (regular : List Nat) (express : List Nat) (expressCost : Nat) : Prop :=
  -- !benchmark @start precond
  regular.length = express.length ∧ regular.length > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function to compute minimum costs iteratively -/
def computeMinCosts (regular : List Nat) (express : List Nat) (expressCost : Nat) : List Nat :=
  let n := regular.length
  -- Initialize previous costs
  let prevRegCost := 0
  let prevExpCost := expressCost
  let result : List Nat := []
  
  -- Use List.range and List.foldl for iteration
  List.foldl (fun (acc : List Nat × Nat × Nat) (i : Nat) =>
    let (result, prevRegCost, prevExpCost) := acc
    let regMoveCost := if i < regular.length then regular.get! i + prevRegCost else prevRegCost
    let expMoveCostFromReg := if i < express.length then express.get! i + prevRegCost + expressCost else prevExpCost
    let expMoveCostFromExp := if i < express.length then express.get! i + prevExpCost else prevExpCost
    
    -- Update express cost to the minimum of coming from regular or staying on express
    let newExpCost := min expMoveCostFromReg expMoveCostFromExp
    -- Update regular cost considering moving on regular or switching from express
    let newRegCost := min regMoveCost newExpCost
    
    -- The minimum cost to reach stop i+1 is the minimum of both routes
    let minCost := min newRegCost newExpCost
    
    -- Update previous costs for next iteration
    (result ++ [minCost], newRegCost, newExpCost)
  ) (result, prevRegCost, prevExpCost) (List.range n)
  |>.1

-- Main function definitions
def minimumCosts (regular : List Nat) (express : List Nat) (expressCost : Nat) (h_precond : minimumCosts_precond (regular) (express) (expressCost)) : List Nat :=
  -- !benchmark @start code
  computeMinCosts regular express expressCost
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def minCostToStops (regular : List Nat) (express : List Nat) (expressCost : Nat) : List Nat :=
  let n := regular.length
  let initialRegCost := 0
  let initialExpCost := expressCost
  let rec loop (i : Nat) (prevRegCost : Nat) (prevExpCost : Nat) (accReg : List Nat) : List Nat :=
    if i ≥ n then
      List.drop 1 accReg.reverse -- Remove the initial 0 cost for stop 0
    else
      let regCost := if i < regular.length then regular.get! i + prevRegCost else 0
      let expCostFromReg := if i < express.length then express.get! i + prevRegCost + expressCost else 0
      let expCostFromExp := if i < express.length then express.get! i + prevExpCost else 0
      let newExpCost := min expCostFromReg expCostFromExp
      let newRegCost := min regCost newExpCost
      loop (i+1) newRegCost newExpCost (newRegCost :: accReg)
  loop 0 initialRegCost initialExpCost [initialRegCost]

-- Postcondition definitions
@[reducible, simp]
def minimumCosts_postcond (regular : List Nat) (express : List Nat) (expressCost : Nat) (result: List Nat) (h_precond : minimumCosts_precond (regular) (express) (expressCost)) : Prop :=
  -- !benchmark @start postcond
  result.length = regular.length ∧
  result = minCostToStops regular express expressCost
  -- !benchmark @end postcond


-- Proof content
theorem minimumCosts_postcond_satisfied (regular: List Nat) (express: List Nat) (expressCost: Nat) (h_precond : minimumCosts_precond (regular) (express) (expressCost)) :
    minimumCosts_postcond (regular) (express) (expressCost) (minimumCosts (regular) (express) (expressCost) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1180_leetcode_2361