import Mathlib

-- Precondition definitions
@[reducible, simp]
def solve_precond (n : Nat) (k : Nat) (a : List Nat) : Prop :=
  -- !benchmark @start precond
  n ≥ 1 ∧ n ≤ 200 ∧ 
    k ≥ 1 ∧ k ≤ 10^18 ∧
    a.length = n ∧
    (∀ x ∈ a, 1 ≤ x ∧ x ≤ 10^18)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute minimum of a list
def listMin (l : List Nat) : Option Nat :=
  l.foldl (fun acc x => match acc with
    | none => some x
    | some y => some (min x y)) none

-- Helper function to compute maximum of a list
def listMax (l : List Nat) : Option Nat :=
  l.foldl (fun acc x => match acc with
    | none => some x
    | some y => some (max x y)) none

-- Modulo constant
def M : Nat := 1000000007

-- Main solving logic based on the Python implementation
def solveImpl (n : Nat) (k : Nat) (a : List Nat) : Nat :=
  let a_min := (listMin a).getD 0
  let a_max := (listMax a).getD 0
  
  let rec loop (i : Nat) (p : Nat) (r : Nat) (fuel : Nat) : Nat :=
    if fuel = 0 then r
    else if i > k then r
    else
      let q_min := a_min / p
      let q_max := a_max / p
      
      if q_min = q_max then
        if q_min = 0 then
          (r + 1) % M
        else
          let add := min (q_min - q_min / 2) (k - i + 1)
          (r + add) % M
      else
        let b := (a.map (· % p)).mergeSort (· ≤ ·)
        let h_max := k - i
        let r' := (r + min q_min (k - i) + 1) % M
        
        let rec innerLoop (j : Nat) (lb : Nat) (r_acc : Nat) (fuel2 : Nat) : Nat :=
          if fuel2 = 0 then r_acc
          else if j >= n then r_acc
          else
            let bj := b[j]!
            if lb = bj then
              innerLoop (j + 1) lb r_acc (fuel2 - 1)
            else
              let rec computeC (q : Nat) (c : Nat) (h : Nat) (fuel3 : Nat) : (Nat × Nat × Bool) :=
                if fuel3 = 0 then (c, h, false)
                else if q = 0 then (c, h, false)
                else
                  if (bj / q) % 2 = 1 then
                    let c' := c + q
                    let h' := h + 1
                    if (lb / q) % 2 ≠ 1 then
                      (c', h', true)
                    else if h' = h_max then
                      (c', h', false)
                    else
                      computeC (q / 2) c' h' (fuel3 - 1)
                  else
                    computeC (q / 2) c h (fuel3 - 1)
              
              let (c, h, f) := computeC (p / 2) 0 0 100
              
              if c ≤ a_min then
                if f then
                  let add := min ((a_min - c) / p) (k - (i + h)) + 1
                  let r_new := (r_acc + add) % M
                  if (a_max - c) / p = 0 then
                    r_new
                  else
                    innerLoop (j + 1) bj r_new (fuel2 - 1)
                else
                  innerLoop (j + 1) lb r_acc (fuel2 - 1)
              else
                r_acc
        
        let lb := b[0]!
        let r'' := innerLoop 1 lb r' n
        
        if q_min = 1 && q_max = 2 then
          r''
        else
          loop (i + 1) (p * 2) r'' (fuel - 1)
  
  loop 0 1 0 (k + 1)

-- Main function definitions
def solve (n : Nat) (k : Nat) (a : List Nat) (h_precond : solve_precond (n) (k) (a)) : Nat :=
  -- !benchmark @start code
  solveImpl n k a
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Operation A: divide each element by 2 (rounded down)
def opA (arr : List Nat) : List Nat :=
  arr.map (· / 2)

-- Operation B: subtract 1 from each element (only if no zeros)
def opB (arr : List Nat) : Option (List Nat) :=
  if arr.any (· = 0) then none
  else some (arr.map (· - 1))

-- Apply a sequence of operations to an array
def applyOps (arr : List Nat) : List (Bool × Nat) → Option (List Nat)
  | [] => some arr
  | (true, _) :: rest => applyOps (opA arr) rest  -- true means Operation A
  | (false, _) :: rest => match opB arr with      -- false means Operation B
    | none => none
    | some arr' => applyOps arr' rest

-- Generate all possible operation sequences of length at most k
def allOpSeqs (k : Nat) : List (List (Bool × Nat)) :=
  let rec helper (remaining : Nat) (acc : List (Bool × Nat)) : List (List (Bool × Nat)) :=
    if remaining = 0 then [acc]
    else 
      [acc] ++ 
      helper (remaining - 1) ((true, 0) :: acc) ++
      helper (remaining - 1) ((false, 0) :: acc)
  helper k []

-- Get all reachable states from initial array a with at most k operations
def reachableStates (a : List Nat) (k : Nat) : List (List Nat) :=
  let seqs := allOpSeqs k
  seqs.filterMap (applyOps a)

-- Count distinct states (modulo sorting)
def countDistinctStates (states : List (List Nat)) : Nat :=
  let sortedStates := states.map (·.mergeSort (· ≤ ·))
  sortedStates.eraseDups.length

-- Postcondition definitions
@[reducible, simp]
def solve_postcond (n : Nat) (k : Nat) (a : List Nat) (result: Nat) (h_precond : solve_precond (n) (k) (a)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the count of distinct reachable states modulo 10^9 + 7
    let M := 1000000007
    let distinctCount := countDistinctStates (reachableStates a k)
    result = distinctCount % M
  -- !benchmark @end postcond


-- Proof content
theorem solve_postcond_satisfied (n: Nat) (k: Nat) (a: List Nat) (h_precond : solve_precond (n) (k) (a)) :
    solve_postcond (n) (k) (a) (solve (n) (k) (a) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

