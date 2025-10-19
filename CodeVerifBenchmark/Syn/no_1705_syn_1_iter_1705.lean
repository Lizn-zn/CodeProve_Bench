import Mathlib

-- Precondition definitions
@[reducible, simp]
def repeat_strings_from_indices_precond (strs : List String) (indices : List (Int × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def valid_index (strs : List String) (i : Int) : Bool :=
  let len := strs.length
  (0 ≤ i ∧ i < len) ∨ (-(len : Int) ≤ i ∧ i < 0)

def get_string_at_index (strs : List String) (i : Int) : Option String :=
  if valid_index strs i then
    let abs_i := if i ≥ 0 then i.toNat else (strs.length + i).toNat
    strs.get? abs_i
  else
    none

def process_pair (strs : List String) (pair : Int × Nat) : String :=
  match get_string_at_index strs pair.1 with
  | some s => String.mk (List.flatMap id (List.replicate pair.2 s.toList))
  | none => ""

def expected_result (strs : List String) (indices : List (Int × Nat)) : String :=
  (indices.map (process_pair strs)).foldl (· ++ ·) ""

-- Main function definitions
def repeat_strings_from_indices (strs : List String) (indices : List (Int × Nat)) (h_precond : repeat_strings_from_indices_precond (strs) (indices)) : String :=
  -- !benchmark @start code
  let rec loop (result : String) : List (Int × Nat) → String
    | [] => result
    | (i, n) :: rest =>
      if valid_index strs i then
        let abs_i := if i ≥ 0 then i.toNat else (strs.length + i).toNat
        match strs.get? abs_i with
        | some s => loop (result ++ String.mk (List.flatMap id (List.replicate n s.toList))) rest
        | none => loop result rest  -- This case should not happen due to valid_index check
      else
        loop result rest
  loop "" indices
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def valid_index_post (strs : List String) (i : Int) : Bool :=
  let len := strs.length
  (0 ≤ i ∧ i < len) ∨ (-(len : Int) ≤ i ∧ i < 0)

def get_string_at_index_post (strs : List String) (i : Int) : Option String :=
  if valid_index_post strs i then
    let abs_i := if i ≥ 0 then i.toNat else (strs.length + i).toNat
    strs.get? abs_i
  else
    none

def process_pair_post (strs : List String) (pair : Int × Nat) : String :=
  match get_string_at_index_post strs pair.1 with
  | some s => String.mk (List.flatMap id (List.replicate pair.2 s.toList))
  | none => ""

def expected_result_post (strs : List String) (indices : List (Int × Nat)) : String :=
  (indices.map (process_pair_post strs)).foldl (· ++ ·) ""

-- Postcondition definitions
@[reducible, simp]
def repeat_strings_from_indices_postcond (strs : List String) (indices : List (Int × Nat)) (result: String) (h_precond : repeat_strings_from_indices_precond (strs) (indices)) : Prop :=
  -- !benchmark @start postcond
  result = expected_result_post strs indices
  -- !benchmark @end postcond


-- Proof content
theorem repeat_strings_from_indices_postcond_satisfied (strs: List String) (indices: List (Int × Nat)) (h_precond : repeat_strings_from_indices_precond (strs) (indices)) :
    repeat_strings_from_indices_postcond (strs) (indices) (repeat_strings_from_indices (strs) (indices) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof