import Mathlib

namespace no_98273_codeexercises_198273


-- Precondition definitions
@[reducible, simp]
def prepare_ingredients_precond (recipe : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed for the implementation

-- Main function definitions
def prepare_ingredients (recipe : List String) (h_precond : prepare_ingredients_precond (recipe)) : List String :=
  -- !benchmark @start code
  let allowed_ingredients : List String := []
  recipe.foldl (λ acc ingredient => 
    if ingredient = "sugar" ∨ ingredient = "salt" ∨ ingredient = "flour" then
      acc
    else
      acc ++ [ingredient]
  ) allowed_ingredients
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def forbidden_ingredients : List String := ["sugar", "salt", "flour"]

def is_allowed_ingredient (ingredient : String) : Bool :=
  ¬ (forbidden_ingredients.contains ingredient)

-- Postcondition definitions
@[reducible, simp]
def prepare_ingredients_postcond (recipe : List String) (result: List String) (h_precond : prepare_ingredients_precond (recipe)) : Prop :=
  -- !benchmark @start postcond
  result = recipe.filter is_allowed_ingredient
  -- !benchmark @end postcond


-- Proof content
theorem prepare_ingredients_postcond_satisfied (recipe: List String) (h_precond : prepare_ingredients_precond (recipe)) :
    prepare_ingredients_postcond (recipe) (prepare_ingredients (recipe) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_98273_codeexercises_198273