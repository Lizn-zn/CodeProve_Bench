import Mathlib

-- Precondition auxiliary definitions
def IsSortedAsc (l : List Int) : Prop :=
  match l with
  | [] => True
  | [a] => True
  | a :: b :: rest => a ≤ b ∧ IsSortedAsc (b :: rest)

def IsSortedAscBool : List Int → Bool
  | [] => true
  | [a] => true
  | a :: b :: rest => (a ≤ b) && IsSortedAscBool (b :: rest)

def AllNonEmpty (arrays : List (List Int)) : Prop :=
  arrays.all (fun arr => arr.length > 0)

def ValidArrays (arrays : List (List Int)) : Prop :=
  arrays.length ≥ 2 ∧ AllNonEmpty arrays ∧ arrays.all (fun arr => IsSortedAscBool arr = true)

-- Precondition definitions
@[reducible, simp]
def maxDistance_precond (arrays : List (List Int)) : Prop :=
  -- !benchmark @start precond
  ValidArrays arrays
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function to compute the maximum value in a list of integers. -/
def List.maximum! (l : List Int) : Int :=
  match l with
  | [] => panic! "empty list"
  | [x] => x
  | x :: xs => max x (xs.maximum!)

/-- Helper function to compute the minimum value in a list of integers. -/
def List.minimum! (l : List Int) : Int :=
  match l with
  | [] => panic! "empty list"
  | [x] => x
  | x :: xs => min x (xs.minimum!)

-- Main function definitions
def maxDistance (arrays : List (List Int)) (h_precond : maxDistance_precond (arrays)) : Int :=
  -- !benchmark @start code
  let mins := arrays.map (fun arr => arr.head!)
  let maxs := arrays.map (fun arr => arr.getLast!)
  let minMin := mins.minimum!
  let maxMax := maxs.maximum!
  max (maxs.map (fun max => max - minMin)).maximum!
      (mins.map (fun min => maxMax - min)).maximum!
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def MaxDistanceCandidates (arrays : List (List Int)) : List Int :=
  let mins := arrays.map (fun arr => arr.head!)
  let maxs := arrays.map (fun arr => arr.getLast!)
  let minMin := mins.minimum!
  let maxMax := maxs.maximum!
  let candidates1 := maxs.map (fun max => max - minMin)
  let candidates2 := mins.map (fun min => maxMax - min)
  candidates1 ++ candidates2

-- Postcondition definitions
@[reducible, simp]
def maxDistance_postcond (arrays : List (List Int)) (result: Int) (h_precond : maxDistance_precond (arrays)) : Prop :=
  -- !benchmark @start postcond
  result = (MaxDistanceCandidates arrays).maximum!
  -- !benchmark @end postcond


-- Proof content
theorem maxDistance_postcond_satisfied (arrays: List (List Int)) (h_precond : maxDistance_precond (arrays)) :
    maxDistance_postcond (arrays) (maxDistance (arrays) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
