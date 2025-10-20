import Mathlib

namespace no_755_leetcode_916


-- Precondition auxiliary definitions
def charCount (s : String) : Char → Nat :=
  fun c => (s.data.filter (· = c)).length

def maxCharCount (words : List String) : Char → Nat :=
  fun c => (words.map (charCount · c)).foldl max 0

def isSubsetOf (s t : String) : Bool :=
  (·.all fun c => charCount s c ≤ charCount t c) (s.data.eraseDup)

-- Precondition definitions
@[reducible, simp]
def findUniversalStrings_precond (words1 : List String) (words2 : List String) : Prop :=
  True


-- Code auxiliary definitions
def universalCriterion (words2 : List String) : String :=
  let maxCounts := maxCharCount words2
  let chars := "abcdefghijklmnopqrstuvwxyz"
  chars.data.foldl (fun acc c => acc ++ String.mk (List.replicate (maxCounts c) c)) ""

-- Main function definitions
def findUniversalStrings (words1 : List String) (words2 : List String) (h_precond : findUniversalStrings_precond words1 words2) : List String :=
  let criterion := universalCriterion words2
  words1.filter (fun w => isSubsetOf criterion w)


-- Postcondition definitions
@[reducible, simp]
def findUniversalStrings_postcond (words1 : List String) (words2 : List String) (result : List String) (h_precond : findUniversalStrings_precond words1 words2) : Prop :=
  result.all (fun w => words1.contains w ∧ isSubsetOf (universalCriterion words2) w = true) ∧
    words1.all (fun w => result.contains w ↔ isSubsetOf (universalCriterion words2) w = true)


-- Proof content
theorem findUniversalStrings_postcond_satisfied (words1 : List String) (words2 : List String) (h_precond : findUniversalStrings_precond words1 words2) :
    findUniversalStrings_postcond words1 words2 (findUniversalStrings words1 words2 h_precond) h_precond := by
  sorry

end no_755_leetcode_916