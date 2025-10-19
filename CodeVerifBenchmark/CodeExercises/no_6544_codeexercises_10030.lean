import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def find_gene_precond (sequence : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Define stop codons as a set for easy checking
def stop_codons : Set String := {"TAA", "TAG", "TGA"}

-- Helper function to check if a substring exists starting at position i
def has_substring_at (s : String) (i : Nat) (sub : String) : Bool :=
  let pos_i : String.Pos := ⟨i⟩
  let pos_end : String.Pos := ⟨i + sub.length⟩
  pos_end ≤ s.endPos ∧ s.extract pos_i pos_end = sub

-- Helper function to find the first occurrence of a stop codon starting from position j
def find_stop_codon (s : String) (j : Nat) : Option Nat :=
  if j + 3 > s.length then
    none
  else
    let pos_j : String.Pos := ⟨j⟩
    let pos_end : String.Pos := ⟨j + 3⟩
    let codon := s.extract pos_j pos_end
    if codon = "TAA" || codon = "TAG" || codon = "TGA" then
      some j
    else
      find_stop_codon s (j + 1)
termination_by s.length - j

-- Helper function to find the first occurrence of a gene starting from position i
def find_gene_from (sequence : String) (i : Nat) : Option Nat :=
  if i + 3 > sequence.length then
    none
  else
    let pos_i : String.Pos := ⟨i⟩
    let pos_end : String.Pos := ⟨i + 3⟩
    let codon := sequence.extract pos_i pos_end
    if codon = "ATG" then
      let remaining := sequence.drop (i + 3)
      let stop_pos := find_stop_codon remaining 0
      match stop_pos with
      | some pos => some i
      | none => find_gene_from sequence (i + 1)
    else
      find_gene_from sequence (i + 1)
termination_by sequence.length - i

-- Main function definitions
def find_gene (sequence : String) (h_precond : find_gene_precond (sequence)) : Int :=
  -- !benchmark @start code
  match find_gene_from sequence 0 with
  | some idx => Int.ofNat idx
  | none => (-1 : Int)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Define stop codons as a set for easy checking
def stop_codons_post : Set String := {"TAA", "TAG", "TGA"}

-- Helper function to check if a substring exists starting at position i
def has_substring_at_post (s : String) (i : Nat) (sub : String) : Prop :=
  let pos_i : String.Pos := ⟨i⟩
  let pos_end : String.Pos := ⟨i + sub.length⟩
  pos_end ≤ s.endPos ∧ s.extract pos_i pos_end = sub

-- Helper function to find the first occurrence of a stop codon starting from position j
def find_stop_codon_post (s : String) (j : Nat) : Option Nat :=
  if j + 3 > s.length then
    none
  else
    let pos_j : String.Pos := ⟨j⟩
    let pos_end : String.Pos := ⟨j + 3⟩
    let codon := s.extract pos_j pos_end
    -- Use explicit equality checks instead of set membership for decidability
    if codon = "TAA" || codon = "TAG" || codon = "TGA" then
      some j
    else
      find_stop_codon_post s (j + 1)
termination_by s.length - j

-- Helper function to find the first occurrence of a gene starting from position i
def find_gene_from_post (sequence : String) (i : Nat) : Option Nat :=
  if i + 3 > sequence.length then
    none
  else
    let pos_i : String.Pos := ⟨i⟩
    let pos_end : String.Pos := ⟨i + 3⟩
    let codon := sequence.extract pos_i pos_end
    if codon = "ATG" then
      let remaining := sequence.drop (i + 3)
      let stop_pos := find_stop_codon_post remaining 0
      match stop_pos with
      | some pos => some i
      | none => find_gene_from_post sequence (i + 1)
    else
      find_gene_from_post sequence (i + 1)
termination_by sequence.length - i

-- Postcondition definitions
@[reducible, simp]
def find_gene_postcond (sequence : String) (result: Int) (h_precond : find_gene_precond (sequence)) : Prop :=
  -- !benchmark @start postcond
  match find_gene_from_post sequence 0 with
  | some idx => result = Int.ofNat idx
  | none => result = (-1 : Int)
  -- !benchmark @end postcond


-- Proof content
theorem find_gene_postcond_satisfied (sequence: String) (h_precond : find_gene_precond (sequence)) :
    find_gene_postcond (sequence) (find_gene (sequence) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof