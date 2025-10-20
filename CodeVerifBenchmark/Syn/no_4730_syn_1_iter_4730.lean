import Mathlib

namespace no_4730_syn_1_iter_4730


-- Precondition definitions
@[reducible, simp]
def filter_string_lengths_precond (n : UInt8) (strs : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def filter_string_lengths (n : UInt8) (strs : List String) (h_precond : filter_string_lengths_precond (n) (strs)) : Array Nat :=
  -- !benchmark @start code
  let result : Array Nat := Array.mkEmpty (strs.length)
  strs.foldl (λ acc s => if s.length > n.toNat then acc.push s.length else acc) result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def filter_string_lengths_aux (n : UInt8) (strs : List String) : Array Nat :=
  (strs.filter (λ s => s.length > n.toNat)).map (λ s => s.length) |>.toArray

-- Postcondition definitions
@[reducible, simp]
def filter_string_lengths_postcond (n : UInt8) (strs : List String) (result: Array Nat) (h_precond : filter_string_lengths_precond (n) (strs)) : Prop :=
  -- !benchmark @start postcond
  result = filter_string_lengths_aux n strs
  -- !benchmark @end postcond


-- Proof content
theorem filter_string_lengths_postcond_satisfied (n: UInt8) (strs: List String) (h_precond : filter_string_lengths_precond (n) (strs)) :
    filter_string_lengths_postcond (n) (strs) (filter_string_lengths (n) (strs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_4730_syn_1_iter_4730