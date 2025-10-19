import Mathlib

-- Precondition auxiliary definitions
inductive Symptom : Type where
  | fever
  | cough
  | headache
  | fatigue
  | nausea
  | rash
  | sore_throat
  | shortness_of_breath
  | chest_pain
  | dizziness

def symptomToString : Symptom → String
  | .fever => "fever"
  | .cough => "cough"
  | .headache => "headache"
  | .fatigue => "fatigue"
  | .nausea => "nausea"
  | .rash => "rash"
  | .sore_throat => "sore_throat"
  | .shortness_of_breath => "shortness_of_breath"
  | .chest_pain => "chest_pain"
  | .dizziness => "dizziness"

def validSymptom (s : String) : Bool :=
  match s with
  | "fever" | "cough" | "headache" | "fatigue" | "nausea" | "rash" | "sore_throat" | "shortness_of_breath" | "chest_pain" | "dizziness" => true
  | _ => false

-- Precondition definitions
@[reducible, simp]
def evaluate_patient_symptoms_precond (symptoms : List String) : Prop :=
  -- !benchmark @start precond
  ∀ s ∈ symptoms, validSymptom s
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to check if a symptom is in the list
def hasSymptomBool (symptoms : List String) (symptom : String) : Bool :=
  symptom ∈ symptoms

-- Helper functions for each condition
def isCommonCold (symptoms : List String) : Bool :=
  hasSymptomBool symptoms "cough" ∧ hasSymptomBool symptoms "sore_throat" ∧ hasSymptomBool symptoms "headache"

def isFlu (symptoms : List String) : Bool :=
  hasSymptomBool symptoms "fever" ∧ hasSymptomBool symptoms "cough" ∧ hasSymptomBool symptoms "fatigue"

def isMigraine (symptoms : List String) : Bool :=
  hasSymptomBool symptoms "headache" ∧ hasSymptomBool symptoms "nausea" ∧ hasSymptomBool symptoms "dizziness"

def isAllergicReaction (symptoms : List String) : Bool :=
  hasSymptomBool symptoms "rash" ∧ hasSymptomBool symptoms "shortness_of_breath"

def isHeartProblem (symptoms : List String) : Bool :=
  hasSymptomBool symptoms "chest_pain" ∧ hasSymptomBool symptoms "shortness_of_breath" ∧ hasSymptomBool symptoms "dizziness"

-- Main function definitions
def evaluate_patient_symptoms (symptoms : List String) (h_precond : evaluate_patient_symptoms_precond (symptoms)) : String :=
  -- !benchmark @start code
  if isCommonCold symptoms then
    "Common cold"
  else if isFlu symptoms then
    "Flu"
  else if isMigraine symptoms then
    "Migraine"
  else if isAllergicReaction symptoms then
    "Allergic reaction"
  else if isHeartProblem symptoms then
    "Possible heart problem"
  else
    "No specific diagnosis - please consult a doctor"
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def hasSymptom (symptoms : List String) (symptom : String) : Prop :=
  symptom ∈ symptoms

def commonCold (symptoms : List String) : Prop :=
  hasSymptom symptoms "cough" ∧ hasSymptom symptoms "sore_throat" ∧ hasSymptom symptoms "headache"

def flu (symptoms : List String) : Prop :=
  hasSymptom symptoms "fever" ∧ hasSymptom symptoms "cough" ∧ hasSymptom symptoms "fatigue"

def migraine (symptoms : List String) : Prop :=
  hasSymptom symptoms "headache" ∧ hasSymptom symptoms "nausea" ∧ hasSymptom symptoms "dizziness"

def allergicReaction (symptoms : List String) : Prop :=
  hasSymptom symptoms "rash" ∧ hasSymptom symptoms "shortness_of_breath"

def heartProblem (symptoms : List String) : Prop :=
  hasSymptom symptoms "chest_pain" ∧ hasSymptom symptoms "shortness_of_breath" ∧ hasSymptom symptoms "dizziness"

def noSpecificDiagnosis (symptoms : List String) : Prop :=
  ¬commonCold symptoms ∧ ¬flu symptoms ∧ ¬migraine symptoms ∧ ¬allergicReaction symptoms ∧ ¬heartProblem symptoms

-- Postcondition definitions
@[reducible, simp]
def evaluate_patient_symptoms_postcond (symptoms : List String) (result: String) (h_precond : evaluate_patient_symptoms_precond (symptoms)) : Prop :=
  -- !benchmark @start postcond
  (result = "Common cold" ∧ commonCold symptoms) ∨
  (result = "Flu" ∧ flu symptoms) ∨
  (result = "Migraine" ∧ migraine symptoms) ∨
  (result = "Allergic reaction" ∧ allergicReaction symptoms) ∨
  (result = "Possible heart problem" ∧ heartProblem symptoms) ∨
  (result = "No specific diagnosis - please consult a doctor" ∧ noSpecificDiagnosis symptoms)
  -- !benchmark @end postcond


-- Proof content
theorem evaluate_patient_symptoms_postcond_satisfied (symptoms: List String) (h_precond : evaluate_patient_symptoms_precond (symptoms)) :
    evaluate_patient_symptoms_postcond (symptoms) (evaluate_patient_symptoms (symptoms) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

