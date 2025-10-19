import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_common_elements_precond (list1 : List String) (list2 : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_common_elements (list1 : List String) (list2 : List String) (h_precond : find_common_elements_precond (list1) (list2)) : List String :=
  -- !benchmark @start code
  let rec loop (i : Nat) (result : List String) : List String :=
    if h : i < list1.length then
      let current := list1[i]!
      if list2.contains current then
        loop (i + 1) (result ++ [current])
      else
        loop (i + 1) result
    else
      result
  loop 0 []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def find_common_elements_aux (list1 : List String) (list2 : List String) : List String :=
  list1.filter (λ x => list2.contains x)

-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond (list1 : List String) (list2 : List String) (result: List String) (h_precond : find_common_elements_precond (list1) (list2)) : Prop :=
  -- !benchmark @start postcond
  result = find_common_elements_aux list1 list2
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied (list1: List String) (list2: List String) (h_precond : find_common_elements_precond (list1) (list2)) :
    find_common_elements_postcond (list1) (list2) (find_common_elements (list1) (list2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

