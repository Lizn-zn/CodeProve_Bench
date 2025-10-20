import Mathlib

namespace no_1678_p02608


-- Precondition definitions
@[reducible, simp]
def countTriples_precond (N : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ N ∧ N ≤ 10000
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def countTriples (N : Nat) (h_precond : countTriples_precond (N)) : Array Nat :=
  -- !benchmark @start code
  let bound := Nat.sqrt N + 1
  let d := Id.run do
    let mut d := Array.mkArray (N + 1) 0
    
    for x in [1:bound] do
      for y in [1:bound] do
        for z in [1:bound] do
          let c := x * x + y * y + z * z + x * y + y * z + z * x
          if 1 ≤ c ∧ c ≤ N then
            d := d.set! c (d[c]! + 1)
    
    return d
  
  -- Extract the results for indices 1 to N
  Id.run do
    let mut result := Array.mkArray N 0
    for i in [0:N] do
      result := result.set! i d[i + 1]!
    
    return result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to count triples (x, y, z) satisfying the equation for a given n
def countTriplesForN (n : Nat) : Nat :=
  let bound := Nat.sqrt n + 1
  (List.range bound).foldl (fun acc x =>
    if x < 1 then acc
    else
      (List.range bound).foldl (fun acc' y =>
        if y < 1 then acc'
        else
          (List.range bound).foldl (fun acc'' z =>
            if z < 1 then acc''
            else
              let val := x * x + y * y + z * z + x * y + y * z + z * x
              if val = n then acc'' + 1 else acc''
          ) acc'
      ) acc
  ) 0

-- Postcondition definitions
@[reducible, simp]
def countTriples_postcond (N : Nat) (result: Array Nat) (h_precond : countTriples_precond (N)) : Prop :=
  -- !benchmark @start postcond
  -- The result array has length N
  result.size = N ∧
  -- Each element at index i (0-based) contains f(i+1)
  (∀ i : Nat, i < N → result[i]! = countTriplesForN (i + 1))
  -- !benchmark @end postcond


-- Proof content
theorem countTriples_postcond_satisfied (N: Nat) (h_precond : countTriples_precond (N)) :
    countTriples_postcond (N) (countTriples (N) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1678_p02608