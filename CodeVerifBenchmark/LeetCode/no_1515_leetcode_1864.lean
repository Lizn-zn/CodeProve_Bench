import Mathlib

-- Precondition auxiliary definitions
def countChar (s : String) (c : Char) : Nat :=
  s.data.foldl (fun acc ch => if ch = c then acc + 1 else acc) 0

def isAlternating (s : String) : Bool :=
  s.data.Pairwise fun a b => a ≠ b

def canBeAlternating (s : String) : Prop :=
  let zeros := countChar s '0'
  let ones := countChar s '1'
  (zeros = ones ∨ zeros = ones + 1 ∨ ones = zeros + 1)

-- Precondition definitions
@[reducible, simp]
def minSwaps_precond (s : String) : Prop :=
  -- !benchmark @start precond
  s.data.all (fun c => c = '0' ∨ c = '1') ∧ canBeAlternating s
  -- !benchmark @end precond


-- Code auxiliary definitions
/- def countChar (s : String) (c : Char) : Nat :=
  s.data.foldl (fun acc ch => if ch = c then acc + 1 else acc) 0 -/

def alternatingConfigurations_code (s : String) : List String :=
  let n := s.length
  let zeros := countChar s '0'
  let ones := countChar s '1'
  let config1 := String.join ((List.range n).map fun i => if i % 2 = 0 then "0" else "1")
  let config2 := String.join ((List.range n).map fun i => if i % 2 = 0 then "1" else "0")
  if zeros = ones then
    [config1, config2]
  else if zeros = ones + 1 then
    [config1]
  else if ones = zeros + 1 then
    [config2]
  else
    []

def swapCount_code (original target : String) : Nat :=
  (List.zipWith (fun a b => decide (a ≠ b)) original.data target.data).foldl (fun acc b => if b then acc + 1 else acc) 0

-- Main function definitions
def minSwaps (s : String) (h_precond : minSwaps_precond (s)) : Int :=
  -- !benchmark @start code
  let zeros := countChar s '0'
  let ones := countChar s '1'
  if ¬(zeros = ones ∨ zeros = ones + 1 ∨ ones = zeros + 1) then
    -1
  else
    let configs := alternatingConfigurations_code s
    let counts := configs.map (fun cfg => swapCount_code s cfg)
    if counts.isEmpty then
      -1
    else
      let minCount := counts.foldl (fun minVal x => if x < minVal then x else minVal) counts.head!
      minCount / 2
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def alternatingConfigurations (s : String) : List String :=
  let n := s.length
  let zeros := countChar s '0'
  let ones := countChar s '1'
  let config1 := String.join ((List.range n).map fun i => if i % 2 = 0 then "0" else "1")
  let config2 := String.join ((List.range n).map fun i => if i % 2 = 0 then "1" else "0")
  let configs := if zeros = ones then [config1, config2]
                 else if zeros = ones + 1 then [config1]
                 else if ones = zeros + 1 then [config2]
                 else []
  configs.filter (fun cfg =>
    let cfgZeros := countChar cfg '0'
    let cfgOnes := countChar cfg '1'
    cfgZeros = zeros ∧ cfgOnes = ones)

def swapCount (original target : String) : Nat :=
  (List.zipWith (fun a b => decide (a ≠ b)) original.data target.data).foldl (fun acc b => if b then acc + 1 else acc) 0

def minSwapsForAlternating (s : String) : Int :=
  let configs := alternatingConfigurations s
  if configs.isEmpty then -1
  else
    let counts := configs.map (fun cfg => swapCount s cfg)
    let totalSwaps := counts.foldl (fun minVal x => if x < minVal then x else minVal) counts.head!
    totalSwaps / 2

-- Postcondition definitions
@[reducible, simp]
def minSwaps_postcond (s : String) (result: Int) (h_precond : minSwaps_precond (s)) : Prop :=
  -- !benchmark @start postcond
  if result = -1 then
    ¬∃ t : String, t.length = s.length ∧ isAlternating t ∧
      (∃ perm : List Char, List.Perm perm s.data ∧ perm = t.data)
  else
    result ≥ 0 ∧
    result = minSwapsForAlternating s ∧
    (∃ t : String, t.length = s.length ∧ isAlternating t ∧
      (∃ perm : List Char, List.Perm perm s.data ∧ perm = t.data ∧
       swapCount s t = result * 2))
  -- !benchmark @end postcond


-- Proof content
theorem minSwaps_postcond_satisfied (s: String) (h_precond : minSwaps_precond (s)) :
    minSwaps_postcond (s) (minSwaps (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof