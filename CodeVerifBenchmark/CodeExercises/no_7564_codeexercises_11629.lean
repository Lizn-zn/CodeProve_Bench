import Mathlib

-- Precondition definitions
@[reducible, simp]
def remove_duplicates_precond (farm_products : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def remove_duplicates (farm_products : List String) (h_precond : remove_duplicates_precond farm_products) : List String :=
  -- !benchmark @start code
  let unique_products := farm_products.eraseDups
  unique_products
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def List.Nodup' (l : List String) : Prop := ∀ (x : String), x ∈ l → List.count x l = 1

-- Postcondition definitions
@[reducible, simp]
def remove_duplicates_postcond (farm_products : List String) (result: List String) (h_precond : remove_duplicates_precond farm_products) : Prop :=
  -- !benchmark @start postcond
  List.Nodup' result ∧ ∀ (x : String), x ∈ result ↔ x ∈ farm_products
  -- !benchmark @end postcond


-- Proof content
theorem remove_duplicates_postcond_satisfied (farm_products: List String) (h_precond : remove_duplicates_precond farm_products) :
    remove_duplicates_postcond farm_products (remove_duplicates farm_products h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof