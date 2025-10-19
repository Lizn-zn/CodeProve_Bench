import Mathlib

-- Precondition definitions
@[reducible, simp]
def update_balance_precond (accounts : List Nat) (index : Nat) (amount : Int) : Prop :=
  -- !benchmark @start precond
  index < accounts.length
  -- !benchmark @end precond


-- Code auxiliary definitions
def update_at_index (l : List Nat) (i : Nat) (v : Nat) : List Nat :=
  match l, i with
  | [], _ => []
  | x :: xs, 0 => v :: xs
  | x :: xs, i+1 => x :: update_at_index xs i v

theorem update_at_index_length (l : List Nat) (i : Nat) (v : Nat) : 
  (update_at_index l i v).length = l.length := by
  induction' l with hd tl IH generalizing i
  · simp [update_at_index]
  · cases i
    · simp [update_at_index]
    · simp [update_at_index, IH]

-- Main function definitions
def update_balance (accounts : List Nat) (index : Nat) (amount : Int) (h_precond : update_balance_precond (accounts) (index) (amount)) : List Nat :=
  -- !benchmark @start code
  let current_balance := (accounts.get? index).getD 0
  let new_balance := current_balance + Int.toNat amount
  update_at_index accounts index new_balance
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def update_at_index_post (l : List Nat) (i : Nat) (v : Nat) : List Nat :=
  match l, i with
  | [], _ => []
  | x :: xs, 0 => v :: xs
  | x :: xs, i+1 => x :: update_at_index_post xs i v

-- Postcondition definitions
@[reducible, simp]
def update_balance_postcond (accounts : List Nat) (index : Nat) (amount : Int) (result: List Nat) (h_precond : update_balance_precond (accounts) (index) (amount)) : Prop :=
  -- !benchmark @start postcond
  result = update_at_index_post accounts index ((accounts.get? index).getD 0 + Int.toNat amount) ∧
  result.length = accounts.length
  -- !benchmark @end postcond


-- Proof content
theorem update_balance_postcond_satisfied (accounts: List Nat) (index: Nat) (amount: Int) (h_precond : update_balance_precond (accounts) (index) (amount)) :
    update_balance_postcond (accounts) (index) (amount) (update_balance (accounts) (index) (amount) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof