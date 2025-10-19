import Mathlib

-- Precondition definitions
@[reducible, simp]
def chef_dishes_precond (chef_menu : List String) (dish_to_remove : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def chef_dishes (chef_menu : List String) (dish_to_remove : String) (h_precond : chef_dishes_precond (chef_menu) (dish_to_remove)) : List String :=
  -- !benchmark @start code
  if h : dish_to_remove ∈ chef_menu then
    let index := chef_menu.indexOf dish_to_remove
    chef_menu.take index ++ chef_menu.drop (index + 1)
  else
    chef_menu
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def occurs_before (l : List String) (x : String) (i : Nat) : Prop :=
  ∃ j : Nat, j < i ∧ j < l.length ∧ l.get! j = x

def occurs_after (l : List String) (x : String) (i : Nat) : Prop :=
  ∃ j : Nat, i < j ∧ j < l.length ∧ l.get! j = x

def occurs_at (l : List String) (x : String) (i : Nat) : Prop :=
  i < l.length ∧ l.get! i = x

def removed_at (l : List String) (x : String) (i : Nat) (result : List String) : Prop :=
  occurs_at l x i ∧
  (∀ j < l.length, (j < i → l.get! j = result.get! j) ∧ 
                   (j > i → l.get! j = result.get! (j - 1))) ∧
  result.length = l.length - 1

-- Postcondition definitions
@[reducible, simp]
def chef_dishes_postcond (chef_menu : List String) (dish_to_remove : String) (result : List String) (h_precond : chef_dishes_precond (chef_menu) (dish_to_remove)) : Prop :=
  -- !benchmark @start postcond
  (dish_to_remove ∉ result) ∧
  (∃ i : Nat, removed_at chef_menu dish_to_remove i result) ∧
  (∀ x : String, x ∈ result → x ∈ chef_menu) ∧
  (∀ x : String, x ∈ chef_menu → x = dish_to_remove ∨ x ∈ result)
  -- !benchmark @end postcond


-- Proof content
theorem chef_dishes_postcond_satisfied (chef_menu: List String) (dish_to_remove: String) (h_precond : chef_dishes_precond (chef_menu) (dish_to_remove)) :
    chef_dishes_postcond (chef_menu) (dish_to_remove) (chef_dishes (chef_menu) (dish_to_remove) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof