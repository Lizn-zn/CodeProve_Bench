import Mathlib

-- Precondition auxiliary definitions
structure MinHeap where
  data : Array Nat
  size : Nat
  deriving Repr

def MinHeap.empty : MinHeap := ⟨#[], 0⟩

def MinHeap.insert (h : MinHeap) (x : Nat) : MinHeap :=
  let new_data := h.data.push x
  let new_size := h.size + 1
  -- This is a simplified version - in practice you'd need heapify operations
  ⟨new_data, new_size⟩

def MinHeap.ofList (elements : List Nat) : MinHeap :=
  elements.foldl (fun heap x => heap.insert x) MinHeap.empty

def MinHeap.levelOrder (h : MinHeap) : List Nat :=
  h.data[:h.size].toList

-- Precondition definitions
@[reducible, simp]
def format_heap_after_insertions_precond (heap : MinHeap) (elements : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to format heap in level-order with proper structure
def formatLevelOrderCode (elements : List Nat) : String :=
  match elements with
  | [] => "Empty heap"
  | xs => 
    let levels := go xs 0 1 [] []
    String.intercalate "\n" (levels.reverse.map (fun level => String.intercalate " " (level.map toString)))
where
  go (remaining : List Nat) (index : Nat) (levelSize : Nat) (currentLevel : List Nat) (acc : List (List Nat)) : List (List Nat) :=
    match remaining with
    | [] => 
      if currentLevel.isEmpty then acc else (currentLevel.reverse :: acc)
    | x :: xs =>
      let newCurrent := x :: currentLevel
      if newCurrent.length = levelSize then
        go xs (index + 1) (levelSize * 2) [] (newCurrent.reverse :: acc)
      else
        go xs (index + 1) levelSize newCurrent acc

-- Main function definitions
def format_heap_after_insertions (heap : MinHeap) (elements : List Nat) (h_precond : format_heap_after_insertions_precond heap elements) : String :=
  -- !benchmark @start code
  let finalHeap := elements.foldl (fun h x => h.insert x) heap
  formatLevelOrderCode (finalHeap.levelOrder)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def formatLevelOrderPost (elements : List Nat) : String :=
  match elements with
  | [] => "Empty heap"
  | xs => 
    let levels := go xs 0 1 [] []
    String.intercalate "\n" (levels.reverse.map (fun level => String.intercalate " " (level.map toString)))
where
  go (remaining : List Nat) (index : Nat) (levelSize : Nat) (currentLevel : List Nat) (acc : List (List Nat)) : List (List Nat) :=
    match remaining with
    | [] => 
      if currentLevel.isEmpty then acc else (currentLevel.reverse :: acc)
    | x :: xs =>
      let newCurrent := x :: currentLevel
      if newCurrent.length = levelSize then
        go xs (index + 1) (levelSize * 2) [] (newCurrent.reverse :: acc)
      else
        go xs (index + 1) levelSize newCurrent acc

-- Postcondition definitions
@[reducible, simp]
def format_heap_after_insertions_postcond (heap : MinHeap) (elements : List Nat) (result: String) (h_precond : format_heap_after_insertions_precond heap elements) : Prop :=
  -- !benchmark @start postcond
  let finalHeap := elements.foldl (fun h x => h.insert x) heap
  let expected := formatLevelOrderPost (finalHeap.levelOrder)
  result = expected
  -- !benchmark @end postcond


-- Proof content
theorem format_heap_after_insertions_postcond_satisfied (heap: MinHeap) (elements: List Nat) (h_precond : format_heap_after_insertions_precond heap elements) :
    format_heap_after_insertions_postcond heap elements (format_heap_after_insertions heap elements h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof