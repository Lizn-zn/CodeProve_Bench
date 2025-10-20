import Mathlib

namespace no_8364_syn_1_iter_8364


-- Precondition definitions
@[reducible, simp]
def generate_pairs_and_sign_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def generate_pairs_and_sign (n : Int) (h_precond : generate_pairs_and_sign_precond n) : Prod (List (Prod Nat Nat)) (List Char) :=
  -- !benchmark @start code
  let abs_n := Int.toNat (Int.natAbs n)
  let pairs : List (Prod Nat Nat) := 
    (List.range (abs_n + 1)).map (λ a => (a, abs_n - a))
  let sign_char : List Char := 
    match n with
    | Int.ofNat 0 => ['Z']
    | Int.ofNat (_ + 1) => ['P']
    | Int.negSucc _ => ['N']
  (pairs, sign_char)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def generate_pairs_and_sign_aux (n : Int) : Prod (List (Prod Nat Nat)) (List Char) :=
  let abs_n := Int.toNat (Int.natAbs n)
  let pairs : List (Prod Nat Nat) := 
    (List.range (abs_n + 1)).map (λ a => (a, abs_n - a))
  let sign_char : List Char := 
    match n with
    | Int.ofNat 0 => ['Z']
    | Int.ofNat (_ + 1) => ['P']
    | Int.negSucc _ => ['N']
  (pairs, sign_char)

-- Postcondition definitions
@[reducible, simp]
def generate_pairs_and_sign_postcond (n : Int) (result: Prod (List (Prod Nat Nat)) (List Char)) (h_precond : generate_pairs_and_sign_precond n) : Prop :=
  -- !benchmark @start postcond
  result = generate_pairs_and_sign_aux n
  -- !benchmark @end postcond


-- Proof content
theorem generate_pairs_and_sign_postcond_satisfied (n: Int) (h_precond : generate_pairs_and_sign_precond n) :
    generate_pairs_and_sign_postcond n (generate_pairs_and_sign n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_8364_syn_1_iter_8364