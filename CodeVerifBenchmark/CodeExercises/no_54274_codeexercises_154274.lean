import Mathlib

-- Precondition definitions
@[reducible, simp]
def remove_elements_precond (nested_list : List (List ℤ)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def has_odd_code (lst : List ℤ) : Bool :=
  lst.any (λ x => ¬Even x)

def filter_evens_code (lst : List ℤ) : List ℤ :=
  lst.filter (λ x => ¬Even x)

-- Main function definitions
def remove_elements (nested_list : List (List ℤ)) (h_precond : remove_elements_precond (nested_list)) : List (List ℤ) :=
  -- !benchmark @start code
  let filtered := nested_list.filter has_odd_code
  filtered.map filter_evens_code
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def has_odd_prop (lst : List ℤ) : Prop := ∃ x ∈ lst, ¬Even x

def filter_evens_prop (lst : List ℤ) : List ℤ :=
  lst.filter (λ x => ¬Even x)

-- Postcondition definitions
@[reducible, simp]
def remove_elements_postcond (nested_list : List (List ℤ)) (result: List (List ℤ)) (h_precond : remove_elements_precond (nested_list)) : Prop :=
  -- !benchmark @start postcond
  ∀ (i : ℕ) (h : i < result.length), 
    (∃ (j : ℕ) (h' : j < nested_list.length), 
      result.get ⟨i, h⟩ = filter_evens_prop (nested_list.get ⟨j, h'⟩) ∧ 
      has_odd_prop (nested_list.get ⟨j, h'⟩)) ∧
  ∀ (j : ℕ) (h' : j < nested_list.length), 
    has_odd_prop (nested_list.get ⟨j, h'⟩) → 
    (∃ (i : ℕ) (h : i < result.length), 
      result.get ⟨i, h⟩ = filter_evens_prop (nested_list.get ⟨j, h'⟩))
  -- !benchmark @end postcond


-- Proof content
theorem remove_elements_postcond_satisfied (nested_list: List (List ℤ)) (h_precond : remove_elements_precond (nested_list)) :
    remove_elements_postcond (nested_list) (remove_elements (nested_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof