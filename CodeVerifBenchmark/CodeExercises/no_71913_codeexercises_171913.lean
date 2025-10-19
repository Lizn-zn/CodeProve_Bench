import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_duplicate_genes_precond (gene_list : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def count_occurrences (gene_list : List String) (gene : String) : Nat :=
  gene_list.filter (λ g => g = gene) |>.length

def is_duplicate (gene_list : List String) (gene : String) : Bool :=
  count_occurrences gene_list gene > 1

-- Main function definitions
def find_duplicate_genes (gene_list : List String) (h_precond : find_duplicate_genes_precond (gene_list)) : Set String :=
  -- !benchmark @start code
  let duplicates := gene_list.filter (λ gene => is_duplicate gene_list gene) |>.toFinset
  duplicates
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_occurrences_post (gene_list : List String) (gene : String) : Nat :=
  gene_list.filter (λ g => g = gene) |>.length

def is_duplicate_post (gene_list : List String) (gene : String) : Prop :=
  count_occurrences_post gene_list gene > 1

-- Postcondition definitions
@[reducible, simp]
def find_duplicate_genes_postcond (gene_list : List String) (result: Set String) (h_precond : find_duplicate_genes_precond (gene_list)) : Prop :=
  -- !benchmark @start postcond
  ∀ gene, gene ∈ result ↔ is_duplicate_post gene_list gene
  -- !benchmark @end postcond


-- Proof content
theorem find_duplicate_genes_postcond_satisfied (gene_list: List String) (h_precond : find_duplicate_genes_precond (gene_list)) :
    find_duplicate_genes_postcond (gene_list) (find_duplicate_genes (gene_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof