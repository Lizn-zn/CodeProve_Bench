import Lean

open Lean Meta Elab Command

namespace RecursionChecker

/-- List of known recursive functions from standard library (实际的递归函数，不包括类型构造器) -/
def knownRecursiveFunctions : List Name := [
  -- Array functions
  `Array.eraseIdx,
  -- List functions
  `List.any, `List.beq, `List.concat, `List.decidableBAll, `List.decidableBEx,
  `List.dropLast, `List.enumFrom, `List.eraseIdx, `List.filter, `List.filterMap,
  `List.flatten, `List.foldl, `List.forM, `List.get, `List.get?,
  `List.instDecidablePairwise, `List.length, `List.lookup, `List.mergeSort,
  `List.range', `List.replicate, `List.set, `List.take, `List.zipIdx, `List.zipWith,
  `List.eraseDups,
  -- Nat functions
  `Nat.add, `Nat.beq, `Nat.decidableBallLT, `Nat.decidableExistsLT,
  `Nat.gcd, `Nat.pow
]

/-- List of recursive type constructors (types that are mutually recursive, usually not causing recursion in user code) -/
def recursiveTypeConstructors : List Name := [
  -- `And, `Array, `BEq, `Bool, `ByteArray, `Char, `Decidable, `Eq, `Except,
  -- `Exists, `Fin, `Float, `ForInStep, `GetElem, `HEq, `Hashable, `IO.Error,
  -- `Iff, `Inhabited, `Int, `LE, `Lean.Loop, `Lean.Name,
  -- `List, `List.Pairwise, `List.Perm, `List.Sublist,
  -- `MProd, `Membership, `Nat, `Nat.le, `Option, `Or, `Ord, `Ordering,
  -- `PProd, `PSigma, `PUnit, `Prod, `Repr, `SizeOf,
  -- `Std.Iterators.PostconditionT, `Std.Iterators.Types.Attach,
  -- `Std.Iterators.Types.ULiftIterator, `Std.PRange.RangeIterator,
  -- `Std.Range, `Std.Slice, `Std.Slice.Internal.SubarrayData,
  -- `String, `String.Iterator, `String.Pos, `Subtype, `Sum, `ToString,
  -- `True, `UInt32, `UInt8, `ULift
]

/-- Check if a name is in the known recursive functions list -/
def isKnownRecursive (name : Name) : Bool :=
  knownRecursiveFunctions.contains name

/-- Check if a name is a match helper for the given const name -/
def isMatchHelper (name : Name) (constName : Name) : Bool :=
  let nameStr := name.toString
  let constStr := constName.toString
  nameStr.startsWith (constStr ++ ".match_")

/-- Recursively check if an expression contains a direct reference to a specific constant (not via match helpers) -/
partial def exprContainsDirectConst (e : Expr) (constName : Name) : Bool :=
  match e with
  | Expr.const name _ => name == constName
  | Expr.app fn arg => exprContainsDirectConst fn constName || exprContainsDirectConst arg constName
  | Expr.lam _ _ body _ => exprContainsDirectConst body constName
  | Expr.forallE _ _ body _ => exprContainsDirectConst body constName
  | Expr.letE _ _ val body _ => exprContainsDirectConst val constName || exprContainsDirectConst body constName
  | Expr.mdata _ e => exprContainsDirectConst e constName
  | Expr.proj _ _ e => exprContainsDirectConst e constName
  | _ => false

/-- Recursively check if an expression contains a reference to a specific constant or its helpers -/
partial def exprContainsConst (e : Expr) (constName : Name) : Bool :=
  exprContainsDirectConst e constName

/-- Check if match helper function contains recursion and return debug info -/
def matchHelperHasRecursion (env : Environment) (constName : Name) (usedConsts : List Name) : Bool × (List Name) × (List Name) :=
  -- Find all match_N helpers for this function from used constants
  let constStr := constName.toString
  let matchHelpers := usedConsts.filter fun name =>
    let nameStr := name.toString
    let hasDotMatch := (nameStr.splitOn ".match_").length > 1
    let startsWithFunc := constStr.isPrefixOf nameStr
    hasDotMatch && startsWithFunc

  let recursiveHelpers := matchHelpers.filter fun name =>
    match env.find? name with
    | some (ConstantInfo.defnInfo val) =>
      exprContainsDirectConst val.value constName
    | _ => false

  (!recursiveHelpers.isEmpty, matchHelpers, recursiveHelpers)

/-- Check if a name is a local function of another name (e.g., "func.helper" is local to "func") -/
def isLocalFunctionOf (localName : Name) (parentName : Name) : Bool :=
  match localName with
  | Name.str localPrefix localStr =>
    -- Check if the prefix matches the parent name
    (localPrefix == parentName) &&
    -- Exclude match helpers and unfold helpers by checking the string
    !localStr.startsWith "match_" &&
    !localStr.startsWith "_sunfold" &&
    !localStr.startsWith "_unary"
  | _ => false

/-- Check if a function has recursive local functions (let rec) -/
def hasRecursiveLocalFunction (env : Environment) (constName : Name) : Bool :=
  match env.find? constName with
  | none => false
  | some info =>
    let usedConsts := info.getUsedConstantsAsSet.toList
    -- Find all local functions using Name structure matching
    let localFunctions := usedConsts.filter fun dep => isLocalFunctionOf dep constName

    -- If we found any local functions, they indicate recursion (let rec creates recursive locals)
    !localFunctions.isEmpty

/-- Check if a constant is a recursive definition by examining its value expression -/
def isRecursive (env : Environment) (constName : Name) : Bool :=
  match env.find? constName with
  | none => false
  | some info =>
    -- First, check the expression value directly
    let valueContainsSelf := match info with
      | ConstantInfo.defnInfo val => exprContainsConst val.value constName
      | _ => false

    let usedConsts := info.getUsedConstantsAsSet.toList

    -- Check if it uses any known recursive functions
    let usesKnownRecursive := usedConsts.any isKnownRecursive

    if valueContainsSelf then
      true
    else if usesKnownRecursive then
      true
    else if (matchHelperHasRecursion env constName usedConsts).1 then
      true
    else if hasRecursiveLocalFunction env constName then
      true
    else
      -- Check if function uses recursors (brecOn, recOn, etc) which indicates structural recursion
      let hasRecursor := usedConsts.any fun dep =>
        let depStr := dep.toString
        depStr.endsWith ".brecOn" || depStr.endsWith ".recOn" ||
        depStr.endsWith ".rec" || depStr.endsWith "._rec"

      if hasRecursor then
        -- If it uses a recursor AND has a match helper, likely recursive
        let constStr := constName.toString
        let hasMatchHelper := usedConsts.any fun dep =>
          let depStr := dep.toString
          (depStr.splitOn ".match_").length > 1 && constStr.isPrefixOf depStr
        hasMatchHelper
      else
        -- Fallback: check used constants (for already compiled definitions)
        let usedConstsSet := info.getUsedConstantsAsSet
        let hasDirectRecursion := usedConstsSet.contains constName

        -- Check for unfolding helpers (_sunfold, _unary)
        let constNameStr := constName.toString
        let hasUnfoldHelper := usedConsts.any fun dep =>
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

/-- Check if a constant uses opaque nested functions (partial def pattern) -/
def usesOpaqueNested (env : Environment) (constName : Name) : Bool :=
  match env.find? constName with
  | none => false
  | some info =>
    let usedConsts := info.getUsedConstantsAsSet.toList
    let constNameStr := constName.toString
    usedConsts.any fun dep =>
      let depStr := dep.toString
      depStr.startsWith constNameStr &&
      match env.find? dep with
      | some (ConstantInfo.opaqueInfo _) => true
      | _ => false

/-- Get all constants referenced in an expression -/
partial def getExprConsts (e : Expr) : List Name :=
  match e with
  | Expr.const name _ => [name]
  | Expr.app fn arg => getExprConsts fn ++ getExprConsts arg
  | Expr.lam _ _ body _ => getExprConsts body
  | Expr.forallE _ _ body _ => getExprConsts body
  | Expr.letE _ _ val body _ => getExprConsts val ++ getExprConsts body
  | Expr.mdata _ e => getExprConsts e
  | Expr.proj _ _ e => getExprConsts e
  | _ => []

/-- Find mutually recursive function groups -/
def findMutualRecursion (env : Environment) (constName : Name) : List Name :=
  match env.find? constName with
  | none => []
  | some info =>
    -- Get constants from both expression value and used constants
    let valueConsts := match info with
      | ConstantInfo.defnInfo val => getExprConsts val.value
      | _ => []
    let usedConsts := info.getUsedConstantsAsSet.toList
    let allUsedConsts := (valueConsts ++ usedConsts).eraseDups

    -- Find all other functions that use the current function (possible mutual recursion)
    allUsedConsts.filter fun dep =>
      dep != constName &&
      match env.find? dep with
      | some depInfo =>
        let depValueConsts := match depInfo with
          | ConstantInfo.defnInfo val => getExprConsts val.value
          | _ => []
        let depUsedConsts := depInfo.getUsedConstantsAsSet.toList
        (depValueConsts ++ depUsedConsts).any (· == constName)
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
    IO.println s!"ERROR: Definition not found: {constName}\n"
  | some info =>
    IO.println s!"Analyzing function: {constName}"
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

    IO.println s!"Type: {typeStr}"

    -- Get used constants
    let usedConsts := info.getUsedConstantsAsSet.toList

    -- Check if opaque/partial
    let isPartialDef := isPartial env constName
    let isOpaque := match info with
      | ConstantInfo.opaqueInfo _ => true
      | _ => false

    if isPartialDef then
      IO.println "WARNING: Uses partial keyword (termination not proven)"

    if isOpaque && !isPartialDef then
      IO.println "WARNING: Opaque definition (function body not accessible for analysis)"
      -- Check if this looks like a nested function from a partial def
      let nameStr := constName.toString
      let hasLoop := (nameStr.splitOn ".loop").length > 1
      let hasTryEdges := (nameStr.splitOn ".tryEdges").length > 1
      let hasInnerLoop := (nameStr.splitOn ".innerLoop").length > 1
      let hasProcessEdges := (nameStr.splitOn ".processEdges").length > 1
      if hasLoop || hasTryEdges || hasInnerLoop || hasProcessEdges then
        IO.println "   Note: Appears to be a nested function, likely from a partial def"

    -- Check direct recursion
    let isDirect := isRecursive env constName

    if isDirect then
      IO.println "Direct recursion: Yes"

      -- Check how recursion was detected
      let valueContainsSelf := match info with
        | ConstantInfo.defnInfo val => exprContainsConst val.value constName
        | _ => false

      let usesKnownRecursive := usedConsts.any isKnownRecursive
      let knownRecursiveUsed := usedConsts.filter isKnownRecursive

      let hasRecursor := usedConsts.any fun dep =>
        let depStr := dep.toString
        depStr.endsWith ".brecOn" || depStr.endsWith ".recOn" ||
        depStr.endsWith ".rec" || depStr.endsWith "._rec"

      let hasRecursiveLocal := hasRecursiveLocalFunction env constName

      if valueContainsSelf then
        IO.println "   Detected: Direct self-reference in function body"
      else if usesKnownRecursive then
        IO.println "   Detected: Uses known recursive functions"
        if knownRecursiveUsed.length <= 10 then
          for dep in knownRecursiveUsed do
            IO.println s!"   - {dep}"
        else
          IO.println s!"   - {knownRecursiveUsed.length} known recursive functions used"
          for dep in knownRecursiveUsed.take 5 do
            IO.println s!"   - {dep}"
          IO.println s!"   - ... and {knownRecursiveUsed.length - 5} more"
      else if hasRecursiveLocal then
        IO.println "   Detected: Contains recursive local function (let rec)"
        let constNameStr := constName.toString
        let localFunctions := usedConsts.filter fun dep =>
          let depStr := dep.toString
          depStr.startsWith (constNameStr ++ ".") &&
          !((depStr.splitOn ".match_").length > 1) &&
          !((depStr.splitOn "._sunfold").length > 1) &&
          !((depStr.splitOn "._unary").length > 1)
        let recursiveLocals := localFunctions.filter fun localFunc =>
          match env.find? localFunc with
          | some (ConstantInfo.defnInfo val) =>
            exprContainsDirectConst val.value localFunc ||
            exprContainsDirectConst val.value constName
          | _ => false
        for localFunc in recursiveLocals do
          IO.println s!"   - Local recursive function: {localFunc}"
      else if hasRecursor then
        IO.println "   Detected: Structural recursion (via pattern matching)"
      else
        -- Show which methods were used (fallback detection)
        let recursors := usedConsts.filter fun dep =>
          dep.toString.endsWith ".rec" || dep.toString.endsWith "._rec" || dep == constName
        if !recursors.isEmpty then
          IO.println "   Detection method:"
          for rec in recursors do
            IO.println s!"   - {rec}"
    else
      IO.println "Direct recursion: No"
      if isOpaque || isPartialDef then
        IO.println "   Note: Cannot analyze recursion in opaque/partial definitions"
      else
        -- Check if this function uses opaque nested functions (partial def pattern)
        let constNameStr := constName.toString
        let hasOpaqueNested := usedConsts.any fun dep =>
          let depStr := dep.toString
          depStr.startsWith constNameStr &&
          match env.find? dep with
          | some (ConstantInfo.opaqueInfo _) => true
          | _ => false
        if hasOpaqueNested then
          IO.println "   Note: Uses opaque nested functions (likely contains recursion)"

    -- Check mutual recursion
    let mutualRecs := findMutualRecursion env constName
    if !mutualRecs.isEmpty then
      IO.println "Mutual recursion: Yes"
      IO.println "   Mutually recursive functions:"
      for partner in mutualRecs do
        IO.println s!"   - {partner}"
    else
      IO.println "Mutual recursion: No"

    -- Show all used functions (for debugging)
    if usedConsts.length < 20 then
      IO.println s!"\nConstants used (total {usedConsts.length}):"
      for dep in usedConsts do
        IO.println s!"   - {dep}"

    -- Summary
    IO.println ""
    if isPartialDef then
      IO.println "OK: Conclusion: partial function (may have recursion/loops)"
    else if isDirect then
      IO.println "OK: Conclusion: Recursive function (termination verified)"
    else if !mutualRecs.isEmpty then
      IO.println "OK: Conclusion: Mutually recursive function"
    else
      IO.println "OK: Conclusion: Non-recursive function"

    IO.println ""

/-- Analyze all definitions in a namespace for recursion -/
def analyzeNamespaceRecursion (ns : Name) : MetaM Unit := do
  let env ← getEnv
  let allConsts := env.constants.map₁.toList

  IO.println "\n"
  IO.println (String.mk (List.replicate 70 '='))
  IO.println s!"Recursion Analysis Report for {ns}"
  IO.println (String.mk (List.replicate 70 '='))
  IO.println "\n"

  let nsConsts := allConsts.filter fun (name, _) =>
    name.toString.startsWith (ns.toString ++ ".")

  if nsConsts.isEmpty then
    IO.println s!"WARNING: No definitions found in namespace {ns}"
    return

  -- Only analyze non-internal definitions and non-constructor/recursor definitions
  let publicConsts := nsConsts.filter fun (name, info) =>
    !name.isInternal &&
    match info with
    | ConstantInfo.defnInfo _ => true
    | ConstantInfo.opaqueInfo _ => true  -- include opaque (partial defs are compiled to opaque)
    | ConstantInfo.thmInfo _ => false  -- theorems are usually not recursive
    | _ => false

  if publicConsts.isEmpty then
    IO.println s!"WARNING: No public definitions found in namespace {ns}"
    return

  -- Statistics
  let mut recursiveCount := 0
  let mut partialCount := 0
  let mut opaqueCount := 0
  let mut mutualRecCount := 0
  let mut usesOpaqueNestedCount := 0

  for (name, info) in publicConsts do
    let isDirect := isRecursive env name
    let isPartialDef := isPartial env name
    let isOpaqueDef := match info with
      | ConstantInfo.opaqueInfo _ => true
      | _ => false
    let hasOpaqueNested := usesOpaqueNested env name
    let mutualRecs := findMutualRecursion env name

    if isDirect || isPartialDef || isOpaqueDef || hasOpaqueNested || !mutualRecs.isEmpty then
      recursiveCount := recursiveCount + 1
      if isPartialDef then
        partialCount := partialCount + 1
      if isOpaqueDef then
        opaqueCount := opaqueCount + 1
      if hasOpaqueNested then
        usesOpaqueNestedCount := usesOpaqueNestedCount + 1
      if !mutualRecs.isEmpty then
        mutualRecCount := mutualRecCount + 1

      analyzeRecursion name

  -- Summary
  IO.println (String.mk (List.replicate 70 '='))
  IO.println "Summary Statistics"
  IO.println (String.mk (List.replicate 70 '='))
  IO.println s!"Total definitions: {publicConsts.length}"
  IO.println s!"Recursive/Opaque functions: {recursiveCount}"
  IO.println s!"  - Partial functions: {partialCount}"
  IO.println s!"  - Opaque functions: {opaqueCount}"
  IO.println s!"  - Functions using opaque nested helpers: {usesOpaqueNestedCount}"
  IO.println s!"  - Mutually recursive functions: {mutualRecCount}"
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
  IO.println s!"Analyzing file: {filePath}"
  IO.println "WARNING: Note: This feature requires importing the target file first"
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
    IO.println "======================================================================"
    IO.println "              Lean4 Recursion Checker                               "
    IO.println "======================================================================"
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
  IO.println "======================================================================"
  IO.println "              Lean4 Recursion Checker - Script Generator            "
  IO.println "======================================================================"
  IO.println ""

  -- Generate unique temporary file using timestamp
  let now ← IO.monoMsNow
  let scriptPath := s!"/tmp/check_rec_analyze_{now}.lean"
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
      IO.println s!"WARNING: Cannot extract namespace from path: {firstArg}"
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
  IO.println s!"OK: Analysis script generated: {scriptPath}"
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

  -- Clean up temporary file
  try
    IO.FS.removeFile scriptPath
  catch _ =>
    pure ()

  if output.exitCode != 0 then
    IO.println ""
    IO.println "ERROR: Analysis failed:"
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
