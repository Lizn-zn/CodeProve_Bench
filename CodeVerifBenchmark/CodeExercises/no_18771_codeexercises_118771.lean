import Mathlib.Data.List.Basic
import Mathlib.Data.String.Basic

namespace no_18771_codeexercises_118771


-- Precondition definitions
@[reducible, simp]
def get_photos_by_tag_precond (photos : List (String × List String)) (tag : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def has_tag_bool (photo : String × List String) (tag : String) : Bool :=
  match photo.2 with
  | tags => tag ∈ tags

-- Main function definitions
def get_photos_by_tag (photos : List (String × List String)) (tag : String) (h_precond : get_photos_by_tag_precond photos tag) : List (String × List String) :=
  -- !benchmark @start code
  photos.filter (λ photo => has_tag_bool photo tag)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def has_tag_prop (photo : String × List String) (tag : String) : Prop :=
  tag ∈ photo.2

-- Postcondition definitions
@[reducible, simp]
def get_photos_by_tag_postcond (photos : List (String × List String)) (tag : String) (result: List (String × List String)) (h_precond : get_photos_by_tag_precond photos tag) : Prop :=
  -- !benchmark @start postcond
  ∀ photo, photo ∈ result ↔ photo ∈ photos ∧ has_tag_prop photo tag
  -- !benchmark @end postcond


-- Proof content
theorem get_photos_by_tag_postcond_satisfied (photos: List (String × List String)) (tag: String) (h_precond : get_photos_by_tag_precond photos tag) :
    get_photos_by_tag_postcond photos tag (get_photos_by_tag photos tag h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_18771_codeexercises_118771