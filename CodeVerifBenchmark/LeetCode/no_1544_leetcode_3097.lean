import Mathlib

namespace no_1544_leetcode_3097


-- Precondition auxiliary definitions
def Array.bitwise_or (arr : Array Nat) : Nat :=
  arr.foldl (· ||| ·) 0

def isSpecialSubarray (nums : Array Nat) (k : Nat) (start : Nat) (stop : Nat) : Prop :=
  start < stop ∧ stop ≤ nums.size ∧ Array.bitwise_or (nums.extract start stop) ≥ k

-- Precondition definitions
@[reducible, simp]
def shortestSpecialSubarray_precond (nums : Array Nat) (k : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def updateBitCount (bitCount : Array Nat) (num : Nat) (delta : Int) : Array Nat :=
  let newBitCount := bitCount
  let i := 0
  let n := num
  let rec loop (i : Nat) (n : Nat) (acc : Array Nat) : Array Nat :=
    if n > 0 then
      let acc := if n % 2 = 1 then
                   acc.set! i (Int.toNat (delta + Int.ofNat acc[i]!))
                 else
                   acc
      loop (i + 1) (n / 2) acc
    else
      acc
  loop i n newBitCount

def computeOR (bitCount : Array Nat) : Nat :=
  let rec loop (i : Nat) (result : Nat) : Nat :=
    if i < bitCount.size then
      let result := if bitCount[i]! > 0 then
                      result ||| (1 <<< i)
                    else
                      result
      loop (i + 1) result
    else
      result
  loop 0 0

-- Main function definitions
def shortestSpecialSubarray (nums : Array Nat) (k : Nat) (h_precond : shortestSpecialSubarray_precond (nums) (k)) : Int :=
  -- !benchmark @start code
  if k = 0 then
    1
  else
    let left := 0
    let minLength := -1
    let bitCount := mkArray 32 0
    let currentOR := 0
    let rec outerLoop (right : Nat) (left : Nat) (minLength : Int) (bitCount : Array Nat) (currentOR : Nat) : Int :=
      if right < nums.size then
        let bitCount := updateBitCount bitCount nums[right]! 1
        let currentOR := computeOR bitCount
        let rec innerLoop (left : Nat) (minLength : Int) (bitCount : Array Nat) (currentOR : Nat) : Int :=
          if currentOR ≥ k ∧ left ≤ right then
            let windowLength := Int.ofNat (right - left + 1)
            let minLength := if minLength = -1 then windowLength else min minLength windowLength
            let bitCount := updateBitCount bitCount nums[left]! (-1)
            let left := left + 1
            let currentOR := computeOR bitCount
            innerLoop left minLength bitCount currentOR
          else
            minLength
        termination_by right - left
        decreasing_by sorry
        let minLength := innerLoop left minLength bitCount currentOR
        outerLoop (right + 1) left minLength bitCount currentOR
      else
        minLength
    decreasing_by sorry
    outerLoop 0 left minLength bitCount currentOR
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def subarrayLength (start stop : Nat) : Int :=
  if start < stop then Int.ofNat (stop - start) else -1

-- Postcondition definitions
@[reducible, simp]
def shortestSpecialSubarray_postcond (nums : Array Nat) (k : Nat) (result: Int) (h_precond : shortestSpecialSubarray_precond (nums) (k)) : Prop :=
  -- !benchmark @start postcond
  (result = -1 ∧ ∀ start stop, ¬isSpecialSubarray nums k start stop) ∨
  (result > 0 ∧ ∃ start stop, isSpecialSubarray nums k start stop ∧
    subarrayLength start stop = result ∧
    ∀ start' stop', isSpecialSubarray nums k start' stop' →
      subarrayLength start' stop' ≥ result)
  -- !benchmark @end postcond


-- Proof content
theorem shortestSpecialSubarray_postcond_satisfied (nums: Array Nat) (k: Nat) (h_precond : shortestSpecialSubarray_precond (nums) (k)) :
    shortestSpecialSubarray_postcond (nums) (k) (shortestSpecialSubarray (nums) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1544_leetcode_3097