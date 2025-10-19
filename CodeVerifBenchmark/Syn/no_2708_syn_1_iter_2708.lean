import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def format_floats_to_strings_precond (nums : List Float) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def formatFloat (x : Float) : String :=
  let rounded := Float.round (x * 100) / 100
  let s := s!"{rounded}"
  let parts := s.splitOn "."
  match parts with
  | [intStr] => s!"{intStr}.00"
  | [intStr, decStr] => 
    let paddedDec := if decStr.length < 2 then decStr ++ String.mk (List.replicate (2 - decStr.length) '0') else decStr
    s!"{intStr}.{paddedDec}"
  | _ => s!"{x}"

-- Main function definitions
def format_floats_to_strings (nums : List Float) (h_precond : format_floats_to_strings_precond (nums)) : List String :=
  -- !benchmark @start code
  nums.map formatFloat
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def formatFloatPost (x : Float) : String :=
  let intPart := Float.floor (x * 100) / 100
  let rounded := Float.round (x * 100) / 100
  let s := if x == rounded then 
      if intPart == x then 
        s!"{intPart}.00"
      else
        s!"{x}"
    else
      s!"{rounded}"
  let parts := s.splitOn "."
  match parts with
  | [intStr] => s!"{intStr}.00"
  | [intStr, decStr] => 
    let paddedDec := decStr ++ String.mk (List.replicate (2 - decStr.length) '0')
    s!"{intStr}.{paddedDec}"
  | _ => s!"{x}"

-- Postcondition definitions
@[reducible, simp]
def format_floats_to_strings_postcond (nums : List Float) (result: List String) (h_precond : format_floats_to_strings_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result = nums.map formatFloatPost
  -- !benchmark @end postcond


-- Proof content
theorem format_floats_to_strings_postcond_satisfied (nums: List Float) (h_precond : format_floats_to_strings_precond (nums)) :
    format_floats_to_strings_postcond (nums) (format_floats_to_strings (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof