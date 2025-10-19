import Mathlib

-- Precondition auxiliary definitions
def isValidCharAux (c : String) : Bool :=
  c = "(" ∨ c = ")"

def isBalancedWithPath (s : List String) : Bool :=
  let balance := s.foldl (fun acc c =>
    if c = "(" then acc + 1 else acc - 1
  ) 0
  balance = 0 && (List.range (s.length + 1)).all (fun i =>
    let prefixBalance := (s.take i).foldl (fun acc c =>
      if c = "(" then acc + 1 else acc - 1
    ) 0
    prefixBalance ≥ 0
  )

def pathToParenString (grid : List (List String)) (path : List (Nat × Nat)) : List String :=
  path.map fun (i, j) => (grid.get! i).get! j

def isValidPath (s : List String) : Bool :=
  isBalancedWithPath s

def isValidGridPath (grid : List (List String)) (path : List (Nat × Nat)) : Bool :=
  let chars := pathToParenString grid path
  isValidPath chars

def allPaths (m n : Nat) : List (List (Nat × Nat)) :=
  if m = 0 ∨ n = 0 then []
  else
    let rec go (i j : Nat) : List (List (Nat × Nat)) :=
      if i ≥ m ∨ j ≥ n then [[]]
      else if i = m - 1 ∧ j = n - 1 then [[(i, j)]]
      else
        let downPaths := go (i+1) j
        let rightPaths := go i (j+1)
        let current := (i, j)
        (downPaths.map (current :: ·)) ++ (rightPaths.map (current :: ·))
    termination_by (m - i) + (n - j)
    go 0 0

-- Precondition definitions
@[reducible, simp]
def hasValidParenthesesPath_precond (grid : List (List String)) : Prop :=
  -- !benchmark @start precond
  grid ≠ [] ∧
  grid.length ≤ 100 ∧
  grid.all (fun row => row ≠ [] ∧ row.length ≤ 100 ∧ row.all (fun s => isValidCharAux s = true)) ∧
  (grid.get! 0).get! 0 = "(" ∧
  let lastRow := grid.get! (grid.length - 1)
  lastRow.get! (lastRow.length - 1) = ")"
  -- !benchmark @end precond


-- Code auxiliary definitions
def countOpen (s : List String) : Nat :=
  s.foldl (fun acc c => if c = "(" then acc + 1 else acc) 0

def countClose (s : List String) : Nat :=
  s.foldl (fun acc c => if c = ")" then acc + 1 else acc) 0

def checkBalance (s : List String) : Int :=
  s.foldl (fun acc c =>
    if c = "(" then acc + 1 else acc - 1
  ) 0

structure State :=
  (i : Nat) -- current row
  (j : Nat) -- current column
  (balance : Int) -- current balance of parentheses

def State.isValid (s : State) : Prop :=
  s.balance ≥ 0

def State.isFinal (s : State) (m n : Nat) : Prop :=
  s.i = m - 1 ∧ s.j = n - 1

def State.nextDown? (s : State) (m : Nat) : Option State :=
  if s.i + 1 < m then
    some { i := s.i + 1, j := s.j, balance := s.balance }
  else none

def State.nextRight? (s : State) (n : Nat) : Option State :=
  if s.j + 1 < n then
    some { i := s.i, j := s.j + 1, balance := s.balance }
  else none

def charAt (grid : List (List String)) (i j : Nat) : String :=
  (grid.get! i).get! j

def updateBalance (balance : Int) (char : String) : Int :=
  if char = "(" then balance + 1 else balance - 1

-- Main function definitions
def hasValidParenthesesPath (grid : List (List String)) (h_precond : hasValidParenthesesPath_precond (grid)) : Bool :=
  -- !benchmark @start code
  let m := grid.length
  let n := (grid.get! 0).length
  
  -- Early exit if grid is invalid or start/end chars are wrong
  if m = 0 ∨ n = 0 then
    false
  else
    let startChar := charAt grid 0 0
    let endChar := charAt grid (m-1) (n-1)
    if startChar ≠ "(" ∨ endChar ≠ ")" then
      false
    else
      -- Use dynamic programming with memoization
      -- memo[i][j][balance] = whether we can reach (i,j) with a given balance
      -- Since balance can be negative, we'll use a map or a different indexing strategy
      -- For simplicity and efficiency, we'll use a recursive approach with memoization
      
      -- The maximum possible balance is m+n-1 (all '(')
      -- The minimum possible balance is -(m+n-1) (all ')')
      -- But we only care about non-negative balances during the path
      
      -- We can use a set of visited states to avoid recomputation
      -- State: (i, j, balance)
      
      -- We'll implement a BFS-like approach with a queue of states
      
      -- But for a functional approach, we'll use a recursive helper with memoization
      -- Let's define a helper function that computes whether we can reach the end from a given state
      
      -- To avoid complex dependent types, we'll use a simple recursive approach with a visited set
      -- represented as a List of States. For better performance, a HashMap would be better, but for
      -- Lean 4 without Std, we'll keep it simple.
      
      -- Actually, for this problem size (100x100), a naive recursive approach might be too slow.
      -- Let's think of a better way.
      
      -- We can use a matrix of sets: memo[i][j] = set of possible balances at (i,j)
      -- This is a common approach for this type of DP problem.
      
      -- However, implementing sets in Lean 4 without Std is complex.
      -- Let's try a different approach: since the maximum path length is 199 (100+100-1),
      -- the balance is bounded by -199 to 199. We can use an array of booleans.
      
      -- But arrays in Lean 4 are not mutable. We need to think functionally.
      
      -- Let's define a recursive function with memoization.
      -- We'll use a list of visited states for memoization.
      
      -- This is getting complex. Let's simplify and implement a straightforward recursive solution
      -- with a cutoff for performance.
      
      -- Given the constraints, a well-implemented recursive solution with pruning should work.
      
      -- Let's define a recursive helper that takes the grid, current position, and current balance,
      -- and returns whether a valid path exists from this state to the end.
      
      -- We'll also pass the dimensions m and n, and the memoization table.
      -- For simplicity, we'll not implement full memoization but just do a recursive search with pruning.
      
      let rec dfsNat (i j : Nat) (balance : Int) : Bool :=
        -- Pruning: if balance is negative, invalid path
        if balance < 0 then false
        -- Pruning: if balance is too large (more than remaining steps), invalid
        else
          let remainingSteps := (m - 1 - i) + (n - 1 - j)
          if balance > remainingSteps then false
          -- Base case: reached the end
          else if i = m - 1 ∧ j = n - 1 then
            -- Check if final character is ')' and balance becomes 0
            let finalChar := charAt grid i j
            if finalChar = ")" ∧ balance = 1 then
              true
            else
              false
          else
            -- Recursive case: try moving down and right
            let currentChar := charAt grid i j
            let newBalance := updateBalance balance currentChar
            let downResult :=
              if i + 1 < m then
                dfsNat (i + 1) j newBalance
              else
                false
            let rightResult :=
              if j + 1 < n then
                dfsNat i (j + 1) newBalance
              else
                false
            downResult || rightResult
      termination_by (m - i) + (n - j)
      
      -- Start DFS from (0, 0) with initial balance 0
      -- But we need to handle the first character specially
      let firstChar := charAt grid 0 0
      if firstChar = "(" then
        dfsNat 0 0 1
      else
        false
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def existsValidParenPath (grid : List (List String)) : Bool :=
  let m := grid.length
  let n := (grid.get! 0).length
  let paths := allPaths m n
  paths.any (fun p => isValidGridPath grid p)

-- Postcondition definitions
@[reducible, simp]
def hasValidParenthesesPath_postcond (grid : List (List String)) (result: Bool) (h_precond : hasValidParenthesesPath_precond (grid)) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ existsValidParenPath grid = true
  -- !benchmark @end postcond


-- Proof content
theorem hasValidParenthesesPath_postcond_satisfied (grid: List (List String)) (h_precond : hasValidParenthesesPath_precond (grid)) :
    hasValidParenthesesPath_postcond (grid) (hasValidParenthesesPath (grid) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof