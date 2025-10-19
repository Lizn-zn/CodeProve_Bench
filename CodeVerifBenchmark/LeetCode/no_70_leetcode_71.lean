import Mathlib

-- Precondition auxiliary definitions
def is_valid_path_char (c : Char) : Prop :=
  c = '/' ∨ c = '.' ∨ c = '_' ∨ Char.isAlpha c ∨ Char.isDigit c

def is_valid_path (path : String) : Prop :=
  path.length > 0 ∧
  path.get 0 = '/' ∧
  ∀ i : String.Pos, i < path.endPos → is_valid_path_char (path.get i)

-- Precondition definitions
@[reducible, simp]
def simplifyPath_precond (path : String) : Prop :=
  -- !benchmark @start precond
  is_valid_path path
  -- !benchmark @end precond


-- Code auxiliary definitions
def splitPath (path : String) : List String :=
  let parts := path.split (· = '/')
  parts.filter (· ≠ "")

def canonicalizeParts (parts : List String) : List String :=
  let rec go (parts : List String) (acc : List String) : List String :=
    match parts with
    | [] => acc.reverse
    | "." :: rest => go rest acc
    | ".." :: rest =>
      match acc with
      | [] => go rest []
      | _ :: acc' => go rest acc'
    | part :: rest => go rest (part :: acc)
  go parts []

def buildCanonicalPath (parts : List String) : String :=
  if parts = [] then "/"
  else "/" ++ String.join (parts.intersperse "/")

-- Main function definitions
def simplifyPath (path : String) (h_precond : simplifyPath_precond (path)) : String :=
  -- !benchmark @start code
  let parts := splitPath path
  let canonicalParts := canonicalizeParts parts
  buildCanonicalPath canonicalParts
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def split_path (path : String) : List String :=
  let parts := path.split (· = '/')
  parts.filter (· ≠ "")

def canonicalize_parts (parts : List String) : List String :=
  let rec go (parts : List String) (acc : List String) : List String :=
    match parts with
    | [] => acc.reverse
    | "." :: rest => go rest acc
    | ".." :: rest =>
      match acc with
      | [] => go rest []
      | _ :: acc' => go rest acc'
    | part :: rest => go rest (part :: acc)
  go parts []

def build_canonical_path (parts : List String) : String :=
  if parts = [] then "/"
  else "/" ++ (String.join (parts.map (· ++ "/"))).dropRight 1

def expected_result (path : String) : String :=
  let parts := split_path path
  let canonical_parts := canonicalize_parts parts
  build_canonical_path canonical_parts

-- Postcondition definitions
@[reducible, simp]
def simplifyPath_postcond (path : String) (result: String) (h_precond : simplifyPath_precond (path)) : Prop :=
  -- !benchmark @start postcond
  result = expected_result path
  -- !benchmark @end postcond


-- Proof content
theorem simplifyPath_postcond_satisfied (path: String) (h_precond : simplifyPath_precond (path)) :
    simplifyPath_postcond (path) (simplifyPath (path) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof