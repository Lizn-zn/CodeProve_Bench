import Mathlib

namespace no_9696_codeexercises_14845


-- Precondition definitions
@[reducible, simp]
def find_common_elements_precond (list1 : List String) (list2 : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to find common elements while preserving order and removing duplicates
def find_common_elements_aux (list1 list2 : List String) : List String :=
  let lower1 := list1.map String.toLower
  let lower2 := list2.map String.toLower
  let common_lower := lower1.filter (λ x => x ∈ lower2)
  let unique_common := common_lower.eraseDups
  -- Reconstruct original case from list1 for common elements
  unique_common.map (λ lower_s => 
    match list1.find? (λ s => s.toLower = lower_s) with
    | some original => original
    | none => lower_s)

-- Main function definitions
def find_common_elements (list1 : List String) (list2 : List String) (h_precond : find_common_elements_precond (list1) (list2)) : List String :=
  -- !benchmark @start code
  let lower1 := list1.map String.toLower
  let lower2 := list2.map String.toLower
  let common_lower := lower1.filter (λ x => x ∈ lower2)
  let unique_common := common_lower.eraseDups
  -- Reconstruct original case from list1 for common elements
  unique_common.map (λ lower_s => 
    match list1.find? (λ s => s.toLower = lower_s) with
    | some original => original
    | none => lower_s)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def to_lowercase_list (l : List String) : List String :=
  l.map String.toLower

def is_common_element (s : String) (list1 list2 : List String) : Bool :=
  let lower1 := to_lowercase_list list1
  let lower2 := to_lowercase_list list2
  s.toLower ∈ lower1 ∧ s.toLower ∈ lower2

def all_common_elements (list1 list2 result : List String) : Prop :=
  ∀ s : String, s ∈ result ↔ is_common_element s list1 list2 = true

def no_duplicates (l : List String) : Prop :=
  l.Nodup

-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond (list1 : List String) (list2 : List String) (result: List String) (h_precond : find_common_elements_precond (list1) (list2)) : Prop :=
  -- !benchmark @start postcond
  all_common_elements list1 list2 result ∧ no_duplicates result
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied (list1: List String) (list2: List String) (h_precond : find_common_elements_precond (list1) (list2)) :
    find_common_elements_postcond (list1) (list2) (find_common_elements (list1) (list2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_9696_codeexercises_14845