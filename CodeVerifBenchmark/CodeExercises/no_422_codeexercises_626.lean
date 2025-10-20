import Mathlib

namespace no_422_codeexercises_626


-- Precondition auxiliary definitions
inductive Medal : Type where
  | gold : Medal
  | silver : Medal
  | bronze : Medal

deriving instance DecidableEq for Medal

structure Athlete where
  medals : List Medal

-- Precondition definitions
@[reducible, simp]
def add_medals_precond (athlete : Athlete) (medals : List Medal) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No additional auxiliary definitions needed since the postcondition helpers are already provided

-- Main function definitions
def add_medals (athlete : Athlete) (medals : List Medal) (h_precond : add_medals_precond athlete medals) : List Medal :=
  -- !benchmark @start code
  let updated_medals := medals.foldl (λ acc medal => 
      if acc.contains medal then medal :: acc else acc) athlete.medals
  updated_medals
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def MedalSet : Type := List Medal

def contains_medal (medals : MedalSet) (medal : Medal) : Bool :=
  medals.contains medal

def add_if_present (athlete_medals : MedalSet) (medal : Medal) : MedalSet :=
  if contains_medal athlete_medals medal then
    medal :: athlete_medals
  else
    athlete_medals

def add_medals_helper (athlete_medals : MedalSet) (medals : List Medal) : MedalSet :=
  medals.foldl add_if_present athlete_medals

-- Postcondition definitions
@[reducible, simp]
def add_medals_postcond (athlete : Athlete) (medals : List Medal) (result: List Medal) (h_precond : add_medals_precond athlete medals) : Prop :=
  -- !benchmark @start postcond
  result = add_medals_helper athlete.medals medals
  -- !benchmark @end postcond


-- Proof content
theorem add_medals_postcond_satisfied (athlete: Athlete) (medals: List Medal) (h_precond : add_medals_precond athlete medals) :
    add_medals_postcond athlete medals (add_medals athlete medals h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_422_codeexercises_626