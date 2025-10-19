import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_rainy_cities_precond (cities : List String) (weather_data : List (String × String)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def hasRainyWeather (weather_desc : String) : Bool :=
  "rain" ∈ weather_desc.toLower.splitOn " "

def getWeatherDescription (city : String) (weather_data : List (String × String)) : Option String :=
  match weather_data.lookup city with
  | some desc => some desc
  | none => none

-- Main function definitions
def find_rainy_cities (cities : List String) (weather_data : List (String × String)) (h_precond : find_rainy_cities_precond (cities) (weather_data)) : List String :=
  -- !benchmark @start code
  cities.filter λ city => 
    match getWeatherDescription city weather_data with
    | some desc => hasRainyWeather desc
    | none => false
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- (hasRainyWeather and getWeatherDescription are now defined above)

-- Postcondition definitions
@[reducible, simp]
def find_rainy_cities_postcond (cities : List String) (weather_data : List (String × String)) (result: List String) (h_precond : find_rainy_cities_precond (cities) (weather_data)) : Prop :=
  -- !benchmark @start postcond
  ∀ city ∈ result, 
    city ∈ cities ∧ 
    (∃ weather_desc, getWeatherDescription city weather_data = some weather_desc ∧ hasRainyWeather weather_desc) ∧
  ∀ city ∈ cities, 
    (∃ weather_desc, getWeatherDescription city weather_data = some weather_desc ∧ hasRainyWeather weather_desc) → 
    city ∈ result
  -- !benchmark @end postcond


-- Proof content
theorem find_rainy_cities_postcond_satisfied (cities: List String) (weather_data: List (String × String)) (h_precond : find_rainy_cities_precond (cities) (weather_data)) :
    find_rainy_cities_postcond (cities) (weather_data) (find_rainy_cities (cities) (weather_data) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof