import Mathlib

namespace no_63963_codeexercises_163963


-- Precondition definitions
@[reducible, simp]
def get_actor_name_precond (actor : String × Option String × String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def get_actor_name (actor : String × Option String × String) (h_precond : get_actor_name_precond (actor)) : String :=
  -- !benchmark @start code
  let (first, middle, last) := actor
  match middle with
  | none => s!"{first} {last}"
  | some m => s!"{first} {m} {last}"
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def assemble_full_name (first : String) (middle : Option String) (last : String) : String :=
  match middle with
  | none => s!"{first} {last}"
  | some m => s!"{first} {m} {last}"

-- Postcondition definitions
@[reducible, simp]
def get_actor_name_postcond (actor : String × Option String × String) (result: String) (h_precond : get_actor_name_precond (actor)) : Prop :=
  -- !benchmark @start postcond
  result = assemble_full_name actor.1 actor.2.1 actor.2.2
  -- !benchmark @end postcond


-- Proof content
theorem get_actor_name_postcond_satisfied (actor: String × Option String × String) (h_precond : get_actor_name_precond (actor)) :
    get_actor_name_postcond (actor) (get_actor_name (actor) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_63963_codeexercises_163963