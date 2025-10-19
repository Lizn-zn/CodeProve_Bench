import Mathlib

-- Precondition auxiliary definitions
structure Dancer where
  name : String
  danceStyles : List String

-- Precondition definitions
@[reducible, simp]
def find_common_dance_styles_precond (dancers : List Dancer) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_common_dance_styles (dancers : List Dancer) (h_precond : find_common_dance_styles_precond dancers) : List String :=
  -- !benchmark @start code
  match dancers with
  | [] => []
  | hd :: tl =>
    let initialStyles := hd.danceStyles
    let commonStyles := List.foldl (λ acc dancer => List.inter acc dancer.danceStyles) initialStyles tl
    commonStyles
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def commonStyles (styles : List (List String)) : List String :=
  match styles with
  | [] => []
  | hd :: tl => List.foldl List.inter hd tl

-- Postcondition definitions
@[reducible, simp]
def find_common_dance_styles_postcond (dancers : List Dancer) (result: List String) (h_precond : find_common_dance_styles_precond dancers) : Prop :=
  -- !benchmark @start postcond
  let allStyles := dancers.map Dancer.danceStyles
  result = commonStyles allStyles ∧
  ∀ s, s ∈ result ↔ ∀ dancer, dancer ∈ dancers → s ∈ dancer.danceStyles
  -- !benchmark @end postcond


-- Proof content
theorem find_common_dance_styles_postcond_satisfied (dancers: List Dancer) (h_precond : find_common_dance_styles_precond dancers) :
    find_common_dance_styles_postcond dancers (find_common_dance_styles dancers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof