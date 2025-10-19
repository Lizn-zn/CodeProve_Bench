import Mathlib

-- Precondition auxiliary definitions
def isValidQueryList (queries : List Nat) : Prop :=
  ∀ q ∈ queries, q > 0

def isBoundedQueryList (queries : List Nat) (m : Nat) : Prop :=
  ∀ q ∈ queries, q ≤ m

-- Precondition definitions
@[reducible, simp]
def processQueries_precond (queries : List Nat) (m : Nat) : Prop :=
  -- !benchmark @start precond
  m > 0 ∧ isValidQueryList queries ∧ isBoundedQueryList queries m
  -- !benchmark @end precond


-- Postcondition auxiliary definitions
def processQueriesStep (P : List Nat) (query : Nat) : Option (Nat × List Nat) :=
  let pos := P.indexOf query
  if pos = P.length then none  -- query not found
  else
    let P' := query :: (P.filter (· ≠ query))
    some (pos, P')

def processQueriesAux (queries : List Nat) (P : List Nat) : Option (List Nat) :=
  match queries with
  | [] => some []
  | q :: qs => do
    let (pos, P') ← processQueriesStep P q
    let rest ← processQueriesAux qs P'
    return pos :: rest

def initialPermutation (m : Nat) : List Nat :=
  List.range m |>.map (· + 1)

-- Code auxiliary definitions
def processQueriesCore (queries : List Nat) (P : List Nat) : List Nat :=
  match queries with
  | [] => []
  | q :: qs =>
    let pos := P.indexOf q
    let P' := q :: (P.filter (· ≠ q))
    pos :: processQueriesCore qs P'

-- Main function definitions
def processQueries (queries : List Nat) (m : Nat) (h_precond : processQueries_precond (queries) (m)) : List Nat :=
  -- !benchmark @start code
  processQueriesCore queries (initialPermutation m)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def processQueries_postcond (queries : List Nat) (m : Nat) (result: List Nat) (h_precond : processQueries_precond (queries) (m)) : Prop :=
  -- !benchmark @start postcond
  ∃ P : List Nat, P = initialPermutation m ∧ processQueriesAux queries P = some result
  -- !benchmark @end postcond


-- Proof content
theorem processQueries_postcond_satisfied (queries: List Nat) (m: Nat) (h_precond : processQueries_precond (queries) (m)) :
    processQueries_postcond (queries) (m) (processQueries (queries) (m) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof