import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_common_colors_precond (fashion_pieces : List (String × List String)) : Prop :=
  -- !benchmark @start precond
  ∀ (piece : String × List String), piece ∈ fashion_pieces → piece.2 ≠ []
  -- !benchmark @end precond


-- Code auxiliary definitions
def colors_of_piece (piece : String × List String) : List String := piece.2

def common_colors_aux (fashion_pieces : List (String × List String)) : List String :=
  match fashion_pieces with
  | [] => []
  | piece :: rest => 
    let rest_common := common_colors_aux rest
    piece.2.filter (λ color => rest_common.contains color)

-- Main function definitions
def find_common_colors (fashion_pieces : List (String × List String)) (h_precond : find_common_colors_precond (fashion_pieces)) : List String :=
  -- !benchmark @start code
  if h : fashion_pieces.isEmpty then
    []
  else
    let first_piece := fashion_pieces.head!
    let remaining_pieces := fashion_pieces.tail
    let remaining_common := find_common_colors remaining_pieces (by
      intro piece h
      apply h_precond piece
      exact List.mem_of_mem_tail h)
    first_piece.2.filter (λ color => remaining_common.contains color)
  -- !benchmark @end code
termination_by fashion_pieces.length
decreasing_by sorry

-- Postcondition auxiliary definitions
def all_colors (fashion_pieces : List (String × List String)) : List String :=
  fashion_pieces.foldl (λ acc piece => acc.union piece.2) []

def is_common_color (color : String) (fashion_pieces : List (String × List String)) : Prop :=
  ∀ (piece : String × List String), piece ∈ fashion_pieces → color ∈ piece.2

-- Postcondition definitions
@[reducible, simp]
def find_common_colors_postcond (fashion_pieces : List (String × List String)) (result: List String) (h_precond : find_common_colors_precond (fashion_pieces)) : Prop :=
  -- !benchmark @start postcond
  ∀ (color : String), color ∈ result ↔ is_common_color color fashion_pieces
  -- !benchmark @end postcond


-- Proof content
theorem find_common_colors_postcond_satisfied (fashion_pieces: List (String × List String)) (h_precond : find_common_colors_precond (fashion_pieces)) :
    find_common_colors_postcond (fashion_pieces) (find_common_colors (fashion_pieces) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof