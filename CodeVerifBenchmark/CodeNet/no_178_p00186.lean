import Mathlib

-- Precondition definitions
@[reducible, simp]
def chickenPurchase_precond (q1 : Nat) (b : Nat) (c1 : Nat) (c2 : Nat) (q2 : Nat) : Prop :=
  -- !benchmark @start precond
  -- All inputs are positive and within valid range (1 to 1,000,000)
    1 ≤ q1 ∧ q1 ≤ 1000000 ∧
    1 ≤ b ∧ b ≤ 1000000 ∧
    1 ≤ c1 ∧ c1 ≤ 1000000 ∧
    1 ≤ c2 ∧ c2 ≤ 1000000 ∧
    1 ≤ q2 ∧ q2 ≤ 1000000
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to find the maximum amount of Aizu chicken that can be bought
-- while still being able to meet the total requirement q1
partial def findMaxAizuChicken (q1 : Nat) (b : Nat) (c1 : Nat) (c2 : Nat) (q2 : Nat) (jq : Nat) : Option Nat :=
  if jq = 0 then
    none
  else
    let cost := jq * c1
    if cost > b then
      findMaxAizuChicken q1 b c1 c2 q2 (jq - 1)
    else
      let remaining := b - cost
      let cq := remaining / c2
      if jq + cq >= q1 then
        some jq
      else
        findMaxAizuChicken q1 b c1 c2 q2 (jq - 1)

-- Main function definitions
def chickenPurchase (q1 : Nat) (b : Nat) (c1 : Nat) (c2 : Nat) (q2 : Nat) (h_precond : chickenPurchase_precond (q1) (b) (c1) (c2) (q2)) : Option (Nat × Nat) :=
  -- !benchmark @start code
  -- Check if we can afford any Aizu chicken at all
    if b < c1 then
      none
    else
      -- Calculate the maximum Aizu chicken we could theoretically buy
      let jideal := b / c1
      let jqmax := min jideal q2
      
      if jqmax = 0 then
        none
      else
        -- Try to find the maximum amount of Aizu chicken that allows us to meet q1
        match findMaxAizuChicken q1 b c1 c2 q2 jqmax with
        | none => none
        | some jq =>
          let remaining := b - jq * c1
          let cq := remaining / c2
          some (jq, cq)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def chickenPurchase_postcond (q1 : Nat) (b : Nat) (c1 : Nat) (c2 : Nat) (q2 : Nat) (result: Option (Nat × Nat)) (h_precond : chickenPurchase_precond (q1) (b) (c1) (c2) (q2)) : Prop :=
  -- !benchmark @start postcond
  match result with
    | none => 
      -- "NA" case: cannot satisfy mother's instructions
      -- Either cannot afford any Aizu chicken, or cannot buy enough total meat
      (b < c1) ∨ 
      (∀ jq : Nat, 1 ≤ jq → jq ≤ q2 → jq * c1 ≤ b → 
        let remaining := b - jq * c1
        let cq := remaining / c2
        jq + cq < q1)
    | some (jq, cq) =>
      -- Valid purchase case
      -- 1. Must buy at least 1 unit of Aizu chicken (required by instructions)
      1 ≤ jq ∧
      -- 2. Cannot exceed the per-person limit for Aizu chicken
      jq ≤ q2 ∧
      -- 3. Total cost must not exceed budget
      jq * c1 + cq * c2 ≤ b ∧
      -- 4. Total amount must meet minimum requirement
      jq + cq ≥ q1 ∧
      -- 5. Aizu chicken amount is maximized within budget and limit
      (∀ jq' : Nat, jq' > jq → jq' ≤ q2 → jq' * c1 ≤ b →
        let remaining' := b - jq' * c1
        let cq' := remaining' / c2
        jq' + cq' < q1) ∧
      -- 6. Regular chicken is maximized with remaining budget
      cq = (b - jq * c1) / c2 ∧
      -- 7. This is the optimal solution (maximum Aizu chicken that allows meeting q1)
      (jq * c1 ≤ b) ∧
      (∀ jq' : Nat, jq' < jq → 1 ≤ jq' → jq' ≤ q2 → jq' * c1 ≤ b →
        let remaining' := b - jq' * c1
        let cq' := remaining' / c2
        jq' + cq' ≥ q1 → False)
  -- !benchmark @end postcond


-- Proof content
theorem chickenPurchase_postcond_satisfied (q1: Nat) (b: Nat) (c1: Nat) (c2: Nat) (q2: Nat) (h_precond : chickenPurchase_precond (q1) (b) (c1) (c2) (q2)) :
    chickenPurchase_postcond (q1) (b) (c1) (c2) (q2) (chickenPurchase (q1) (b) (c1) (c2) (q2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

