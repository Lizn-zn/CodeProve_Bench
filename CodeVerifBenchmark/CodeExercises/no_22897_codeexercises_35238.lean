import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_common_modulus_precond (physician1 : String) (physician2 : String) : Prop :=
  -- !benchmark @start precond
  physician1.length > 0 ∧ physician2.length > 0 ∧
  physician1.all (λ c => c.isDigit) ∧ physician2.all (λ c => c.isDigit)
  -- !benchmark @end precond


-- Code auxiliary definitions
def commonDivisors (n m : Nat) : List Nat :=
  List.filter (λ d => n % d = 0 ∧ m % d = 0) ((List.range (Nat.min n m + 1)).tail?.getD [])

-- Main function definitions
def find_common_modulus (physician1 : String) (physician2 : String) (h_precond : find_common_modulus_precond (physician1) (physician2)) : List Nat :=
  -- !benchmark @start code
  let id1 := physician1.toNat?
    let id2 := physician2.toNat?
    match id1, id2 with
    | some n1, some n2 => commonDivisors n1 n2
    | none, _ => []
    | _, none => []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def divisors (n : Nat) : List Nat :=
  List.filter (λ d => n % d = 0) ((List.range (n + 1)).tail?.getD [])

def commonDivisorsPost (n m : Nat) : List Nat :=
  List.filter (λ d => n % d = 0 ∧ m % d = 0) ((List.range (Nat.min n m + 1)).tail?.getD [])

-- Postcondition definitions
@[reducible, simp]
def find_common_modulus_postcond (physician1 : String) (physician2 : String) (result: List Nat) (h_precond : find_common_modulus_precond (physician1) (physician2)) : Prop :=
  -- !benchmark @start postcond
  let id1 := physician1.toNat?
  let id2 := physician2.toNat?
  match id1, id2 with
  | some n1, some n2 => result = commonDivisorsPost n1 n2
  | _, _ => False
  -- !benchmark @end postcond


-- Proof content
theorem find_common_modulus_postcond_satisfied (physician1: String) (physician2: String) (h_precond : find_common_modulus_precond (physician1) (physician2)) :
    find_common_modulus_postcond (physician1) (physician2) (find_common_modulus (physician1) (physician2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof