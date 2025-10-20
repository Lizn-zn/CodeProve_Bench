import Mathlib

namespace no_176_p00184


-- Precondition definitions
@[reducible, simp]
def countVisitorsByAgeGroup_precond (ages : List Nat) : Prop :=
  -- !benchmark @start precond
  ages.all (fun age => age ≤ 120)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to determine age group index (0-6)
def getAgeGroupIndex (age : Nat) : Nat :=
  if age < 10 then 0
  else if age < 20 then 1
  else if age < 30 then 2
  else if age < 40 then 3
  else if age < 50 then 4
  else if age < 60 then 5
  else 6

-- Main function definitions
def countVisitorsByAgeGroup (ages : List Nat) (h_precond : countVisitorsByAgeGroup_precond (ages)) : Array Nat :=
  -- !benchmark @start code
  -- Initialize array with 7 zeros
  Id.run do
    let mut counts : Array Nat := Array.mkArray 7 0
    -- Process each age
    for age in ages do
      let idx := getAgeGroupIndex age
      counts := counts.set! idx (counts[idx]! + 1)
    return counts
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to count visitors in a specific age range
def countInRange (ages : List Nat) (lower : Nat) (upper : Nat) : Nat :=
  ages.filter (fun age => lower ≤ age ∧ age < upper) |>.length

-- Helper function to count visitors aged 60 and above
def countAtLeast (ages : List Nat) (lower : Nat) : Nat :=
  ages.filter (fun age => lower ≤ age) |>.length

-- Postcondition definitions
@[reducible, simp]
def countVisitorsByAgeGroup_postcond (ages : List Nat) (result: Array Nat) (h_precond : countVisitorsByAgeGroup_precond (ages)) : Prop :=
  -- !benchmark @start postcond
  result.size = 7 ∧
    result[0]! = countInRange ages 0 10 ∧
    result[1]! = countInRange ages 10 20 ∧
    result[2]! = countInRange ages 20 30 ∧
    result[3]! = countInRange ages 30 40 ∧
    result[4]! = countInRange ages 40 50 ∧
    result[5]! = countInRange ages 50 60 ∧
    result[6]! = countAtLeast ages 60
  -- !benchmark @end postcond


-- Proof content
theorem countVisitorsByAgeGroup_postcond_satisfied (ages: List Nat) (h_precond : countVisitorsByAgeGroup_precond (ages)) :
    countVisitorsByAgeGroup_postcond (ages) (countVisitorsByAgeGroup (ages) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_176_p00184