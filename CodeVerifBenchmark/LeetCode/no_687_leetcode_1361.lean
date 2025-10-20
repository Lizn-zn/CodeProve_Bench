import Mathlib

namespace no_687_leetcode_1361


-- Precondition auxiliary definitions
def childrenLengthEq (n : Nat) (leftChild : List Int) (rightChild : List Int) : Prop :=
  leftChild.length = n ∧ rightChild.length = n

def validChildIndex (n : Nat) (child : Int) : Prop :=
  child = -1 ∨ (0 ≤ child ∧ child < ↑n)

def validChildrenIndices (n : Nat) (children : List Int) : Prop :=
  ∀ (i : Fin children.length), validChildIndex n (children[i])

def countParents (n : Nat) (leftChild : List Int) (rightChild : List Int) : List Nat :=
  let parentCount := List.replicate n 0
  let updateCount (countList : List Nat) (child : Int) : List Nat :=
    if child ≠ -1 then
      let idx := (child.toNat : Nat)
      countList.set idx ((countList.get ⟨idx, by sorry⟩) + 1)
    else
      countList
  List.foldl (fun acc i => updateCount (updateCount acc (leftChild.get ⟨i, by sorry⟩)) (rightChild.get ⟨i, by sorry⟩)) parentCount (List.range n)

def hasNoCyclesAndOneRootAux (visited : List Bool) (queue : List Nat) (n : Nat) (leftChild : List Int) (rightChild : List Int) : Bool :=
  match queue with
  | [] => visited.count true = 1
  | head :: tail =>
    let left := leftChild.get ⟨head, by sorry⟩
    let right := rightChild.get ⟨head, by sorry⟩
    let visited' := if left ≠ -1 ∧ ¬(visited.get ⟨(left.toNat : Nat), by sorry⟩) then
                      visited.set (left.toNat : Nat) true
                    else
                      visited
    let visited'' := if right ≠ -1 ∧ ¬(visited'.get ⟨(right.toNat : Nat), by sorry⟩) then
                       visited'.set (right.toNat : Nat) true
                     else
                       visited'
    let queue' := if left ≠ -1 ∧ ¬(visited.get ⟨(left.toNat : Nat), by sorry⟩) then
                    tail ++ [left.toNat]
                  else
                    tail
    let queue'' := if right ≠ -1 ∧ ¬(visited'.get ⟨(right.toNat : Nat), by sorry⟩) then
                     queue' ++ [right.toNat]
                   else
                     queue'
    hasNoCyclesAndOneRootAux visited'' queue'' n leftChild rightChild
  decreasing_by sorry

def hasNoCyclesAndOneRoot (n : Nat) (leftChild : List Int) (rightChild : List Int) : Bool :=
  let visited := List.replicate n false
  let root := (List.range n).find? fun i => (leftChild.find? (· = ↑i)).isNone ∧ (rightChild.find? (· = ↑i)).isNone
  match root with
  | none => false
  | some r => hasNoCyclesAndOneRootAux (visited.set r true) [r] n leftChild rightChild

-- Precondition definitions
@[reducible, simp]
def validateBinaryTreeNodes_precond (n : Nat) (leftChild : List Int) (rightChild : List Int) : Prop :=
  -- !benchmark @start precond
  childrenLengthEq n leftChild rightChild ∧
  validChildrenIndices n leftChild ∧
  validChildrenIndices n rightChild
  -- !benchmark @end precond

-- Postcondition auxiliary definitions
def exactlyOneValidTree (n : Nat) (leftChild : List Int) (rightChild : List Int) : Prop :=
  let parentCounts := countParents n leftChild rightChild
  let roots := parentCounts.filter (· = 0)
  roots.length = 1 ∧ (∀ i, parentCounts.get! i ≤ 1)

-- Code auxiliary definitions
def checkNoCyclesAndConnected (n : Nat) (leftChild : List Int) (rightChild : List Int) : Bool :=
  let parentCounts := countParents n leftChild rightChild
  let roots := parentCounts.filter (· = 0)
  if roots.length ≠ 1 then
    false
  else
    -- Check each node has at most one parent
    let allHaveAtMostOneParent := (List.range parentCounts.length).all fun i => parentCounts.get! i ≤ 1
    if ¬allHaveAtMostOneParent then
      false
    else
      -- Check for cycles and connectivity via BFS
      let root := (List.range n).find? fun i => parentCounts.get! i = 0
      match root with
      | none => false
      | some r =>
        let visited := List.replicate n false
        let visitedWithRoot := visited.set r true
        -- Convert Prop to Bool
        hasNoCyclesAndOneRootAux visitedWithRoot [r] n leftChild rightChild

-- Main function definitions
def validateBinaryTreeNodes (n : Nat) (leftChild : List Int) (rightChild : List Int) (h_precond : validateBinaryTreeNodes_precond (n) (leftChild) (rightChild)) : Bool :=
  -- !benchmark @start code
  checkNoCyclesAndConnected n leftChild rightChild
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def validateBinaryTreeNodes_postcond (n : Nat) (leftChild : List Int) (rightChild : List Int) (result: Bool) (h_precond : validateBinaryTreeNodes_precond (n) (leftChild) (rightChild)) : Prop :=
  -- !benchmark @start postcond
  result = exactlyOneValidTree n leftChild rightChild
  -- !benchmark @end postcond

-- Proof content
theorem validateBinaryTreeNodes_postcond_satisfied (n: Nat) (leftChild: List Int) (rightChild: List Int) (h_precond : validateBinaryTreeNodes_precond (n) (leftChild) (rightChild)) :
    validateBinaryTreeNodes_postcond (n) (leftChild) (rightChild) (validateBinaryTreeNodes (n) (leftChild) (rightChild) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_687_leetcode_1361