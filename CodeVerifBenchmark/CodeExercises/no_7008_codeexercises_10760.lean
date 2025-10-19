import Mathlib

-- Precondition definitions
@[reducible, simp]
def create_set_precond (photos : List String) (categories : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def create_set (photos : List String) (categories : List String) (h_precond : create_set_precond (photos) (categories)) : Set (String × String) :=
  -- !benchmark @start code
  let photo_set : Set (String × String) := ∅
    let photo_set := photos.foldl (λ set photo => 
      categories.foldl (λ inner_set category => 
        inner_set.insert (photo, category)) set) photo_set
    photo_set
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def all_combinations (photos : List String) (categories : List String) : Set (String × String) :=
  { p | ∃ (photo : String) (category : String), photo ∈ photos ∧ category ∈ categories ∧ p = (photo, category) }

-- Postcondition definitions
@[reducible, simp]
def create_set_postcond (photos : List String) (categories : List String) (result: Set (String × String)) (h_precond : create_set_precond (photos) (categories)) : Prop :=
  -- !benchmark @start postcond
  result = all_combinations photos categories
  -- !benchmark @end postcond


-- Proof content
theorem create_set_postcond_satisfied (photos: List String) (categories: List String) (h_precond : create_set_precond (photos) (categories)) :
    create_set_postcond (photos) (categories) (create_set (photos) (categories) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

