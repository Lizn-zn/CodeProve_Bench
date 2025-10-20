import Mathlib

namespace no_45699_codeexercises_145699


-- Precondition definitions
@[reducible, simp]
def delete_photos_precond (photos : List String) (delete_list : List Nat) : Prop :=
  -- !benchmark @start precond
  ∀ i ∈ delete_list, i < photos.length
  -- !benchmark @end precond


-- Code auxiliary definitions
def delete_photos_helper (photos : List String) (delete_list : List Nat) : List String :=
  match photos with
  | [] => []
  | h :: t =>
    if photos.length - 1 ∈ delete_list then
      delete_photos_helper t (delete_list.filter (· ≠ photos.length - 1))
    else
      delete_photos_helper t delete_list ++ [h]

-- Main function definitions
def delete_photos (photos : List String) (delete_list : List Nat) (h_precond : delete_photos_precond (photos) (delete_list)) : List String :=
  -- !benchmark @start code
  match photos with
  | [] => []
  | h :: t =>
    if photos.length - 1 ∈ delete_list then
      delete_photos_helper t (delete_list.filter (· ≠ photos.length - 1))
    else
      delete_photos_helper t delete_list ++ [h]
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def delete_photos_helper_post (photos : List String) (delete_list : List Nat) : List String :=
  match photos with
  | [] => []
  | h :: t =>
    if photos.length - 1 ∈ delete_list then
      delete_photos_helper_post t (delete_list.filter (· ≠ photos.length - 1))
    else
      delete_photos_helper_post t delete_list ++ [h]

-- Postcondition definitions
@[reducible, simp]
def delete_photos_postcond (photos : List String) (delete_list : List Nat) (result: List String) (h_precond : delete_photos_precond (photos) (delete_list)) : Prop :=
  -- !benchmark @start postcond
  result = delete_photos_helper_post photos delete_list
  -- !benchmark @end postcond


-- Proof content
theorem delete_photos_postcond_satisfied (photos: List String) (delete_list: List Nat) (h_precond : delete_photos_precond (photos) (delete_list)) :
    delete_photos_postcond (photos) (delete_list) (delete_photos (photos) (delete_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_45699_codeexercises_145699