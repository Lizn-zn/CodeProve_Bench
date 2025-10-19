import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_common_colors_precond (rooms : List (String × List String)) (clients : List String) : Prop :=
  -- !benchmark @start precond
  ∀ (client : String), client ∈ clients → ∃ (room : String × List String), room ∈ rooms ∧ room.1 = client
  -- !benchmark @end precond


-- Code auxiliary definitions
def common_colors (color_lists : List (List String)) : List String :=
  match color_lists with
  | [] => []
  | hd::tl => List.foldl (λ acc colors => List.filter (λ color => color ∈ acc) colors) hd tl

-- Main function definitions
def find_common_colors (rooms : List (String × List String)) (clients : List String) (h_precond : find_common_colors_precond rooms clients) : List String :=
  -- !benchmark @start code
  let client_rooms := List.filter (λ room => room.1 ∈ clients) rooms
  let client_colors := List.map (λ room => room.2) client_rooms
  common_colors client_colors
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def get_room_colors (rooms : List (String × List String)) (client : String) : List String :=
  match rooms.find? (λ room => room.1 = client) with
  | some room => room.2
  | none => []

-- Postcondition definitions
@[reducible, simp]
def find_common_colors_postcond (rooms : List (String × List String)) (clients : List String) (result: List String) (h_precond : find_common_colors_precond rooms clients) : Prop :=
  -- !benchmark @start postcond
  let client_rooms := List.filter (λ room => room.1 ∈ clients) rooms
  let client_colors := List.map (λ room => room.2) client_rooms
  result = common_colors client_colors ∧
  (∀ color, color ∈ result → ∀ colors, colors ∈ client_colors → color ∈ colors) ∧
  (∀ color, (∀ colors, colors ∈ client_colors → color ∈ colors) → color ∈ result)
  -- !benchmark @end postcond


-- Proof content
theorem find_common_colors_postcond_satisfied (rooms: List (String × List String)) (clients: List String) (h_precond : find_common_colors_precond rooms clients) :
    find_common_colors_postcond rooms clients (find_common_colors rooms clients h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof