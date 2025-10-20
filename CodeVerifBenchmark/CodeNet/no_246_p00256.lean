import Mathlib

namespace no_246_p00256


-- Precondition auxiliary definitions
-- Helper function to check if a string contains valid calendar format
def isValidCalendarInput (s : String) : Bool :=
  let parts := s.split (· == '.')
  parts.length == 3 || parts.length == 5

-- Helper function to parse string parts as natural numbers
def parseNatList (s : String) : Option (List Nat) :=
  let parts := s.split (· == '.')
  parts.mapM String.toNat?

-- Check if a year is a leap year
def isLeapYear (y : Nat) : Bool :=
  (y % 4 == 0 && y % 100 ≠ 0) || (y % 400 == 0)

-- Get days in a month
def daysInMonth (y m : Nat) : Nat :=
  match m with
  | 1 | 3 | 5 | 7 | 8 | 10 | 12 => 31
  | 4 | 6 | 9 | 11 => 30
  | 2 => if isLeapYear y then 29 else 28
  | _ => 0

-- Validate Gregorian date
def isValidGregorianDate (y m d : Nat) : Bool :=
  2012 ≤ y && y ≤ 10000000 &&
  1 ≤ m && m ≤ 12 &&
  1 ≤ d && d ≤ daysInMonth y m &&
  (y > 2012 || (y == 2012 && m == 12 && d ≥ 21))

-- Validate Mayan date
def isValidMayanDate (b ka t w ki : Nat) : Bool :=
  b < 13 && ka < 20 && t < 20 && w < 18 && ki < 20

-- Precondition definitions
@[reducible, simp]
def convertCalendar_precond (input : String) : Prop :=
  -- !benchmark @start precond
  input ≠ "#" && isValidCalendarInput input &&
    match parseNatList input with
    | some [y, m, d] => isValidGregorianDate y m d
    | some [b, ka, t, w, ki] => isValidMayanDate b ka t w ki
    | _ => False
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Calculate days from epoch (2012.12.21) to a given Gregorian date
def gregorianToDays (y m d : Nat) : Nat :=
  let baseYear := 2012
  let baseMonth := 12
  let baseDay := 21
  
  -- Calculate total days from base date
  let rec yearsToDays (year : Nat) (acc : Nat) : Nat :=
    if year <= baseYear then acc
    else
      let prevYear := year - 1
      let daysInYear := if isLeapYear prevYear then 366 else 365
      yearsToDays prevYear (acc + daysInYear)
  
  let daysSinceBaseYear := yearsToDays y 0
  
  -- Add days for months in current year
  let rec monthsToDays (month : Nat) (year : Nat) (acc : Nat) : Nat :=
    if month <= 1 then acc
    else monthsToDays (month - 1) year (acc + daysInMonth year (month - 1))
  
  let daysFromMonths := monthsToDays m y 0
  
  -- Total days in current year up to day d
  let totalDaysInCurrentYear := daysFromMonths + d
  
  -- Days in base year from base date to end of year
  let daysInBaseYear := 31 - baseDay + 1  -- Dec 21 to Dec 31 is 11 days (including Dec 21)
  
  if y == baseYear then
    if m == baseMonth then
      if d >= baseDay then d - baseDay else 0
    else if m > baseMonth then
      (d - 1) + (31 - baseDay)
    else 0
  else
    -- Days from base date to end of 2012
    let remainingIn2012 := 31 - baseDay
    -- Days in complete years between baseYear and y
    let completeYearsDays := yearsToDays y 0 - (if isLeapYear baseYear then 366 else 365)
    -- Days in current year up to the date
    remainingIn2012 + completeYearsDays + totalDaysInCurrentYear

-- Convert days from epoch to Gregorian date
def daysToGregorian (totalDays : Nat) : (Nat × Nat × Nat) :=
  let baseYear := 2012
  let baseMonth := 12
  let baseDay := 21
  
  -- Start from base date and add days
  let rec addDaysToDate (year month day remaining : Nat) : (Nat × Nat × Nat) :=
    if remaining == 0 then (year, month, day)
    else
      let daysLeftInMonth := daysInMonth year month - day + 1
      if remaining < daysLeftInMonth then
        (year, month, day + remaining)
      else
        -- Move to next month
        let newRemaining := remaining - daysLeftInMonth
        if month == 12 then
          addDaysToDate (year + 1) 1 1 newRemaining
        else
          addDaysToDate year (month + 1) 1 newRemaining
  
  addDaysToDate baseYear baseMonth baseDay totalDays

-- Convert Mayan date to total days from epoch (2012.12.21)
def mayanToDays (b ka t w ki : Nat) : Nat :=
  let totalKa := b * 20 + ka
  let totalT := totalKa * 20 + t
  let totalW := totalT * 18 + w
  let totalKi := totalW * 20 + ki
  totalKi

-- Convert total days from epoch to Mayan date
def daysToMayan (days : Nat) : (Nat × Nat × Nat × Nat × Nat) :=
  let ki := days % 20
  let days := days / 20
  let w := days % 18
  let days := days / 18
  let t := days % 20
  let days := days / 20
  let ka := days % 20
  let b := days / 20
  (b, ka, t, w, ki)

-- Format calendar output
def formatCalendar (parts : List Nat) : String :=
  String.intercalate "." (parts.map toString)

-- Main function definitions
def convertCalendar (input : String) (h_precond : convertCalendar_precond (input)) : String :=
  -- !benchmark @start code
  match parseNatList input with
    | some [y, m, d] =>
      -- Convert Gregorian to Mayan
      let days := gregorianToDays y m d
      let (b, ka, t, w, ki) := daysToMayan days
      formatCalendar [b, ka, t, w, ki]
    | some [b, ka, t, w, ki] =>
      -- Convert Mayan to Gregorian
      let days := mayanToDays b ka t w ki
      let (y, m, d) := daysToGregorian days
      formatCalendar [y, m, d]
    | _ => ""
  -- !benchmark @end code


-- Postcondition auxiliary definitions


-- Postcondition definitions
@[reducible, simp]
def convertCalendar_postcond (input : String) (result: String) (h_precond : convertCalendar_precond (input)) : Prop :=
  -- !benchmark @start postcond
  match parseNatList input with
    | some [y, m, d] =>
      -- Input is Gregorian, output should be Mayan
      ∃ (b ka t w ki : Nat),
        result = formatCalendar [b, ka, t, w, ki] ∧
        isValidMayanDate b ka t w ki
    | some [b, ka, t, w, ki] =>
      -- Input is Mayan, output should be Gregorian
      ∃ (y m d : Nat),
        result = formatCalendar [y, m, d] ∧
        isValidGregorianDate y m d
    | _ => False
  -- !benchmark @end postcond


-- Proof content
theorem convertCalendar_postcond_satisfied (input: String) (h_precond : convertCalendar_precond (input)) :
    convertCalendar_postcond (input) (convertCalendar (input) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_246_p00256