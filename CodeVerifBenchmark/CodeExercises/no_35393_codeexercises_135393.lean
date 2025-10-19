import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_common_tags_precond (photos : String) (tags : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No additional auxiliary definitions needed

-- Main function definitions
noncomputable def find_common_tags (photos : String) (tags : String) (h_precond : find_common_tags_precond (photos) (tags)) : List String :=
  -- !benchmark @start code
  let photoSet := (photos.split (λ c => c = ' ')).filter (λ x => ¬x.isEmpty) |>.toFinset
  let tagSet := (tags.split (λ c => c = ' ')).filter (λ x => ¬x.isEmpty) |>.toFinset
  (photoSet ∩ tagSet).toList
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def String.toTagSet (s : String) : Set String :=
  s.split (λ c => c = ' ') |>.filter (λ x => ¬x.isEmpty) |>.toFinset

def commonTags (photos : String) (tags : String) : Set String :=
  String.toTagSet photos ∩ String.toTagSet tags

-- Postcondition definitions
@[reducible, simp]
def find_common_tags_postcond (photos : String) (tags : String) (result: List String) (h_precond : find_common_tags_precond (photos) (tags)) : Prop :=
  -- !benchmark @start postcond
  result.toFinset = commonTags photos tags
  -- !benchmark @end postcond


-- Proof content
theorem find_common_tags_postcond_satisfied (photos: String) (tags: String) (h_precond : find_common_tags_precond (photos) (tags)) :
    find_common_tags_postcond (photos) (tags) (find_common_tags (photos) (tags) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof