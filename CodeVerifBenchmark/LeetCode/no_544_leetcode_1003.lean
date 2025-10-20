import Mathlib

namespace no_544_leetcode_1003


-- Precondition auxiliary definitions
/-- A stack-based characterization of valid strings.
    A string is valid iff it reduces to empty string by repeatedly removing "abc".
 -/
inductive ValidStack : List Char → Prop
  | empty : ValidStack []
  | push_abc {l} : ValidStack l → ValidStack (l ++ ['a', 'b', 'c'])

/-- Reduce a list of characters by removing "abc" substrings from the end -/
def reduceStep (l : List Char) : List Char :=
  match l with
  | _₁₀::_₁₁::_₁₂::t => if _₁₀ = 'a' ∧ _₁₁ = 'b' ∧ _₁₂ = 'c' then t else l
  | _ => l

/-- Check if a list can be reduced to empty by repeated applications of reduceStep -/
def reducesToEmpty : List Char → Prop
  | l => ∃ n, Nat.iterate reduceStep n l = []

/-- Alternative characterization: a string is valid if its character list
    can be reduced to empty by removing "abc" substrings from the right -/
def isValidCharListAlt (l : List Char) : Prop := 
  reducesToEmpty l

-- Precondition definitions
@[reducible, simp]
def isValid_precond (s : String) : Prop :=
  -- !benchmark @start precond
  s.length ≥ 0 -- Always true for strings, but explicit about non-negative length
  ∧ s.data.all (fun c => c = 'a' ∨ c = 'b' ∨ c = 'c') -- All characters must be a, b, or c
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- A stack-based validator: process characters one by one,
    maintaining a stack. When we see a 'c', check if the last
    two characters are 'a' and 'b'. If so, remove them (pop),
    otherwise the string is invalid. -/
def isValidStackBased (s : String) : Bool :=
  let rec loop (stack : List Char) (remaining : List Char) : Bool :=
    match remaining with
    | [] => stack = [] -- If no more characters, stack must be empty
    | c :: cs =>
      if c = 'c' then
        match stack with
        | b :: a :: rest =>
          if a = 'a' ∧ b = 'b' then loop rest cs
          else false -- Invalid: 'c' not preceded by 'ab'
        | _ => false -- Invalid: 'c' with less than 2 chars in stack
      else
        loop (c :: stack) cs -- Push non-'c' characters
  loop [] s.data

-- Main function definitions
def isValid (s : String) (h_precond : isValid_precond (s)) : Bool :=
  -- !benchmark @start code
  isValidStackBased s
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Core definition: a string is valid if it can be built by inserting "abc"
    This is equivalent to being able to reduce it to empty by removing "abc" 
    We use the stack-based approach for the actual check -/
def isValidCore (s : String) : Prop := 
  ValidStack s.data

/-- Helper function to perform one reduction step from the end of the list 
    Removes the last occurrence of "abc" if it exists at the end -/
def reduceFromEnd : List Char → List Char
  | a::b::c::rest => 
    if a = 'a' ∧ b = 'b' ∧ c = 'c' then rest
    else a :: reduceFromEnd (b::c::rest)
  | l => l

/-- Perform reductions until no more changes occur -/
partial def reduceFully : List Char → List Char
  | l => 
    let l' := reduceFromEnd l
    if l' = l then l else reduceFully l'

/-- Final simplified condition: a string is valid iff full reduction yields empty -/
def isValidReduced (s : String) : Prop := 
  reduceFully s.data = []

-- Postcondition definitions
@[reducible, simp]
def isValid_postcond (s : String) (result: Bool) (h_precond : isValid_precond (s)) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ isValidReduced s
  -- !benchmark @end postcond


-- Proof content
theorem isValid_postcond_satisfied (s: String) (h_precond : isValid_precond (s)) :
    isValid_postcond (s) (isValid (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_544_leetcode_1003