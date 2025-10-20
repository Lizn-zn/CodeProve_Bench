import Mathlib

namespace no_98979_codeexercises_198979


-- Precondition definitions
@[reducible, simp]
def update_distance_precond (stars : List (String × Float)) (star_name : String) (new_distance : Float) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def find_star_index (stars : List (String × Float)) (star_name : String) : Option Nat :=
  let rec go (l : List (String × Float)) (idx : Nat) : Option Nat :=
    match l with
    | [] => none
    | (name, _) :: rest => if name = star_name then some idx else go rest (idx + 1)
  go stars 0

def update_star_at_index (stars : List (String × Float)) (index : Nat) (new_distance : Float) : List (String × Float) :=
  let rec go (l : List (String × Float)) (idx : Nat) : List (String × Float) :=
    match l with
    | [] => []
    | (name, dist) :: rest => 
      if idx = index then (name, new_distance) :: rest
      else (name, dist) :: go rest (idx + 1)
  go stars 0

-- Main function definitions
def update_distance (stars : List (String × Float)) (star_name : String) (new_distance : Float) (h_precond : update_distance_precond (stars) (star_name) (new_distance)) : Option (List (String × Float)) :=
  -- !benchmark @start code
  match find_star_index stars star_name with
  | none => none
  | some index => some (update_star_at_index stars index new_distance)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- (find_star_index and update_star_at_index are already defined above)

-- Postcondition definitions
@[reducible, simp]
def update_distance_postcond (stars : List (String × Float)) (star_name : String) (new_distance : Float) (result: Option (List (String × Float))) (h_precond : update_distance_precond (stars) (star_name) (new_distance)) : Prop :=
  -- !benchmark @start postcond
  match find_star_index stars star_name with
  | none => result = none
  | some index => result = some (update_star_at_index stars index new_distance)
  -- !benchmark @end postcond


-- Proof content
theorem update_distance_postcond_satisfied (stars: List (String × Float)) (star_name: String) (new_distance: Float) (h_precond : update_distance_precond (stars) (star_name) (new_distance)) :
    update_distance_postcond (stars) (star_name) (new_distance) (update_distance (stars) (star_name) (new_distance) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_98979_codeexercises_198979