import Mathlib

-- Precondition definitions
@[reducible, simp]
def generate_outfit_combinations_precond (items : List (List String)) : Prop :=
  -- !benchmark @start precond
  ∀ category ∈ items, category ≠ []
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def generate_outfit_combinations (items : List (List String)) (h_precond : generate_outfit_combinations_precond (items)) : List (List String) :=
  -- !benchmark @start code
  match items with
  | [] => [[]]
  | xs :: xss => 
    let rec_combinations := generate_outfit_combinations xss (by
      intro category h_category
      apply h_precond category
      exact List.mem_cons_of_mem xs h_category)
    xs.flatMap (λ x => rec_combinations.map (λ ys => x :: ys))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def cartesianProduct (lists : List (List String)) : List (List String) :=
  match lists with
  | [] => [[]]
  | xs :: xss => xs.flatMap (λ x => (cartesianProduct xss).map (λ ys => x :: ys))

-- Postcondition definitions
@[reducible, simp]
def generate_outfit_combinations_postcond (items : List (List String)) (result: List (List String)) (h_precond : generate_outfit_combinations_precond (items)) : Prop :=
  -- !benchmark @start postcond
  result = cartesianProduct items
  -- !benchmark @end postcond


-- Proof content
theorem generate_outfit_combinations_postcond_satisfied (items: List (List String)) (h_precond : generate_outfit_combinations_precond (items)) :
    generate_outfit_combinations_postcond (items) (generate_outfit_combinations (items) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof