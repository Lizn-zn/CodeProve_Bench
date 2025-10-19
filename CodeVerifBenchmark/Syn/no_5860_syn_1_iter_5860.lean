import Mathlib

-- Precondition auxiliary definitions
inductive ValidLineFormat : String → Prop where
  | empty : ValidLineFormat ""
  | valid (line : String) : ValidLineFormat line

-- Precondition definitions
@[reducible, simp]
def parse_string_data_precond (input_str : String) : Prop :=
  -- !benchmark @start precond
  ∀ (c : Char), c ∈ input_str.data → c.isWhitespace ∨ c.isDigit ∨ c = ',' ∨ c = ';' ∨ c = '-' ∨ c = '\n'
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper functions for parsing
private def parseInts (s : String) : Array Int :=
  s.splitOn "," |>.filterMap String.toInt? |>.toArray

private def parseNats (s : String) : List Nat :=
  s.trim.splitOn " " |>.filterMap String.toNat?

private def parseLineCode (line : String) : Option (Array Int × List Nat) :=
  match line.splitOn ";" with
  | [intPart, natPart] => 
    some (parseInts intPart, parseNats natPart)
  | _ => none

private def processLines (lines : List String) : Array (Array Int) × List Nat :=
  let parsed := lines.filterMap parseLineCode
  let intArrays := parsed.map Prod.fst |>.toArray
  let allNats := parsed.foldl (λ acc (_, nats) => acc ++ nats) []
  (intArrays, allNats)

-- Main function definitions
def parse_string_data (input_str : String) (h_precond : parse_string_data_precond (input_str)) : Prod (Array (Array Int)) (List Nat) :=
  -- !benchmark @start code
  let lines := input_str.splitOn "\n"
  let (intArrays, allNats) := processLines lines
  (intArrays, allNats)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
inductive ParsedLine : Type where
  | mk (ints : Array Int) (nats : List Nat) : ParsedLine

def parseLinePost (line : String) : Option ParsedLine :=
  match line.splitOn ";" with
  | [intPart, natPart] => 
    let ints := intPart.splitOn "," |>.filterMap String.toInt? |>.toArray
    let nats := natPart.trim.splitOn " " |>.filterMap String.toNat?
    some (ParsedLine.mk ints nats)
  | _ => none

def parseAllLines (input : String) : Array ParsedLine :=
  (input.splitOn "\n" |>.filterMap parseLinePost).toArray

def getAllIntArrays (parsed : Array ParsedLine) : Array (Array Int) :=
  parsed.map λ ⟨ints, _⟩ => ints

def getAllNats (parsed : Array ParsedLine) : List Nat :=
  parsed.foldl (λ acc ⟨_, nats⟩ => acc ++ nats) []

-- Postcondition definitions
@[reducible, simp]
def parse_string_data_postcond (input_str : String) (result: Prod (Array (Array Int)) (List Nat)) (h_precond : parse_string_data_precond (input_str)) : Prop :=
  -- !benchmark @start postcond
  let parsed := parseAllLines input_str
  result.1 = getAllIntArrays parsed ∧
  result.2 = getAllNats parsed ∧
  ∀ line ∈ input_str.splitOn "\n", ValidLineFormat line
  -- !benchmark @end postcond


-- Proof content
theorem parse_string_data_postcond_satisfied (input_str: String) (h_precond : parse_string_data_precond (input_str)) :
    parse_string_data_postcond (input_str) (parse_string_data (input_str) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof