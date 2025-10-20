import Mathlib

namespace no_75311_codeexercises_175311


-- Precondition definitions
@[reducible, simp]
def get_common_letters_precond (vet_name : String) (animal_names : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed beyond what's already provided in postcond_aux

-- Main function definitions
def get_common_letters (vet_name : String) (animal_names : List String) (h_precond : get_common_letters_precond (vet_name) (animal_names)) : Set Char :=
  -- !benchmark @start code
  let vet_chars := vet_name.toList.toFinset
  animal_names.foldl (fun acc animal_name => 
    acc ∩ (animal_name.toList.toFinset ∩ vet_chars)
  ) vet_chars
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def common_letters (s1 s2 : String) : Set Char :=
  let chars1 := s1.toList.toFinset
  let chars2 := s2.toList.toFinset
  chars1 ∩ chars2

def common_letters_all (vet_name : String) (animal_names : List String) : Set Char :=
  animal_names.foldl (fun acc animal_name => acc ∩ common_letters vet_name animal_name) (common_letters vet_name vet_name)

-- Postcondition definitions
@[reducible, simp]
def get_common_letters_postcond (vet_name : String) (animal_names : List String) (result: Set Char) (h_precond : get_common_letters_precond (vet_name) (animal_names)) : Prop :=
  -- !benchmark @start postcond
  result = common_letters_all vet_name animal_names
  -- !benchmark @end postcond


-- Proof content
theorem get_common_letters_postcond_satisfied (vet_name: String) (animal_names: List String) (h_precond : get_common_letters_precond (vet_name) (animal_names)) :
    get_common_letters_postcond (vet_name) (animal_names) (get_common_letters (vet_name) (animal_names) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_75311_codeexercises_175311