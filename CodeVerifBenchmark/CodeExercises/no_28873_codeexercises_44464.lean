import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_common_elements_precond (list1 : List α) (list2 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_common_elements [BEq α] (list1 : List α) (list2 : List α) (h_precond : find_common_elements_precond list1 list2) : List α :=
  -- !benchmark @start code
  let rec loop (l1 : List α) (acc : List α) : List α :=
    match l1 with
    | [] => acc
    | x :: xs => 
      if list2.contains x then
        loop xs (x :: acc)
      else
        loop xs acc
  loop list1 []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def common_elements [BEq α] (list1 list2 : List α) : List α :=
  list1.filter (λ x => list2.contains x)

-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond [BEq α] (list1 : List α) (list2 : List α) (result: List α) (h_precond : find_common_elements_precond list1 list2) : Prop :=
  -- !benchmark @start postcond
  result = common_elements list1 list2
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied [BEq α] (list1: List α) (list2: List α) (h_precond : find_common_elements_precond list1 list2) :
    find_common_elements_postcond list1 list2 (find_common_elements list1 list2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof