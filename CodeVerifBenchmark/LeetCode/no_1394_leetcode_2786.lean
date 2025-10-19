import Mathlib

-- Precondition auxiliary definitions
def Parity : Nat → Bool := λ n ↦ n % 2 = 0

@[simp]
def ScorePath (nums : List Nat) (x : Nat) (path : List Nat) : Option Int :=
  if path = [] then some 0
  else
    let rec scoreOfPathAux (p : List Nat) (acc : Int) (prevParity : Option Bool) : Option Int :=
      match p with
      | [] => some acc
      | i :: rest =>
        let currentVal := nums[i]!
        let currentParity := Parity currentVal
        let newAcc : Int :=
          match prevParity with
          | none => ↑currentVal
          | some pp =>
            if pp = currentParity then
              acc + ↑currentVal
            else
              acc + ↑currentVal - ↑x
        scoreOfPathAux rest newAcc (some currentParity)
    scoreOfPathAux path 0 none

@[simp]
def ValidPath (nums : List Nat) (path : List Nat) : Prop :=
  match path with
  | [] => True
  | h :: t =>
    h = 0 ∧ List.Sorted (fun a b => a < b) path ∧ path.length ≤ nums.length

-- Precondition definitions
@[reducible, simp]
def maxScore_precond (nums : List Nat) (x : Nat) : Prop :=
  -- !benchmark @start precond
  nums.length ≥ 2 ∧ x ≥ 1
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Dynamic programming approach:
    Track the maximum score ending at current position with even parity and odd parity separately.
    At each step, decide whether to extend the even-path or odd-path, considering the cost x for parity switch.
-/

def maxScoreDP (nums : List Nat) (x : Nat) : Int :=
  match nums with
  | [] => 0
  | head :: tail =>
    let firstParity := Parity head
    let firstVal : Int := ↑head
    -- Initialize based on the parity of the first element
    let initEven : Int := if firstParity then firstVal else firstVal - ↑x
    let initOdd : Int := if ¬firstParity then firstVal else firstVal - ↑x

    let rec loop (lst : List Nat) (evenMax : Int) (oddMax : Int) : Int :=
      match lst with
      | [] => max evenMax oddMax
      | val :: rest =>
        let currentVal : Int := ↑val
        let currentParity := Parity val
        let newEven : Int := if currentParity then max (evenMax + currentVal) (oddMax + currentVal - ↑x) else evenMax
        let newOdd : Int := if ¬currentParity then max (oddMax + currentVal) (evenMax + currentVal - ↑x) else oddMax
        loop rest newEven newOdd

    loop tail initEven initOdd

-- Main function definitions
def maxScore (nums : List Nat) (x : Nat) (h_precond : maxScore_precond (nums) (x)) : Int :=
  -- !benchmark @start code
  maxScoreDP nums x
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def maxScore_postcond (nums : List Nat) (x : Nat) (result: Int) (h_precond : maxScore_precond (nums) (x)) : Prop :=
  -- !benchmark @start postcond
  ∃ path : List Nat, ValidPath nums path ∧
    (∃ score : Int, ScorePath nums x path = some score ∧ result = score) ∧
    (∀ otherPath : List Nat, ValidPath nums otherPath →
      (∃ otherScore : Int, ScorePath nums x otherPath = some otherScore) →
      (∃ score : Int, ScorePath nums x path = some score) →
      (∃ score : Int, ScorePath nums x path = some score) ≥ (∃ otherScore : Int, ScorePath nums x otherPath = some otherScore))
  -- !benchmark @end postcond


-- Proof content
theorem maxScore_postcond_satisfied (nums: List Nat) (x: Nat) (h_precond : maxScore_precond (nums) (x)) :
    maxScore_postcond (nums) (x) (maxScore (nums) (x) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof