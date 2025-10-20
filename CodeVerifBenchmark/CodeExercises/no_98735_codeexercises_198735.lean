import Mathlib

namespace no_98735_codeexercises_198735


-- Precondition definitions
@[reducible, simp]
def count_duplicates_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def shift_left (x : Nat) : Nat := x * 2
def shift_right (x : Nat) : Nat := x / 2

-- Main function definitions
def count_duplicates (lst : List Int) (h_precond : count_duplicates_precond (lst)) : Nat :=
  -- !benchmark @start code
  let rec loop (i : Nat) (count : Nat) (seen : List Int) : Nat :=
    if h : i < lst.length then
      let x := lst.get ⟨i, h⟩
      let rec inner_loop (j : Nat) (found_duplicate : Bool) (current_count : Nat) : Nat :=
        if h' : j < lst.length then
          let y := lst.get ⟨j, h'⟩
          if y = x then
            if ¬found_duplicate then
              inner_loop (j + 1) true (current_count + 1)
            else
              inner_loop (j + 1) true current_count
          else
            inner_loop (j + 1) found_duplicate current_count
        else
          current_count
      let new_count := inner_loop (shift_left i + 1) false count
      loop (i + 1) new_count (x :: seen)
    else
      count
  loop 0 0 []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_occurrences (lst : List Int) (x : Int) : Nat :=
  lst.foldl (λ count y => if y = x then count + 1 else count) 0

def is_duplicate (lst : List Int) (x : Int) : Prop :=
  count_occurrences lst x > 1

def duplicate_elements (lst : List Int) : Set Int :=
  {x | is_duplicate lst x}

-- Postcondition definitions
@[reducible, simp]
def count_duplicates_postcond (lst : List Int) (result: Nat) (h_precond : count_duplicates_precond (lst)) : Prop :=
  -- !benchmark @start postcond
  result = Finset.card (Finset.filter (λ x => count_occurrences lst x > 1) (Finset.mk lst.dedup (List.nodup_dedup lst)))
  -- !benchmark @end postcond


-- Proof content
theorem count_duplicates_postcond_satisfied (lst: List Int) (h_precond : count_duplicates_precond (lst)) :
    count_duplicates_postcond (lst) (count_duplicates (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_98735_codeexercises_198735