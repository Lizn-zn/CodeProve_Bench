import Mathlib

-- Precondition definitions
@[reducible, simp]
def josephusPotato_precond (n : Nat) (m : Nat) : Prop :=
  -- !benchmark @start precond
  n > 0 ∧ m > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to remove element at index from a list
def List.eraseIdx' {α : Type} (lst : List α) (idx : Nat) : List α :=
  let rec aux (acc : List α) (remaining : List α) (i : Nat) : List α :=
    match remaining with
    | [] => acc.reverse
    | x :: xs =>
      if i == idx then
        acc.reverse ++ xs
      else
        aux (x :: acc) xs (i + 1)
  aux [] lst 0

-- Simulate the Josephus potato game
def josephusPotatoSimulation (n m : Nat) : Nat :=
  let rec simulate (participants : List Nat) (currentIdx : Nat) : Nat :=
    match participants with
    | [] => 0  -- Should never happen
    | [last] => last
    | _ =>
      let len := participants.length
      -- Calculate elimination position: move m-1 steps forward (since we pass m times)
      let elimIdx := (currentIdx + m - 1) % len
      -- Remove the person at elimIdx
      let newParticipants := participants.eraseIdx' elimIdx
      -- Next position: if we removed someone before the end, stay at same index
      -- otherwise wrap to 0
      let nextIdx := if elimIdx >= newParticipants.length then 0 else elimIdx
      simulate newParticipants nextIdx
  termination_by participants.length
  decreasing_by sorry
  -- Start with participants 1 to n, starting from the last position (n-1)
  simulate (List.range n |>.map (· + 1)) (n - 1)

-- Main function definitions
def josephusPotato (n : Nat) (m : Nat) (h_precond : josephusPotato_precond (n) (m)) : Nat :=
  -- !benchmark @start code
  josephusPotatoSimulation n m
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Simulate the Josephus problem
def josephusSimulation (n m : Nat) : Nat :=
  let rec simulate (participants : List Nat) (current : Nat) : Nat :=
    match participants with
    | [] => 0  -- Should never happen with valid input
    | [last] => last
    | _ =>
      let len := participants.length
      -- Find the position of the person to be eliminated (m-1 steps from current)
      let elimPos := (current + m - 1) % len
      -- Remove the person at elimPos
      let newParticipants := participants.eraseIdx elimPos
      -- Next position wraps around if needed
      let nextPos := if elimPos >= newParticipants.length then 0 else elimPos
      simulate newParticipants nextPos
  termination_by participants.length
  decreasing_by sorry
  -- Start with participants numbered 1 to n, starting from position n (index n-1)
  simulate (List.range n |>.map (· + 1)) (n - 1)

-- Postcondition definitions
@[reducible, simp]
def josephusPotato_postcond (n : Nat) (m : Nat) (result: Nat) (h_precond : josephusPotato_precond (n) (m)) : Prop :=
  -- !benchmark @start postcond
  result = josephusSimulation n m ∧ result ≥ 1 ∧ result ≤ n
  -- !benchmark @end postcond


-- Proof content
theorem josephusPotato_postcond_satisfied (n: Nat) (m: Nat) (h_precond : josephusPotato_precond (n) (m)) :
    josephusPotato_postcond (n) (m) (josephusPotato (n) (m) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
