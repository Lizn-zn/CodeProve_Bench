import Mathlib

namespace no_2334_leetcode_2864


-- Precondition auxiliary definitions
def countOnes (s : String) : Nat :=
  s.data.foldl (fun acc c => if c = '1' then acc + 1 else acc) 0

def countZeros (s : String) : Nat :=
  s.data.foldl (fun acc c => if c = '0' then acc + 1 else acc) 0

-- Precondition definitions
@[reducible, simp]
def maximumOddBinaryNumber_precond (s : String) : Prop :=
  -- !benchmark @start precond
  s.length ≥ 1 ∧ s.length ≤ 100 ∧
  (∀ c ∈ s.data, c = '0' ∨ c = '1') ∧
  countOnes s ≥ 1
  -- !benchmark @end precond


-- Code auxiliary definitions
def maximumOddBinaryNumber_aux (s : String) : String :=
  let ones := countOnes s
  let zeros := countZeros s
  let leadingOnes := List.replicate (ones - 1) '1'
  let trailingZeros := List.replicate zeros '0'
  String.mk (leadingOnes ++ trailingZeros ++ ['1'])

-- Main function definitions
def maximumOddBinaryNumber (s : String) (h_precond : maximumOddBinaryNumber_precond (s)) : String :=
  -- !benchmark @start code
  maximumOddBinaryNumber_aux s
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def countChar (s : String) (char : Char) : Nat :=
  s.data.foldl (fun acc c => if c = char then acc + 1 else acc) 0

def isOddBinary (s : String) : Bool :=
  match s.data.getLast? with
  | some '1' => true
  | _ => false

-- Postcondition definitions
@[reducible, simp]
def maximumOddBinaryNumber_postcond (s : String) (result: String) (h_precond : maximumOddBinaryNumber_precond (s)) : Prop :=
  -- !benchmark @start postcond
  let ones := countOnes s
  let zeros := countZeros s
  let result_ones := countChar result '1'
  let result_zeros := countChar result '0'
  
  result.length = s.length ∧
  result_ones = ones ∧
  result_zeros = zeros ∧
  isOddBinary result = true ∧
  -- Check that the result is the maximum possible odd binary number
  -- This means all but one '1' should be placed at the beginning,
  -- followed by all '0's, and ending with the final '1'
  let expected_result :=
    String.mk (('1' :: List.replicate (ones - 1) '1') ++ List.replicate zeros '0' ++ ['1'])
  result = expected_result
  -- !benchmark @end postcond


-- Proof content
theorem maximumOddBinaryNumber_postcond_satisfied (s: String) (h_precond : maximumOddBinaryNumber_precond (s)) :
    maximumOddBinaryNumber_postcond (s) (maximumOddBinaryNumber (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2334_leetcode_2864