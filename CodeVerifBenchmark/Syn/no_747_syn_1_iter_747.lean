import Mathlib

-- Precondition definitions
@[reducible, simp]
def process_mixed_array_precond (arr : Array (Sum Int (Sum UInt8 Nat))) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No additional auxiliary definitions needed beyond what's already provided in the template

-- Main function definitions
def process_mixed_array (arr : Array (Sum Int (Sum UInt8 Nat))) (h_precond : process_mixed_array_precond arr) : Prod (Array Char) (List (Char × Nat)) :=
  -- !benchmark @start code
  let uint8s := arr.filterMap (λ x => match x with
    | .inr (.inl u) => some (Char.ofNat u.toNat)
    | _ => none)
  let ints := arr.foldl (λ acc x => match x with
    | .inl i => i :: acc
    | _ => acc) [] |>.reverse
  let nats := arr.foldl (λ acc x => match x with
    | .inr (.inr n) => n :: acc
    | _ => acc) [] |>.reverse
  let rec pairRemaining : List Int → List Nat → List (Char × Nat) := λ is ns =>
    match is, ns with
    | i''::is'', n''::ns'' => (Char.ofNat (Int.natAbs i'' % 256), n'') :: pairRemaining is'' ns''
    | _, _ => []
  let pairs := match ints, nats with
    | [], _ => []
    | _, [] => []
    | i::is, n::ns => (Char.ofNat (Int.natAbs i % 256), n) :: 
        (match is, ns with
         | i'::is', n'::ns' => (Char.ofNat (Int.natAbs i' % 256), n') :: pairRemaining is' ns'
         | _, _ => [])
  (uint8s, pairs)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def extractUInt8s (arr : Array (Sum Int (Sum UInt8 Nat))) : Array UInt8 :=
  arr.filterMap (λ x => match x with
    | Sum.inr (Sum.inl u) => some u
    | _ => none)

def extractInts (arr : Array (Sum Int (Sum UInt8 Nat))) : List Int :=
  arr.foldl (λ acc x => match x with
    | Sum.inl i => i :: acc
    | _ => acc) [] |>.reverse

def extractNats (arr : Array (Sum Int (Sum UInt8 Nat))) : List Nat :=
  arr.foldl (λ acc x => match x with
    | Sum.inr (Sum.inr n) => n :: acc
    | _ => acc) [] |>.reverse

def pairLists (ints : List Int) (nats : List Nat) : List (Char × Nat) :=
  match ints, nats with
  | i::is, n::ns => (Char.ofNat (Int.natAbs i % 256), n) :: pairLists is ns
  | _, _ => []

-- Postcondition definitions
@[reducible, simp]
def process_mixed_array_postcond (arr : Array (Sum Int (Sum UInt8 Nat))) (result: Prod (Array Char) (List (Char × Nat))) (h_precond : process_mixed_array_precond arr) : Prop :=
  -- !benchmark @start postcond
  let chars := (extractUInt8s arr).map (λ u => Char.ofNat u.toNat)
  let pairs := pairLists (extractInts arr) (extractNats arr)
  result = (chars, pairs)
  -- !benchmark @end postcond


-- Proof content
theorem process_mixed_array_postcond_satisfied (arr: Array (Sum Int (Sum UInt8 Nat))) (h_precond : process_mixed_array_precond arr) :
    process_mixed_array_postcond arr (process_mixed_array arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof