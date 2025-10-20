import Mathlib

namespace no_73015_codeexercises_173015


-- Precondition auxiliary definitions
structure PatientData where
  sessions : List Nat
  threshold : Nat

def patient_database : String → Option PatientData := λ name =>
  match name with
  | "Alice" => some ⟨[85, 92, 78, 95, 88], 80⟩
  | "Bob" => some ⟨[75, 82, 79, 88, 91], 85⟩
  | "Charlie" => some ⟨[90, 87, 93, 85, 89], 85⟩
  | _ => none

-- Precondition definitions
@[reducible, simp]
def evaluate_patient_progress_precond (patient_name : String) (duration : Nat) : Prop :=
  -- !benchmark @start precond
  ∃ data, patient_database patient_name = some data ∧ duration ≤ data.sessions.length
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def evaluate_patient_progress (patient_name : String) (duration : Nat) (h_precond : evaluate_patient_progress_precond (patient_name) (duration)) : Nat :=
  -- !benchmark @start code
  match h : patient_database patient_name with
  | some data => 
    let sessions := data.sessions.take duration
    sessions.filter (λ score => score > data.threshold) |>.length
  | none => by
    exfalso
    rcases h_precond with ⟨data, h', _⟩
    rw [h] at h'
    simp at h'
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_successful_sessions (sessions : List Nat) (threshold : Nat) (duration : Nat) : Nat :=
  (sessions.take duration).filter (λ score => score > threshold) |>.length

-- Postcondition definitions
@[reducible, simp]
def evaluate_patient_progress_postcond (patient_name : String) (duration : Nat) (result: Nat) (h_precond : evaluate_patient_progress_precond (patient_name) (duration)) : Prop :=
  -- !benchmark @start postcond
  match patient_database patient_name with
  | some data => result = count_successful_sessions data.sessions data.threshold duration
  | none => False
  -- !benchmark @end postcond


-- Proof content
theorem evaluate_patient_progress_postcond_satisfied (patient_name: String) (duration: Nat) (h_precond : evaluate_patient_progress_precond (patient_name) (duration)) :
    evaluate_patient_progress_postcond (patient_name) (duration) (evaluate_patient_progress (patient_name) (duration) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_73015_codeexercises_173015