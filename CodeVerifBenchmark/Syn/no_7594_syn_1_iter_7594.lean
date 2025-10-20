import Mathlib

namespace no_7594_syn_1_iter_7594


-- Precondition definitions
@[reducible, simp]
def sum_divisible_by_3_or_5_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def divisible_by_3_or_5 (x : Int) : Bool :=
  x % 3 = 0 || x % 5 = 0

def sum_divisible_up_to_n (n : Int) : Int :=
  if n < 0 then 0
  else
    let rec loop (i : Int) (acc : Int) : Int :=
      if i > n then acc
      else
        let new_acc := if divisible_by_3_or_5 i then acc + i else acc
        loop (i + 1) new_acc
    termination_by n - i
    decreasing_by sorry
    loop 1 0

-- Main function definitions
def sum_divisible_by_3_or_5 (n : Int) (h_precond : sum_divisible_by_3_or_5_precond (n)) : Int :=
  -- !benchmark @start code
  if n < 0 then 0
  else
    let rec loop (i : Int) (acc : Int) : Int :=
      if i > n then acc
      else
        let new_acc := if divisible_by_3_or_5 i then acc + i else acc
        loop (i + 1) new_acc
    termination_by n - i
    decreasing_by sorry
    loop 1 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def divisible_by_3_or_5_post (x : Int) : Bool :=
  x % 3 = 0 || x % 5 = 0

def sum_divisible_up_to_n_post (n : Int) : Int :=
  if n < 0 then 0
  else
    let rec loop (i : Int) (acc : Int) : Int :=
      if i > n then acc
      else
        let new_acc := if divisible_by_3_or_5_post i then acc + i else acc
        loop (i + 1) new_acc
    termination_by n - i
    decreasing_by sorry
    loop 1 0

-- Postcondition definitions
@[reducible, simp]
def sum_divisible_by_3_or_5_postcond (n : Int) (result: Int) (h_precond : sum_divisible_by_3_or_5_precond (n)) : Prop :=
  -- !benchmark @start postcond
  result = sum_divisible_up_to_n_post n
  -- !benchmark @end postcond


-- Proof content
theorem sum_divisible_by_3_or_5_postcond_satisfied (n: Int) (h_precond : sum_divisible_by_3_or_5_precond (n)) :
    sum_divisible_by_3_or_5_postcond (n) (sum_divisible_by_3_or_5 (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_7594_syn_1_iter_7594