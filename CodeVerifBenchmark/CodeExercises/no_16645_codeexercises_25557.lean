import Mathlib

namespace no_16645_codeexercises_25557


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def find_shortest_travel_time_precond (planets : Array (Float × Float)) (speed : Float) : Prop :=
  -- !benchmark @start precond
  speed > 0 ∧ planets.size ≥ 2
  -- !benchmark @end precond


-- Postcondition auxiliary definitions
def distance (p1 p2 : Float × Float) : Float :=
  Float.sqrt (((p2.1 - p1.1) ^ 2) + ((p2.2 - p1.2) ^ 2))

def travel_time (p1 p2 : Float × Float) (speed : Float) : Float :=
  distance p1 p2 / speed

-- Code auxiliary definitions
def pairwise_distances (planets : Array (Float × Float)) (speed : Float) : Array Float :=
  let n := planets.size
  Id.run do
    let mut distances : Array Float := #[]
    for i in [:n] do
      for j in [:n] do
        if i ≠ j then
          distances := distances.push (travel_time (planets[i]!) (planets[j]!) speed)
    return distances

def find_min_time (distances : Array Float) : Float :=
  Id.run do
    let mut min_time := Float.inf
    for time in distances do
      if time < min_time then
        min_time := time
    return min_time

-- Main function definitions
def find_shortest_travel_time (planets : Array (Float × Float)) (speed : Float) (h_precond : find_shortest_travel_time_precond (planets) (speed)) : Float :=
  -- !benchmark @start code
  let distances := pairwise_distances planets speed
  find_min_time distances
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def find_shortest_travel_time_postcond (planets : Array (Float × Float)) (speed : Float) (result: Float) (h_precond : find_shortest_travel_time_precond (planets) (speed)) : Prop :=
  -- !benchmark @start postcond
  ∃ (i j : Fin planets.size), i ≠ j ∧
    result = travel_time (planets[i]) (planets[j]) speed ∧
    ∀ (k l : Fin planets.size), k ≠ l → result ≤ travel_time (planets[k]) (planets[l]) speed
  -- !benchmark @end postcond


-- Proof content
theorem find_shortest_travel_time_postcond_satisfied (planets: Array (Float × Float)) (speed: Float) (h_precond : find_shortest_travel_time_precond (planets) (speed)) :
    find_shortest_travel_time_postcond (planets) (speed) (find_shortest_travel_time (planets) (speed) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_16645_codeexercises_25557