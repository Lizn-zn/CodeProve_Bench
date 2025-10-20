import Mathlib

namespace no_5016_syn_1_iter_5016


-- Precondition definitions
@[reducible, simp]
def array_to_indexed_pairs_precond (arr : Array Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def array_to_indexed_pairs (arr : Array Nat) (h_precond : array_to_indexed_pairs_precond arr) : List (Nat × Nat) :=
  -- !benchmark @start code
  let rec loop (i : Nat) (acc : List (Nat × Nat)) : List (Nat × Nat) :=
      if h : i < arr.size then
        let idx : Fin arr.size := ⟨i, h⟩
        loop (i + 1) ((i, arr[idx]) :: acc)
      else
        acc.reverse
  loop 0 []
  -- !benchmark @end code


-- Postcondition definitions
def array_to_indexed_pairs_postcond (arr : Array Nat) (result: List (Nat × Nat)) (h_precond : array_to_indexed_pairs_precond arr) : Prop :=
  -- !benchmark @start postcond
  result = List.ofFn fun (i : Fin arr.size) => (i.val, arr[i])
  -- !benchmark @end postcond


-- Proof content
theorem array_to_indexed_pairs_postcond_satisfied (arr: Array Nat) (h_precond : array_to_indexed_pairs_precond arr) :
    array_to_indexed_pairs_postcond arr (array_to_indexed_pairs arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_5016_syn_1_iter_5016