import Mathlib

namespace no_2755_p03800


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def solveZooAssignment_precond (n : Nat) (s : String) : Prop :=
  -- !benchmark @start precond
  n ≥ 3 ∧ s.length = n ∧ (∀ i : Fin s.length, s.get ⟨i.val⟩ = 'o' ∨ s.get ⟨i.val⟩ = 'x')
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to check if two animals are of the same species
def sameSpecies (c1 c2 : Char) : Bool :=
  (c1 = 'S' ∧ c2 = 'S') ∨ (c1 = 'W' ∧ c2 = 'W')

-- Helper function to reverse species
def reverseSpecies (c : Char) : Char :=
  if c = 'S' then 'W' else 'S'

-- Helper function to determine next animal based on current and previous
def getNextAnimal (current : Char) (previous : Char) (response : Char) : Char :=
  if current = 'S' then
    if response = 'o' then previous else reverseSpecies previous
  else -- current = 'W'
    if response = 'o' then reverseSpecies previous else previous

-- Try to build an assignment starting with given first two animals
def tryAssignment (n : Nat) (s : String) (first : Char) (second : Char) : Option String :=
  -- Build the assignment
  let rec buildAssignment (i : Nat) (ans : Array Char) : Array Char :=
    if i >= n then ans
    else
      let prev := ans[i - 1]!
      let curr := ans[i]!
      let resp := s.get ⟨i⟩
      let next := getNextAnimal curr prev resp
      buildAssignment (i + 1) (ans.push next)
  
  let initial := #[first, second]
  let assignment := buildAssignment 1 initial
  
  -- Check if the assignment is valid (check the circular constraint)
  if assignment.size != n then none
  else
    let a0 := assignment[0]!
    let a1 := assignment[1]!
    let aNm1 := assignment[n - 1]!
    let s0 := s.get ⟨0⟩
    
    -- Check consistency for animal 0
    let neighborsAreSame := sameSpecies aNm1 a1
    let valid := 
      if a0 = 'S' then
        (neighborsAreSame && s0 = 'o') || (!neighborsAreSame && s0 = 'x')
      else -- a0 = 'W'
        (neighborsAreSame && s0 = 'x') || (!neighborsAreSame && s0 = 'o')
    
    if valid then
      some (String.mk assignment.toList)
    else
      none

-- Main function definitions
def solveZooAssignment (n : Nat) (s : String) (h_precond : solveZooAssignment_precond (n) (s)) : String :=
  -- !benchmark @start code
  -- Try all four possible combinations for the first two animals
    let combinations := [('S', 'S'), ('S', 'W'), ('W', 'S'), ('W', 'W')]
    
    let rec tryAll (combos : List (Char × Char)) : String :=
      match combos with
      | [] => "-1"
      | (first, second) :: rest =>
        match tryAssignment n s first second with
        | some result => result
        | none => tryAll rest
    
    tryAll combinations
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to get neighbor indices in circular arrangement
def leftNeighbor (i : Nat) (n : Nat) : Nat :=
  if i = 0 then n - 1 else i - 1

def rightNeighbor (i : Nat) (n : Nat) : Nat :=
  if i = n - 1 then 0 else i + 1

-- Check if an assignment is consistent with the responses
def isValidAssignment (n : Nat) (s : String) (t : String) : Prop :=
  t.length = n ∧
  (∀ i : Fin t.length, t.get ⟨i.val⟩ = 'S' ∨ t.get ⟨i.val⟩ = 'W') ∧
  (∀ i : Fin n,
    let left := leftNeighbor i.val n
    let right := rightNeighbor i.val n
    let animal := t.get ⟨i.val⟩
    let leftAnimal := t.get ⟨left⟩
    let rightAnimal := t.get ⟨right⟩
    let neighborsAreSame := sameSpecies leftAnimal rightAnimal
    let response := s.get ⟨i.val⟩
    -- Sheep: says 'o' if neighbors are same, 'x' if different
    -- Wolf: says 'x' if neighbors are same, 'o' if different
    if animal = 'S' then
      (neighborsAreSame ∧ response = 'o') ∨ (¬neighborsAreSame ∧ response = 'x')
    else -- animal = 'W'
      (neighborsAreSame ∧ response = 'x') ∨ (¬neighborsAreSame ∧ response = 'o'))

-- Postcondition definitions
@[reducible, simp]
def solveZooAssignment_postcond (n : Nat) (s : String) (result: String) (h_precond : solveZooAssignment_precond (n) (s)) : Prop :=
  -- !benchmark @start postcond
  (result = "-1" ∧ ¬∃ t : String, isValidAssignment n s t) ∨
    (result ≠ "-1" ∧ isValidAssignment n s result)
  -- !benchmark @end postcond


-- Proof content
theorem solveZooAssignment_postcond_satisfied (n: Nat) (s: String) (h_precond : solveZooAssignment_precond (n) (s)) :
    solveZooAssignment_postcond (n) (s) (solveZooAssignment (n) (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2755_p03800