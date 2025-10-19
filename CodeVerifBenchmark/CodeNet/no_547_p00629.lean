import Mathlib

-- Precondition definitions
@[reducible, simp]
def selectTeamsAdvancedToRegional_precond (teams : List (Nat × Nat × Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  -- Teams are well-formed: IDs are unique and in valid range
    teams.length ≤ 300 ∧
    (∀ t ∈ teams, 1 ≤ t.1 ∧ t.1 ≤ 1000 ∧ 1 ≤ t.2.1 ∧ t.2.1 ≤ 1000 ∧ t.2.2.1 ≤ 10 ∧ t.2.2.2 ≤ 100000) ∧
    (∀ i j, i < teams.length → j < teams.length → i ≠ j → teams[i]!.1 ≠ teams[j]!.1)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper to compare teams by ranking rules
def teamRank (t1 t2 : Nat × Nat × Nat × Nat) : Bool :=
  let (id1, _, solved1, penalty1) := t1
  let (id2, _, solved2, penalty2) := t2
  if solved1 > solved2 then true
  else if solved1 < solved2 then false
  else if penalty1 < penalty2 then true
  else if penalty1 > penalty2 then false
  else id1 < id2

-- Get sorted teams by ranking
def sortedTeams (teams : List (Nat × Nat × Nat × Nat)) : List (Nat × Nat × Nat × Nat) :=
  teams.toArray.qsort (fun t1 t2 => teamRank t1 t2) |>.toList

-- Helper function to process teams in order and build the selected list
def selectTeamsHelper (sortedTeams : List (Nat × Nat × Nat × Nat)) (selected : List Nat) (affiCount : Array Nat) : List Nat :=
  match sortedTeams with
  | [] => selected.reverse
  | team :: rest =>
    let (id, u, _, _) := team
    let total := selected.length
    let currentAffiCount := affiCount[u]!
    -- Apply selection rules
    let (shouldAdd, newAffiCount) :=
      if total < 10 && currentAffiCount < 3 then
        (true, affiCount.set! u (currentAffiCount + 1))
      else if total < 20 && currentAffiCount < 2 then
        (true, affiCount.set! u (currentAffiCount + 1))
      else if total < 26 && currentAffiCount < 1 then
        (true, affiCount.set! u (currentAffiCount + 1))
      else
        (false, affiCount)
    if shouldAdd then
      selectTeamsHelper rest (id :: selected) newAffiCount
    else
      selectTeamsHelper rest selected affiCount

-- Main function definitions
def selectTeamsAdvancedToRegional (teams : List (Nat × Nat × Nat × Nat)) (h_precond : selectTeamsAdvancedToRegional_precond (teams)) : List Nat :=
  -- !benchmark @start code
  -- Sort teams by ranking rules
    let sorted := sortedTeams teams
    -- Initialize affiliation count array (size 1001 to handle affiliations 1-1000)
    let affiCount := Array.mkArray 1001 0
    -- Process teams and build selected list
    selectTeamsHelper sorted [] affiCount
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Count teams from affiliation u in the first k selected teams
def countAffiliation (selected : List Nat) (teams : List (Nat × Nat × Nat × Nat)) (u : Nat) (k : Nat) : Nat :=
  (selected.take k).countP (fun id => 
    match teams.find? (fun t => t.1 = id) with
    | some t => t.2.1 = u
    | none => false)

-- Check if team should be selected according to rules
def shouldSelect (teams : List (Nat × Nat × Nat × Nat)) (selected : List Nat) (teamId : Nat) : Bool :=
  let total := selected.length
  match teams.find? (fun t => t.1 = teamId) with
  | none => false
  | some team =>
    let affiCount := countAffiliation selected teams team.2.1 total
    if total < 10 then affiCount < 3
    else if total < 20 then affiCount < 2
    else if total < 26 then affiCount < 1
    else false

-- Postcondition definitions
@[reducible, simp]
def selectTeamsAdvancedToRegional_postcond (teams : List (Nat × Nat × Nat × Nat)) (result: List Nat) (h_precond : selectTeamsAdvancedToRegional_precond (teams)) : Prop :=
  -- !benchmark @start postcond
  -- Result contains only valid team IDs from input
    (∀ id ∈ result, ∃ t ∈ teams, t.1 = id) ∧
    -- No duplicate IDs in result
    result.Nodup ∧
    -- Result length is at most 26
    result.length ≤ 26 ∧
    -- The result follows the selection rules when applied to sorted teams
    (let sorted := sortedTeams teams
     -- Each selected team satisfies the selection rule at the time it was selected
     ∀ i < result.length, 
       let selectedSoFar := result.take i
       shouldSelect teams selectedSoFar result[i]! = true) ∧
    -- All teams that should have been selected are in the result (completeness)
    (let sorted := sortedTeams teams
     ∀ t ∈ sorted, 
       let idx := result.findIdx? (· = t.1)
       match idx with
       | none => ¬shouldSelect teams result t.1  -- If not selected, it shouldn't be
       | some i => 
         -- If selected at position i, it should be selected with teams before it
         let before := result.take i
         shouldSelect teams before t.1 ∧
         -- All teams ranked higher are either selected before or shouldn't be selected
         (∀ t2 ∈ sorted, teamRank t2 t = true → t2.1 ≠ t.1 →
           (∃ j < i, result[j]! = t2.1) ∨ 
           ¬shouldSelect teams (result.take (result.findIdx? (· = t2.1) |>.getD i)) t2.1))
  -- !benchmark @end postcond


-- Proof content
theorem selectTeamsAdvancedToRegional_postcond_satisfied (teams: List (Nat × Nat × Nat × Nat)) (h_precond : selectTeamsAdvancedToRegional_precond (teams)) :
    selectTeamsAdvancedToRegional_postcond (teams) (selectTeamsAdvancedToRegional (teams) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof