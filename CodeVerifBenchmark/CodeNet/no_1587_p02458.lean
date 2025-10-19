import Mathlib

-- Precondition definitions
@[reducible, simp]
def processMultiSetQueries_precond (queries : List (Nat × List Nat)) : Prop :=
  -- !benchmark @start precond
  -- Each query is well-formed:
    -- Operation 0 (insert), 1 (find), 2 (delete): have exactly 1 parameter
    -- Operation 3 (dump): has exactly 2 parameters (L and R)
    queries.all fun (op, params) =>
      match op with
      | 0 => params.length = 1  -- insert
      | 1 => params.length = 1  -- find
      | 2 => params.length = 1  -- delete
      | 3 => params.length = 2  -- dump
      | _ => False
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper structure to maintain the multiset with efficient operations
structure MultiSet where
  elements : List Nat
  deriving Inhabited

-- Insert an element and return the new multiset and count
def MultiSet.insert (ms : MultiSet) (x : Nat) : MultiSet × Nat :=
  let newElements := x :: ms.elements
  (⟨newElements⟩, newElements.length)

-- Find count of element x
def MultiSet.find (ms : MultiSet) (x : Nat) : Nat :=
  ms.elements.filter (· = x) |>.length

-- Delete all occurrences of x
def MultiSet.delete (ms : MultiSet) (x : Nat) : MultiSet :=
  ⟨ms.elements.filter (· ≠ x)⟩

-- Dump elements in range [L, R] in sorted order
def MultiSet.dump (ms : MultiSet) (L R : Nat) : List String :=
  let filtered := ms.elements.filter (fun x => L ≤ x ∧ x ≤ R)
  let sorted := filtered.toArray.qsort (· ≤ ·) |>.toList
  sorted.map toString

-- Main function definitions
def processMultiSetQueries (queries : List (Nat × List Nat)) (h_precond : processMultiSetQueries_precond (queries)) : List String :=
  -- !benchmark @start code
  let rec go (qs : List (Nat × List Nat)) (ms : MultiSet) (acc : List String) : List String :=
      match qs with
      | [] => acc.reverse
      | (op, params) :: rest =>
        match op with
        | 0 => -- insert x
          let x := params.head!
          let (newMs, count) := ms.insert x
          go rest newMs (toString count :: acc)
        | 1 => -- find x
          let x := params.head!
          let count := ms.find x
          go rest ms (toString count :: acc)
        | 2 => -- delete x
          let x := params.head!
          let newMs := ms.delete x
          go rest newMs acc
        | 3 => -- dump L R
          let L := params.head!
          let R := params.tail.head!
          let output := ms.dump L R
          go rest ms (output.reverse ++ acc)
        | _ => go rest ms acc
    go queries ⟨[]⟩ []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Process queries and compute expected output
def processQueries (queries : List (Nat × List Nat)) : List String :=
  let rec go (qs : List (Nat × List Nat)) (multiset : List Nat) (acc : List String) : List String :=
    match qs with
    | [] => acc.reverse
    | (op, params) :: rest =>
      match op with
      | 0 => -- insert x
        let x := params.head!
        let newMultiset := x :: multiset
        let count := newMultiset.length
        go rest newMultiset (toString count :: acc)
      | 1 => -- find x
        let x := params.head!
        let count := multiset.filter (· = x) |>.length
        go rest multiset (toString count :: acc)
      | 2 => -- delete x
        let x := params.head!
        let newMultiset := multiset.filter (· ≠ x)
        go rest newMultiset acc
      | 3 => -- dump L R
        let L := params.head!
        let R := params.tail.head!
        let filtered := multiset.filter (fun x => L ≤ x ∧ x ≤ R)
        let sorted := filtered.toArray.qsort (· ≤ ·) |>.toList
        let output := sorted.map toString
        go rest multiset (output.reverse ++ acc)
      | _ => go rest multiset acc
  go queries [] []

-- Postcondition definitions
@[reducible, simp]
def processMultiSetQueries_postcond (queries : List (Nat × List Nat)) (result: List String) (h_precond : processMultiSetQueries_precond (queries)) : Prop :=
  -- !benchmark @start postcond
  -- The result matches the expected output from processing the queries
    result = processQueries queries
  -- !benchmark @end postcond


-- Proof content
theorem processMultiSetQueries_postcond_satisfied (queries: List (Nat × List Nat)) (h_precond : processMultiSetQueries_precond (queries)) :
    processMultiSetQueries_postcond (queries) (processMultiSetQueries (queries) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

