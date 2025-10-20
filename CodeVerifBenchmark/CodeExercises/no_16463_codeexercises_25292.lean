import Mathlib

namespace no_16463_codeexercises_25292


-- Precondition definitions
@[reducible, simp]
def list_all_claims_precond (claims_list : List (List String)) : Prop :=
  -- !benchmark @start precond
  ∀ lawsuit ∈ claims_list, lawsuit ≠ []
  -- !benchmark @end precond


-- Code auxiliary definitions
def powerset (l : List α) : List (List α) :=
  match l with
  | [] => [[]]
  | x :: xs => 
      let pxs := powerset xs
      pxs ++ List.map (fun ys => x :: ys) pxs

def all_combinations (lists : List (List α)) : List (List α) :=
  match lists with
  | [] => [[]]
  | xs :: xss =>
      let rest_combinations := all_combinations xss
      xs.flatMap (λ x => rest_combinations.map (λ comb => x :: comb))

def filter_valid_intersections (claims_list : List (List String)) : List (List String) :=
  let all_possible := all_combinations claims_list
  all_possible.filter (λ intersection => 
    intersection ≠ [] ∧ 
    ∀ claim ∈ intersection, ∃ i, i < claims_list.length ∧ claim ∈ (claims_list.get? i).getD [] ∧
      ∀ j, j < claims_list.length → claim ∈ (claims_list.get? j).getD [] → i = j)

-- Main function definitions
def list_all_claims (claims_list : List (List String)) (h_precond : list_all_claims_precond (claims_list)) : List (List String) :=
  -- !benchmark @start code
  let lawsuits := claims_list
  let all_intersections := filter_valid_intersections lawsuits
  let unique_intersections := all_intersections.eraseDups
  unique_intersections
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_valid_intersection (claims_list : List (List String)) (intersection : List String) : Prop :=
  intersection ≠ [] ∧
  ∀ claim ∈ intersection, ∃ i, i < claims_list.length ∧ claim ∈ (claims_list.get? i).getD [] ∧
    ∀ j, j < claims_list.length → claim ∈ (claims_list.get? j).getD [] → i = j

-- Postcondition definitions
@[reducible, simp]
def list_all_claims_postcond (claims_list : List (List String)) (result: List (List String)) (h_precond : list_all_claims_precond (claims_list)) : Prop :=
  -- !benchmark @start postcond
  let all_intersections := {intersection | is_valid_intersection claims_list intersection}
  result.toFinset = all_intersections ∧
  ∀ intersection ∈ result, is_valid_intersection claims_list intersection ∧
  ∀ i j, i < j → j < result.length → result.get? i ≠ result.get? j
  -- !benchmark @end postcond


-- Proof content
theorem list_all_claims_postcond_satisfied (claims_list: List (List String)) (h_precond : list_all_claims_precond (claims_list)) :
    list_all_claims_postcond (claims_list) (list_all_claims (claims_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_16463_codeexercises_25292