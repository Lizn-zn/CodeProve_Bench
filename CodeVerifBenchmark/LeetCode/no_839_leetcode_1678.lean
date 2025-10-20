import Mathlib

namespace no_839_leetcode_1678


-- Precondition auxiliary definitions
/-- Check if a given command is valid according to the grammar:
    validCommand ::= 'G' | '()' | '(al)' | validCommand* -/
inductive ValidCommand : String → Prop where
  | g : ValidCommand "G"
  | empty_paren : ValidCommand "()"
  | al_paren : ValidCommand "(al)"
  | concat {s₁ s₂} : ValidCommand s₁ → ValidCommand s₂ → ValidCommand (s₁ ++ s₂)

/-- A helper function to check if every character in the string is part of a valid token. -/
def isValidTokenDecomposition (s : String) : Bool :=
  let rec go (chars : List Char) : Bool :=
    match chars with
    | [] => true
    | 'G' :: rest => go rest
    | '(' :: ')' :: rest => go rest
    | '(' :: 'a' :: 'l' :: ')' :: rest => go rest
    | _ => false
  go s.toList

/-- Decides validity of command by checking decomposition into valid tokens. -/
def isValidCommand (s : String) : Bool :=
  isValidTokenDecomposition s

-- Precondition definitions
@[reducible, simp]
def interpretCommand_precond (command : String) : Prop :=
  -- !benchmark @start precond
  isValidCommand command
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Auxiliary function to process the command string and build the result recursively. -/
def interpretCommand.go : List Char → String
  | [] => ""
  | 'G' :: cs => "G" ++ interpretCommand.go cs
  | '(' :: ')' :: cs => "o" ++ interpretCommand.go cs
  | '(' :: 'a' :: 'l' :: ')' :: cs => "al" ++ interpretCommand.go cs
  | _ => "" -- This case should not occur due to the precondition

-- Main function definitions
def interpretCommand (command : String) (h_precond : interpretCommand_precond (command)) : String :=
  -- !benchmark @start code
  interpretCommand.go command.toList
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Interpret a single valid token. -/
def interpretToken (token : String) : Option String :=
  match token with
  | "G" => some "G"
  | "()" => some "o"
  | "(al)" => some "al"
  | _ => none

/-- Recursively interpret a list of tokens. -/
def interpretTokens (tokens : List String) : Option String :=
  match tokens with
  | [] => some ""
  | t :: ts =>
    match interpretToken t, interpretTokens ts with
    | some i, some is => some (i ++ is)
    | _, _ => none

/-- Decompose a string into a list of valid tokens if possible. -/
def tokenizeCommand (s : String) : Option (List String) :=
  let rec go (chars : List Char) : Option (List String) :=
    match chars with
    | [] => some []
    | 'G' :: rest =>
      match go rest with
      | some rest_tokens => some ("G" :: rest_tokens)
      | none => none
    | '(' :: ')' :: rest =>
      match go rest with
      | some rest_tokens => some ("()" :: rest_tokens)
      | none => none
    | '(' :: 'a' :: 'l' :: ')' :: rest =>
      match go rest with
      | some rest_tokens => some ("(al)" :: rest_tokens)
      | none => none
    | _ => none
  go s.toList

/-- The expected result based on correct parsing and interpretation. -/
def expectedInterpretation (command : String) : Option String :=
  match tokenizeCommand command with
  | some tokens => interpretTokens tokens
  | none => none

-- Postcondition definitions
@[reducible, simp]
def interpretCommand_postcond (command : String) (result: String) (h_precond : interpretCommand_precond (command)) : Prop :=
  -- !benchmark @start postcond
  expectedInterpretation command = some result
  -- !benchmark @end postcond


-- Proof content
theorem interpretCommand_postcond_satisfied (command: String) (h_precond : interpretCommand_precond (command)) :
    interpretCommand_postcond (command) (interpretCommand (command) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_839_leetcode_1678