import Mathlib

namespace no_2478_p03490


-- Precondition definitions
@[reducible, simp]
def canRobotReachTarget_precond (s : String) (x : Int) (y : Int) : Prop :=
  -- !benchmark @start precond
  s.all (fun c => c = 'F' || c = 'T') ∧ 
    s.length ≥ 1 ∧ s.length ≤ 8000 ∧
    x.natAbs ≤ s.length ∧ y.natAbs ≤ s.length
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to simulate the robot's movement
def simulateRobot (s : String) : List Int × List Int :=
  let rec process (chars : List Char) (dir : Nat) (cnt : Int) (px : List Int) (py : List Int) (first : Bool) : List Int × List Int :=
    match chars with
    | [] => 
      -- Process final segment
      let px' := if dir % 2 = 0 then
        if first then px.map (· + cnt)
        else px.flatMap (fun p => [p + cnt, p - cnt])
      else px
      let py' := if dir % 2 = 1 then
        if first then py.map (· + cnt)
        else py.flatMap (fun p => [p + cnt, p - cnt])
      else py
      (px', py')
    | 'F' :: rest => process rest dir (cnt + 1) px py first
    | 'T' :: rest =>
      -- Process accumulated moves in current direction
      let px' := if dir % 2 = 0 then
        if first then px.map (· + cnt)
        else px.flatMap (fun p => [p + cnt, p - cnt])
      else px
      let py' := if dir % 2 = 1 then
        if first then py.map (· + cnt)
        else py.flatMap (fun p => [p + cnt, p - cnt])
      else py
      process rest (dir + 1) 0 px' py' false
    | _ :: rest => process rest dir cnt px py first
  
  let chars := (s ++ "T").toList
  process chars 0 0 [0] [0] true

-- Main function definitions
def canRobotReachTarget (s : String) (x : Int) (y : Int) (h_precond : canRobotReachTarget_precond (s) (x) (y)) : Bool :=
  -- !benchmark @start code
  let (px, py) := simulateRobot s
    let px_dedup := px.eraseDups
    let py_dedup := py.eraseDups
    px_dedup.contains x && py_dedup.contains y
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Represents a 2D direction as (dx, dy) where each is -1, 0, or 1
inductive Direction
  | right : Direction  -- (1, 0)
  | up : Direction     -- (0, 1)
  | left : Direction   -- (-1, 0)
  | down : Direction   -- (0, -1)

def Direction.toVector : Direction → Int × Int
  | Direction.right => (1, 0)
  | Direction.up => (0, 1)
  | Direction.left => (-1, 0)
  | Direction.down => (0, -1)

def Direction.turnCW : Direction → Direction
  | Direction.right => Direction.down
  | Direction.down => Direction.left
  | Direction.left => Direction.up
  | Direction.up => Direction.right

def Direction.turnCCW : Direction → Direction
  | Direction.right => Direction.up
  | Direction.up => Direction.left
  | Direction.left => Direction.down
  | Direction.down => Direction.right

-- Represents a choice at each 'T' instruction: clockwise or counterclockwise
def TurnChoices := List Bool  -- true = CW, false = CCW

-- Execute the instruction sequence with given turn choices
def executeInstructions (s : String) (choices : TurnChoices) : Option (Int × Int) :=
  let rec go (pos : Int × Int) (dir : Direction) (instrs : List Char) (chs : TurnChoices) : Option (Int × Int) :=
    match instrs with
    | [] => some pos
    | 'F' :: rest =>
      let (dx, dy) := dir.toVector
      go (pos.1 + dx, pos.2 + dy) dir rest chs
    | 'T' :: rest =>
      match chs with
      | [] => none  -- Not enough turn choices
      | turnCW :: restChs =>
        let newDir := if turnCW then dir.turnCW else dir.turnCCW
        go pos newDir rest restChs
    | _ :: rest => none  -- Invalid character (shouldn't happen with precondition)
  go (0, 0) Direction.right s.toList choices

-- Count the number of 'T' instructions in the string
def countTurns (s : String) : Nat :=
  s.toList.filter (· = 'T') |>.length

-- Check if there exists a valid sequence of turn choices that reaches the target
def canReach (s : String) (x : Int) (y : Int) : Prop :=
  ∃ (choices : TurnChoices), 
    choices.length = countTurns s ∧ 
    executeInstructions s choices = some (x, y)

-- Postcondition definitions
@[reducible, simp]
def canRobotReachTarget_postcond (s : String) (x : Int) (y : Int) (result: Bool) (h_precond : canRobotReachTarget_precond (s) (x) (y)) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ canReach s x y
  -- !benchmark @end postcond


-- Proof content
theorem canRobotReachTarget_postcond_satisfied (s: String) (x: Int) (y: Int) (h_precond : canRobotReachTarget_precond (s) (x) (y)) :
    canRobotReachTarget_postcond (s) (x) (y) (canRobotReachTarget (s) (x) (y) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2478_p03490