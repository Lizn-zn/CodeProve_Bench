import Mathlib

-- Precondition definitions
@[reducible, simp]
def canFormAkihabara_precond (s : String) : Prop :=
  -- !benchmark @start precond
  s.length ≥ 1 ∧ s.length ≤ 50 ∧ s.all (fun c => c.isUpper)
  -- !benchmark @end precond


-- Postcondition auxiliary definitions
-- Helper function to check if a string matches the pattern A?KIHA?BA?RA?
def matchesAkihabaraPattern (s : String) : Bool :=
  let patterns := [
    "AKIHABARA",
    "KIHABARA",
    "AKIHABRA",
    "AKIHBARA",
    "AKIHABAR",
    "KIHABRA",
    "KIHBARA",
    "KIHABAR",
    "AKIHBRA",
    "AKIHBAR",
    "AKIHABR",
    "KIHBRA",
    "KIHBAR",
    "KIHABR",
    "AKIHBR",
    "KIHBR"
  ]
  patterns.any (fun p => p == s)

-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def canFormAkihabara (s : String) (h_precond : canFormAkihabara_precond (s)) : String :=
  -- !benchmark @start code
  if matchesAkihabaraPattern s then
      "YES"
    else
      "NO"
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def canFormAkihabara_postcond (s : String) (result: String) (h_precond : canFormAkihabara_precond (s)) : Prop :=
  -- !benchmark @start postcond
  (result = "YES" ↔ matchesAkihabaraPattern s) ∧
    (result = "NO" ↔ ¬matchesAkihabaraPattern s) ∧
    (result = "YES" ∨ result = "NO")
  -- !benchmark @end postcond


-- Proof content
theorem canFormAkihabara_postcond_satisfied (s: String) (h_precond : canFormAkihabara_precond (s)) :
    canFormAkihabara_postcond (s) (canFormAkihabara (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof