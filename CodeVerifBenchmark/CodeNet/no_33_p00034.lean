import Mathlib

-- Precondition auxiliary definitions
-- Helper function to compute cumulative distances from start
def cumulativeDistances (sectionLengths : List Nat) : List Nat :=
  sectionLengths.scanl (· + ·) 0

-- Helper function to compute total distance
def totalDistance (sectionLengths : List Nat) : Nat :=
  sectionLengths.foldl (· + ·) 0

-- Precondition definitions
@[reducible, simp]
def findMeetingSection_precond (sectionLengths : List Nat) (speed1 : Nat) (speed2 : Nat) : Prop :=
  -- !benchmark @start precond
  -- The list must have exactly 10 sections
    sectionLengths.length = 10 ∧
    -- All section lengths must be positive (between 1 and 2000)
    (∀ l ∈ sectionLengths, 1 ≤ l ∧ l ≤ 2000) ∧
    -- Both speeds must be positive (between 1 and 2000)
    1 ≤ speed1 ∧ speed1 ≤ 2000 ∧
    1 ≤ speed2 ∧ speed2 ≤ 2000 ∧
    -- The sum of speeds must be positive to avoid division by zero
    speed1 + speed2 > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to parse a line of comma-separated integers
def parseInput (line : String) : Option (List Nat × Nat × Nat) := do
  let parts := line.split (· == ',')
  if parts.length != 12 then none
  else
    let nums ← parts.mapM String.toNat?
    let sectionLengths := nums.take 10
    let speed1 := nums.get! 10
    let speed2 := nums.get! 11
    return (sectionLengths, speed1, speed2)

-- Postcondition auxiliary definitions
-- Helper to get the position where train 1 meets train 2
-- Train 1 starts from position 0, train 2 starts from total distance
-- They meet when: speed1 * t = distance traveled by train 1
-- and: totalDist - speed2 * t = distance from start where train 2 is
-- So: speed1 * t + speed2 * t = totalDist
-- Therefore: t = totalDist / (speed1 + speed2)
-- Meeting position from start: speed1 * totalDist / (speed1 + speed2)
def meetingPosition (sectionLengths : List Nat) (speed1 : Nat) (speed2 : Nat) : Rat :=
  let totalDist := totalDistance sectionLengths
  (speed1 * totalDist : Rat) / (speed1 + speed2)

-- Helper to find meeting section by checking each section
def findMeetingSectionAux (cumDist : List Nat) (meetPos : Rat) (currentSection : Nat) : Nat :=
  if currentSection > 10 then 1  -- fallback, should not happen
  else
    let startPos := (cumDist.get! (currentSection - 1) : Rat)
    let endPos := (cumDist.get! currentSection : Rat)
    if startPos == meetPos then
      currentSection - 1  -- exactly at station, return smaller section number
    else if startPos < meetPos && meetPos < endPos then
      currentSection  -- strictly inside this section
    else if meetPos == endPos && currentSection < 10 then
      currentSection  -- at the end station of this section
    else
      findMeetingSectionAux cumDist meetPos (currentSection + 1)
termination_by (11 - currentSection)
decreasing_by sorry

-- Main function definitions
def findMeetingSection (sectionLengths : List Nat) (speed1 : Nat) (speed2 : Nat) (h_precond : findMeetingSection_precond (sectionLengths) (speed1) (speed2)) : Nat :=
  -- !benchmark @start code
  let cumDist := cumulativeDistances sectionLengths
    let meetPos := meetingPosition sectionLengths speed1 speed2
    findMeetingSectionAux cumDist meetPos 1
  -- !benchmark @end code


-- Check if a rational position falls in section i (1-indexed)
-- Section i spans from cumDist[i-1] to cumDist[i]
def inSection (cumDist : List Nat) (pos : Rat) (sectionIdx : Nat) : Prop :=
  sectionIdx ≥ 1 ∧ sectionIdx ≤ 10 ∧
  let startPos := (cumDist.get! (sectionIdx - 1) : Rat)
  let endPos := (cumDist.get! sectionIdx : Rat)
  startPos < pos ∧ pos < endPos

-- Check if position is exactly at station i (0-indexed in cumDist)
def atStation (cumDist : List Nat) (pos : Rat) (stationIdx : Nat) : Prop :=
  stationIdx < cumDist.length ∧
  (cumDist.get! stationIdx : Rat) = pos

-- Postcondition definitions
@[reducible, simp]
def findMeetingSection_postcond (sectionLengths : List Nat) (speed1 : Nat) (speed2 : Nat) (result: Nat) (h_precond : findMeetingSection_precond (sectionLengths) (speed1) (speed2)) : Prop :=
  -- !benchmark @start postcond
  let cumDist := cumulativeDistances sectionLengths
    let meetPos := meetingPosition sectionLengths speed1 speed2
    -- Result must be between 1 and 10 (valid section number)
    1 ≤ result ∧ result ≤ 10 ∧
    -- The meeting occurs either:
    -- (1) strictly inside section 'result', or
    -- (2) exactly at a station, and 'result' is the smaller adjacent section number
    (inSection cumDist meetPos result ∨
     (∃ stationIdx, atStation cumDist meetPos stationIdx ∧
                    stationIdx = result ∧
                    stationIdx ≥ 1))
  -- !benchmark @end postcond


-- Proof content
theorem findMeetingSection_postcond_satisfied (sectionLengths: List Nat) (speed1: Nat) (speed2: Nat) (h_precond : findMeetingSection_precond (sectionLengths) (speed1) (speed2)) :
    findMeetingSection_postcond (sectionLengths) (speed1) (speed2) (findMeetingSection (sectionLengths) (speed1) (speed2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof