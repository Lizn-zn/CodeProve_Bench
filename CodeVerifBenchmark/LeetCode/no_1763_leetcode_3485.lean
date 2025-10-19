import Mathlib

-- Precondition auxiliary definitions
/-- A helper function to compute the longest common prefix of two strings. -/
def longestCommonPrefixOfTwo (s₁ s₂ : String) : Nat :=
  let chars1 := s₁.data
  let chars2 := s₂.data
  let rec go (i : Nat) : Nat :=
    if h1 : i < chars1.length ∧ i < chars2.length then
      if chars1[i]! = chars2[i]! then
        go (i + 1)
      else
        i
    else
      i
  termination_by chars1.length + chars2.length - 2 * i
  go 0

/-- A helper function to compute the longest common prefix among a list of strings. -/
def longestCommonPrefixOfList (lst : List String) : Nat :=
  match lst with
  | [] => 0
  | [s] => s.length
  | s₁ :: s₂ :: rest =>
    let prefixLength := longestCommonPrefixOfTwo s₁ s₂
    match rest with
    | [] => prefixLength
    | _ =>
      let commonPrefixChars := (s₁.extract { byteIdx := 0 } { byteIdx := prefixLength }).data
      let rec checkRest (lst : List String) (currentLength : Nat) : Nat :=
        match lst with
        | [] => currentLength
        | str :: rest =>
          let strData := str.data
          let newLength := 
            let rec inner (i : Nat) : Nat :=
              if h : i < currentLength ∧ i < strData.length then
                if h1 : commonPrefixChars[i]! = strData[i]! then
                  inner (i + 1)
                else
                  i
              else
                i
            termination_by currentLength + strData.length - 2 * i
            inner 0
          checkRest rest newLength
      termination_by lst.length
      checkRest rest prefixLength

/-- A helper function to generate all combinations of k elements from a list. -/
def combinations (lst : List α) (k : Nat) : List (List α) :=
  if k = 0 then
    [[]]
  else
    match lst with
    | [] => []
    | x :: xs =>
      let withX := List.map (fun comb => x :: comb) (combinations xs (k - 1))
      let withoutX := combinations xs k
      withX ++ withoutX
  termination_by lst.length + k

-- Precondition definitions
@[reducible, simp]
def longestCommonPrefixAfterRemoval_precond (words : List String) (k : Nat) : Prop :=
  -- !benchmark @start precond
  k > 0 ∧ words.length > 0
  -- !benchmark @end precond


-- Main function definitions
def longestCommonPrefixAfterRemoval (words : List String) (k : Nat) (h_precond : longestCommonPrefixAfterRemoval_precond (words) (k)) : List Nat :=
  -- !benchmark @start code
  
    let n := words.length
    List.range n |>.map fun i =>
      let wordsWithoutI := List.eraseIdx words i
      if wordsWithoutI.length < k then
        0
      else
        let allCombinations := combinations wordsWithoutI k
        match allCombinations with
        | [] => 0
        | comb :: rest =>
          let rec maxOfList (lst : List (List String)) (currentMax : Nat) : Nat :=
            match lst with
            | [] => currentMax
            | comb :: rest =>
              let prefixLen := longestCommonPrefixOfList comb
              maxOfList rest (max currentMax prefixLen)
          termination_by lst.length
          maxOfList rest (longestCommonPrefixOfList comb)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def longestCommonPrefixAfterRemoval_postcond (words : List String) (k : Nat) (result: List Nat) (h_precond : longestCommonPrefixAfterRemoval_precond (words) (k)) : Prop :=
  -- !benchmark @start postcond
  result.length = words.length ∧
    ∀ i : Fin words.length,
      let wordsWithoutI := List.eraseIdx words i
      if wordsWithoutI.length < k then
        result[i]! = 0
      else
        let allCombinations := combinations wordsWithoutI k
        let maxPrefixLength := 
          match allCombinations with
          | [] => 0
          | comb :: rest =>
            let rec maxOfList (lst : List (List String)) (currentMax : Nat) : Nat :=
              match lst with
              | [] => currentMax
              | comb :: rest =>
                let prefixLen := longestCommonPrefixOfList comb
                maxOfList rest (max currentMax prefixLen)
            termination_by lst.length
            maxOfList rest (longestCommonPrefixOfList comb)
        result[i]! = maxPrefixLength
  -- !benchmark @end postcond


-- Proof content
theorem longestCommonPrefixAfterRemoval_postcond_satisfied (words: List String) (k: Nat) (h_precond : longestCommonPrefixAfterRemoval_precond (words) (k)) :
    longestCommonPrefixAfterRemoval_postcond (words) (k) (longestCommonPrefixAfterRemoval (words) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof