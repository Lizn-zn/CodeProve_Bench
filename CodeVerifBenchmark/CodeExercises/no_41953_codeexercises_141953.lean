import Mathlib

namespace no_41953_codeexercises_141953


-- Precondition auxiliary definitions
inductive Nucleotide : Type
  | A : Nucleotide
  | C : Nucleotide
  | G : Nucleotide
  | T : Nucleotide

def Nucleotide.toChar : Nucleotide → Char
  | A => 'A'
  | C => 'C'
  | G => 'G'
  | T => 'T'

def validDNAChar (c : Char) : Prop :=
  c = 'A' ∨ c = 'C' ∨ c = 'G' ∨ c = 'T'

-- Precondition definitions
@[reducible, simp]
def get_dna_base_composition_precond (dna_sequence : String) : Prop :=
  -- !benchmark @start precond
  ∀ (c : Char), c ∈ dna_sequence.data → validDNAChar c
  -- !benchmark @end precond


-- Code auxiliary definitions
def countOccurrencesInString (s : String) (target : Char) : Nat :=
  s.foldl (λ count c => if c = target then count + 1 else count) 0

-- Main function definitions
def get_dna_base_composition (dna_sequence : String) (h_precond : get_dna_base_composition_precond (dna_sequence)) : List (Nat × Char) :=
  -- !benchmark @start code
  let countA := countOccurrencesInString dna_sequence 'A'
  let countC := countOccurrencesInString dna_sequence 'C'
  let countG := countOccurrencesInString dna_sequence 'G'
  let countT := countOccurrencesInString dna_sequence 'T'
  [(countA, 'A'), (countC, 'C'), (countG, 'G'), (countT, 'T')]
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def countOccurrences (s : String) (nuc : Nucleotide) : Nat :=
  s.foldl (λ count c => if c = nuc.toChar then count + 1 else count) 0

def expectedResult (s : String) : List (Nat × Char) :=
  [ (countOccurrences s Nucleotide.A, 'A')
  , (countOccurrences s Nucleotide.C, 'C')
  , (countOccurrences s Nucleotide.G, 'G')
  , (countOccurrences s Nucleotide.T, 'T')
  ]

-- Postcondition definitions
@[reducible, simp]
def get_dna_base_composition_postcond (dna_sequence : String) (result: List (Nat × Char)) (h_precond : get_dna_base_composition_precond (dna_sequence)) : Prop :=
  -- !benchmark @start postcond
  result = expectedResult dna_sequence
  -- !benchmark @end postcond


-- Proof content
theorem get_dna_base_composition_postcond_satisfied (dna_sequence: String) (h_precond : get_dna_base_composition_precond (dna_sequence)) :
    get_dna_base_composition_postcond (dna_sequence) (get_dna_base_composition (dna_sequence) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_41953_codeexercises_141953