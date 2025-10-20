import Lean

open Lean Meta Elab Command

namespace RecursionChecker

/-- Check if a constant is a recursive definition -/
def isRecursive (env : Environment) (constName : Name) : Bool :=
  match env.find? constName with
  | none => false
  | some info =>
    let usedConsts := info.getUsedConstantsAsSet
    -- Check if the function uses itself (direct recursion)
    -- or if it has helper functions like .rec or ._unary
    let hasDirectRecursion := usedConsts.contains constName

    -- Check for unfolding helpers (_sunfold, _unary)
    let constNameStr := constName.toString
    let hasUnfoldHelper := usedConsts.toList.any fun dep =>
      let depStr := dep.toString
      depStr.startsWith constNameStr &&
      (("._sunfold".isPrefixOf (depStr.drop constNameStr.length)) ||
       ("._unary".isPrefixOf (depStr.drop constNameStr.length)))

    hasDirectRecursion || hasUnfoldHelper

/-- Check if a constant uses the partial keyword -/
def isPartial (env : Environment) (constName : Name) : Bool :=
  match env.find? constName with
  | none => false
  | some (ConstantInfo.defnInfo info) => info.safety == DefinitionSafety.partial
  | some (ConstantInfo.opaqueInfo info) => info.isUnsafe  -- partial functions are marked as unsafe opaque
  | _ => false

/-- Find mutually recursive function groups -/
def findMutualRecursion (env : Environment) (constName : Name) : List Name :=
  match env.find? constName with
  | none => []
  | some info =>
    let usedConsts := info.getUsedConstantsAsSet.toList
    -- Find all other functions that use the current function (possible mutual recursion)
    usedConsts.filter fun dep =>
      dep != constName &&
      match env.find? dep with
      | some depInfo => depInfo.getUsedConstantsAsSet.contains constName
      | none => false

/-- Recursion type -/
inductive RecursionType where
  | notRecursive : RecursionType
  | directRecursive : RecursionType
  | mutualRecursive (partners : List Name) : RecursionType
  | partialDef : RecursionType

/-- Analyze a single constant for recursion -/
def analyzeRecursion (constName : Name) : MetaM Unit := do
  let env ← getEnv

  match env.find? constName with
  | none =>
    IO.println s!"❌ Definition not found: {constName}\n"
  | some info =>
    IO.println s!"🔍 Analyzing function: {constName}"
    IO.println (String.mk (List.replicate 70 '='))

    -- Get function type
    let typeStr := match info with
      | ConstantInfo.defnInfo _ => "def"
      | ConstantInfo.thmInfo _ => "theorem"
      | ConstantInfo.axiomInfo _ => "axiom"
      | ConstantInfo.opaqueInfo _ => "opaque"
      | ConstantInfo.quotInfo _ => "quot"
      | ConstantInfo.inductInfo _ => "inductive"
      | ConstantInfo.ctorInfo _ => "constructor"
      | ConstantInfo.recInfo _ => "recursor"

    IO.println s!"📝 Type: {typeStr}"

    -- Get used constants
    let usedConsts := info.getUsedConstantsAsSet.toList

    -- Check if partial
    let isPartialDef := isPartial env constName
    if isPartialDef then
      IO.println "⚠️  Uses partial keyword (termination not proven)"

    -- Check direct recursion
    let isDirect := isRecursive env constName
    if isDirect then
      IO.println "🔄 Direct recursion: Yes"
      -- Show which recursors are used
      let recursors := usedConsts.filter fun dep =>
        dep.toString.endsWith ".rec" || dep.toString.endsWith "._rec" || dep == constName
      if !recursors.isEmpty then
        IO.println "   Recursors/self-references used:"
        for rec in recursors do
          IO.println s!"   • {rec}"
    else
      IO.println "🔄 Direct recursion: No"

    -- Check mutual recursion
    let mutualRecs := findMutualRecursion env constName
    if !mutualRecs.isEmpty then
      IO.println "🔀 Mutual recursion: Yes"
      IO.println "   Mutually recursive functions:"
      for partner in mutualRecs do
        IO.println s!"   • {partner}"
    else
      IO.println "🔀 Mutual recursion: No"

    -- Show all used functions (for debugging)
    if usedConsts.length < 20 then
      IO.println s!"\n📋 Constants used (total {usedConsts.length}):"
      for dep in usedConsts do
        IO.println s!"   • {dep}"

    -- Summary
    IO.println ""
    if isPartialDef then
      IO.println "✓ Conclusion: partial function (may have recursion/loops)"
    else if isDirect then
      IO.println "✓ Conclusion: Recursive function (termination verified)"
    else if !mutualRecs.isEmpty then
      IO.println "✓ Conclusion: Mutually recursive function"
    else
      IO.println "✓ Conclusion: Non-recursive function"

    IO.println ""

/-- Analyze all definitions in a namespace for recursion -/
def analyzeNamespaceRecursion (ns : Name) : MetaM Unit := do
  let env ← getEnv
  let allConsts := env.constants.map₁.toList

  IO.println "\n"
  IO.println (String.mk (List.replicate 70 '='))
  IO.println s!"🔍 Recursion Analysis Report for {ns}"
  IO.println (String.mk (List.replicate 70 '='))
  IO.println "\n"

  let nsConsts := allConsts.filter fun (name, _) =>
    name.toString.startsWith (ns.toString ++ ".")

  if nsConsts.isEmpty then
    IO.println s!"⚠️  No definitions found in namespace {ns}"
    return

  -- Only analyze non-internal definitions and non-constructor/recursor definitions
  let publicConsts := nsConsts.filter fun (name, info) =>
    !name.isInternal &&
    match info with
    | ConstantInfo.defnInfo _ => true
    | ConstantInfo.thmInfo _ => false  -- theorems are usually not recursive
    | _ => false

  if publicConsts.isEmpty then
    IO.println s!"⚠️  No public definitions found in namespace {ns}"
    return

  -- Statistics
  let mut recursiveCount := 0
  let mut partialCount := 0
  let mut mutualRecCount := 0

  for (name, _) in publicConsts do
    let isDirect := isRecursive env name
    let isPartialDef := isPartial env name
    let mutualRecs := findMutualRecursion env name

    if isDirect || isPartialDef || !mutualRecs.isEmpty then
      recursiveCount := recursiveCount + 1
      if isPartialDef then
        partialCount := partialCount + 1
      if !mutualRecs.isEmpty then
        mutualRecCount := mutualRecCount + 1

      analyzeRecursion name

  -- Summary
  IO.println (String.mk (List.replicate 70 '='))
  IO.println "📊 Summary Statistics"
  IO.println (String.mk (List.replicate 70 '='))
  IO.println s!"Total definitions: {publicConsts.length}"
  IO.println s!"Recursive functions: {recursiveCount}"
  IO.println s!"Partial functions: {partialCount}"
  IO.println s!"Mutually recursive functions: {mutualRecCount}"
  IO.println ""

/-- Command: Check if specified definitions are recursive -/
elab "#check_rec " ids:ident* : command => do
  liftTermElabM do
    for id in ids do
      let constName := id.getId
      analyzeRecursion constName

/-- Command: Check for recursive functions in a namespace -/
elab "#check_namespace_rec " id:ident : command => do
  liftTermElabM do
    let ns := id.getId
    analyzeNamespaceRecursion ns

/-- Read and analyze recursive functions from a file path -/
def analyzeFile (filePath : String) : IO Unit := do
  IO.println s!"📂 Analyzing file: {filePath}"
  IO.println "⚠️  Note: This feature requires importing the target file first"
  IO.println "   Please use #check_namespace_rec or #check_rec commands in Lean files"
  IO.println ""

end RecursionChecker

/-- Extract namespace name from file path -/
def extractNamespace (filePath : String) : Option String := do
  -- Remove file extension
  let path := filePath.stripSuffix ".lean"

  -- Look for the part after CodeVerifBenchmark/
  if let some idx := path.splitOn "CodeVerifBenchmark/" |>.tail? then
    let parts := idx.head!.replace "/" "."
    return parts

  -- If CodeVerifBenchmark/ not found, try using the file name directly
  let fileName := path.splitOn "/" |>.reverse.head!
  return fileName

/-- Main program entry - generate and execute recursion analysis -/
def main (args : List String) : IO UInt32 := do
  -- If no arguments, show help
  if args.isEmpty then
    IO.println "╔════════════════════════════════════════════════════════════════════╗"
    IO.println "║              Lean4 Recursion Checker                               ║"
    IO.println "╚════════════════════════════════════════════════════════════════════╝"
    IO.println ""
    IO.println "Usage:"
    IO.println "  lake exe check-rec <file-path>          - Analyze specific Lean file"
    IO.println "  lake exe check-rec <namespace>          - Analyze specific namespace"
    IO.println "  lake exe check-rec <def1> <def2> ...   - Analyze specific definitions"
    IO.println ""
    IO.println "Examples:"
    IO.println "  lake exe check-rec CodeVerifBenchmark/LeetCode/no_22_leetcode_23.lean"
    IO.println "  lake exe check-rec no_22_leetcode_23"
    IO.println "  lake exe check-rec no_22_leetcode_23.flattenAndSort"
    IO.println "  lake exe check-rec List.mergeSort List.foldl"
    IO.println ""
    IO.println "Available commands (use directly in Lean files):"
    IO.println "  #check_rec <definition>              - Check if definition is recursive"
    IO.println "  #check_namespace_rec <namespace>     - Check namespace for recursion"
    IO.println ""
    IO.println "Example Lean code:"
    IO.println "```lean"
    IO.println "import Tools.CheckRec"
    IO.println "import YourModule"
    IO.println ""
    IO.println "#check_rec yourFunction"
    IO.println "#check_namespace_rec YourNamespace"
    IO.println "```"
    IO.println ""

    return 0

  -- Process arguments
  let firstArg := args.head!

  -- Generate analysis script
  IO.println "╔════════════════════════════════════════════════════════════════════╗"
  IO.println "║              Lean4 Recursion Checker - Script Generator            ║"
  IO.println "╚════════════════════════════════════════════════════════════════════╝"
  IO.println ""

  let scriptPath := "/tmp/check_rec_analyze.lean"
  let mut scriptContent := "import Tools.CheckRec\n"

  -- Check if first argument is a file path
  if firstArg.endsWith ".lean" then
    -- File path mode
    IO.println s!"Analyzing file: {firstArg}"

    -- Extract module name and namespace
    if let some moduleName := extractNamespace firstArg then
      let moduleImport := "CodeVerifBenchmark." ++ moduleName
      -- Namespace is usually the last part of the file name
      let namespaceName := moduleName.splitOn "." |>.reverse.head!

      scriptContent := scriptContent ++ s!"import {moduleImport}\n\n"
      scriptContent := scriptContent ++ "open RecursionChecker in\n\n"
      scriptContent := scriptContent ++ s!"#check_namespace_rec {namespaceName}\n"

      IO.println s!"Module import: {moduleImport}"
      IO.println s!"Namespace: {namespaceName}"
    else
      IO.println s!"⚠️  Cannot extract namespace from path: {firstArg}"
      return 1
  else
    -- Namespace or definition name mode
    IO.println s!"Analyzing: {args}"

    -- Check if it looks like a namespace (single argument and doesn't start with List./Array.)
    let looksLikeNamespace := args.length == 1 &&
                              !firstArg.startsWith "List." &&
                              !firstArg.startsWith "Array." &&
                              !firstArg.startsWith "Int." &&
                              !firstArg.startsWith "Nat."

    if looksLikeNamespace then
      -- Single namespace
      let moduleImport := "CodeVerifBenchmark." ++ firstArg
      scriptContent := scriptContent ++ s!"import {moduleImport}\n\n"
      scriptContent := scriptContent ++ "open RecursionChecker in\n\n"
      scriptContent := scriptContent ++ s!"#check_namespace_rec {firstArg}\n"
    else
      -- Multiple definitions or function names
      scriptContent := scriptContent ++ "\nopen RecursionChecker in\n\n"
      for arg in args do
        scriptContent := scriptContent ++ s!"#check_rec {arg}\n"

  scriptContent := scriptContent ++ "\n"

  -- Write script
  IO.FS.writeFile scriptPath scriptContent

  IO.println ""
  IO.println "✓ Analysis script generated: /tmp/check_rec_analyze.lean"
  IO.println ""
  IO.println "Running analysis..."
  IO.println (String.mk (List.replicate 70 '='))
  IO.println ""

  -- Execute analysis
  let output ← IO.Process.output {
    cmd := "lake"
    args := #["env", "lean", scriptPath]
    cwd := "/local/home/zenali/CodeVerif-Lean4"
  }

  IO.print output.stdout

  if output.exitCode != 0 then
    IO.println ""
    IO.println "❌ Analysis failed:"
    IO.println output.stderr
    return 1

  return 0

/-
Usage:

Add this to the beginning of your Lean file:
  import Tools.CheckRec

Then use the following commands:

1. Check if a single function is recursive:
   #check_rec yourFunction

2. Check multiple functions:
   #check_rec function1 function2 function3

3. Check for recursive functions in an entire namespace:
   #check_namespace_rec YourNamespace

Example:
```lean
import Tools.CheckRec
import CodeVerifBenchmark.LeetCode.no_22_leetcode_23

open RecursionChecker

#check_rec no_22_leetcode_23.flattenAndSort
#check_namespace_rec no_22_leetcode_23
```

Recursion types:
- Direct recursion: Function calls itself in its definition
- Mutual recursion: Multiple functions call each other forming recursion
- Partial: Functions defined with partial keyword (termination not proven)
- Non-recursive: Functions without any recursive calls
-/
