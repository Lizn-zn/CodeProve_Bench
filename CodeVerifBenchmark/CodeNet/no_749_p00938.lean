import Mathlib

namespace no_749_p00938


-- Precondition auxiliary definitions
-- Helper function to check if a direction character is valid
def isValidDirection (f : Char) : Prop :=
  f = 'N' ∨ f = 'E' ∨ f = 'W' ∨ f = 'S'

-- Precondition definitions
@[reducible, simp]
def minClocks_precond (n : Nat) (w : Nat) (d : Nat) (members : List (Nat × Nat × Char)) : Prop :=
  -- !benchmark @start precond
  -- The number of members matches the list length
    members.length = n ∧
    -- Room dimensions are valid
    w ≥ 2 ∧ d ≥ 2 ∧
    -- At least one member
    n ≥ 1 ∧
    -- All members have valid positions and directions
    (∀ (member : Nat × Nat × Char), member ∈ members →
      let (x, y, f) := member
      -- Position is strictly within the room boundaries
      1 ≤ x ∧ x ≤ w - 1 ∧
      1 ≤ y ∧ y ≤ d - 1 ∧
      -- Direction is valid
      isValidDirection f) ∧
    -- All positions are distinct
    (∀ i j, i < members.length → j < members.length → i ≠ j →
      let (x1, y1, _) := members[i]!
      let (x2, y2, _) := members[j]!
      x1 ≠ x2 ∨ y1 ≠ y2)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to calculate wall coordinate
def calcWallCoordImpl (w d : Nat) (x0 y0 : Int) (dx dy : Int) : Int :=
  let s := min (if dx ≥ 0 then (w : Int) - x0 else x0) (if dy ≥ 0 then (d : Int) - y0 else y0)
  let x := x0 + dx * s
  let y := y0 + dy * s
  if y = 0 then x
  else if x = (w : Int) then (w : Int) + y
  else if y = (d : Int) then 2 * (w : Int) + (d : Int) - x
  else 2 * (w : Int) + 2 * (d : Int) - y

-- Helper to compute the field of view interval for a member
def getViewIntervalImpl (w d : Nat) (x y : Nat) (f : Char) : Int × Int :=
  let x0 := (x : Int)
  let y0 := (y : Int)
  let (t1, t2) := 
    if f = 'N' then 
      let t1 := calcWallCoordImpl w d x0 y0 1 1
      let t2 := calcWallCoordImpl w d x0 y0 (-1) 1
      (t1, t2)
    else if f = 'E' then
      let t1 := calcWallCoordImpl w d x0 y0 1 (-1)
      let t2 := calcWallCoordImpl w d x0 y0 1 1
      (t1, t2)
    else if f = 'S' then
      let t1 := calcWallCoordImpl w d x0 y0 (-1) (-1)
      let t2 := calcWallCoordImpl w d x0 y0 1 (-1)
      (t1, t2)
    else  -- W
      let t1 := calcWallCoordImpl w d x0 y0 (-1) 1
      let t2 := calcWallCoordImpl w d x0 y0 (-1) (-1)
      (t1, t2)
  if t1 ≥ t2 then (t1 - 2 * ((w : Int) + (d : Int)), t2) else (t1, t2)

-- Convert members to intervals sorted by right endpoint
def membersToIntervals (w d : Nat) (members : List (Nat × Nat × Char)) : List (Int × Int) :=
  let intervals := members.map (fun member =>
    let (x, y, f) := member
    getViewIntervalImpl w d x y f)
  intervals.insertionSort (fun a b => a.2 < b.2)

-- Greedy algorithm to find minimum clocks starting from a given member index
def findMinClocksFrom (intervals : List (Int × Int)) (perimeter : Int) (startIdx : Nat) : Nat :=
  let rec loop (idx : Nat) (count : Nat) (curEnd : Int) (fuel : Nat) : Nat :=
    if fuel = 0 then count  -- Safety check
    else if idx ≥ intervals.length then count
    else
      let i := (startIdx + idx) % intervals.length
      let (a, b) := intervals[i]!
      let base := (idx / intervals.length) * perimeter
      let aAdj := a + base
      let bAdj := b + base
      if aAdj ≤ curEnd then
        loop (idx + 1) count curEnd (fuel - 1)
      else
        loop (idx + 1) (count + 1) bAdj (fuel - 1)
  loop 0 0 (-(1000000000 : Int)) (intervals.length * 2 + 10)

-- Main function definitions
def minClocks (n : Nat) (w : Nat) (d : Nat) (members : List (Nat × Nat × Char)) (h_precond : minClocks_precond (n) (w) (d) (members)) : Nat :=
  -- !benchmark @start code
  -- Convert members to sorted intervals
    let intervals := membersToIntervals w d members
    let perimeter := 2 * ((w : Int) + (d : Int))
    
    -- Try starting from each member and find the minimum
    let rec tryAllStarts (idx : Nat) (minSoFar : Nat) (fuel : Nat) : Nat :=
      if fuel = 0 then minSoFar
      else if idx ≥ n then minSoFar
      else
        let clocksNeeded := findMinClocksFrom intervals perimeter idx
        let newMin := min clocksNeeded minSoFar
        tryAllStarts (idx + 1) newMin (fuel - 1)
    
    tryAllStarts 0 n (n + 1)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper to compute the wall coordinate for a given position and direction vector
def calcWallCoord (w d : Nat) (x0 y0 : Int) (dx dy : Int) : Int :=
  -- Calculate the distance to the wall in the given direction
  let s := min (if dx ≥ 0 then w - x0 else x0) (if dy ≥ 0 then d - y0 else y0)
  let x := x0 + dx * s
  let y := y0 + dy * s
  -- Map the wall position to a coordinate on the perimeter
  if y = 0 then x
  else if x = w then w + y
  else if y = d then 2 * w + d - x
  else 2 * w + 2 * d - y

-- Helper to compute the field of view interval for a member
def getViewInterval (w d : Nat) (x y : Nat) (f : Char) : Int × Int :=
  let x0 := (x : Int)
  let y0 := (y : Int)
  let (dx1, dy1, dx2, dy2) := 
    if f = 'N' then (1, 1, -1, 1)
    else if f = 'E' then (1, -1, 1, 1)
    else if f = 'S' then (-1, -1, 1, -1)
    else (-1, 1, -1, -1)  -- W
  let t1 := calcWallCoord w d x0 y0 dx1 dy1
  let t2 := calcWallCoord w d x0 y0 dx2 dy2
  if t1 ≥ t2 then (t1 - 2 * (w + d), t2) else (t1, t2)

-- A valid clock placement covers a member if it's in their view interval
def coversInterval (perimeter : Int) (clockPos : Int) (interval : Int × Int) : Prop :=
  let (t1, t2) := interval
  -- Handle the circular nature of the perimeter
  (t1 ≤ clockPos ∧ clockPos ≤ t2) ∨
  (t1 ≤ clockPos + perimeter ∧ clockPos + perimeter ≤ t2) ∨
  (t1 ≤ clockPos - perimeter ∧ clockPos - perimeter ≤ t2)

-- Check if a set of clock positions covers all members
def coversAllMembers (w d : Nat) (members : List (Nat × Nat × Char)) (clocks : List Int) : Prop :=
  let perimeter := 2 * (w + d)
  ∀ (member : Nat × Nat × Char), member ∈ members →
    let (x, y, f) := member
    let interval := getViewInterval w d x y f
    ∃ (clock : Int), clock ∈ clocks ∧ coversInterval perimeter clock interval

-- Postcondition definitions
@[reducible, simp]
def minClocks_postcond (n : Nat) (w : Nat) (d : Nat) (members : List (Nat × Nat × Char)) (result: Nat) (h_precond : minClocks_precond (n) (w) (d) (members)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the minimum number of clocks needed
    -- There exists a valid placement with 'result' clocks
    (∃ (clocks : List Int), clocks.length = result ∧ 
      coversAllMembers w d members clocks) ∧
    -- No valid placement exists with fewer clocks
    (∀ (clocks : List Int), clocks.length < result → 
      ¬coversAllMembers w d members clocks)
  -- !benchmark @end postcond


-- Proof content
theorem minClocks_postcond_satisfied (n: Nat) (w: Nat) (d: Nat) (members: List (Nat × Nat × Char)) (h_precond : minClocks_precond (n) (w) (d) (members)) :
    minClocks_postcond (n) (w) (d) (members) (minClocks (n) (w) (d) (members) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_749_p00938