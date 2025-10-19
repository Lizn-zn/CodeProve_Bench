import Mathlib

-- Precondition auxiliary definitions
inductive Tuple (α : Type) : Type
  | nil : Tuple α
  | cons (head : α) (tail : Tuple α) : Tuple α

namespace Tuple

def toList : Tuple α → List α
  | nil => []
  | cons h t => h :: toList t

def ofList : List α → Tuple α
  | [] => nil
  | h :: t => cons h (ofList t)

def length : Tuple α → Nat
  | nil => 0
  | cons _ t => 1 + length t

def get? : Tuple α → Nat → Option α
  | nil, _ => none
  | cons h _, 0 => some h
  | cons _ t, n+1 => get? t n

def filter (p : α → Bool) : Tuple α → Tuple α
  | nil => nil
  | cons h t => if p h then cons h (filter p t) else filter p t

end Tuple

-- Precondition definitions
@[reducible, simp]
def filter_even_numbers_from_tuple_precond (tuple : Tuple Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def is_even (n : Nat) : Bool := n % 2 = 0

-- Main function definitions
def filter_even_numbers_from_tuple (tuple : Tuple Nat) (h_precond : filter_even_numbers_from_tuple_precond tuple) : Tuple Nat :=
  -- !benchmark @start code
  Tuple.filter is_even tuple
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- is_even is already defined above

-- Postcondition definitions
@[reducible, simp]
def filter_even_numbers_from_tuple_postcond (tuple : Tuple Nat) (result: Tuple Nat) (h_precond : filter_even_numbers_from_tuple_precond tuple) : Prop :=
  -- !benchmark @start postcond
  result = Tuple.filter is_even tuple
  -- !benchmark @end postcond


-- Proof content
theorem filter_even_numbers_from_tuple_postcond_satisfied (tuple : Tuple Nat) (h_precond : filter_even_numbers_from_tuple_precond tuple) :
    filter_even_numbers_from_tuple_postcond tuple (filter_even_numbers_from_tuple tuple h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof