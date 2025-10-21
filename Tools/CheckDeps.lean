import Lean

open Lean Meta Elab Command

namespace DependencyChecker

/-- Analyze the dependencies of a constant and print information -/
def analyzeConstant (constName : Name) : MetaM Unit := do
  let env ← getEnv
  match env.find? constName with
  | none =>
    IO.println s!"ERROR: Definition not found: {constName}\n"
  | some info =>
    IO.println s!"Analyzing definition: {constName}"
    IO.println (String.mk (List.replicate 70 '='))

    let deps := info.getUsedConstantsAsSet.toList
    IO.println s!"Stats: Total {deps.length} external constants used\n"

    if deps.isEmpty then
      IO.println "OK: No external dependencies"
    else
      -- Categorize by source
      let mut mathlibDeps : Array (Name × Name) := #[]
      let mut stdDeps : Array (Name × Name) := #[]
      let mut initDeps : Array Name := #[]
      let mut localDeps : Array Name := #[]

      for dep in deps do
        let modIdx? := env.getModuleIdxFor? dep
        match modIdx? with
        | none =>
          localDeps := localDeps.push dep
        | some idx =>
          let modName := env.allImportedModuleNames[idx.toNat]!
          if modName.toString.startsWith "Mathlib" then
            mathlibDeps := mathlibDeps.push (dep, modName)
          else if modName.toString.startsWith "Std" then
            stdDeps := stdDeps.push (dep, modName)
          else if modName.toString.startsWith "Init" then
            initDeps := initDeps.push dep
          else
            localDeps := localDeps.push dep

      if !mathlibDeps.isEmpty then
        IO.println "[Mathlib] Dependencies from Mathlib:"
        for (dep, mod) in mathlibDeps do
          IO.println s!"   - {dep}"
          IO.println s!"     Module: {mod}"
        IO.println ""

      if !stdDeps.isEmpty then
        IO.println "[Std] Dependencies from Standard Library:"
        for (dep, mod) in stdDeps do
          IO.println s!"   - {dep}"
          IO.println s!"     Module: {mod}"
        IO.println ""

      if !initDeps.isEmpty then
        IO.println "[Init] Dependencies from Core Library:"
        for dep in initDeps do
          IO.println s!"   - {dep}"
        IO.println ""

      if !localDeps.isEmpty then
        IO.println "[Local] Local/Other Dependencies:"
        for dep in localDeps do
          IO.println s!"   - {dep}"
        IO.println ""

    IO.println ""

/-- Analyze all definitions in a namespace -/
def analyzeNamespace (ns : Name) : MetaM Unit := do
  let env ← getEnv
  let allConsts := env.constants.map₁.toList

  IO.println "\n"
  IO.println (String.mk (List.replicate 70 '='))
  IO.println s!"Dependency Analysis Report for {ns}"
  IO.println (String.mk (List.replicate 70 '='))
  IO.println "\n"

  let nsConsts := allConsts.filter fun (name, _) =>
    name.toString.startsWith (ns.toString ++ ".")

  if nsConsts.isEmpty then
    IO.println s!"WARNING: No definitions found in namespace {ns}"
    return

  -- Only analyze non-internal definitions
  let publicConsts := nsConsts.filter fun (name, _) => !name.isInternal

  for (name, _) in publicConsts do
    analyzeConstant name

/-- Command: Analyze dependencies of specified definitions -/
elab "#check_deps " ids:ident* : command => do
  liftTermElabM do
    for id in ids do
      let constName := id.getId
      analyzeConstant constName

/-- Command: Analyze namespace -/
elab "#check_namespace " id:ident : command => do
  liftTermElabM do
    let ns := id.getId
    analyzeNamespace ns

/-- Command: List the module where constants are located -/
elab "#module_of " ids:ident* : command => do
  liftTermElabM do
    let env ← getEnv
    IO.println "\nConstant Module Sources:"
    IO.println (String.mk (List.replicate 70 '='))

    for id in ids do
      let constName := id.getId
      match env.find? constName with
      | none =>
        IO.println s!"UNKNOWN: {constName}: Definition not found"
      | some _ =>
        let modIdx? := env.getModuleIdxFor? constName
        match modIdx? with
        | none =>
          IO.println s!"CORE: {constName}: Core definition (no module info)"
        | some idx =>
          let modName := env.allImportedModuleNames[idx.toNat]!
          IO.println s!"Location: {constName}"
          IO.println s!"   From module: {modName}"
    IO.println ""

end DependencyChecker

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

/-- Main program entry - generate and execute dependency analysis -/
def main (args : List String) : IO UInt32 := do
  -- If no arguments, show help
  if args.isEmpty then
    IO.println "======================================================================"
    IO.println "              Lean4 Dependency Checker                              "
    IO.println "======================================================================"
    IO.println ""
    IO.println "Usage:"
    IO.println "  lake exe check-deps <file-path>          - Analyze specific Lean file"
    IO.println "  lake exe check-deps <namespace>          - Analyze specific namespace"
    IO.println "  lake exe check-deps <def1> <def2> ...   - Analyze specific definitions"
    IO.println ""
    IO.println "Examples:"
    IO.println "  lake exe check-deps CodeVerifBenchmark/LeetCode/no_22_leetcode_23.lean"
    IO.println "  lake exe check-deps no_22_leetcode_23"
    IO.println "  lake exe check-deps no_22_leetcode_23.flattenAndSort"
    IO.println "  lake exe check-deps List.flatMap List.mergeSort"
    IO.println ""
    IO.println "Available commands (use directly in Lean files):"
    IO.println "  #check_deps <definition>         - Analyze single definition"
    IO.println "  #check_namespace <namespace>     - Analyze entire namespace"
    IO.println "  #module_of <constant>            - View module source of constant"
    IO.println ""
    IO.println "Example Lean code:"
    IO.println "```lean"
    IO.println "import Tools.CheckDeps"
    IO.println "import YourModule"
    IO.println ""
    IO.println "#check_deps yourFunction"
    IO.println "#check_namespace YourNamespace"
    IO.println "```"
    IO.println ""

    return 0

  -- Process arguments
  let firstArg := args.head!

  -- Generate analysis script
  IO.println "======================================================================"
  IO.println "              Lean4 Dependency Checker - Script Generator           "
  IO.println "======================================================================"
  IO.println ""

  -- Generate unique temporary file using timestamp
  let now ← IO.monoMsNow
  let scriptPath := s!"/tmp/check_deps_analyze_{now}.lean"
  let mut scriptContent := "import Tools.CheckDeps\n"

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
      scriptContent := scriptContent ++ "open DependencyChecker in\n\n"
      scriptContent := scriptContent ++ s!"#check_namespace {namespaceName}\n"

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
      scriptContent := scriptContent ++ "open DependencyChecker in\n\n"
      scriptContent := scriptContent ++ s!"#check_namespace {firstArg}\n"
    else
      -- Multiple definitions or function names
      scriptContent := scriptContent ++ "\nopen DependencyChecker in\n\n"
      for arg in args do
        scriptContent := scriptContent ++ s!"#check_deps {arg}\n"

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
  import Tools.CheckDeps

Then use the following commands:

1. Check dependencies of a single definition:
   #check_deps yourFunction

2. Check dependencies of multiple definitions:
   #check_deps function1 function2 function3

3. Check dependencies for all definitions in a namespace:
   #check_namespace YourNamespace

4. Check which module a constant comes from:
   #module_of someConstant

Example:
```lean
import Tools.CheckDeps
import CodeVerifBenchmark.LeetCode.no_22_leetcode_23

open DependencyChecker

#check_deps no_22_leetcode_23.flattenAndSort
#check_namespace no_22_leetcode_23
#module_of List.flatMap
```

The tool categorizes dependencies into:
- Mathlib dependencies
- Standard library (Std) dependencies
- Core library (Init) dependencies
- Local/other dependencies
-/
