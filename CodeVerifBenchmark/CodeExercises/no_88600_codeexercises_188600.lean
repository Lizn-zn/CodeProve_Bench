import Mathlib

namespace no_88600_codeexercises_188600


-- Precondition auxiliary definitions
inductive ClothingPreference : Type where
  | top : ClothingPreference
  | bottom : ClothingPreference
  | accessory : ClothingPreference
  deriving DecidableEq, Repr

inductive Season : Type where
  | summer : Season
  | winter : Season
  deriving DecidableEq, Repr

def isValidPreference (s : String) : Bool :=
  s = "top" ∨ s = "bottom" ∨ s = "accessory"

def isValidSeason (s : String) : Bool :=
  s = "summer" ∨ s = "winter"

-- Precondition definitions
@[reducible, simp]
def get_outfit_precond (preference : String) (season : String) : Prop :=
  -- !benchmark @start precond
  isValidPreference preference ∧ isValidSeason season
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def get_outfit (preference : String) (season : String) (h_precond : get_outfit_precond (preference) (season)) : String :=
  -- !benchmark @start code
  match preference, season with
    | "top", "summer" => "t-shirt"
    | "top", "winter" => "sweater"
    | "bottom", "summer" => "shorts"
    | "bottom", "winter" => "jeans"
    | "accessory", "summer" => "sunglasses"
    | "accessory", "winter" => "scarf"
    | _, _ => "unknown"
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def getOutfitMapping (preference : String) (season : String) : String :=
  match preference, season with
  | "top", "summer" => "t-shirt"
  | "top", "winter" => "sweater"
  | "bottom", "summer" => "shorts"
  | "bottom", "winter" => "jeans"
  | "accessory", "summer" => "sunglasses"
  | "accessory", "winter" => "scarf"
  | _, _ => "unknown"

-- Postcondition definitions
@[reducible, simp]
def get_outfit_postcond (preference : String) (season : String) (result: String) (h_precond : get_outfit_precond (preference) (season)) : Prop :=
  -- !benchmark @start postcond
  result = getOutfitMapping preference season
  -- !benchmark @end postcond


-- Proof content
theorem get_outfit_postcond_satisfied (preference: String) (season: String) (h_precond : get_outfit_precond (preference) (season)) :
    get_outfit_postcond (preference) (season) (get_outfit (preference) (season) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_88600_codeexercises_188600