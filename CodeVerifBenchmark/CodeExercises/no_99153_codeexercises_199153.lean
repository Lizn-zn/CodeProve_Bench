import Mathlib

namespace no_99153_codeexercises_199153


-- Precondition definitions
@[reducible, simp]
def find_prime_numbers_precond (start : Nat) (end_bound : Nat) : Prop :=
  -- !benchmark @start precond
  start ≤ end_bound
  -- !benchmark @end_bound precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_prime_numbers (start : Nat) (end_bound : Nat) (h_precond : find_prime_numbers_precond start end_bound) : List Nat :=
  -- !benchmark @start code
  -- Filter numbers in the range [start, end_bound] that are prime
    let candidates := List.range (end_bound + 1)
    candidates.filter (λ n => 
      if n < start then false
      else if n < 2 then false
      else
        let sqrt_n := Nat.sqrt n
        -- Check divisibility by numbers from 2 to sqrt(n)
        (List.range (sqrt_n + 1)).all (λ k => 
          if k < 2 then true
          else ¬(k ∣ n)
        )
    )
  -- !benchmark @end_bound code


-- Postcondition auxiliary definitions
def is_prime (n : Nat) : Prop :=
  n ≥ 2 ∧ ∀ (k : Nat), 2 ≤ k → k < n → ¬ (k ∣ n)

def is_prime_bool (n : Nat) : Bool :=
  if n < 2 then false
  else
    let sqrt_n := Nat.sqrt n
    (List.range (sqrt_n + 1)).all (λ k => 
      if k < 2 then true
      else ¬(k ∣ n)
    )

def primes_in_range (start end_bound : Nat) : List Nat :=
  (List.range (end_bound + 1)).filter (λ x => x ≥ start ∧ is_prime_bool x)

-- Postcondition definitions
@[reducible, simp]
def find_prime_numbers_postcond (start : Nat) (end_bound : Nat) (result: List Nat) (h_precond : find_prime_numbers_precond start end_bound) : Prop :=
  -- !benchmark @start postcond
  result = primes_in_range start end_bound
  -- !benchmark @end_bound postcond


-- Proof content
theorem find_prime_numbers_postcond_satisfied (start: Nat) (end_bound: Nat) (h_precond : find_prime_numbers_precond start end_bound) :
    find_prime_numbers_postcond start end_bound (find_prime_numbers start end_bound h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end_bound proof

end no_99153_codeexercises_199153