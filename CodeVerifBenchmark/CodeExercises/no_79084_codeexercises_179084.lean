import Mathlib

-- Precondition definitions
@[reducible, simp]
def check_real_and_imaginary_parts_precond (complex_num : ℂ) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this function

-- Main function definitions
noncomputable def check_real_and_imaginary_parts (complex_num : ℂ) (h_precond : check_real_and_imaginary_parts_precond complex_num) : String :=
  -- !benchmark @start code
  let real_zero : Bool := complex_num.re = 0
  let imag_zero : Bool := complex_num.im = 0
  match real_zero, imag_zero with
  | true, true => "Both real and imaginary parts are zero."
  | false, true => "Only imaginary part is zero."
  | true, false => "Only real part is zero."
  | false, false => "Neither real nor imaginary parts are zero."
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def check_real_and_imaginary_parts_postcond (complex_num : ℂ) (result: String) (h_precond : check_real_and_imaginary_parts_precond complex_num) : Prop :=
  -- !benchmark @start postcond
  if complex_num.re = 0 then
    if complex_num.im = 0 then
      result = "Both real and imaginary parts are zero."
    else
      result = "Only real part is zero."
  else
    if complex_num.im = 0 then
      result = "Only imaginary part is zero."
    else
      result = "Neither real nor imaginary parts are zero."
  -- !benchmark @end postcond


-- Proof content
theorem check_real_and_imaginary_parts_postcond_satisfied (complex_num: ℂ) (h_precond : check_real_and_imaginary_parts_precond complex_num) :
    check_real_and_imaginary_parts_postcond complex_num (check_real_and_imaginary_parts complex_num h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof