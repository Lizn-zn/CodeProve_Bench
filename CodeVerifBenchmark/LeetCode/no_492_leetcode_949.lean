import Mathlib

-- Precondition auxiliary definitions
def isValidTime (digits : List Nat) : Bool :=
  match digits with
  | [h1, h2, m1, m2] =>
    let hour := h1 * 10 + h2
    let minute := m1 * 10 + m2
    hour < 24 && minute < 60
  | _ => false

def permute (l : List α) : List (List α) :=
  match l with
  | [] => [[]]
  | x :: xs =>
    let perms := permute xs
    perms.flatMap fun p =>
      List.range (p.length + 1) |>.map fun i =>
        List.take i p ++ [x] ++ List.drop i p

-- Precondition definitions
@[reducible, simp]
def latestTimeFromDigits_precond (arr : List Nat) : Prop :=
  -- !benchmark @start precond
  arr.length = 4 ∧ ∀ x ∈ arr, x ≤ 9
  -- !benchmark @end precond

-- Postcondition auxiliary definitions
def timeValue (digits : List Nat) : Nat :=
  match digits with
  | [h1, h2, m1, m2] =>
    let hour := h1 * 10 + h2
    let minute := m1 * 10 + m2
    hour * 60 + minute
  | _ => 0

def formatTime (digits : List Nat) : String :=
  match digits with
  | [h1, h2, m1, m2] =>
    let hour := toString h1 ++ toString h2
    let minute := toString m1 ++ toString m2
    hour ++ ":" ++ minute
  | _ => ""

-- Code auxiliary definitions
def List.findMaxWithIndex (l : List (List Nat)) : Option (List Nat × Nat) :=
  let rec helper (l : List (List Nat)) (index : Nat) : Option (List Nat × Nat) :=
    match l with
    | [] => none
    | x :: xs =>
      match helper xs (index + 1) with
      | none => some (x, index)
      | some (y, yi) =>
        if timeValue x < timeValue y then
          some (y, yi + 1)
        else
          some (x, index)
  helper l 0

def List.findLatestValidTime (arr : List Nat) : Option (List Nat) :=
  let validPermutations := permute arr |>.filter isValidTime
  match validPermutations with
  | [] => none
  | _ =>
    match List.findMaxWithIndex validPermutations with
    | some (digits, _) => some digits
    | none => none

-- Main function definitions
def latestTimeFromDigits (arr : List Nat) (h_precond : latestTimeFromDigits_precond (arr)) : String :=
  -- !benchmark @start code
  match List.findLatestValidTime arr with
    | none => ""
    | some digits => formatTime digits
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def latestTimeFromDigits_postcond (arr : List Nat) (result: String) (h_precond : latestTimeFromDigits_precond (arr)) : Prop :=
  -- !benchmark @start postcond
  let validPermutations := permute arr |>.filter isValidTime
  if validPermutations = [] then
    result = ""
  else
    let maxTimePerm := validPermutations.foldl (fun acc perm => 
      match acc with
      | none => some perm
      | some currentMax => if timeValue perm > timeValue currentMax then some perm else some currentMax
    ) none
    result = match maxTimePerm with
      | some perm => formatTime perm
      | none => ""
  -- !benchmark @end postcond

-- Proof content
theorem latestTimeFromDigits_postcond_satisfied (arr: List Nat) (h_precond : latestTimeFromDigits_precond (arr)) :
    latestTimeFromDigits_postcond (arr) (latestTimeFromDigits (arr) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof