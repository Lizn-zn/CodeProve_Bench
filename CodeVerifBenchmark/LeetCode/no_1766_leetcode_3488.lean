import Mathlib

namespace no_1766_leetcode_3488


-- Precondition auxiliary definitions
def circularDistance (len : Nat) (i j : Nat) : Nat :=
  let d := if i >= j then i - j else j - i
  min d (len - d)

def hasDuplicates (l : List Nat) : Bool :=
  match l with
  | [] => false
  | x :: xs => xs.contains x || hasDuplicates xs

-- !benchmark @end precond_aux

-- Precondition definitions
@[reducible, simp]
def findClosestEqualElements_precond (nums : List Nat) (queries : List Nat) : Prop :=
  -- !benchmark @start precond
  queries.all (· < nums.length) ∧ nums.length > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
def findClosestEqualElements_map (nums : List Nat) : Std.HashMap Nat (List Nat) :=
  let arr := nums.toArray
  let map := ({} : Std.HashMap Nat (List Nat))
  let modifyMap := fun m i =>
    let val := arr[i]!
    match map.findEntry? val with
    | some (_, indices) => map.insert val (i::indices)
    | none => map.insert val [i]
  List.foldl modifyMap map (List.range arr.size)

def findClosestEqualElements_minDist (indices : List Nat) (target : Nat) (len : Nat) : Int :=
  let distances := indices.filter (· ≠ target) |>.map (circularDistance len target ·)
  if distances = [] then -1 else Int.ofNat (distances.foldl min distances.head!)

-- Main function definitions
def findClosestEqualElements (nums : List Nat) (queries : List Nat) (h_precond : findClosestEqualElements_precond (nums) (queries)) : List Int :=
  -- !benchmark @start code
  let numsArray := nums.toArray
  let len := numsArray.size
  let indexMap := findClosestEqualElements_map nums
  let queryIndices := queries.toArray
  let results := queryIndices.map (fun qi =>
    let targetIdx := qi
    let targetVal := numsArray[targetIdx]!
    match indexMap.findEntry? targetVal with
    | some (_, indices) => findClosestEqualElements_minDist indices targetIdx len
    | none => -1
  )
  results.toList
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def findMinDistance (nums : List Nat) (targetIndex : Nat) : Int :=
  let targetValue := nums.get! targetIndex
  let len := nums.length
  let distances := List.range len |>.filter (fun i => i ≠ targetIndex ∧ nums.get! i = targetValue) |>.map (circularDistance len targetIndex ·)
  if distances = [] then -1 else Int.ofNat (distances.foldl min distances.head!)

-- !benchmark @end postcond_aux

-- Postcondition definitions
@[reducible, simp]
def findClosestEqualElements_postcond (nums : List Nat) (queries : List Nat) (result: List Int) (h_precond : findClosestEqualElements_precond (nums) (queries)) : Prop :=
  -- !benchmark @start postcond
  result.length = queries.length ∧
    ∀ i, result.get! i = findMinDistance nums (queries.get! i)
  -- !benchmark @end postcond


-- Proof content
theorem findClosestEqualElements_postcond_satisfied (nums: List Nat) (queries: List Nat) (h_precond : findClosestEqualElements_precond (nums) (queries)) :
    findClosestEqualElements_postcond (nums) (queries) (findClosestEqualElements (nums) (queries) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1766_leetcode_3488