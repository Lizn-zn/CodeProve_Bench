import Mathlib

namespace no_98480_codeexercises_198480


-- Precondition auxiliary definitions
inductive ValidFuelType : Type where
  | wood : ValidFuelType
  | paper : ValidFuelType
  | gasoline : ValidFuelType
  | electrical : ValidFuelType

def fuelTypeToString : ValidFuelType → String
  | .wood => "wood"
  | .paper => "paper"
  | .gasoline => "gasoline"
  | .electrical => "electrical"

def isValidFuelType (fuel_type : String) : Prop :=
  fuel_type = "wood" ∨ fuel_type = "paper" ∨ fuel_type = "gasoline" ∨ fuel_type = "electrical"

-- Precondition definitions
@[reducible, simp]
def extinguish_fire_precond (fuel_type : String) (fire_size : Float) : Prop :=
  -- !benchmark @start precond
  isValidFuelType fuel_type ∧ fire_size > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed for the implementation

-- Main function definitions
def extinguish_fire (fuel_type : String) (fire_size : Float) (h_precond : extinguish_fire_precond (fuel_type) (fire_size)) : Float :=
  -- !benchmark @start code
  match fuel_type with
  | "wood" => fire_size * 500.0
  | "paper" => fire_size * 502.0
  | "gasoline" => fire_size * 350.0
  | "electrical" => fire_size * 500.0
  | _ => 0.0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def waterRequired (fuel_type : String) (fire_size : Float) : Float :=
  match fuel_type with
  | "wood" => fire_size * 500.0
  | "paper" => fire_size * 502.0
  | "gasoline" => fire_size * 350.0
  | "electrical" => fire_size * 500.0
  | _ => 0.0

-- Postcondition definitions
@[reducible, simp]
def extinguish_fire_postcond (fuel_type : String) (fire_size : Float) (result: Float) (h_precond : extinguish_fire_precond (fuel_type) (fire_size)) : Prop :=
  -- !benchmark @start postcond
  result = waterRequired fuel_type fire_size
  -- !benchmark @end postcond


-- Proof content
theorem extinguish_fire_postcond_satisfied (fuel_type: String) (fire_size: Float) (h_precond : extinguish_fire_precond (fuel_type) (fire_size)) :
    extinguish_fire_postcond (fuel_type) (fire_size) (extinguish_fire (fuel_type) (fire_size) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_98480_codeexercises_198480