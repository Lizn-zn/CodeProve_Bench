import Mathlib

-- Precondition definitions
@[reducible, simp]
def create_empty_lists_and_complex_conjugate_precond (pixels : List (List ℂ)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def create_empty_lists_and_complex_conjugate (pixels : List (List ℂ)) (h_precond : create_empty_lists_and_complex_conjugate_precond (pixels)) : List (List (ℂ × (List Unit))) :=
  -- !benchmark @start code
  pixels.map (λ row => row.map (λ pixel => (star pixel, [])))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def complex_conjugate (c : ℂ) : ℂ :=
  ⟨c.re, -c.im⟩

def create_empty_lists_and_complex_conjugate_expected (pixels : List (List ℂ)) : List (List (ℂ × (List Unit))) :=
  pixels.map (λ row => row.map (λ pixel => (complex_conjugate pixel, [])))

-- Postcondition definitions
@[reducible, simp]
def create_empty_lists_and_complex_conjugate_postcond (pixels : List (List ℂ)) (result: List (List (ℂ × (List Unit)))) (h_precond : create_empty_lists_and_complex_conjugate_precond (pixels)) : Prop :=
  -- !benchmark @start postcond
  result = create_empty_lists_and_complex_conjugate_expected pixels
  -- !benchmark @end postcond


-- Proof content
theorem create_empty_lists_and_complex_conjugate_postcond_satisfied (pixels: List (List ℂ)) (h_precond : create_empty_lists_and_complex_conjugate_precond (pixels)) :
    create_empty_lists_and_complex_conjugate_postcond (pixels) (create_empty_lists_and_complex_conjugate (pixels) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof