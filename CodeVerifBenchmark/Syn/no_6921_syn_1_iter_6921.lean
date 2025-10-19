import Mathlib

-- Precondition definitions
@[reducible, simp]
def compute_min_max_char_precond (nums : Finset ℕ) (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def getFirstChar (s : String) : Char :=
  match s.data with
  | [] => ' '
  | c :: _ => c

-- Main function definitions
def compute_min_max_char (nums : Finset ℕ) (s : String) (h_precond : compute_min_max_char_precond (nums) (s)) : ℕ × ℕ × Char :=
  -- !benchmark @start code
  if h : nums.Nonempty then
    let min_val := nums.min' h
    let max_val := nums.max' h
    (min_val, max_val, getFirstChar s)
  else
    (0, 0, getFirstChar s)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def defaultChar : Char := ' '

def getMinMax (nums : Finset ℕ) : ℕ × ℕ :=
  if h : nums.Nonempty then 
    (nums.min' h, nums.max' h)
  else (0, 0)

-- Postcondition definitions
@[reducible, simp]
def compute_min_max_char_postcond (nums : Finset ℕ) (s : String) (result: ℕ × ℕ × Char) (h_precond : compute_min_max_char_precond (nums) (s)) : Prop :=
  -- !benchmark @start postcond
  let (min_val, max_val) := getMinMax nums
  let char_val := getFirstChar s
  result = (min_val, max_val, char_val)
  -- !benchmark @end postcond


-- Proof content
theorem compute_min_max_char_postcond_satisfied (nums: Finset ℕ) (s: String) (h_precond : compute_min_max_char_precond (nums) (s)) :
    compute_min_max_char_postcond (nums) (s) (compute_min_max_char (nums) (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof