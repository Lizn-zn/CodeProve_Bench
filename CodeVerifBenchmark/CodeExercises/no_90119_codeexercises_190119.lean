import Mathlib

namespace no_90119_codeexercises_190119


-- Precondition definitions
@[reducible, simp]
def find_gene_length_precond (gene_sequence : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple task

-- Main function definitions
def find_gene_length (gene_sequence : String) (h_precond : find_gene_length_precond (gene_sequence)) : Nat :=
  -- !benchmark @start code
  gene_sequence.foldl (fun length _ => length + 1) 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def find_gene_length_postcond (gene_sequence : String) (result: Nat) (h_precond : find_gene_length_precond (gene_sequence)) : Prop :=
  -- !benchmark @start postcond
  result = gene_sequence.length
  -- !benchmark @end postcond


-- Proof content
theorem find_gene_length_postcond_satisfied (gene_sequence: String) (h_precond : find_gene_length_precond (gene_sequence)) :
    find_gene_length_postcond (gene_sequence) (find_gene_length (gene_sequence) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_90119_codeexercises_190119