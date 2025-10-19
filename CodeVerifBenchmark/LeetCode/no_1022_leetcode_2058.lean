import Mathlib

-- Precondition auxiliary definitions
def IsLocalMaxima (lst : List Int) (index : Nat) : Prop :=
  index > 0 ∧ index + 1 < lst.length ∧
  lst[index - 1]! < lst[index]! ∧ lst[index + 1]! < lst[index]!

def IsLocalMinima (lst : List Int) (index : Nat) : Prop :=
  index > 0 ∧ index + 1 < lst.length ∧
  lst[index - 1]! > lst[index]! ∧ lst[index + 1]! > lst[index]!

def IsCriticalPoint (lst : List Int) (index : Nat) : Prop :=
  IsLocalMaxima lst index ∨ IsLocalMinima lst index

instance (lst : List Int) (index : Nat) : Decidable (IsLocalMaxima lst index) :=
  inferInstanceAs (Decidable (_ ∧ _ ∧ _ ∧ _))

instance (lst : List Int) (index : Nat) : Decidable (IsLocalMinima lst index) :=
  inferInstanceAs (Decidable (_ ∧ _ ∧ _ ∧ _))

instance (lst : List Int) (index : Nat) : Decidable (IsCriticalPoint lst index) :=
  inferInstanceAs (Decidable (_ ∨ _))

def CriticalPointsIndices (lst : List Int) : List Nat :=
  List.filter (fun i => decide (IsCriticalPoint lst i)) (List.range lst.length)

-- Precondition definitions
@[reducible, simp]
def criticalPointsDistances_precond (head : List Int) : Prop :=
  -- !benchmark @start precond
  head.length ≥ 2
  -- !benchmark @end precond


-- Code auxiliary definitions
def List.pairs {α : Type} (lst : List α) : List (α × α) :=
  match lst with
  | [] => []
  | [_] => []
  | x :: xs => (List.map (fun y => (x, y)) xs) ++ List.pairs xs

def List.minimum? [Ord α] : List α → Option α :=
  fun l => match l with
  | [] => none
  | x :: xs => some (List.foldl (fun acc y => if compare y acc = .lt then y else acc) x xs)

def List.maximum? [Ord α] : List α → Option α :=
  fun l => match l with
  | [] => none
  | x :: xs => some (List.foldl (fun acc y => if compare y acc = .gt then y else acc) x xs)

-- Main function definitions
def criticalPointsDistances (head : List Int) (h_precond : criticalPointsDistances_precond head) : List Int :=
  -- !benchmark @start code
  let critical_indices := CriticalPointsIndices head
  if critical_indices.length < 2 then
    [-1, -1]
  else
    let distances := List.map (fun (i, j) => Int.ofNat (j - i)) (List.pairs critical_indices)
    let min_dist := (List.minimum? distances).getD (-1)
    let max_dist := (List.maximum? distances).getD (-1)
    [min_dist, max_dist]
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def criticalPointsDistances_postcond (head : List Int) (result: List Int) (h_precond : criticalPointsDistances_precond head) : Prop :=
  -- !benchmark @start postcond
  let critical_indices := CriticalPointsIndices head
  if critical_indices.length < 2 then
    result = [-1, -1]
  else
    let distances := List.map (fun (i, j) => j - i) (List.pairs critical_indices)
    let min_dist := (List.minimum? distances).getD 0
    let max_dist := (List.maximum? distances).getD 0
    result = [min_dist, max_dist]
  -- !benchmark @end postcond


-- Proof content
theorem criticalPointsDistances_postcond_satisfied (head: List Int) (h_precond : criticalPointsDistances_precond head) :
    criticalPointsDistances_postcond head (criticalPointsDistances head h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof