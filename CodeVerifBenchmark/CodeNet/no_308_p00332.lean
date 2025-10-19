import Mathlib

-- Precondition definitions
@[reducible, simp]
def convertYear_precond (E : Nat) (Y : Nat) : Prop :=
  -- !benchmark @start precond
  (E = 0 ∧ 1868 ≤ Y ∧ Y ≤ 2016) ∨
    (E = 1 ∧ 1 ≤ Y ∧ Y ≤ 44) ∨
    (E = 2 ∧ 1 ≤ Y ∧ Y ≤ 14) ∨
    (E = 3 ∧ 1 ≤ Y ∧ Y ≤ 63) ∨
    (E = 4 ∧ 1 ≤ Y ∧ Y ≤ 28)
  -- !benchmark @end precond


-- Main function definitions
def convertYear (E : Nat) (Y : Nat) (h_precond : convertYear_precond (E) (Y)) : String :=
  -- !benchmark @start code
  if E = 0 then
      -- Convert from Western calendar to Japanese calendar
      if Y < 1912 then
        "M" ++ toString (Y - 1867)
      else if Y < 1926 then
        "T" ++ toString (Y - 1911)
      else if Y < 1989 then
        "S" ++ toString (Y - 1925)
      else
        "H" ++ toString (Y - 1988)
    else if E = 1 then
      -- Meiji to Western
      toString (1867 + Y)
    else if E = 2 then
      -- Taisho to Western
      toString (1911 + Y)
    else if E = 3 then
      -- Showa to Western
      toString (1925 + Y)
    else
      -- Heisei to Western (E = 4)
      toString (1988 + Y)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def convertYear_postcond (E : Nat) (Y : Nat) (result: String) (h_precond : convertYear_precond (E) (Y)) : Prop :=
  -- !benchmark @start postcond
  -- Convert from Western calendar to Japanese calendar
    (E = 0 ∧ Y < 1912 ∧ result = "M" ++ toString (Y - 1867)) ∨
    (E = 0 ∧ 1912 ≤ Y ∧ Y < 1926 ∧ result = "T" ++ toString (Y - 1911)) ∨
    (E = 0 ∧ 1926 ≤ Y ∧ Y < 1989 ∧ result = "S" ++ toString (Y - 1925)) ∨
    (E = 0 ∧ 1989 ≤ Y ∧ Y ≤ 2016 ∧ result = "H" ++ toString (Y - 1988)) ∨
    -- Convert from Japanese calendar to Western calendar
    (E = 1 ∧ result = toString (1867 + Y)) ∨
    (E = 2 ∧ result = toString (1911 + Y)) ∨
    (E = 3 ∧ result = toString (1925 + Y)) ∨
    (E = 4 ∧ result = toString (1988 + Y))
  -- !benchmark @end postcond


-- Proof content
theorem convertYear_postcond_satisfied (E: Nat) (Y: Nat) (h_precond : convertYear_precond (E) (Y)) :
    convertYear_postcond (E) (Y) (convertYear (E) (Y) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

