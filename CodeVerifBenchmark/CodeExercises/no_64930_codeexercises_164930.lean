import Mathlib

-- Precondition definitions
@[reducible, simp]
def compare_economists_precond (economist_1 : String × Nat × Nat) (economist_2 : String × Nat × Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def compare_economists (economist_1 : String × Nat × Nat) (economist_2 : String × Nat × Nat) (h_precond : compare_economists_precond (economist_1) (economist_2)) : String :=
  -- !benchmark @start code
  let seniority1 := economist_1.2.1
  let seniority2 := economist_2.2.1
  let pubs1 := economist_1.2.2
  let pubs2 := economist_2.2.2
  let name1 := economist_1.1
  let name2 := economist_2.1
  if seniority1 > seniority2 ∧ pubs1 > pubs2 then
    s!"{name1} has more seniority and more publications than {name2}"
  else if seniority1 > seniority2 ∧ pubs1 < pubs2 then
    s!"{name1} has more seniority but fewer publications than {name2}"
  else if seniority1 < seniority2 ∧ pubs1 > pubs2 then
    s!"{name1} has less seniority but more publications than {name2}"
  else if seniority1 < seniority2 ∧ pubs1 < pubs2 then
    s!"{name1} has less seniority and fewer publications than {name2}"
  else if seniority1 > seniority2 ∧ pubs1 = pubs2 then
    s!"{name1} has more seniority and the same number of publications as {name2}"
  else if seniority1 < seniority2 ∧ pubs1 = pubs2 then
    s!"{name1} has less seniority and the same number of publications as {name2}"
  else if seniority1 = seniority2 ∧ pubs1 > pubs2 then
    s!"{name1} has the same seniority but more publications than {name2}"
  else if seniority1 = seniority2 ∧ pubs1 < pubs2 then
    s!"{name1} has the same seniority but fewer publications than {name2}"
  else
    s!"{name1} and {name2} have the same seniority and number of publications"
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def get_seniority (economist : String × Nat × Nat) : Nat :=
  economist.2.1

def get_publications (economist : String × Nat × Nat) : Nat :=
  economist.2.2

def get_name (economist : String × Nat × Nat) : String :=
  economist.1

-- Postcondition definitions
@[reducible, simp]
def compare_economists_postcond (economist_1 : String × Nat × Nat) (economist_2 : String × Nat × Nat) (result: String) (h_precond : compare_economists_precond (economist_1) (economist_2)) : Prop :=
  -- !benchmark @start postcond
  let seniority1 := get_seniority economist_1
  let seniority2 := get_seniority economist_2
  let pubs1 := get_publications economist_1
  let pubs2 := get_publications economist_2
  let name1 := get_name economist_1
  let name2 := get_name economist_2
  if seniority1 > seniority2 ∧ pubs1 > pubs2 then
    result = s!"{name1} has more seniority and more publications than {name2}"
  else if seniority1 > seniority2 ∧ pubs1 < pubs2 then
    result = s!"{name1} has more seniority but fewer publications than {name2}"
  else if seniority1 < seniority2 ∧ pubs1 > pubs2 then
    result = s!"{name1} has less seniority but more publications than {name2}"
  else if seniority1 < seniority2 ∧ pubs1 < pubs2 then
    result = s!"{name1} has less seniority and fewer publications than {name2}"
  else if seniority1 > seniority2 ∧ pubs1 = pubs2 then
    result = s!"{name1} has more seniority and the same number of publications as {name2}"
  else if seniority1 < seniority2 ∧ pubs1 = pubs2 then
    result = s!"{name1} has less seniority and the same number of publications as {name2}"
  else if seniority1 = seniority2 ∧ pubs1 > pubs2 then
    result = s!"{name1} has the same seniority but more publications than {name2}"
  else if seniority1 = seniority2 ∧ pubs1 < pubs2 then
    result = s!"{name1} has the same seniority but fewer publications than {name2}"
  else
    result = s!"{name1} and {name2} have the same seniority and number of publications"
  -- !benchmark @end postcond


-- Proof content
theorem compare_economists_postcond_satisfied (economist_1: String × Nat × Nat) (economist_2: String × Nat × Nat) (h_precond : compare_economists_precond (economist_1) (economist_2)) :
    compare_economists_postcond (economist_1) (economist_2) (compare_economists (economist_1) (economist_2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof