import Mathlib

namespace no_92918_codeexercises_192918


-- Precondition definitions
@[reducible, simp]
def find_note_index_precond (music_notes : List String) (key : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def find_note_index (music_notes : List String) (key : String) (h_precond : find_note_index_precond (music_notes) (key)) : List Nat :=
  -- !benchmark @start code
  let rec aux (notes : List String) (idx : Nat) : List Nat :=
      match notes with
      | [] => []
      | note :: rest =>
        if note = key then
          idx :: aux rest (idx + 1)
        else
          aux rest (idx + 1)
    aux music_notes 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def find_note_index_indices (music_notes : List String) (key : String) : List Nat :=
  (music_notes.enum.filter (λ (i, note) => note = key)).map Prod.fst

-- Postcondition definitions
@[reducible, simp]
def find_note_index_postcond (music_notes : List String) (key : String) (result: List Nat) (h_precond : find_note_index_precond (music_notes) (key)) : Prop :=
  -- !benchmark @start postcond
  result = find_note_index_indices music_notes key
  -- !benchmark @end postcond


-- Proof content
theorem find_note_index_postcond_satisfied (music_notes: List String) (key: String) (h_precond : find_note_index_precond (music_notes) (key)) :
    find_note_index_postcond (music_notes) (key) (find_note_index (music_notes) (key) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_92918_codeexercises_192918