import Mathlib

namespace no_719_p00894


-- Precondition auxiliary definitions
-- Parse a log entry into its components
def parseLogEntry (entry : String) : Option (Nat × Nat × Nat × Bool × Nat) :=
  let parts := entry.split (· == ' ')
  if parts.length != 4 then none
  else
    let date := parts[0]!
    let time := parts[1]!
    let io := parts[2]!
    let pid := parts[3]!
    
    -- Parse date (MM/DD)
    let dateParts := date.split (· == '/')
    if dateParts.length != 2 then none
    else
      let month := dateParts[0]!.toNat?
      let day := dateParts[1]!.toNat?
      
      -- Parse time (HH:MM)
      let timeParts := time.split (· == ':')
      if timeParts.length != 2 then none
      else
        let hour := timeParts[0]!.toNat?
        let minute := timeParts[1]!.toNat?
        
        -- Parse I/O
        let isEntrance := io == "I"
        
        -- Parse person ID
        let personId := pid.toNat?
        
        match month, day, hour, minute, personId with
        | some m, some d, some h, some min, some p =>
          some (m, d, h * 60 + min, isEntrance, p)
        | _, _, _, _, _ => none

-- Precondition definitions
@[reducible, simp]
def findMaxBlessedTime_precond (n : Nat) (logEntries : List String) : Prop :=
  -- !benchmark @start precond
  -- n is even and positive
    n > 0 ∧ n % 2 = 0 ∧
    -- logEntries has exactly n entries
    logEntries.length = n ∧
    -- All entries can be parsed
    (∀ entry ∈ logEntries, parseLogEntry entry ≠ none) ∧
    -- All person IDs are less than 1000
    (∀ entry ∈ logEntries, 
      match parseLogEntry entry with
      | some (_, _, _, _, pid) => pid < 1000
      | none => False) ∧
    -- All times are between 00:01 and 23:59 (in minutes: 1 to 1439)
    (∀ entry ∈ logEntries,
      match parseLogEntry entry with
      | some (_, _, t, _, _) => 1 ≤ t ∧ t ≤ 1439
      | none => False)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Process log entries to compute blessed times for all programmers
def processLogEntries (logEntries : List String) : Array Nat :=
  Id.run do
    let mut existSet : Std.HashSet Nat := Std.HashSet.empty
    let mut entryTime : Array Nat := Array.mkArray 1000 0
    let mut blessedTime : Array Nat := Array.mkArray 1000 0
    
    for entry in logEntries do
      match parseLogEntry entry with
      | some (_, _, t, isEntr, pid) =>
        if isEntr then
          -- Entrance
          entryTime := entryTime.set! pid t
          existSet := existSet.insert pid
        else
          -- Exit
          existSet := existSet.erase pid
          if pid == 0 then
            -- Goddess exits - bless all present programmers
            for presentId in existSet do
              let blessStart := max (entryTime.get! 0) (entryTime.get! presentId)
              let blessDuration := t - blessStart
              blessedTime := blessedTime.set! presentId (blessedTime.get! presentId + blessDuration)
          else
            -- Programmer exits - check if goddess is present
            if existSet.contains 0 then
              let blessStart := max (entryTime.get! 0) (entryTime.get! pid)
              let blessDuration := t - blessStart
              blessedTime := blessedTime.set! pid (blessedTime.get! pid + blessDuration)
      | none => ()
    
    return blessedTime

-- Find maximum value in an array
def arrayMax (arr : Array Nat) : Nat :=
  arr.foldl max 0

-- Main function definitions
def findMaxBlessedTime (n : Nat) (logEntries : List String) (h_precond : findMaxBlessedTime_precond (n) (logEntries)) : Nat :=
  -- !benchmark @start code
  let blessedTimes := processLogEntries logEntries
  arrayMax blessedTimes
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Calculate the time in minutes from parsed entry
def getTimeInMinutes (entry : String) : Nat :=
  match parseLogEntry entry with
  | some (_, _, t, _, _) => t
  | none => 0

-- Get person ID from entry
def getPersonId (entry : String) : Nat :=
  match parseLogEntry entry with
  | some (_, _, _, _, pid) => pid
  | none => 0

-- Check if entry is entrance
def isEntrance (entry : String) : Bool :=
  match parseLogEntry entry with
  | some (_, _, _, isEntr, _) => isEntr
  | none => false

-- Compute blessed time for a specific programmer
def computeBlessedTime (logEntries : List String) (programmerId : Nat) : Nat :=
  -- This is a specification helper that computes the total blessed time
  -- for a given programmer based on the log entries
  -- The actual implementation would track entrance/exit times and goddess presence
  sorry

-- Check if a person ID appears in the log (excluding goddess ID 000)
def isProgrammerInLog (logEntries : List String) (pid : Nat) : Bool :=
  pid ≠ 0 ∧ logEntries.any (fun entry => getPersonId entry == pid)

-- Postcondition definitions
@[reducible, simp]
def findMaxBlessedTime_postcond (n : Nat) (logEntries : List String) (result: Nat) (h_precond : findMaxBlessedTime_precond (n) (logEntries)) : Prop :=
  -- !benchmark @start postcond
  -- result is the maximum blessed time among all programmers
    (∃ programmerId : Nat, 
      programmerId ≠ 0 ∧
      isProgrammerInLog logEntries programmerId ∧
      result = computeBlessedTime logEntries programmerId ∧
      (∀ otherId : Nat, 
        otherId ≠ 0 → 
        isProgrammerInLog logEntries otherId →
        computeBlessedTime logEntries otherId ≤ result))
  -- !benchmark @end postcond


-- Proof content
theorem findMaxBlessedTime_postcond_satisfied (n: Nat) (logEntries: List String) (h_precond : findMaxBlessedTime_precond (n) (logEntries)) :
    findMaxBlessedTime_postcond (n) (logEntries) (findMaxBlessedTime (n) (logEntries) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_719_p00894