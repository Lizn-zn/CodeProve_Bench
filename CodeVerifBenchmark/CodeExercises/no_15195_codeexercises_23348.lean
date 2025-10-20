import Mathlib

namespace no_15195_codeexercises_23348


-- Precondition definitions
@[reducible, simp]
def modify_carpenter_inventory_precond (inventory : List String) (remove_items : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed for this implementation

-- Main function definitions
def modify_carpenter_inventory (inventory : List String) (remove_items : List String) (h_precond : modify_carpenter_inventory_precond (inventory) (remove_items)) : List String :=
  -- !benchmark @start code
  inventory.filter (λ x => ¬ remove_items.contains x)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def List.removeAllCustom (xs : List String) (toRemove : List String) : List String :=
  xs.filter (λ x => ¬ toRemove.contains x)

-- Postcondition definitions
@[reducible, simp]
def modify_carpenter_inventory_postcond (inventory : List String) (remove_items : List String) (result: List String) (h_precond : modify_carpenter_inventory_precond (inventory) (remove_items)) : Prop :=
  -- !benchmark @start postcond
  result = List.removeAllCustom inventory remove_items
  -- !benchmark @end postcond


-- Proof content
theorem modify_carpenter_inventory_postcond_satisfied (inventory: List String) (remove_items: List String) (h_precond : modify_carpenter_inventory_precond (inventory) (remove_items)) :
    modify_carpenter_inventory_postcond (inventory) (remove_items) (modify_carpenter_inventory (inventory) (remove_items) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_15195_codeexercises_23348