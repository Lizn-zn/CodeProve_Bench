# Lean 4 Code Analysis Tools

This directory contains tools for analyzing Lean 4 code, including dependency checking and recursion detection.

## 📋 Table of Contents

- [Dependency Checker](#dependency-checker)
- [Recursion Checker](#recursion-checker)
- [Files](#files)

---

## 🔍 Dependency Checker

Analyze **any** Lean 4 file to see which libraries and modules it depends on.

### Features

- 🔍 **Analyze any Lean file** - Supports all Lean files in the project
- 📊 **Detailed dependency reports** - Shows library functions and module sources for each definition
- 🎯 **Multiple usage modes** - File paths, namespaces, individual definitions, etc.
- 🚀 **Automated analysis** - Complete reports with a single command

### Usage

#### Method 1: Executable File (Recommended for any file)

```bash
# Show help
lake exe check-deps

# Analyze a specific Lean file (works for any file)
lake exe check-deps CodeVerifBenchmark/LeetCode/no_22_leetcode_23.lean
lake exe check-deps CodeVerifBenchmark/LeetCode/no_227_leetcode_266.lean
lake exe check-deps CodeVerifBenchmark/CodeExercises/no_864_codeexercises_1316.lean

# Analyze individual definitions
lake exe check-deps List.flatMap List.mergeSort
```

#### Method 2: Direct use in Lean files

Add the import at the beginning of your Lean file:

```lean
import Tools.CheckDeps
```

Then use these commands:

```lean
-- Analyze a single definition
#check_deps yourFunction

-- Analyze an entire namespace
#check_namespace YourNamespace

-- View the module source of constants
#module_of List.flatMap List.mergeSort
```

### Output Categories

The tool categorizes dependencies into:

- 📚 **Mathlib dependencies** - Functions and theorems from Mathlib
- 📦 **Standard library (Std) dependencies** - Definitions from Lean 4 Std
- ⚙️ **Core library (Init) dependencies** - Definitions from Lean 4 Init
- 🏠 **Local/other dependencies** - Local project definitions or other modules

### Example Output

```
📋 Analyzing definition: no_22_leetcode_23.flattenAndSort
======================================================================
📊 Total of 9 external constants used

⚙️  Core library (Init) dependencies:
   • Int.decLe
   • id
   • Int
   • LE.le
   • List
   • Decidable.decide
   • List.mergeSort
   • List.flatMap
   • Int.instLEInt
```

---

## 🔄 Recursion Checker

Analyze Lean 4 code for recursive and looping functions.

### Features

- 🔍 **Detect direct recursion** - Functions that call themselves
- 🔀 **Detect mutual recursion** - Multiple functions that call each other
- ⚠️ **Detect partial functions** - Functions with unproven termination
- 📋 **Show dependencies** - List all constants used by functions

### Usage

#### Method 1: Executable File (Recommended for any file)

```bash
# Show help
lake exe check-rec

# Analyze a specific Lean file (works for any file)
lake exe check-rec CodeVerifBenchmark/LeetCode/no_22_leetcode_23.lean
lake exe check-rec CodeVerifBenchmark/LeetCode/no_227_leetcode_266.lean
lake exe check-rec CodeVerifBenchmark/CodeExercises/no_864_codeexercises_1316.lean

# Analyze individual definitions
lake exe check-rec List.mergeSort List.foldl
```

#### Method 2: Direct use in Lean files

Add the import at the beginning of your Lean file:

```lean
import Tools.CheckRec
open RecursionChecker
```

#### Available Commands

```lean
-- Check a single function
#check_rec yourFunction

-- Check multiple functions
#check_rec function1 function2 function3

-- Check an entire namespace
#check_namespace_rec YourNamespace
```

### Example

```lean
import Tools.CheckRec
import CodeVerifBenchmark.LeetCode.no_22_leetcode_23

open RecursionChecker

-- Check a single function
#check_rec no_22_leetcode_23.flattenAndSort

-- Check an entire namespace
#check_namespace_rec no_22_leetcode_23
```

### Detected Recursion Types

1. **Direct recursion**: Function directly calls itself in its definition
2. **Mutual recursion**: Multiple functions call each other forming recursion
3. **Partial functions**: Functions defined with `partial` keyword (termination not proven)

### Output Information

The tool displays:

- 📝 **Type**: Function definition type (def, theorem, opaque, etc.)
- 🔄 **Direct recursion**: Whether direct recursion is detected
- 🔀 **Mutual recursion**: Whether mutual recursion relationships are detected
- 📋 **Constants used**: All other constants used by the function (for debugging)
- ✓ **Conclusion**: Overall judgment

### Important Notes and Limitations

#### Lean 4 Recursion Mechanism

The Lean 4 compiler performs extensive optimization and transformation on recursive functions:

1. **Structural recursion** is converted to use recursors (`brecOn`, `recOn`, etc.)
2. **Recursive functions** no longer directly reference themselves, but use underlying recursion mechanisms
3. **Partial functions** are compiled to opaque definitions

#### Detection Limitations

Due to Lean 4 compiler optimizations, the following cases **may not be detected**:

- Standard recursive functions with termination proven via `termination_by` and `decreasing_by`
- Tail-recursive functions optimized by the compiler
- Recursion implemented using Lean standard library recursors

#### What Can Be Detected

✓ Functions that directly reference themselves (before compilation)
✓ Mutually recursive function pairs
✓ Some partial functions (if marked as unsafe)

#### Recommended Usage

For scenarios requiring strict recursion checking, we recommend:

1. **Source code level checking**: Check for recursion patterns during code review
2. **Documentation annotation**: Add documentation comments to recursive functions
3. **Termination proofs**: Prefer using `termination_by` to prove termination rather than `partial`

### Technical Details

#### Detection Methods

1. **Direct recursion detection**: Check if the function's used constant set contains itself
2. **Mutual recursion detection**: Check if function A uses B and B also uses A
3. **Partial detection**: Check the definition's safety flag

#### Implementation

The tool accesses the Environment through Lean 4's metaprogramming API to obtain:
- Constant information (`ConstantInfo`)
- Used constant sets (`getUsedConstantsAsSet`)
- Definition safety flags (`DefinitionSafety`)

---

## 📁 Files

- `CheckDeps.lean` - Dependency checking tool with executable entry point (**Recommended**)
- `CheckRec.lean` - Recursion checker tool
- `DEPENDENCY_CHECKER_README.md` - Detailed documentation for dependency checker
- `RECURSION_CHECKER_README.md` - Detailed documentation for recursion checker
- `CHECK_DEPS_QUICKSTART.md` - Quick start guide for dependency checker

## 🎯 Use Cases

### 1. Analyze LeetCode Problem Files

```bash
lake exe check-deps CodeVerifBenchmark/LeetCode/no_22_leetcode_23.lean
lake exe check-deps CodeVerifBenchmark/LeetCode/no_227_leetcode_266.lean
```

### 2. Analyze CodeExercises Files

```bash
lake exe check-deps CodeVerifBenchmark/CodeExercises/no_864_codeexercises_1316.lean
lake exe check-deps CodeVerifBenchmark/CodeExercises/no_97297_codeexercises_197297.lean
```

### 3. Batch Analyze Multiple Definitions

```bash
lake exe check-deps List.flatMap List.mergeSort List.filter
```

### 4. Check for Recursion

```lean
import Tools.CheckRec

#check_rec List.flatMap
#check_namespace_rec YourModule
```

## 🔧 Related Tools

These tools complement each other:
- Use **Dependency Checker** to understand what libraries and functions your code uses
- Use **Recursion Checker** to identify recursive patterns in your functions

## 💡 Tips

- Combine source code review with these tools for best results
- For recursion checking, note that Lean 4's compiler optimizations may hide some recursion patterns
- Use the executable version of dependency checker for convenient file-level analysis

## 📝 Feedback

If you find that the tools cannot detect certain patterns or have suggestions for improvement, please provide feedback. These tools work best when combined with manual code review.

