import Mathlib

-- Precondition auxiliary definitions
-- Union-Find data structure to manage word similarity groups
structure UnionFind where
  parent : String → String
  rank : String → Nat

def UnionFind.find (uf : UnionFind) (x : String) : String :=
  let px := uf.parent x
  if px = x then x else UnionFind.find { uf with parent := fun y => if y = x then uf.parent px else uf.parent y } px
decreasing_by
  sorry

def UnionFind.union (uf : UnionFind) (x y : String) : UnionFind :=
  let rx := UnionFind.find uf x
  let ry := UnionFind.find uf y
  if rx = ry then uf
  else if uf.rank rx < uf.rank ry then
    { uf with parent := Function.update uf.parent rx ry }
  else if uf.rank rx > uf.rank ry then
    { uf with parent := Function.update uf.parent ry rx }
  else
    { uf with
      parent := Function.update uf.parent ry rx,
      rank := Function.update uf.rank rx (uf.rank rx + 1) }

def UnionFind.ofPairs (pairs : List (String × String)) : UnionFind :=
  let words := pairs.flatMap (fun p => [p.1, p.2])
  let initialUf : UnionFind := ⟨(fun x => x), (fun _ => 0)⟩
  let ufWithParents := words.foldl (fun uf word => { uf with parent := Function.update uf.parent word word }) initialUf
  pairs.foldl (fun uf pair => UnionFind.union uf pair.1 pair.2) ufWithParents

def areWordsSimilar (uf : UnionFind) (word1 word2 : String) : Bool :=
  UnionFind.find uf word1 = UnionFind.find uf word2

-- Precondition definitions
@[reducible, simp]
def areSentencesSimilar_precond (sentence1 : List String) (sentence2 : List String) (similarPairs : List (String × String)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def checkSimilarity (uf : UnionFind) (sentence1 sentence2 : List String) : Bool :=
  if sentence1.length ≠ sentence2.length then false
  else
    let indices := List.range sentence1.length
    indices.all (fun i =>
      let w1 := sentence1.get! i
      let w2 := sentence2.get! i
      w1 = w2 ∨ areWordsSimilar uf w1 w2)

-- Main function definitions
def areSentencesSimilar (sentence1 : List String) (sentence2 : List String) (similarPairs : List (String × String)) (h_precond : areSentencesSimilar_precond (sentence1) (sentence2) (similarPairs)) : Bool :=
  -- !benchmark @start code
  let uf := UnionFind.ofPairs similarPairs
  checkSimilarity uf sentence1 sentence2
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def areSentencesSimilar_postcond (sentence1 : List String) (sentence2 : List String) (similarPairs : List (String × String)) (result: Bool) (h_precond : areSentencesSimilar_precond (sentence1) (sentence2) (similarPairs)) : Prop :=
  -- !benchmark @start postcond
  let uf := UnionFind.ofPairs similarPairs
  sentence1.length = sentence2.length ∧
    (List.range sentence1.length).all (fun i =>
      let w1 := sentence1.get! i
      let w2 := sentence2.get! i
      w1 = w2 ∨ areWordsSimilar uf w1 w2)
  -- !benchmark @end postcond


-- Proof content
theorem areSentencesSimilar_postcond_satisfied (sentence1: List String) (sentence2: List String) (similarPairs: List (String × String)) (h_precond : areSentencesSimilar_precond (sentence1) (sentence2) (similarPairs)) :
    areSentencesSimilar_postcond (sentence1) (sentence2) (similarPairs) (areSentencesSimilar (sentence1) (sentence2) (similarPairs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof