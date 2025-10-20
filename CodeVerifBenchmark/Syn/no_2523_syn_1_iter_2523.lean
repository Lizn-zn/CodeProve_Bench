import Mathlib

namespace no_2523_syn_1_iter_2523


-- Precondition definitions
@[reducible, simp]
def analyze_chars_precond (chars : Array Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def analyze_chars (chars : Array Char) (h_precond : analyze_chars_precond (chars)) : Int × Nat :=
  -- !benchmark @start code
  Id.run do
    let mut sum : Int := 0
    let mut count : Nat := 0
    for i in [0:chars.size] do
      let c := chars[i]!
      sum := sum + (c.toNat : Int)
      if 'A' ≤ c ∧ c ≤ 'Z' then
        count := count + 1
    return (sum, count)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def analyze_chars_postcond (chars : Array Char) (result: Int × Nat) (h_precond : analyze_chars_precond (chars)) : Prop :=
  -- !benchmark @start postcond
  let (sum, count) := result
  sum = chars.foldl (λ acc c => acc + (c.toNat : Int)) 0 ∧
  count = chars.foldl (λ acc c => if 'A' ≤ c ∧ c ≤ 'Z' then acc + 1 else acc) 0
  -- !benchmark @end postcond


-- Proof content
theorem analyze_chars_postcond_satisfied (chars: Array Char) (h_precond : analyze_chars_precond (chars)) :
    analyze_chars_postcond (chars) (analyze_chars (chars) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2523_syn_1_iter_2523