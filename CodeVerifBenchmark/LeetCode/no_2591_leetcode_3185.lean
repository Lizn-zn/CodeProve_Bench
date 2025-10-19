import Mathlib

-- Precondition auxiliary definitions
def completeDayPair (h1 h2 : Nat) : Prop :=
  (h1 + h2) % 24 = 0

-- Precondition definitions
@[reducible, simp]
def countCompleteDayPairs_precond (hours : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- A map from remainders mod 24 to their frequency -/
def RemainderFreq := Nat → Nat

def RemainderFreq.empty : RemainderFreq := fun _ => 0

def RemainderFreq.get (freq : RemainderFreq) (k : Nat) : Nat := freq k

def RemainderFreq.insert (freq : RemainderFreq) (k : Nat) (v : Nat) : RemainderFreq :=
  fun i => if i = k then v else freq i

def List.foldlFreq (as : List Nat) : RemainderFreq :=
  as.foldl (fun (acc : RemainderFreq) (h : Nat) =>
    let modVal := h % 24
    let currentCount := acc.get modVal
    acc.insert modVal (currentCount + 1)
  ) RemainderFreq.empty

def countSamePairs (freq : RemainderFreq) : Nat :=
  -- For values that pair with themselves: 0 and 12
  let count0 := freq.get 0
  let count12 := freq.get 12
  (count0 * (count0 - 1)) / 2 + (count12 * (count12 - 1)) / 2

def countDiffPairs (freq : RemainderFreq) : Nat :=
  -- For values that pair with their complement (k + complement = 24)
  -- Only count each pair once by ensuring k < complement
  let rec loop (k : Nat) (acc : Nat) : Nat :=
    if k ≥ 24 then
      acc
    else
      let complement := (24 - k) % 24
      if k < complement then
        let fk := freq.get k
        let fc := freq.get complement
        loop (k + 1) (acc + fk * fc)
      else
        loop (k + 1) acc
  loop 0 0

-- Main function definitions
def countCompleteDayPairs (hours : List Nat) (h_precond : countCompleteDayPairs_precond (hours)) : Nat :=
  -- !benchmark @start code
  let freq := hours.foldlFreq
  let same := countSamePairs freq
  let diff := countDiffPairs freq
  same + diff
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def countCompleteDayPairs_spec (hours : List Nat) : Nat :=
  let mods := hours.map (· % 24)
  let freq := mods.foldl (fun acc h => RemainderFreq.insert acc h (RemainderFreq.get acc h + 1)) RemainderFreq.empty
  let countSame := 
    (RemainderFreq.get freq 0 * (RemainderFreq.get freq 0 - 1)) / 2 +
    (RemainderFreq.get freq 12 * (RemainderFreq.get freq 12 - 1)) / 2
  let countDiff := 
    let rec loop (k : Nat) (acc : Nat) : Nat :=
      if k ≥ 24 then
        acc
      else
        let complement := (24 - k) % 24
        if k < complement then
          let fk := RemainderFreq.get freq k
          let fc := RemainderFreq.get freq complement
          loop (k + 1) (acc + fk * fc)
        else
          loop (k + 1) acc
    loop 0 0
  countSame + countDiff

-- Postcondition definitions
@[reducible, simp]
def countCompleteDayPairs_postcond (hours : List Nat) (result: Nat) (h_precond : countCompleteDayPairs_precond (hours)) : Prop :=
  -- !benchmark @start postcond
  result = countCompleteDayPairs_spec hours
  -- !benchmark @end postcond


-- Proof content
theorem countCompleteDayPairs_postcond_satisfied (hours: List Nat) (h_precond : countCompleteDayPairs_precond (hours)) :
    countCompleteDayPairs_postcond (hours) (countCompleteDayPairs (hours) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof