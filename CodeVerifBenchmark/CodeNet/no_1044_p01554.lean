import Mathlib

namespace no_1044_p01554


-- Precondition definitions
@[reducible, simp]
def processCardSystem_precond (registeredIds : List String) (cardScans : List String) : Prop :=
  -- !benchmark @start precond
  -- All registered IDs are non-empty strings of at most 10 lowercase letters
  registeredIds.all (fun id => id.length > 0 ∧ id.length ≤ 10 ∧ id.all (fun c => c.isLower)) ∧
  -- All registered IDs are unique
  registeredIds.Nodup ∧
  -- All card scans are non-empty strings of at most 10 lowercase letters
  cardScans.all (fun id => id.length > 0 ∧ id.length ≤ 10 ∧ id.all (fun c => c.isLower))
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Postcondition auxiliary definitions
-- Helper function to process a single card scan
-- Takes the current lock state (true = locked, false = unlocked), registered IDs, and scanned ID
-- Returns the new lock state and the output message
def processOneScan (isLocked : Bool) (registeredIds : List String) (scannedId : String) : Bool × String :=
  if registeredIds.contains scannedId then
    if isLocked then
      (false, "Opened by " ++ scannedId)
    else
      (true, "Closed by " ++ scannedId)
  else
    (isLocked, "Unknown " ++ scannedId)

-- Helper function to process all card scans
-- Returns the list of output messages
def processAllScans (registeredIds : List String) (cardScans : List String) : List String :=
  let rec aux (scans : List String) (isLocked : Bool) (acc : List String) : List String :=
    match scans with
    | [] => acc.reverse
    | scan :: rest =>
      let (newLocked, msg) := processOneScan isLocked registeredIds scan
      aux rest newLocked (msg :: acc)
  aux cardScans true []

-- Main function definitions
def processCardSystem (registeredIds : List String) (cardScans : List String) (h_precond : processCardSystem_precond (registeredIds) (cardScans)) : List String :=
  -- !benchmark @start code
  let rec aux (scans : List String) (isLocked : Bool) (acc : List String) : List String :=
      match scans with
      | [] => acc.reverse
      | scan :: rest =>
        let (newLocked, msg) := processOneScan isLocked registeredIds scan
        aux rest newLocked (msg :: acc)
    aux cardScans true []
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def processCardSystem_postcond (registeredIds : List String) (cardScans : List String) (result: List String) (h_precond : processCardSystem_precond (registeredIds) (cardScans)) : Prop :=
  -- !benchmark @start postcond
  -- The result matches the expected output from processing all card scans
  result = processAllScans registeredIds cardScans ∧
  -- The length of result matches the number of card scans
  result.length = cardScans.length
  -- !benchmark @end postcond


-- Proof content
theorem processCardSystem_postcond_satisfied (registeredIds: List String) (cardScans: List String) (h_precond : processCardSystem_precond (registeredIds) (cardScans)) :
    processCardSystem_postcond (registeredIds) (cardScans) (processCardSystem (registeredIds) (cardScans) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1044_p01554