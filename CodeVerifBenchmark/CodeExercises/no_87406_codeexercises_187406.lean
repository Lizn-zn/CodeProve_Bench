import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_common_elements_precond (electrical_appliances : List α) (tools : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_common_elements [BEq α] (electrical_appliances : List α) (tools : List α) (h_precond : find_common_elements_precond (electrical_appliances) (tools)) : List α :=
  -- !benchmark @start code
  electrical_appliances.filter (λ x => tools.contains x)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_common_element (x : α) (electrical_appliances : List α) (tools : List α) : Prop :=
  x ∈ electrical_appliances ∧ x ∈ tools

-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond (electrical_appliances : List α) (tools : List α) (result: List α) (h_precond : find_common_elements_precond (electrical_appliances) (tools)) : Prop :=
  -- !benchmark @start postcond
  ∀ x : α, x ∈ result ↔ is_common_element x electrical_appliances tools
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied [BEq α] (electrical_appliances: List α) (tools: List α) (h_precond : find_common_elements_precond (electrical_appliances) (tools)) :
    find_common_elements_postcond (electrical_appliances) (tools) (find_common_elements (electrical_appliances) (tools) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof