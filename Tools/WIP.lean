import Mathlib
import Lean
import Lean.Compiler.LCNF

open Lean Meta Elab Command
open Lean.Compiler.LCNF

-- Recursive unfolding helper function
partial def unfoldExprDeep (expr : Expr) (maxDepth : Nat) (visited : List Name := []) : MetaM Expr := do
  if maxDepth == 0 then return expr

  -- If lambda, recursively unfold function body
  match expr with
  | .lam name ty body bi =>
    let bodyUnfolded ← unfoldExprDeep body maxDepth visited
    return .lam name ty bodyUnfolded bi
  | _ =>
    -- Try to unfold constant
    matchConst expr.getAppFn (fun _ => pure expr) fun cinfo fLvls => do
      -- Avoid circular unfolding
      if visited.contains cinfo.name then
        return expr

      if cinfo.hasValue && cinfo.levelParams.length == fLvls.length then
        -- Get the value of the definition
        let defValue ← instantiateValueLevelParams cinfo fLvls

        -- Apply all arguments
        let args := expr.getAppArgs
        let revArgs := List.toArray args.reverse.toList
        let expanded := defValue.betaRev revArgs (useZeta := true)

        -- Recursively unfold
        unfoldExprDeep expanded (maxDepth - 1) (cinfo.name :: visited)
      else
        pure expr

elab "#show_def" e:term : command => do
  liftTermElabM do
    let term ← Term.elabTerm e.raw none
    let exprToShow ← Meta.withTransparency .all <| do
      matchConst term.getAppFn (fun _ => pure term) fun cinfo fLvls => do
        if cinfo.hasValue && cinfo.levelParams.length == fLvls.length then
          let defValue ← instantiateValueLevelParams cinfo fLvls
          let expanded1 := defValue.betaRev term.getAppRevArgs (useZeta := true)
          match expanded1.getAppFn with
          | Expr.const constName2 levels2 =>
            match (← getEnv).find? constName2 with
            | some cinfo2 =>
              if cinfo2.hasValue && cinfo2.levelParams.length == levels2.length &&
                 constName2 != cinfo.name then
                let defValue2 ← instantiateValueLevelParams cinfo2 levels2
                pure (defValue2.betaRev expanded1.getAppRevArgs (useZeta := true))
              else
                pure expanded1
            | _ => pure expanded1
          | _ => pure expanded1
        else
          pure term
    let normalized ← try
      Meta.zetaReduce exprToShow
    catch _ =>
      pure exprToShow
    let fmt ← Meta.withTransparency .default <| Meta.ppExpr normalized
    -- Output directly to stdout
    IO.println "===CONTENT_START==="
    IO.println fmt.pretty
    IO.println "===CONTENT_END==="

-- Command to check declaration type
elab "#check_type" e:ident : command => do
  let declName := e.getId
  let env ← getEnv
  match env.find? declName with
  | none => throwError "not found declaration '{declName}'"
  | some cinfo =>
    let kindStr := match cinfo with
    | .defnInfo _ => "def"
    | .thmInfo _ => "theorem"
    | .axiomInfo _ => "axiom"
    | .opaqueInfo _ => "opaque"
    | .quotInfo _ => "quot  "
    | .inductInfo _ => "inductive"
    | .ctorInfo _ => "constructor"
    | .recInfo _ => "recursor"

    let hasValueStr := if cinfo.hasValue then "has definition" else "no definition"
    logInfo m!"{declName} is {kindStr}, {hasValueStr}"

-- Print declaration's doc comment
elab "#print_doc" e:ident : command => do
  let declName := e.getId
  let env ← getEnv

  -- Check if declaration exists
  match env.find? declName with
  | none => throwError "not found declaration '{declName}'"
  | some _ =>
    -- Get doc string
    match ← findDocString? env declName with
    | none => logInfo m!"{declName} has no doc comment"
    | some docStr =>
      logInfo m!"Documentation for {declName}:\n{docStr}"

-- #check List.map
-- #check @List.map Float Float

elab "#print_signature" e:term : command => do
  try
    liftTermElabM do
      let expr ← Term.elabTerm e.raw none
      let typeExpr ← Meta.inferType expr
      let sigStr ← Meta.ppExpr typeExpr
      IO.println "===SIGNATURE_START==="
      IO.println sigStr.pretty
      IO.println "===SIGNATURE_END==="
  catch _ =>
    IO.println "===NO_SIGNATURE==="

#print_doc List.map

#check @Min.min Nat
#print_signature @Min.min Nat

def test := @List.map Float Float


#check test
#show_def test

#check Int

#check Nat

elab "#compile_decl" name:ident : command => do
  let declName := name.getId
  unless (← getEnv).contains declName do
    throwError "unknown declaration '{declName}'"
  logInfo m!"Compiling declaration '{declName}'..."

  let irDecls ← liftCoreM <| do
    compileDecls [declName] (logErrors := true)
    try
      compile #[declName]
    catch _ =>
      return #[]

  if irDecls.isEmpty then
    logInfo m!"Declaration '{declName}' compiled (using old compiler - no IR available)."
  else
    logInfo m!"Declaration '{declName}' compiled successfully. Generated {irDecls.size} IR declarations:"
    for irDecl in irDecls do
      logInfo m!"\nIR Declaration: {irDecl.name}"
      let lcnfFmt ← liftCoreM <| do
        try
          let fmt ← showDecl .mono declName
          return fmt
        catch _ =>
          return "<LCNF not available>"
      logInfo m!"LCNF representation:\n{lcnfFmt}"

      logInfo m!"IR type: {irDecl.resultType}"
      logInfo m!"IR params: {irDecl.params.size}"
      match irDecl with
      | .fdecl (body := body) .. => logInfo m!"IR body present"
      | .extern .. => logInfo m!"IR extern declaration"


def remove_duplicates_from_dictionary_aux (dictionary : List (String × Nat)) : List (String × Nat) :=
  let seen : List Nat := []
  let rec helper (pairs : List (String × Nat)) (seen_so_far : List Nat) : List (String × Nat) :=
    match pairs with
    | [] => []
    | (k, v) :: rest =>
      if v ∈ seen_so_far then
        helper rest seen_so_far
      else
        (k, v) :: helper rest (v :: seen_so_far)
  helper dictionary seen

def round_float (x : Float) (precision : Nat) : Float :=
  let factor := (10.0 : Float) ^ (precision : Nat).toFloat
  ((x * factor).round) / factor

#compile_decl List.eraseDup

#compile_decl remove_duplicates_from_dictionary_aux.helper
#compile_decl Float.ofScientific


def test_Array_all_iff_forall_Nat := @Array.all Nat

#show_def Array.all

#compile_decl test_Array_all_iff_forall_Nat

-- test #check_type
#check_type Array.all
#check_type Nat

-- test #print_doc
#print_doc Array.all
#print_doc List.map
#print_doc Nat.add


def pre_test_Array__sizeOf_inst_Nat (m : Array Nat) : Prop :=
  Nonempty (SizeOf Nat)

def post_test_Array__sizeOf_inst_Nat (m : Array Nat) (r : Nat) : Prop :=
  r = m._sizeOf_1 ∧ r ≥ 0

#print Array.all

def test_Array_all_Int := @Array.all Int

#print test_Array_all_Int
#check_type test_Array_all_Int
#show_def Array.all
#show_def test_Array_all_Int


-- theorem map_correct_aux {α β : Type} (f : α → β) (x : α) (xs : List α)
--   (ih : pre_map f xs → post_map f xs (List.map f xs))
--   (a : pre_map f (x :: xs)) :
--   ∀ (i : ℕ) (hi : i < (x :: xs).length), (List.map f (x :: xs))[i] = f ((x :: xs)[i]) := by
--   intro i hi
--   cases i with
--   | zero =>
--     simp [List.get, List.map]
--   | succ i' =>
--     simp [List.get, List.map]
--     have h₁ := ih trivial
--     have h₂ := h₁.right i' (by simpa using Nat.succ_lt_succ_iff.mp hi)
--     simp [h₂]

def test_Array_back_Nat := @Array.back Nat


#print_signature test_Array_back_Nat
