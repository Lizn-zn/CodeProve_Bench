import Mathlib

namespace no_47705_codeexercises_147705


-- Precondition definitions
@[reducible, simp]
def add_photo_to_album_precond (album : List String) (photo : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to check if a string ends with a specific character
def endsWith (s : String) (c : Char) : Bool :=
  match s.data.getLast? with
  | some lastChar => lastChar == c
  | none => false

-- Helper function to check if a string starts with a specific character
def startsWith (s : String) (c : Char) : Bool :=
  match s.data.get? 0 with
  | some firstChar => firstChar == c
  | none => false

-- Main function definitions
def add_photo_to_album (album : List String) (photo : String) (h_precond : add_photo_to_album_precond (album) (photo)) : List String :=
  -- !benchmark @start code
  if album.length = 3 then
    album
  else if photo ∈ album then
    album
  else if startsWith photo 'A' ∨ startsWith photo 'B' then
    album
  else if endsWith photo '7' ∧ ¬startsWith photo 'C' then
    album
  else
    album ++ [photo]
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def should_add_photo (album : List String) (photo : String) : Bool :=
  album.length ≠ 3 ∧ ¬(photo ∈ album) ∧ 
  ¬(photo.startsWith "A" ∨ photo.startsWith "B") ∧
  ¬(photo.endsWith "7" ∧ ¬photo.startsWith "C")

-- Postcondition definitions
@[reducible, simp]
def add_photo_to_album_postcond (album : List String) (photo : String) (result: List String) (h_precond : add_photo_to_album_precond (album) (photo)) : Prop :=
  -- !benchmark @start postcond
  if should_add_photo album photo then
    result = album ++ [photo]
  else
    result = album
  -- !benchmark @end postcond


-- Proof content
theorem add_photo_to_album_postcond_satisfied (album: List String) (photo: String) (h_precond : add_photo_to_album_precond (album) (photo)) :
    add_photo_to_album_postcond (album) (photo) (add_photo_to_album (album) (photo) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_47705_codeexercises_147705