import Mathlib

namespace no_16978_codeexercises_26069


-- Precondition definitions
@[reducible, simp]
def sum_of_odds_precond (elements : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def sum_of_odds (elements : List Int) (h_precond : sum_of_odds_precond (elements)) : Int :=
  -- !benchmark @start code
  elements.foldl (λ sum elem => if elem % 2 ≠ 0 then sum + elem else sum) 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_odd (n : Int) : Bool := n % 2 ≠ 0

def sum_odds (elements : List Int) : Int :=
  elements.filter is_odd |>.foldl (· + ·) 0

-- Postcondition definitions
@[reducible, simp]
def sum_of_odds_postcond (elements : List Int) (result: Int) (h_precond : sum_of_odds_precond (elements)) : Prop :=
  -- !benchmark @start postcond
  result = sum_odds elements
  -- !benchmark @end postcond


-- Proof content
theorem sum_of_odds_postcond_satisfied (elements: List Int) (h_precond : sum_of_odds_precond (elements)) :
    sum_of_odds_postcond (elements) (sum_of_odds (elements) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_16978_codeexercises_26069