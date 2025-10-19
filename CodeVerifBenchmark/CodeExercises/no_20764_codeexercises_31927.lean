import Mathlib.Data.List.Basic
import Mathlib.Data.Prod.Basic

-- Precondition definitions
@[reducible, simp]
def find_sliced_colors_by_room_precond (color_palette : List (String × List (Nat × Nat × Nat × Nat))) (room : String) : Prop :=
  -- !benchmark @start precond
  (∃ entry, entry ∈ color_palette ∧ entry.1 = room) ∧ 
  (∃ entry, entry ∈ color_palette ∧ entry.1 = room ∧ entry.2 ≠ [])
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No additional auxiliary definitions needed

-- Main function definitions
def find_sliced_colors_by_room (color_palette : List (String × List (Nat × Nat × Nat × Nat))) (room : String) (h_precond : find_sliced_colors_by_room_precond color_palette room) : List (Nat × Nat) × List (Nat × Nat) :=
  -- !benchmark @start code
  let colors := (color_palette.find? (λ x => x.1 = room)).get!.2
  let first_half := colors.map (λ color => match color with | (r, g, b, a) => (r, g))
  let last_half := colors.map (λ color => match color with | (r, g, b, a) => (b, a))
  (first_half, last_half)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def split_color_tuple (color : Nat × Nat × Nat × Nat) : (Nat × Nat) × (Nat × Nat) :=
  match color with
  | (r, g, b, a) => ((r, g), (b, a))

-- Postcondition definitions
@[reducible, simp]
def find_sliced_colors_by_room_postcond (color_palette : List (String × List (Nat × Nat × Nat × Nat))) (room : String) (result: List (Nat × Nat) × List (Nat × Nat)) (h_precond : find_sliced_colors_by_room_precond color_palette room) : Prop :=
  -- !benchmark @start postcond
  let colors := (color_palette.find? (λ x => x.1 = room)).get!.2
  let first_half := colors.map (λ color => (split_color_tuple color).1)
  let last_half := colors.map (λ color => (split_color_tuple color).2)
  result = (first_half, last_half)
  -- !benchmark @end postcond


-- Proof content
theorem find_sliced_colors_by_room_postcond_satisfied (color_palette: List (String × List (Nat × Nat × Nat × Nat))) (room: String) (h_precond : find_sliced_colors_by_room_precond color_palette room) :
    find_sliced_colors_by_room_postcond color_palette room (find_sliced_colors_by_room color_palette room h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof