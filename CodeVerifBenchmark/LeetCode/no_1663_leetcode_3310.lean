import Mathlib

-- Precondition auxiliary definitions
/-- The set of all methods that are suspicious, i.e. method `k` and all methods it invokes directly or indirectly. -/
def suspiciousMethods (n : Nat) (k : Nat) (invocations : List (Nat × Nat)) : List Nat :=
  let invokesMap := invocations.foldl (fun (acc : Std.HashMap Nat (List Nat)) (a, b) => acc.insert a (b :: acc.getD a [])) (Std.HashMap.empty : Std.HashMap Nat (List Nat))
  let rec dfs (visited : Std.HashSet Nat) (current : Nat) : Std.HashSet Nat :=
    if visited.contains current then
      visited
    else
      let newVisited := visited.insert current
      match invokesMap.get? current with
      | none => newVisited
      | some invokedList => invokedList.foldl (fun (acc : Std.HashSet Nat) (next : Nat) => dfs acc next) newVisited
  termination_by current
  decreasing_by sorry
  (dfs Std.HashSet.empty k).toList

/-- Checks if any method outside the suspicious group invokes a method inside the suspicious group. -/
def hasExternalInvocation (n : Nat) (suspicious : List Nat) (invocations : List (Nat × Nat)) : Bool :=
  let suspiciousSet := suspicious.foldl (fun (acc : Std.HashSet Nat) x => acc.insert x) (Std.HashSet.empty : Std.HashSet Nat)
  invocations.any fun (a, b) => (!suspiciousSet.contains a) && suspiciousSet.contains b

-- Precondition definitions
@[reducible, simp]
def remainingMethods_precond (n : Nat) (k : Nat) (invocations : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  n > 0 ∧ k < n ∧ (∀ (pair : Nat × Nat), pair ∈ invocations → pair.1 < n ∧ pair.2 < n)
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Returns all methods not in the suspicious group. -/
def nonSuspiciousMethods (n : Nat) (suspicious : List Nat) : List Nat :=
  let suspiciousSet := suspicious.foldl (fun (acc : Std.HashSet Nat) x => acc.insert x) (Std.HashSet.empty : Std.HashSet Nat)
  List.range n |>.filter fun i => !suspiciousSet.contains i

-- Main function definitions
def remainingMethods (n : Nat) (k : Nat) (invocations : List (Nat × Nat)) (h_precond : remainingMethods_precond (n) (k) (invocations)) : List Nat :=
  -- !benchmark @start code
  let suspicious := suspiciousMethods n k invocations
  if hasExternalInvocation n suspicious invocations then
    List.range n
  else
    nonSuspiciousMethods n suspicious
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def remainingMethods_postcond (n : Nat) (k : Nat) (invocations : List (Nat × Nat)) (result: List Nat) (h_precond : remainingMethods_precond (n) (k) (invocations)) : Prop :=
  -- !benchmark @start postcond
  let suspicious := suspiciousMethods n k invocations
  if hasExternalInvocation n suspicious invocations then
    result = List.range n
  else
    result = nonSuspiciousMethods n suspicious
  -- !benchmark @end postcond


-- Proof content
theorem remainingMethods_postcond_satisfied (n: Nat) (k: Nat) (invocations: List (Nat × Nat)) (h_precond : remainingMethods_precond (n) (k) (invocations)) :
    remainingMethods_postcond (n) (k) (invocations) (remainingMethods (n) (k) (invocations) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof