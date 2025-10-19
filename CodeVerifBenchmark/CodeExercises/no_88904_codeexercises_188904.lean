import Mathlib

-- Precondition auxiliary definitions
structure Athlete where
  name : String
  speed : Nat
  deriving Repr

-- Precondition definitions
@[reducible, simp]
def find_fastest_runner_precond (athletes : List Athlete) : Prop :=
  -- !benchmark @start precond
  ∃ a ∈ athletes, a.speed > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to find the athlete with maximum speed
def find_max_athlete (athletes : List Athlete) : Option Athlete :=
  match athletes with
  | [] => none
  | h :: t => 
      let result := List.foldl (λ (best : Athlete) (a : Athlete) => 
        if a.speed > best.speed then a else best) h t
      some result

-- Main function definitions
def find_fastest_runner (athletes : List Athlete) (h_precond : find_fastest_runner_precond (athletes)) : Option Athlete :=
  -- !benchmark @start code
  match athletes with
  | [] => none
  | h :: t =>
      let fastest := List.foldl (λ (best : Athlete) (a : Athlete) => 
        if a.speed > best.speed then a else best) h t
      some fastest
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def max_speed (athletes : List Athlete) : Nat :=
  match athletes with
  | [] => 0
  | h :: t => List.foldl (λ max a => if a.speed > max then a.speed else max) h.speed t

-- Postcondition definitions
@[reducible, simp]
def find_fastest_runner_postcond (athletes : List Athlete) (result: Option Athlete) (h_precond : find_fastest_runner_precond (athletes)) : Prop :=
  -- !benchmark @start postcond
  match result with
  | none => athletes = []
  | some fastest => 
      fastest ∈ athletes ∧ 
      fastest.speed = max_speed athletes ∧ 
      ∀ a ∈ athletes, a.speed ≤ fastest.speed
  -- !benchmark @end postcond


-- Proof content
theorem find_fastest_runner_postcond_satisfied (athletes: List Athlete) (h_precond : find_fastest_runner_precond (athletes)) :
    find_fastest_runner_postcond (athletes) (find_fastest_runner (athletes) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

