import Mathlib

-- Precondition auxiliary definitions
def validIndex (n : Nat) (index : Nat) : Prop :=
  index < n

def validColor (color : Nat) : Prop :=
  color > 0

def validQuery (n : Nat) (query : Nat × Nat) : Prop :=
  let (index, color) := query
  validIndex n index ∧ validColor color

-- Precondition definitions
@[reducible, simp]
def colorTheArray_precond (n : Nat) (queries : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  n > 0 ∧ ∀ query ∈ queries, validQuery n query
  -- !benchmark @end precond


-- Code auxiliary definitions
def updateArray (arr : Array Nat) (index : Nat) (value : Nat) : Array Nat :=
  arr.set! index value

def countAdjacentPairs (colors : Array Nat) (index : Nat) (oldValue : Nat) (newValue : Nat) (prevCount : Nat) : Nat :=
  let n := colors.size
  let count := prevCount
  
  -- Check left neighbor (index - 1)
  let count := if index > 0 then
    let leftIndex := index - 1
    let leftColor := colors[leftIndex]!
    
    -- If old value matched left neighbor, we lose one pair
    let count := if oldValue ≠ 0 ∧ oldValue = leftColor then
      count - 1
    else
      count
    
    -- If new value matches left neighbor, we gain one pair
    if newValue ≠ 0 ∧ newValue = leftColor then
      count + 1
    else
      count
  else
    count
  
  -- Check right neighbor (index + 1)
  let count := if index + 1 < n then
    let rightIndex := index + 1
    let rightColor := colors[rightIndex]!
    
    -- If old value matched right neighbor, we lose one pair
    let count := if oldValue ≠ 0 ∧ oldValue = rightColor then
      count - 1
    else
      count
    
    -- If new value matches right neighbor, we gain one pair
    if newValue ≠ 0 ∧ newValue = rightColor then
      count + 1
    else
      count
  else
    count
  
  count

-- Main function definitions
def colorTheArray (n : Nat) (queries : List (Nat × Nat)) (h_precond : colorTheArray_precond (n) (queries)) : List Nat :=
  -- !benchmark @start code
  let initialColors := Array.mk (List.replicate n 0)
  let currentColors := initialColors
  let results := []
  let pairCount := 0
  
  let state := (currentColors, results, pairCount)
  let finalState := queries.foldl (fun (colors, res, count) query =>
    let (index, color) := query
    let oldValue := colors[index]!
    
    -- Update the pair count based on this change
    let newCount := countAdjacentPairs colors index oldValue color count
    
    -- Update the array
    let newColors := updateArray colors index color
    
    -- Add current count to results
    (newColors, newCount :: res, newCount)
  ) state
  
  let (_, finalResults, _) := finalState
  finalResults.reverse
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def updateListArray (arr : List Nat) (index : Nat) (value : Nat) : List Nat :=
  arr.set index value

def countAdjacentSameColors (colors : List Nat) : Nat :=
  let rec go (lst : List Nat) (acc : Nat) : Nat :=
    match lst with
    | [] => acc
    | [_] => acc
    | a :: b :: rest =>
      if a = b ∧ a ≠ 0 then
        go (b :: rest) (acc + 1)
      else
        go (b :: rest) acc
  go colors 0

def simulateQueries (n : Nat) (queries : List (Nat × Nat)) : List Nat :=
  let initialColors := List.replicate n 0
  let rec go (qs : List (Nat × Nat)) (colors : List Nat) (results : List Nat) : List Nat :=
    match qs with
    | [] => results.reverse
    | (index, color) :: rest =>
      let newColors := updateListArray colors index color
      let count := countAdjacentSameColors newColors
      go rest newColors (count :: results)
  go queries initialColors []

-- Postcondition definitions
@[reducible, simp]
def colorTheArray_postcond (n : Nat) (queries : List (Nat × Nat)) (result: List Nat) (h_precond : colorTheArray_precond (n) (queries)) : Prop :=
  -- !benchmark @start postcond
  result = simulateQueries n queries
  -- !benchmark @end postcond


-- Proof content
theorem colorTheArray_postcond_satisfied (n: Nat) (queries: List (Nat × Nat)) (h_precond : colorTheArray_precond (n) (queries)) :
    colorTheArray_postcond (n) (queries) (colorTheArray (n) (queries) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof