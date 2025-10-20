import Mathlib

namespace no_960_leetcode_1942


-- Precondition auxiliary definitions
def valid_times_list : List (List Nat) → Prop
  | [] => True
  | [a, l] :: rest => a < l ∧ valid_times_list rest
  | _ => False

def times_length_property (times : List (List Nat)) : Prop :=
  times.length ≥ 2 ∧ times.length ≤ 10000

def target_friend_bounds (times : List (List Nat)) (targetFriend : Nat) : Prop :=
  targetFriend < times.length

def arrival_times_distinct (times : List (List Nat)) : Prop :=
  let arrivals := times.map (fun pair => pair.head!)
  arrivals.Nodup

def arrival_leaving_bounds (times : List (List Nat)) : Prop :=
  ∀ pair ∈ times, pair.length = 2 ∧ pair[0]! < pair[1]! ∧ pair[1]! ≤ 100000

-- Precondition definitions
@[reducible, simp]
def find_chair_for_friend_precond (times : List (List Nat)) (targetFriend : Nat) : Prop :=
  -- !benchmark @start precond
  times_length_property times ∧ 
  target_friend_bounds times targetFriend ∧
  valid_times_list times ∧
  arrival_times_distinct times ∧
  arrival_leaving_bounds times
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- A simple priority queue simulation using sorted lists -/
def PriorityQueue : Type := List Nat

def PriorityQueue.empty : PriorityQueue := []

def PriorityQueue.insert (pq : PriorityQueue) (x : Nat) : PriorityQueue :=
  let rec insert_sorted (lst : List Nat) (val : Nat) : List Nat :=
    match lst with
    | [] => [val]
    | h :: t => if val ≤ h then val :: lst else h :: insert_sorted t val
  insert_sorted pq x

def PriorityQueue.extractMin? (pq : PriorityQueue) : Option (Nat × PriorityQueue) :=
  match pq with
    | [] => none
    | h :: t => some (h, t)

def PriorityQueue.isEmpty (pq : PriorityQueue) : Bool :=
  match pq with
    | [] => true
    | _ => false

/-- Simulate the chair assignment process -/
def simulateChairAssignment (times : List (List Nat)) (targetFriend : Nat) : Nat := 
  let n := times.length
  -- Create list of (arrival, leaving, friend_index)
  let indexedTimes := List.zip times (List.range n)
  -- Sort by arrival time
  let sortedArrivals := indexedTimes.mergeSort (fun a b => (a.fst.head!) < (b.fst.head!))
  
  -- State: (occupiedChairs, availableChairs, nextChair, friendToChair)
  let initialState : List (Nat × Nat) × PriorityQueue × Nat × List (Nat × Nat) := 
    ([], PriorityQueue.empty, 0, [])
  
  -- Process each friend's arrival in order
  let processResult := sortedArrivals.foldl (fun acc pair =>
    let timePair := pair.fst
    let friendIdx := pair.snd
    let arrival := timePair.head!
    let leaving := timePair.tail!.head!
    
    let (occupiedChairs, availableChairs, nextChair, friendToChair) := acc
    
    -- Free up chairs whose leaving time <= current arrival time
    let (freed, remaining) := occupiedChairs.partition (fun (l, _) => l ≤ arrival)
    let updatedOccupied := remaining
    -- Add freed chair numbers to available chairs (maintain sorted order)
    let freedChairs := freed.map Prod.snd
    let updatedAvailable := freedChairs.foldl (fun pq chair => PriorityQueue.insert pq chair) availableChairs
    
    -- Assign chair
    let (chair, newAvailable, newNextChair) := 
      match PriorityQueue.extractMin? updatedAvailable with
        | some (minChair, pq') => 
          (minChair, pq', nextChair)
        | none => 
          let c := nextChair
          (c, updatedAvailable, c + 1)
    
    -- Record assignment
    let newFriendToChair := (friendIdx, chair) :: friendToChair
    let newOccupied := (leaving, chair) :: updatedOccupied
    
    (newOccupied, newAvailable, newNextChair, newFriendToChair)
  ) initialState
  
  -- Find the chair for targetFriend
  match processResult.2.2.2.find? (fun x => x.fst = targetFriend) with
    | some (_, chair) => chair
    | none => 0 -- Should not happen with valid inputs

-- Main function definitions
def find_chair_for_friend (times : List (List Nat)) (targetFriend : Nat) (h_precond : find_chair_for_friend_precond (times) (targetFriend)) : Nat :=
  -- !benchmark @start code
  simulateChairAssignment times targetFriend
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def simulate_chair_assignment (times : List (List Nat)) (targetFriend : Nat) : Nat :=
  let n := times.length
  let indexed_times := List.zip times (List.range n)
  let sorted_arrivals := indexed_times.mergeSort (fun a b => (a.fst.head!) < (b.fst.head!))
  
  -- State: (occupied_chairs, available_chairs, next_chair, friend_chair_map)
  let initial_state : List (Nat × Nat) × List Nat × Nat × List (Nat × Nat) := 
    ([], [], 0, [])
  
  -- Process each friend's arrival in order
  let process_result := sorted_arrivals.foldl (fun acc pair =>
    let (time_pair, friend_idx) := pair
    let arrival := time_pair.head!
    let leaving := time_pair.tail!.head!
    
    let (occupied_chairs, available_chairs, next_chair, friend_chair_map) := acc
    
    -- Free up chairs whose leaving time <= current arrival time
    let (freed, remaining) := occupied_chairs.partition (fun (l, _) => l ≤ arrival)
    let updated_occupied := remaining
    let sorted_freed := (freed.map (fun x => x.snd)).mergeSort (fun a b => a < b)
    let updated_available := sorted_freed ++ available_chairs
    
    -- Assign chair
    let (chair, new_available, new_next_chair) := 
      if updated_available.isEmpty then
        let c := next_chair
        (c, updated_available, c + 1)
      else
        let c := updated_available.head!
        (c, updated_available.tail!, next_chair)
    
    -- Record assignment
    let new_friend_chair_map := (friend_idx, chair) :: friend_chair_map
    let new_occupied := (leaving, chair) :: updated_occupied
    
    (new_occupied, new_available, new_next_chair, new_friend_chair_map)
  ) initial_state
  
  -- Find the chair for targetFriend
  match process_result.2.2.2.find? (fun x => x.fst = targetFriend) with
    | some (_, chair) => chair
    | none => 0 -- This shouldn't happen with valid inputs

-- Postcondition definitions
@[reducible, simp]
def find_chair_for_friend_postcond (times : List (List Nat)) (targetFriend : Nat) (result: Nat) (h_precond : find_chair_for_friend_precond (times) (targetFriend)) : Prop :=
  -- !benchmark @start postcond
  result = simulate_chair_assignment times targetFriend
  -- !benchmark @end postcond


-- Proof content
theorem find_chair_for_friend_postcond_satisfied (times: List (List Nat)) (targetFriend: Nat) (h_precond : find_chair_for_friend_precond (times) (targetFriend)) :
    find_chair_for_friend_postcond (times) (targetFriend) (find_chair_for_friend (times) (targetFriend) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_960_leetcode_1942