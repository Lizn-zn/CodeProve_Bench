import Mathlib

namespace no_26798_codeexercises_126798


-- Precondition definitions
@[reducible, simp]
def chop_ingredient_precond (ingredient : String) (chopping_time : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed for this implementation

-- Main function definitions
def chop_ingredient (ingredient : String) (chopping_time : Nat) (h_precond : chop_ingredient_precond (ingredient) (chopping_time)) : String :=
  -- !benchmark @start code
  if chopping_time > 10 then
    "Chopping time exceeded for " ++ ingredient
  else
    "Successfully chopped " ++ ingredient
  -- !benchmark @end code


-- Postcondition auxiliary definitions
inductive ChopResult : Type where
  | success : ChopResult
  | exceeded_time : ChopResult

def chop_outcome_message (result : ChopResult) (ingredient : String) : String :=
  match result with
  | .success => s!"Successfully chopped {ingredient}"
  | .exceeded_time => s!"Chopping time exceeded for {ingredient}"

-- Postcondition definitions
@[reducible, simp]
def chop_ingredient_postcond (ingredient : String) (chopping_time : Nat) (result: String) (h_precond : chop_ingredient_precond (ingredient) (chopping_time)) : Prop :=
  -- !benchmark @start postcond
  let result_type : ChopResult := 
    if chopping_time > 10 then
      .exceeded_time
    else
      .success
  result = chop_outcome_message result_type ingredient
  -- !benchmark @end postcond


-- Proof content
theorem chop_ingredient_postcond_satisfied (ingredient: String) (chopping_time: Nat) (h_precond : chop_ingredient_precond (ingredient) (chopping_time)) :
    chop_ingredient_postcond (ingredient) (chopping_time) (chop_ingredient (ingredient) (chopping_time) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_26798_codeexercises_126798