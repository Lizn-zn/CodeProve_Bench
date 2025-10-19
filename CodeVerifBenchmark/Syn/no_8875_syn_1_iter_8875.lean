import Mathlib

-- Precondition auxiliary definitions
def get_chars (char_nat_pairs : List (Char × Nat)) : List Char :=
  char_nat_pairs.map Prod.fst

def char_list_length (char_nat_pairs : List (Char × Nat)) : Nat :=
  (get_chars char_nat_pairs).length

-- Precondition definitions
@[reducible, simp]
def construct_sum_array_precond (char_nat_pairs : List (Char × Nat)) (xs : List Int) (k : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def get_target_char (chars : List Char) (i : Nat) : Char :=
  if h : chars.length > 0 then
    chars.get! (i % chars.length)
  else
    default

def sum_matching_positions (char_nat_pairs : List (Char × Nat)) (xs : List Int) (target_char : Char) : Int :=
  let min_length := min char_nat_pairs.length xs.length
  let indices := List.range min_length
  indices.foldl (fun sum j => 
    if h : j < char_nat_pairs.length then
      let (c, _) := char_nat_pairs[j]'h
      if c = target_char then
        if h' : j < xs.length then
          sum + xs[j]'h'
        else
          sum
      else
        sum
    else
      sum
  ) 0

-- Main function definitions
def construct_sum_array (char_nat_pairs : List (Char × Nat)) (xs : List Int) (k : Nat) (h_precond : construct_sum_array_precond (char_nat_pairs) (xs) (k)) : Array Int :=
  -- !benchmark @start code
  if k = 0 then
    #[]
  else
    let chars := get_chars char_nat_pairs
    let char_count := chars.length
    if char_count = 0 then
      Array.mkArray k 0
    else
      let result := Array.mkEmpty k
      let result := 
        (List.range k).foldl (fun arr i => 
          let target_char := get_target_char chars i
          let sum := sum_matching_positions char_nat_pairs xs target_char
          arr.push sum
        ) result
      result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def compute_sum_for_index (char_nat_pairs : List (Char × Nat)) (xs : List Int) (i : Nat) : Int :=
  let chars := get_chars char_nat_pairs
  let char_count := chars.length
  if char_count = 0 then
    0
  else
    let target_char := chars.get! (i % char_count)
    let indices_to_sum : List Nat := 
      List.range (min (char_nat_pairs.length) (xs.length)) |>.filter fun j =>
        if h : j < char_nat_pairs.length then
          let (c, _) := char_nat_pairs[j]'h
          c = target_char
        else
          false
    indices_to_sum.foldl (fun sum j => 
      if h : j < xs.length then
        sum + xs[j]'h
      else
        sum
    ) 0

-- Postcondition definitions
@[reducible, simp]
def construct_sum_array_postcond (char_nat_pairs : List (Char × Nat)) (xs : List Int) (k : Nat) (result: Array Int) (h_precond : construct_sum_array_precond (char_nat_pairs) (xs) (k)) : Prop :=
  -- !benchmark @start postcond
  result.size = k ∧
  ∀ (i : Fin result.size), 
    result[i] = compute_sum_for_index char_nat_pairs xs i.val
  -- !benchmark @end postcond


-- Proof content
theorem construct_sum_array_postcond_satisfied (char_nat_pairs: List (Char × Nat)) (xs: List Int) (k: Nat) (h_precond : construct_sum_array_precond (char_nat_pairs) (xs) (k)) :
    construct_sum_array_postcond (char_nat_pairs) (xs) (k) (construct_sum_array (char_nat_pairs) (xs) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof