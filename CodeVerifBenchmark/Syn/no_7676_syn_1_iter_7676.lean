import Mathlib

namespace no_7676_syn_1_iter_7676


-- Precondition definitions
@[reducible, simp]
def count_chars_in_range_precond (strings : List String) (n : Nat) (m : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def count_chars_in_range (strings : List String) (n : Nat) (m : Nat) (h_precond : count_chars_in_range_precond (strings) (n) (m)) : Nat :=
  -- !benchmark @start code
  if n > m then 0
  else
    let start := n
    let end_idx := min m (strings.length - 1)
    if start > end_idx then 0
    else
      let sublist := strings.drop start |>.take (end_idx - start + 1)
      sublist.foldl (fun acc s => acc + s.length) 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_chars_in_range_spec (strings : List String) (n : Nat) (m : Nat) : Nat :=
  if n > m then 0
  else
    let valid_indices := List.range (min m (strings.length - 1) + 1) |>.filter (λ i => n ≤ i ∧ i ≤ m)
    valid_indices.foldl (fun acc i => acc + (strings.get? i |>.map String.length |>.getD 0)) 0

-- Postcondition definitions
@[reducible, simp]
def count_chars_in_range_postcond (strings : List String) (n : Nat) (m : Nat) (result: Nat) (h_precond : count_chars_in_range_precond (strings) (n) (m)) : Prop :=
  -- !benchmark @start postcond
  result = count_chars_in_range_spec strings n m
  -- !benchmark @end postcond


-- Proof content
theorem count_chars_in_range_postcond_satisfied (strings: List String) (n: Nat) (m: Nat) (h_precond : count_chars_in_range_precond (strings) (n) (m)) :
    count_chars_in_range_postcond (strings) (n) (m) (count_chars_in_range (strings) (n) (m) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_7676_syn_1_iter_7676