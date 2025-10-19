import Mathlib

-- Precondition auxiliary definitions
-- Define the standard energy consumption rates for common appliances (in watts)
def appliance_power_consumption : String → Float := λ
  | "Refrigerator" => 150.0
  | "Microwave" => 1200.0
  | "TV" => 100.0
  | "Laptop" => 50.0
  | "Washing Machine" => 500.0
  | "Dishwasher" => 1200.0
  | "Air Conditioner" => 1500.0
  | "Heater" => 1500.0
  | "Light Bulb" => 10.0
  | "Fan" => 50.0
  | _ => 0.0  -- Default for unknown appliances

-- Precondition definitions
@[reducible, simp]
def calculate_daily_energy_usage_precond (appliances : Finset String) (hours : List Nat) : Prop :=
  -- !benchmark @start precond
  -- The hours list must have the same length as the number of appliances
    -- All hours must be between 0 and 24 (inclusive)
    hours.length = appliances.card ∧
    ∀ h ∈ hours, h ≤ 24
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the implementation

-- Main function definitions
noncomputable def calculate_daily_energy_usage (appliances : Finset String) (hours : List Nat) (h_precond : calculate_daily_energy_usage_precond appliances hours) : Float :=
  -- !benchmark @start code
  -- Calculate total energy usage by converting appliances to list, mapping to power consumption,
    -- converting hours to Float, computing energy per appliance, and summing
    let appliance_list := appliances.toList
    let power_consumptions := appliance_list.map appliance_power_consumption
    let hours_float := hours.map (λ h => Float.ofNat h)
    let energy_per_appliance := List.zipWith (λ power hours => power * hours / 1000.0) power_consumptions hours_float
    energy_per_appliance.foldl (λ acc x => acc + x) 0.0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to calculate total energy usage
noncomputable def calculate_total_energy (appliances : Finset String) (hours : List Nat) : Float :=
  let appliance_list := appliances.toList
  let power_consumptions := appliance_list.map appliance_power_consumption
  let hours_float := hours.map (λ h => Float.ofNat h)
  let energy_per_appliance := List.zipWith (λ power hours => power * hours / 1000.0) power_consumptions hours_float
  energy_per_appliance.foldl (λ acc x => acc + x) 0.0

-- Postcondition definitions
@[reducible, simp]
def calculate_daily_energy_usage_postcond (appliances : Finset String) (hours : List Nat) (result: Float) (h_precond : calculate_daily_energy_usage_precond appliances hours) : Prop :=
  -- !benchmark @start postcond
  -- The result should equal the sum of (power_consumption * hours / 1000) for each appliance
    -- where power_consumption is looked up from appliance_power_consumption
    result = calculate_total_energy appliances hours
  -- !benchmark @end postcond


-- Proof content
theorem calculate_daily_energy_usage_postcond_satisfied (appliances: Finset String) (hours: List Nat) (h_precond : calculate_daily_energy_usage_precond appliances hours) :
    calculate_daily_energy_usage_postcond appliances hours (calculate_daily_energy_usage appliances hours h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof