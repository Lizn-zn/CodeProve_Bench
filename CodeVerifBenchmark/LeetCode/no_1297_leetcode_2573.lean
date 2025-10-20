import Mathlib

namespace no_1297_leetcode_2573


-- Precondition auxiliary definitions
/-- Check if a matrix is square -/
def Matrix.isSquare (m : List (List α)) : Prop :=
  match m with
  | [] => True
  | h :: t => 
    let n := h.length
    (List.all (h :: t) (fun row => row.length = n)) ∧ 
    (h :: t).length = n

/-- Get the size of a square matrix -/
def Matrix.size (m : List (List α)) : Nat :=
  match m with
  | [] => 0
  | h :: _ => h.length

/-- Check if all elements in the matrix satisfy a property -/
def Matrix.all (m : List (List α)) (p : α → Bool) : Bool :=
  List.all m (fun row => List.all row p)

-- Precondition definitions
@[reducible, simp]
def findTheString_precond (lcp : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  Matrix.isSquare lcp ∧ 
  (∀ i j, i < Matrix.size lcp → j < Matrix.size lcp → (lcp.get! i).get! j ≤ Matrix.size lcp)
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function to check symmetry of the LCP matrix -/
def isSymmetric (lcp : List (List Nat)) : Bool :=
  let n := Matrix.size lcp
  if n = 0 then true else
  List.all (List.range n) fun i =>
    List.all (List.range n) fun j =>
      (lcp.get! i).get! j = (lcp.get! j).get! i

/-- Helper function to check diagonal consistency -/
def checkDiagonal (lcp : List (List Nat)) : Bool :=
  let n := Matrix.size lcp
  List.all (List.range n) fun i =>
    (lcp.get! i).get! i = n - i

/-- Helper function to check if LCP values are consistent with each other -/
def checkConsistency (lcp : List (List Nat)) : Bool :=
  let n := Matrix.size lcp
  if n = 0 then true else
  List.all (List.range n) fun i =>
    List.all (List.range n) fun j =>
      if i = j then true else
      let val := (lcp.get! i).get! j
      if val = 0 then true else
      if i + 1 < n ∧ j + 1 < n then
        val ≤ n ∧ val = (lcp.get! (i+1)).get! (j+1) + 1
      else
        val = 1

/-- Compute the length of the longest common prefix of two strings -/
def commonPrefixLength (s1 s2 : String) : Nat :=
  let chars1 := s1.data
  let chars2 := s2.data
  let rec loop (i : Nat) : Nat :=
    if h1 : i < chars1.length ∧ i < chars2.length then
      if chars1.get ⟨i, h1.left⟩ = chars2.get ⟨i, h1.right⟩ then
        loop (i + 1)
      else
        i
    else
      i
  decreasing_by sorry
  loop 0

/-- Helper function to construct the string from LCP matrix -/
def constructString (lcp : List (List Nat)) : String :=
  let n := Matrix.size lcp
  if n = 0 then "" else
  let chars : List Char := []
  let nextChar := 'a'
  let group : Array Nat := Array.mk (List.replicate n 0)
  
  -- Assign groups to positions based on LCP values
  let group := Id.run do
    let mut g := group
    for i in [0:n] do
      if g.get! i = 0 then
        g := g.set! i (i+1)
        for j in [i+1:n] do
          if (lcp.get! i).get! j > 0 then
            g := g.set! j (i+1)
    g
  
  -- Assign characters to groups
  let charMap := Id.run do
    let mut cm := Array.mk (List.replicate (n+1) 0)
    let mut nc := Char.val nextChar
    for i in [0:n] do
      let g := group.get! i
      if cm.get! g = 0 then
        cm := cm.set! g (nc + 1)
        let nextVal := nc + 1
        nc := if nextVal < (Char.val 'z' + 1) then nextVal else Char.val 'z'
    cm
  
  let chars := List.range n |>.map fun i =>
    let charCode := charMap.get! (group.get! i)
    if charCode = 0 then 'a' else Char.ofNat (if charCode > 0 then (charCode.toNat - 1) else 0)
  
  String.mk chars

-- Main function definitions
def findTheString (lcp : List (List Nat)) (h_precond : findTheString_precond (lcp)) : String :=
  -- !benchmark @start code
  let n := Matrix.size lcp
    
    -- Check basic properties of LCP matrix
    if ¬isSymmetric lcp then
      ""
    else if ¬checkDiagonal lcp then
      ""
    else if ¬checkConsistency lcp then
      ""
    else
      -- Construct the string
      let word := constructString lcp
      
      -- Verify the constructed string matches the LCP matrix
      if word.length ≠ n then
        ""
      else
        -- Check if the constructed string's LCP matches the given LCP
        let valid := List.all (List.range n) fun i =>
          List.all (List.range n) fun j =>
            let suffix_i := word.drop i
            let suffix_j := word.drop j
            let expected := commonPrefixLength suffix_i suffix_j
            (lcp.get! i).get! j = expected
        
        if valid then
          word
        else
          ""
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Check if lcp[i][j] equals the length of longest common prefix of suffixes starting at i and j -/
def isValidLCP (word : String) (lcp : List (List Nat)) : Prop :=
  let n := word.length
  ∀ i j, i < n → j < n → 
    let suffix_i := word.drop i
    let suffix_j := word.drop j
    (lcp.get! i).get! j = commonPrefixLength suffix_i suffix_j

/-- Check if the string is alphabetically smallest among all valid solutions -/
def isLexicographicallySmallest (word : String) (lcp : List (List Nat)) : Prop :=
  let n := word.length
  isValidLCP word lcp ∧
  ∀ other : String, other.length = n → 
    isValidLCP other lcp → 
    word ≤ other

-- Postcondition definitions
@[reducible, simp]
def findTheString_postcond (lcp : List (List Nat)) (result: String) (h_precond : findTheString_precond (lcp)) : Prop :=
  -- !benchmark @start postcond
  if result.isEmpty then
    ¬(∃ word : String, word.length = Matrix.size lcp ∧ isValidLCP word lcp)
  else
    isLexicographicallySmallest result lcp
  -- !benchmark @end postcond


-- Proof content
theorem findTheString_postcond_satisfied (lcp: List (List Nat)) (h_precond : findTheString_precond (lcp)) :
    findTheString_postcond (lcp) (findTheString (lcp) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1297_leetcode_2573