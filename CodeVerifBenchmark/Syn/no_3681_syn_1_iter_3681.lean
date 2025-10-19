import Mathlib

-- Precondition definitions
@[reducible, simp]
def count_positive_less_than_256_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def count_positive_less_than_256 (nums : List Int) (h_precond : count_positive_less_than_256_precond (nums)) : UInt8 :=
  -- !benchmark @start code
  let filtered := nums.filter (λ x => x > 0 ∧ x < 256)
    let count := filtered.length
    if count > 255 then
      (255 : UInt8)
    else
      count.toUInt8
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_positive_less_than_256_post_aux (nums : List Int) : Nat :=
  let filtered := nums.filter (λ x => x > 0 ∧ x < 256)
  min filtered.length 255

-- Postcondition definitions
@[reducible, simp]
def count_positive_less_than_256_postcond (nums : List Int) (result: UInt8) (h_precond : count_positive_less_than_256_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result = (count_positive_less_than_256_post_aux nums).toUInt8
  -- !benchmark @end postcond


-- Proof content
theorem count_positive_less_than_256_postcond_satisfied (nums: List Int) (h_precond : count_positive_less_than_256_precond (nums)) :
    count_positive_less_than_256_postcond (nums) (count_positive_less_than_256 (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof