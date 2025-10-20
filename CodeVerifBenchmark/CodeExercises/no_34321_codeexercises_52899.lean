import Mathlib

namespace no_34321_codeexercises_52899


-- Precondition definitions
@[reducible, simp]
def break_loop_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def break_loop (nums : List Nat) (h_precond : break_loop_precond nums) : Unit :=
  -- !benchmark @start code
  let rec loop (i : Nat) : Unit :=
    if h : i < nums.length then
      if 7 ∣ nums.get ⟨i, h⟩ then
        ()
      else
        loop (i + 1)
    else
      ()
  loop 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def break_loop_postcond (nums : List Nat) (result: Unit) (h_precond : break_loop_precond nums) : Prop :=
  -- !benchmark @start postcond
  ∃ (i : Nat) (h : i < nums.length), 
    7 ∣ nums.get ⟨i, h⟩ ∧ 
    ∀ (j : Nat) (hj : j < i), 
      if h' : j < nums.length then ¬7 ∣ nums.get ⟨j, h'⟩ else True
  -- !benchmark @end postcond


-- Proof content
theorem break_loop_correct (nums : List Nat) (h_precond : break_loop_precond nums) : 
    break_loop_postcond nums (break_loop nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_34321_codeexercises_52899