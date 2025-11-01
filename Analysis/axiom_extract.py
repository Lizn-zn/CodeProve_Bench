#!/usr/bin/env python3
"""
过滤掉没有输入参数的 Lean 4 定义

使用方法:
    python axiom_extract.py
"""

import subprocess
import tempfile
import os
from typing import List, Set
from concurrent.futures import ThreadPoolExecutor, as_completed

PROJECT_ROOT = "/local/home/zenali/CodeVerif-Lean4"

all_deps = [
      "Alternative.toApplicative",
      "And",
      "And.casesOn",
      "And.intro",
      "And.left",
      "And.right",
      "Applicative.toFunctor",
      "Applicative.toPure",
      "Array",
      "Array._sizeOf_inst",
      "Array.all",
      "Array.all_congr",
      "Array.all_eq",
      "Array.all_iff_forall",
      "Array.any",
      "Array.any_congr",
      "Array.any_eq",
      "Array.any_eq_true._simp_1",
      "Array.any_iff_exists",
      "Array.append",
      "Array.back!",
      "Array.casesOn",
      "Array.contains",
      "Array.count",
      "Array.drop",
      "Array.empty",
      "Array.eraseIdx",
      "Array.eraseIdx!",
      "Array.extract",
      "Array.filter",
      "Array.filterMap",
      "Array.find?",
      "Array.findIdx?",
      "Array.foldl",
      "Array.get!",
      "Array.getD",
      "Array.getD_eq_getD_getElem?",
      "Array.getElem!_eq_getD",
      "Array.getElem_eraseIdx",
      "Array.getElem_eraseIdx._proof_2",
      "Array.getElem_eraseIdx._proof_4",
      "Array.getElem_map",
      "Array.getElem_map._proof_1",
      "Array.getElem_mapIdx",
      "Array.getElem_mapIdx._proof_1",
      "Array.getElem_setIfInBounds",
      "Array.getElem_setIfInBounds._proof_1",
      "Array.getElem_setIfInBounds_self",
      "Array.getElem_set_self",
      "Array.getElem_set_self._proof_1",
      "Array.getInternal",
      "Array.idxOf",
      "Array.insertionSort",
      "Array.instAppend",
      "Array.instDecidableMemOfLawfulBEq",
      "Array.instForIn'InferInstanceMembership",
      "Array.instGetElem?NatLtSize",
      "Array.instGetElemNatLtSize",
      "Array.instInhabited",
      "Array.instLawfulGetElemNatLtSize",
      "Array.instMembership",
      "Array.isEmpty",
      "Array.map",
      "Array.mapIdx",
      "Array.mk",
      "Array.mkArray",
      "Array.mkEmpty",
      "Array.modify",
      "Array.ofFn",
      "Array.ofSubarray",
      "Array.push",
      "Array.qsort",
      "Array.range",
      "Array.replicate",
      "Array.reverse",
      "Array.set",
      "Array.set!",
      "Array.setIfInBounds",
      "Array.setIfInBounds.eq_1",
      "Array.setIfInBounds_comm",
      "Array.size",
      "Array.size_eraseIdx",
      "Array.size_map",
      "Array.size_mapIdx",
      "Array.size_set",
      "Array.size_setIfInBounds",
      "Array.sum",
      "Array.take",
      "Array.toArrayLit_eq",
      "Array.toList",
      "Array.toSubarray",
      "BEq",
      "BEq.beq",
      "BEq.mk",
      "BaseIO",
      "Bind.bind",
      "BitVec.ofFin",
      "Bool",
      "Bool._sizeOf_inst",
      "Bool.and",
      "Bool.and_eq_true",
      "Bool.and_true",
      "Bool.casesOn",
      "Bool.false",
      "Bool.false_eq_true",
      "Bool.false_or",
      "Bool.forall_bool._simp_1",
      "Bool.if_false_left",
      "Bool.if_false_right",
      "Bool.if_true_left",
      "Bool.not",
      "Bool.not_eq_eq_eq_not._simp_1",
      "Bool.not_eq_false",
      "Bool.not_eq_true",
      "Bool.not_true",
      "Bool.or",
      "Bool.or_eq_true",
      "Bool.true",
      "Bool.xor",
      "ByteArray",
      "ByteArray.get!",
      "ByteArray.isEmpty",
      "Char",
      "Char.instDecidableLe",
      "Char.instInhabited",
      "Char.instLE",
      "Char.isAlpha",
      "Char.isDigit",
      "Char.isLower",
      "Char.isUpper",
      "Char.isWhitespace",
      "Char.ofNat",
      "Char.toLower",
      "Char.toNat",
      "Char.toString",
      "Char.toUpper",
      "Char.val",
      "Decidable",
      "Decidable.byContradiction",
      "Decidable.casesOn",
      "Decidable.decide",
      "Decidable.imp_iff_not_or",
      "Decidable.isFalse",
      "Decidable.isTrue",
      "DecidableEq",
      "DecidablePred",
      "DecidableRel",
      "Dvd.dvd",
      "EIO",
      "EmptyCollection.emptyCollection",
      "Eq",
      "Eq.casesOn",
      "Eq.mp",
      "Eq.mpr",
      "Eq.mpr_prop",
      "Eq.ndrec",
      "Eq.propIntro",
      "Eq.rec",
      "Eq.refl",
      "Eq.substr",
      "Eq.symm",
      "Eq.trans",
      "Except",
      "Except.casesOn",
      "Except.error",
      "Except.ok",
      "Exists",
      "Exists.casesOn",
      "Exists.choose",
      "Exists.intro",
      "False",
      "False.elim",
      "Fin",
      "Fin.casesOn",
      "Fin.cast",
      "Fin.castSucc",
      "Fin.instGetElem?FinVal",
      "Fin.instGetElemFinVal",
      "Fin.instOfNat",
      "Fin.last",
      "Fin.mk",
      "Fin.succ",
      "Fin.val",
      "Float",
      "Float._sizeOf_inst",
      "Float.abs",
      "Float.atan2",
      "Float.decLe",
      "Float.decLt",
      "Float.floor",
      "Float.ofInt",
      "Float.ofNat",
      "Float.round",
      "Float.sqrt",
      "Float.toUInt64",
      "ForIn.forIn",
      "ForInStep",
      "ForInStep.done",
      "ForInStep.yield",
      "GE.ge",
      "GT.gt",
      "GetElem",
      "GetElem.getElem",
      "GetElem?.getElem!",
      "GetElem?.getElem?",
      "GetElem?.toGetElem",
      "HAdd.hAdd",
      "HAnd.hAnd",
      "HAppend.hAppend",
      "HDiv.hDiv",
      "HEq",
      "HEq.refl",
      "HMod.hMod",
      "HMul.hMul",
      "HOr.hOr",
      "HPow.hPow",
      "HShiftLeft.hShiftLeft",
      "HShiftRight.hShiftRight",
      "HSub.hSub",
      "HXor.hXor",
      "HasSubset.Subset",
      "Hashable",
      "Hashable.hash",
      "Hashable.mk",
      "IO",
      "IO.Error",
      "IO.print",
      "IO.println",
      "IO.rand",
      "Id",
      "Id.instMonad",
      "Id.instMonadLiftTOfPure",
      "Id.instOfNat",
      "Id.run",
      "Iff",
      "Iff.intro",
      "Iff.mp",
      "Iff.mpr",
      "Iff.of_eq",
      "Iff.rfl",
      "Inhabited",
      "Inhabited.default",
      "Inhabited.mk",
      "Insert.insert",
      "Int",
      "Int.Linear.Expr.add",
      "Int.Linear.Expr.eq_of_norm_eq",
      "Int.Linear.Expr.mulL",
      "Int.Linear.Expr.mulR",
      "Int.Linear.Expr.var",
      "Int.Linear.Poly.add",
      "Int.Linear.Poly.num",
      "Int.Linear.eq_eq_true",
      "Int._sizeOf_inst",
      "Int.add_assoc",
      "Int.add_mul",
      "Int.add_zero",
      "Int.casesOn",
      "Int.cast",
      "Int.cast_id",
      "Int.decLe",
      "Int.decLt",
      "Int.decidableDvd",
      "Int.dvd_eq_true_of_mod_eq_zero",
      "Int.ediv_add_emod'",
      "Int.emod_eq_zero_of_dvd",
      "Int.instAdd",
      "Int.instDecidableEq",
      "Int.instDiv",
      "Int.instDvd",
      "Int.instInhabited",
      "Int.instLEInt",
      "Int.instLTInt",
      "Int.instLawfulBEq",
      "Int.instMax",
      "Int.instMin",
      "Int.instMod",
      "Int.instMul",
      "Int.instNegInt",
      "Int.instSub",
      "Int.le_antisymm",
      "Int.le_of_lt",
      "Int.le_refl._simp_1",
      "Int.lt_irrefl",
      "Int.lt_trans",
      "Int.mul_add",
      "Int.mul_comm",
      "Int.mul_ediv_assoc",
      "Int.mul_ediv_cancel_left",
      "Int.mul_neg_of_neg_of_pos",
      "Int.mul_one",
      "Int.natAbs",
      "Int.natCast_nonneg",
      "Int.negSucc",
      "Int.not_le",
      "Int.not_lt._simp_1",
      "Int.ofNat",
      "Int.ofNat_eq_natCast",
      "Int.one_mul",
      "Int.sub_add_cancel",
      "Int.sub_self",
      "Int.sub_sub_self",
      "Int.toNat",
      "Int.toNat_ofNat",
      "Int.toNat_of_nonneg",
      "Int.zero_add",
      "Int.zero_le_ofNat",
      "Inter.inter",
      "LE",
      "LE.le",
      "LT.lt",
      "Lean.Loop",
      "Lean.Loop.mk",
      "Lean.Name",
      "Lean.Name.anonymous",
      "Lean.Name.mkStr1",
      "Lean.Name.mkStr2",
      "Lean.Name.num",
      "Lean.Name.str",
      "Lean.ParserDescr.binary",
      "Lean.ParserDescr.cat",
      "Lean.ParserDescr.symbol",
      "Lean.ParserDescr.trailingNode",
      "Lean.RArray.branch",
      "Lean.RArray.leaf",
      "Lean.TrailingParserDescr",
      "Lean.instForInLoopUnit",
      "List",
      "List.Nodup",
      "List.Pairwise",
      "List.Perm",
      "List.Sublist",
      "List._sizeOf_inst",
      "List.all",
      "List.all_eq_true._simp_1",
      "List.all_toArray'",
      "List.any",
      "List.any_eq_true._simp_1",
      "List.append",
      "List.asString",
      "List.attach",
      "List.below",
      "List.beq",
      "List.brecOn",
      "List.casesOn",
      "List.concat",
      "List.cons",
      "List.contains",
      "List.count",
      "List.countP",
      "List.decidableBAll",
      "List.decidableBEx",
      "List.decidablePerm",
      "List.drop",
      "List.dropLast",
      "List.dropWhile",
      "List.elem",
      "List.enum",
      "List.erase",
      "List.eraseDups",
      "List.eraseIdx",
      "List.eraseP",
      "List.extract",
      "List.filter",
      "List.filterMap",
      "List.filter_unattach",
      "List.filter_wfParam",
      "List.finRange",
      "List.find?",
      "List.findIdx?",
      "List.flatMap",
      "List.flatMap_unattach",
      "List.flatMap_wfParam",
      "List.flatten",
      "List.foldl",
      "List.foldr",
      "List.forM",
      "List.get",
      "List.get!",
      "List.get?",
      "List.getD",
      "List.getElem!_eq_getElem?_getD",
      "List.getElem!_toArray",
      "List.getElem?_map",
      "List.getElem_map",
      "List.getElem_singleton",
      "List.getElem_toArray._proof_1",
      "List.getLast!",
      "List.getLast?",
      "List.getLastD",
      "List.head!",
      "List.head?",
      "List.headD",
      "List.idxOf",
      "List.indexOf",
      "List.indexOf?",
      "List.instAppend",
      "List.instBEq",
      "List.instDecidableMemOfLawfulBEq",
      "List.instDecidablePairwise",
      "List.instDecidableRelSubsetOfDecidableEq",
      "List.instForIn'InferInstanceMembership",
      "List.instGetElem?NatLtLength",
      "List.instGetElemNatLtLength",
      "List.instHasSubset",
      "List.instLawfulGetElemNatLtLength",
      "List.instMembership",
      "List.intersperse",
      "List.isEmpty",
      "List.isPerm",
      "List.length",
      "List.length_eq_zero_iff._simp_1",
      "List.length_filter_le",
      "List.length_map",
      "List.length_mapIdx",
      "List.lookup",
      "List.map",
      "List.mapIdx",
      "List.mapIdx_toArray",
      "List.mapM",
      "List.map_unattach.match_1",
      "List.max?",
      "List.mem_mapIdx._simp_1",
      "List.mem_range._simp_1",
      "List.mergeSort",
      "List.min?",
      "List.min?_eq_none_iff",
      "List.min?_eq_some_iff'",
      "List.nil",
      "List.noConfusion",
      "List.nodupDecidable",
      "List.ofFn",
      "List.partition",
      "List.range",
      "List.range'",
      "List.rec",
      "List.replicate",
      "List.reverse",
      "List.rotateRight",
      "List.set",
      "List.size_toArray",
      "List.splitAt",
      "List.sum",
      "List.tail",
      "List.tail!",
      "List.tail?",
      "List.take",
      "List.takeWhile",
      "List.toArray",
      "List.unattach",
      "List.zip",
      "List.zipIdx",
      "List.zipWith",
      "MProd",
      "MProd.casesOn",
      "MProd.fst",
      "MProd.mk",
      "MProd.snd",
      "Max.max",
      "Membership",
      "Membership.mem",
      "Min.min",
      "Monad.toApplicative",
      "Monad.toBind",
      "MonadLiftT.monadLift",
      "Nat",
      "Nat.Linear.Expr.add",
      "Nat.Linear.Expr.num",
      "Nat.Linear.Expr.var",
      "Nat.Linear.ExprCnstr.eq_of_toNormPoly_eq",
      "Nat.Linear.ExprCnstr.mk",
      "Nat.Simproc.add_le_le",
      "Nat.add",
      "Nat.add_assoc",
      "Nat.add_comm",
      "Nat.add_eq_zero._simp_1",
      "Nat.add_left_cancel_iff._simp_1",
      "Nat.add_lt_add_iff_right",
      "Nat.add_lt_add_iff_right._simp_1",
      "Nat.add_lt_of_lt_sub",
      "Nat.add_mul",
      "Nat.below",
      "Nat.beq",
      "Nat.ble",
      "Nat.blt",
      "Nat.brecOn",
      "Nat.casesAuxOn",
      "Nat.casesOn",
      "Nat.cast",
      "Nat.decEq",
      "Nat.decLe",
      "Nat.decLt",
      "Nat.decidableBallLT",
      "Nat.decidableExistsFin",
      "Nat.decidableExistsLT",
      "Nat.decidableExistsLT'",
      "Nat.decidable_dvd",
      "Nat.div_zero",
      "Nat.elimOffset",
      "Nat.eq_iff_le_and_ge",
      "Nat.gcd",
      "Nat.instAndOp",
      "Nat.instDiv",
      "Nat.instDvd",
      "Nat.instLawfulBEq",
      "Nat.instMax",
      "Nat.instMod",
      "Nat.instNeZeroSucc",
      "Nat.instOrOp",
      "Nat.instShiftLeft",
      "Nat.instShiftRight",
      "Nat.instXor",
      "Nat.land",
      "Nat.lcm",
      "Nat.le",
      "Nat.le.casesOn",
      "Nat.le.refl",
      "Nat.le.step",
      "Nat.le_add_right_of_le",
      "Nat.le_of_lt_add_one",
      "Nat.le_of_mul_le_mul_left",
      "Nat.le_sub_of_add_le",
      "Nat.le_sub_one_of_lt",
      "Nat.le_succ",
      "Nat.le_total",
      "Nat.le_trans",
      "Nat.le_zero_eq",
      "Nat.log2",
      "Nat.lt_add_one._simp_1",
      "Nat.lt_of_add_right_lt",
      "Nat.lt_of_le_of_lt",
      "Nat.lt_of_le_of_ne",
      "Nat.lt_of_lt_of_le",
      "Nat.lt_of_succ_lt_succ",
      "Nat.lt_one_iff._simp_1",
      "Nat.lt_succ_of_le",
      "Nat.lt_trans",
      "Nat.max",
      "Nat.min",
      "Nat.min_eq_left",
      "Nat.min_eq_right",
      "Nat.mod_lt",
      "Nat.mod_zero",
      "Nat.mul_add",
      "Nat.mul_comm",
      "Nat.mul_le_mul",
      "Nat.mul_one",
      "Nat.ne_zero_of_lt",
      "Nat.noConfusion",
      "Nat.not_le",
      "Nat.not_le._simp_1",
      "Nat.not_lt",
      "Nat.not_lt._simp_1",
      "Nat.not_lt_of_ge",
      "Nat.not_lt_of_le",
      "Nat.not_lt_zero._simp_1",
      "Nat.one_le_iff_ne_zero",
      "Nat.pos_of_ne_zero",
      "Nat.pow",
      "Nat.rec",
      "Nat.recAux",
      "Nat.repr",
      "Nat.shiftRight",
      "Nat.sub",
      "Nat.sub_add_cancel",
      "Nat.sub_add_eq",
      "Nat.sub_eq_zero_iff_le",
      "Nat.sub_eq_zero_of_le",
      "Nat.sub_le",
      "Nat.sub_lt_sub_right",
      "Nat.sub_one_lt_of_le",
      "Nat.sub_pos_of_lt",
      "Nat.sub_self",
      "Nat.sub_sub_self",
      "Nat.succ",
      "Nat.succ_le_of_lt",
      "Nat.succ_ne_self._simp_1",
      "Nat.succ_ne_zero",
      "Nat.testBit",
      "Nat.toDigits",
      "Nat.toFloat",
      "Nat.toUInt8",
      "Nat.xor",
      "Nat.zero",
      "Nat.zero_add",
      "Nat.zero_le",
      "Nat.zero_le._simp_1",
      "Nat.zero_lt_one",
      "Nat.zero_lt_sub_of_lt",
      "Nat.zero_lt_succ._simp_1",
      "Ne",
      "Neg.neg",
      "Not",
      "OfNat.ofNat",
      "OfScientific.ofScientific",
      "One.toOfNat1",
      "Option",
      "Option._sizeOf_inst",
      "Option.casesOn",
      "Option.get!",
      "Option.getD",
      "Option.instDecidableEq",
      "Option.isNone",
      "Option.isSome",
      "Option.map",
      "Option.noConfusion",
      "Option.none",
      "Option.some",
      "Option.some_inj",
      "Or",
      "Or.casesOn",
      "Or.elim",
      "Or.inl",
      "Or.inr",
      "Ord",
      "Ord.compare",
      "Ordering",
      "Ordering.eq",
      "Ordering.gt",
      "Ordering.lt",
      "PProd",
      "PProd.mk",
      "PSigma",
      "PSigma.mk",
      "PUnit",
      "PUnit.unit",
      "Prod",
      "Prod._sizeOf_inst",
      "Prod.casesOn",
      "Prod.fst",
      "Prod.mk",
      "Prod.noConfusion",
      "Prod.snd",
      "Pure.pure",
      "Repr",
      "Repr.mk",
      "SDiff.sdiff",
      "Singleton.singleton",
      "SizeOf",
      "SizeOf.sizeOf",
      "Std.Iterators.Iter.attachWith",
      "Std.Iterators.Iter.map",
      "Std.Iterators.Iter.toIterM",
      "Std.Iterators.Iter.uLift",
      "Std.Iterators.Map",
      "Std.Iterators.Map.instIteratorCollect",
      "Std.Iterators.PostconditionT",
      "Std.Iterators.Types.Attach",
      "Std.Iterators.Types.Attach.instIterator",
      "Std.Iterators.Types.ULiftIterator",
      "Std.Iterators.Types.ULiftIterator.instIterator",
      "Std.Iterators.Types.ULiftIterator.instIteratorCollect",
      "Std.Iterators.ULiftT",
      "Std.Iterators.instIteratorCollectState",
      "Std.Iterators.instIteratorMap",
      "Std.Iterators.instIteratorState",
      "Std.Iterators.instMonadPostconditionT",
      "Std.Iterators.instMonadULiftT",
      "Std.PRange.BoundShape.closed",
      "Std.PRange.BoundShape.open",
      "Std.PRange.Internal.iter",
      "Std.PRange.RangeIterator",
      "Std.PRange.RangeShape.mk",
      "Std.PRange.instBoundedUpwardEnumerableClosed",
      "Std.PRange.instIteratorRangeIteratorIdOfUpwardEnumerableOfSupportsUpperBound",
      "Std.PRange.instSupportsUpperBoundOpenOfDecidableLT",
      "Std.PRange.instUpwardEnumerableNat",
      "Std.PRange.mk",
      "Std.Range",
      "Std.Range.instForIn'NatInferInstanceMembership",
      "Std.Range.mk",
      "Std.Slice",
      "Std.Slice.Internal.SubarrayData",
      "Std.Slice.Internal.SubarrayData.array",
      "Std.Slice.Internal.SubarrayData.start",
      "Std.Slice.Internal.SubarrayData.stop",
      "Std.Slice.internalRepresentation",
      "Std.Slice.toList",
      "Std.instMembershipNatRange",
      "String",
      "String.Iterator",
      "String.Iterator.atEnd",
      "String.Iterator.curr",
      "String.Iterator.next",
      "String.Pos",
      "String.Pos.mk",
      "String._sizeOf_inst",
      "String.all",
      "String.any",
      "String.contains",
      "String.data",
      "String.decidableLT",
      "String.drop",
      "String.dropRight",
      "String.endPos",
      "String.endsWith",
      "String.extract",
      "String.foldl",
      "String.foldr",
      "String.get",
      "String.get!",
      "String.get?",
      "String.instAppend",
      "String.instInhabited",
      "String.instLE",
      "String.instLT",
      "String.instOfNatPos",
      "String.instSizeOfIterator",
      "String.intercalate",
      "String.isEmpty",
      "String.iter",
      "String.join",
      "String.length",
      "String.mk",
      "String.push",
      "String.replace",
      "String.singleton",
      "String.split",
      "String.splitOn",
      "String.startsWith",
      "String.take",
      "String.toInt?",
      "String.toList",
      "String.toLower",
      "String.toNat?",
      "String.toUTF8",
      "String.trim",
      "Subarray",
      "Subarray.instGetElemNatLtSize",
      "Subarray.size",
      "Subsingleton.elim",
      "Subtype",
      "Subtype.val",
      "Sum",
      "Sum.casesOn",
      "Sum.inl",
      "Sum.inr",
      "ToString.toString",
      "True",
      "True.intro",
      "UInt32",
      "UInt32.decLe",
      "UInt32.decLt",
      "UInt32.instOfNat",
      "UInt32.toNat",
      "UInt64.toNat",
      "UInt8",
      "UInt8.decLe",
      "UInt8.instOfNat",
      "UInt8.ofBitVec",
      "UInt8.ofNat",
      "UInt8.size",
      "UInt8.toNat",
      "UInt8.val",
      "UInt8.xor",
      "ULift",
      "Union.union",
      "Unit",
      "Unit.unit",
      "WellFounded.fix",
      "WellFounded.fix_eq",
      "Zero.ofOfNat0",
      "Zero.toOfNat0",
      "absurd",
      "and_false",
      "and_imp._simp_1",
      "and_self",
      "and_true",
      "beq_iff_eq",
      "beq_iff_eq._simp_1",
      "binderNameHint",
      "bne",
      "cond",
      "congr",
      "congrArg",
      "decide_eq_false_iff_not._simp_1",
      "decide_eq_true_eq",
      "dif_neg",
      "dif_pos",
      "dite",
      "dite_cond_eq_true",
      "dite_congr",
      "dite_eq_right_iff._simp_1",
      "eq_comm",
      "eq_false",
      "eq_false'",
      "eq_false_of_decide",
      "eq_self",
      "eq_true",
      "exists_and_left._simp_1",
      "exists_eq._simp_1",
      "exists_prop_congr",
      "exists_true_left._simp_1",
      "false_implies",
      "false_or",
      "forall_congr",
      "forall_const._simp_1",
      "forall_exists_index._simp_1",
      "forall_false",
      "forall_prop_decidable",
      "forall_prop_domain_congr",
      "funext",
      "ge_iff_le._simp_1",
      "getElem!_neg",
      "getElem!_pos",
      "getElem?_pos",
      "gt_iff_lt._simp_1",
      "have_body_congr'",
      "have_congr'",
      "id",
      "if_neg",
      "if_pos",
      "iff_self",
      "imp_false._simp_1",
      "imp_self._simp_1",
      "implies_congr",
      "implies_congr_ctx",
      "implies_dep_congr_ctx",
      "implies_true",
      "inferInstance",
      "inferInstanceAs",
      "instAddFloat",
      "instAddNat",
      "instAddUInt32",
      "instAddUInt8",
      "instAlternativeOption",
      "instBEqFloat",
      "instBEqOfDecidableEq",
      "instBEqProd",
      "instDecidableAnd",
      "instDecidableDite",
      "instDecidableEqBool",
      "instDecidableEqChar",
      "instDecidableEqList",
      "instDecidableEqNat",
      "instDecidableEqOfIff",
      "instDecidableEqOrdering",
      "instDecidableEqProd",
      "instDecidableEqString",
      "instDecidableEqSum",
      "instDecidableEqUInt32",
      "instDecidableEqUInt8",
      "instDecidableFalse",
      "instDecidableIff",
      "instDecidableIte",
      "instDecidableLePos",
      "instDecidableNot",
      "instDecidableOr",
      "instDecidableTrue",
      "instDivFloat",
      "instForInOfForIn'",
      "instGetElem?OfGetElemOfDecidable",
      "instHAdd",
      "instHAndOfAndOp",
      "instHAppendOfAppend",
      "instHDiv",
      "instHMod",
      "instHMul",
      "instHOrOfOrOp",
      "instHPow",
      "instHShiftLeftOfShiftLeft",
      "instHShiftRightOfShiftRight",
      "instHSub",
      "instHXorOfXor",
      "instHashableInt",
      "instHashableNat",
      "instHashableProd",
      "instHashableString",
      "instHomogeneousPowFloat",
      "instInhabitedBool",
      "instInhabitedFloat",
      "instInhabitedList",
      "instInhabitedNat",
      "instInhabitedOption",
      "instInhabitedPUnit",
      "instInhabitedProd",
      "instInhabitedTrue",
      "instInhabitedUInt32",
      "instIntCastInt",
      "instLEFloat",
      "instLENat",
      "instLEOption",
      "instLEPos",
      "instLEUInt32",
      "instLEUInt8",
      "instLTFin",
      "instLTFloat",
      "instLTNat",
      "instLTPos",
      "instLTUInt32",
      "instLawfulBEq",
      "instLawfulBEqChar",
      "instLawfulBEqString",
      "instMaxFloat",
      "instMinFloat",
      "instMinNat",
      "instMonadEIO",
      "instMonadLiftBaseIOEIO",
      "instMonadLiftT",
      "instMonadLiftTOfMonadLift",
      "instMonadOption",
      "instMulFloat",
      "instMulNat",
      "instNatCastInt",
      "instNatPowNat",
      "instNegFloat",
      "instNonemptyOfInhabited",
      "instOfNat",
      "instOfNatFloat",
      "instOfNatNat",
      "instOfScientificFloat",
      "instOrdInt",
      "instPowNat",
      "instPowOfHomogeneousPow",
      "instReprNat",
      "instReprProdOfReprTuple",
      "instReprTupleOfRepr",
      "instReprTupleProdOfRepr",
      "instSizeOfNat",
      "instSubFloat",
      "instSubNat",
      "instSubUInt32",
      "instSubsingletonDecidable",
      "instToIteratorSubarrayId",
      "instToIteratorSubarrayId.match_1",
      "instToStringFloat",
      "instToStringInt",
      "instToStringList",
      "instToStringNat",
      "instToStringString",
      "invImage",
      "ite",
      "ite_cond_eq_false",
      "ite_cond_eq_true",
      "ite_congr",
      "ite_eq_left_iff._simp_1",
      "ite_eq_right_iff._simp_1",
      "liftM",
      "namedPattern",
      "noConfusionEnum",
      "noConfusionTypeEnum",
      "not_and._simp_1",
      "not_false_eq_true",
      "not_or._simp_1",
      "not_true_eq_false",
      "of_decide_eq_false",
      "of_decide_eq_true",
      "of_eq_true",
      "optParam",
      "or_self",
      "or_true",
      "panic",
      "panicWithPosWithDecl",
      "propext",
      "rfl",
      "right_eq_ite_iff._simp_1",
      "sizeOfWFRel",
      "sorryAx",
      "trivial",
      "true_and",
      "true_or",
      "wfParam"
    ]


def check_has_params(definition: str) -> tuple[str, bool, str]:
    """
    检查一个定义是否有输入参数
    
    返回: (定义名, 是否有参数, 错误信息)
    """
    # 创建临时 Lean 文件，使用 #eval 命令来检查类型
    # 注意：某些定义可能需要导入特定模块，但基本类型和函数应该可以直接访问
    with tempfile.NamedTemporaryFile(mode='w', suffix='.lean', delete=False, dir=PROJECT_ROOT) as f:
        # 尝试直接检查，如果失败可能需要导入
        lean_content = f"""-- 临时文件检查定义类型
#check {definition}
"""
        f.write(lean_content)
        temp_file = f.name
        temp_file_rel = os.path.relpath(temp_file, PROJECT_ROOT)
    
    try:
        # 使用 lake env lean 来运行，这样可以访问项目环境
        result = subprocess.run(
            ['lake', 'env', 'lean', temp_file_rel],
            cwd=PROJECT_ROOT,
            capture_output=True,
            text=True,
            timeout=15
        )
        
        output = result.stdout + result.stderr
        
        # 如果失败，尝试添加一些基本导入后再检查
        if result.returncode != 0 and ("unknown" in output.lower() or "not found" in output.lower()):
            # 尝试添加导入
            with tempfile.NamedTemporaryFile(mode='w', suffix='.lean', delete=False, dir=PROJECT_ROOT) as f2:
                lean_content2 = f"""import Init.Prelude
#check {definition}
"""
                f2.write(lean_content2)
                temp_file2 = f2.name
                temp_file2_rel = os.path.relpath(temp_file2, PROJECT_ROOT)
            
            result2 = subprocess.run(
                ['lake', 'env', 'lean', temp_file2_rel],
                cwd=PROJECT_ROOT,
                capture_output=True,
                text=True,
                timeout=15
            )
            output = result2.stdout + result2.stderr
            result = result2  # 使用第二次尝试的结果
            
            # 清理第二个临时文件
            try:
                os.unlink(temp_file2)
            except:
                pass
        
        has_params = False
        error_msg = ""
        
        if result.returncode != 0:
            error_msg = output.strip()[:100]
            # 如果无法检查（可能是导入问题），我们保守地假设它有参数
            return (definition, True, error_msg)
        
        # 检查类型签名中是否包含函数箭头
        # Lean 4 的输出格式通常是: definition_name : type
        # 或者在某些情况下会显示完整的签名
        
        # 首先尝试找到类型部分（在 : 之后）
        if ":" in output:
            # 提取类型部分
            parts = output.split(":", 1)
            if len(parts) > 1:
                type_part = parts[1].strip()
                
                # 清理可能的换行和额外空白
                type_part = " ".join(type_part.split())
                
                # 检查是否有函数箭头（排除类型构造器如 Type -> Type）
                # 如果有箭头且不是单纯的类型到类型，通常表示有参数
                if " -> " in type_part or " → " in type_part:
                    # 进一步检查：如果是以大写字母开头的类型（如 Type, Prop, Sort）开头
                    # 并且只有一个箭头，可能是类型构造器，但要小心
                    # 简化判断：如果类型中有箭头，通常有参数
                    # 例外：Type u -> Type v 这样的类型构造器
                    if type_part.startswith("Type") and " -> Type" in type_part:
                        # 可能是类型构造器，但为了安全，仍然认为有参数
                        # （因为即使是类型构造器，在 Lean 中也需要类型参数）
                        has_params = True
                    elif type_part.startswith("Sort") and " -> Sort" in type_part:
                        has_params = True
                    else:
                        # 其他情况，认为有参数
                        has_params = True
                else:
                    # 没有箭头，可能是常量类型（如 Type, Nat, Prop等）
                    # 但排除明显的类型常量
                    known_type_constants = ["Type", "Prop", "Sort", "Nat", "Int", "Bool", "String", "Char", "Float"]
                    is_type_constant = any(type_part.startswith(const) for const in known_type_constants)
                    if is_type_constant:
                        has_params = False
                    else:
                        # 未知类型，保守假设有参数
                        has_params = False
            else:
                # 无法解析，保守假设有参数
                has_params = True
        else:
            # 没有类型标注，可能是错误输出或其他情况
            # 保守假设有参数
            has_params = True
        
        return (definition, has_params, error_msg)
    
    except subprocess.TimeoutExpired:
        return (definition, True, "Timeout")  # 超时时保守假设有参数
    except Exception as e:
        return (definition, True, f"Exception: {str(e)[:50]}")  # 异常时保守假设有参数
    finally:
        # 清理临时文件
        try:
            os.unlink(temp_file)
        except:
            pass


def filter_definitions_with_params(definitions: List[str], max_workers: int = 10) -> tuple[List[str], List[str]]:
    """
    过滤定义，返回有参数的定义和没有参数的定义
    
    返回: (有参数的定义列表, 没有参数的定义列表)
    """
    definitions_with_params = []
    definitions_without_params = []
    
    print(f"检查 {len(definitions)} 个定义...")
    
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        # 提交所有任务
        future_to_def = {
            executor.submit(check_has_params, def_name): def_name
            for def_name in definitions
        }
        
        # 收集结果
        completed = 0
        for future in as_completed(future_to_def):
            completed += 1
            def_name, has_params, error = future.result()
            
            if error:
                print(f"  [{completed}/{len(definitions)}] {def_name}: ERROR - {error[:50]}")
                # 如果有错误，我们保守地假设它有参数（避免误删）
                definitions_with_params.append(def_name)
            elif has_params:
                definitions_with_params.append(def_name)
                if completed % 50 == 0:
                    print(f"  [{completed}/{len(definitions)}] 处理中... (已有 {len(definitions_with_params)} 个有参数)")
            else:
                definitions_without_params.append(def_name)
                if completed % 50 == 0:
                    print(f"  [{completed}/{len(definitions)}] 处理中... (已过滤 {len(definitions_without_params)} 个无参数)")
    
    return definitions_with_params, definitions_without_params


if __name__ == "__main__":
    print("="*80)
    print("过滤没有输入参数的 Lean 4 定义")
    print("="*80)
    print(f"\n原始定义数量: {len(all_deps)}\n")
    
    # 过滤定义
    deps_with_params, deps_without_params = filter_definitions_with_params(all_deps)
    
    print("\n" + "="*80)
    print("过滤结果")
    print("="*80)
    print(f"\n有输入参数的定义数量: {len(deps_with_params)}")
    print(f"没有输入参数的定义数量: {len(deps_without_params)}")
    
    # 显示一些没有参数的定义示例
    if deps_without_params:
        print(f"\n没有输入参数的定义示例 (前20个):")
        for i, def_name in enumerate(deps_without_params[:20]):
            print(f"  {i+1}. {def_name}")
        if len(deps_without_params) > 20:
            print(f"  ... 还有 {len(deps_without_params) - 20} 个")
    
    # 保存结果
    print("\n保存结果...")
    
    # 保存过滤后的定义（只保留有参数的）
    filtered_deps = deps_with_params
    
    # 更新文件中的 all_deps
    with open(__file__, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 找到 all_deps 列表的位置并替换
    start_marker = "all_deps = ["
    end_marker = "]"
    
    start_idx = content.find(start_marker)
    if start_idx != -1:
        # 找到列表结束位置（跳过函数定义）
        lines = content.split('\n')
        new_lines = []
        in_list = False
        
        for i, line in enumerate(lines):
            if line.strip().startswith("all_deps = ["):
                in_list = True
                # 写入新的列表
                new_lines.append("all_deps = [")
                for j, dep in enumerate(filtered_deps):
                    comma = "," if j < len(filtered_deps) - 1 else ""
                    new_lines.append(f'      "{dep}"{comma}')
                new_lines.append("    ]")
                # 跳过原来的列表内容
                continue
            elif in_list and line.strip() == "]":
                in_list = False
                continue
            elif in_list:
                continue
            
            new_lines.append(line)
        
        new_content = '\n'.join(new_lines)
        
        with open(__file__, 'w', encoding='utf-8') as f:
            f.write(new_content)
        
        print(f"已更新 {__file__}，保留 {len(filtered_deps)} 个有参数的定义")
    else:
        print(f"警告: 无法在文件中找到 all_deps 列表的位置")
    
    print("="*80)


