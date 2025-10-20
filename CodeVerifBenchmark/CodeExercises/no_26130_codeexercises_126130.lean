import Mathlib

namespace no_26130_codeexercises_126130


-- Precondition auxiliary definitions
structure FurnitureItem where
  name : String
  color : String
  material : String
  price : Nat

def furniture_db : List FurnitureItem := []

-- Precondition definitions
@[reducible, simp]
def find_furniture_precond (color : String) (material : String) (price : Option Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No additional auxiliary definitions needed

-- Main function definitions
def find_furniture (color : String) (material : String) (price : Option Nat) (h_precond : find_furniture_precond (color) (material) (price)) : List String :=
  -- !benchmark @start code
  let matching_items := furniture_db.filter (λ item => item.color = color ∧ item.material = material)
  match price with
  | none => matching_items.map FurnitureItem.name
  | some p => (matching_items.filter (λ item => item.price ≤ p)).map FurnitureItem.name
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def matches_color_and_material (item : FurnitureItem) (color : String) (material : String) : Bool :=
  item.color = color ∧ item.material = material

def matches_price (item : FurnitureItem) (target_price : Nat) : Bool :=
  item.price ≤ target_price

def filter_furniture (color : String) (material : String) (price : Option Nat) : List String :=
  let matching_items := furniture_db.filter (λ item => matches_color_and_material item color material)
  match price with
  | none => matching_items.map FurnitureItem.name
  | some p => (matching_items.filter (λ item => matches_price item p)).map FurnitureItem.name

-- Postcondition definitions
@[reducible, simp]
def find_furniture_postcond (color : String) (material : String) (price : Option Nat) (result: List String) (h_precond : find_furniture_precond (color) (material) (price)) : Prop :=
  -- !benchmark @start postcond
  result = filter_furniture color material price
  -- !benchmark @end postcond


-- Proof content
theorem find_furniture_postcond_satisfied (color: String) (material: String) (price: Option Nat) (h_precond : find_furniture_precond (color) (material) (price)) :
    find_furniture_postcond (color) (material) (price) (find_furniture (color) (material) (price) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_26130_codeexercises_126130