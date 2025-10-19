import Mathlib

-- Precondition definitions
@[reducible, simp]
def modify_list_precond (athlete : List Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def is_vowel (c : Char) : Bool :=
  c = 'a' || c = 'e' || c = 'i' || c = 'o' || c = 'u' ||
  c = 'A' || c = 'E' || c = 'I' || c = 'O' || c = 'U'

-- Main function definitions
def modify_list (athlete : List Char) (h_precond : modify_list_precond athlete) : Prod (List Char) (List Char) :=
  -- !benchmark @start code
  let shuffled := List.permutations athlete |>.head? |>.getD []
  let vowel_list := List.filter is_vowel athlete
  (shuffled, vowel_list)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_permutation (l1 l2 : List Char) : Prop :=
  ∀ (c : Char), List.count c l1 = List.count c l2

def vowels_in_order (original vowels : List Char) : Prop :=
  vowels = List.filter is_vowel original

-- Postcondition definitions
@[reducible, simp]
def modify_list_postcond (athlete : List Char) (result: Prod (List Char) (List Char)) (h_precond : modify_list_precond athlete) : Prop :=
  -- !benchmark @start postcond
  let shuffled := result.1
  let vowel_list := result.2
  is_permutation athlete shuffled ∧ vowels_in_order athlete vowel_list
  -- !benchmark @end postcond


-- Proof content
theorem modify_list_postcond_satisfied (athlete: List Char) (h_precond : modify_list_precond athlete) :
    modify_list_postcond athlete (modify_list athlete h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof