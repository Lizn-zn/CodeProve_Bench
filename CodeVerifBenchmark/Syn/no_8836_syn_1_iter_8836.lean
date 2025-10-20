import Mathlib

namespace no_8836_syn_1_iter_8836


-- Precondition definitions
@[reducible, simp]
def find_valid_integers_precond (c : Char) (n : Int) (lst : List (Nat × Nat)) (arr : Array (Array Int)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def asciiValue (c : Char) : Int :=
  c.toNat

def appearsInPairs (x : Int) (lst : List (Nat × Nat)) : Bool :=
  lst.any (λ p => p.1 = x.toNat)

def appearsInArray (x : Int) (arr : Array (Array Int)) : Bool :=
  arr.any (λ inner => inner.contains x)

-- Main function definitions
def find_valid_integers (c : Char) (n : Int) (lst : List (Nat × Nat)) (arr : Array (Array Int)) (h_precond : find_valid_integers_precond c n lst arr) : Set Int :=
  -- !benchmark @start code
  let ascii_val := asciiValue c
  let valid_ascii_divisor := ascii_val ≠ 0
    
  -- Get all first elements from pairs in lst
  let first_elements : Set Int := 
    lst.foldl (λ s p => s.insert (Int.ofNat p.1)) (∅ : Set Int)
    
  -- Get all integers from the 2D array
  let array_integers : Set Int :=
    arr.foldl (λ s inner => 
      inner.foldl (λ s' x => s'.insert x) s
    ) (∅ : Set Int)
    
  -- Filter integers that satisfy all conditions
  {x | x ∈ first_elements ∧ 
       x > n ∧ 
       (¬valid_ascii_divisor ∨ x % ascii_val = 0) ∧ 
       appearsInArray x arr}
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def asciiValue_post (c : Char) : Int :=
  c.toNat

def appearsInPairs_post (x : Int) (lst : List (Nat × Nat)) : Prop :=
  ∃ (p : Nat × Nat) (h : p ∈ lst), p.1 = x.toNat

def appearsInArray_post (x : Int) (arr : Array (Array Int)) : Prop :=
  ∃ (inner : Array Int) (h : inner ∈ arr), x ∈ inner

-- Postcondition definitions
@[reducible, simp]
def find_valid_integers_postcond (c : Char) (n : Int) (lst : List (Nat × Nat)) (arr : Array (Array Int)) (result: Set Int) (h_precond : find_valid_integers_precond c n lst arr) : Prop :=
  -- !benchmark @start postcond
  let ascii_val := asciiValue_post c
  let valid_ascii_divisor := ascii_val ≠ 0
  ∀ x : Int, 
    x ∈ result ↔ 
      (x > n ∧ 
       (valid_ascii_divisor → x % ascii_val = 0) ∧ 
       appearsInPairs_post x lst ∧ 
       appearsInArray_post x arr)
  -- !benchmark @end postcond


-- Proof content
theorem find_valid_integers_postcond_satisfied (c: Char) (n: Int) (lst: List (Nat × Nat)) (arr: Array (Array Int)) (h_precond : find_valid_integers_precond c n lst arr) :
    find_valid_integers_postcond c n lst arr (find_valid_integers c n lst arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_8836_syn_1_iter_8836