import Mathlib

namespace no_747_p00936


-- Precondition definitions
@[reducible, simp]
def squeezeCylinders_precond (radii : List Nat) : Prop :=
  -- !benchmark @start precond
  -- The list of radii must be non-empty and all radii must be positive (at most 10000)
  radii.length ≥ 1 ∧ radii.length ≤ 500 ∧ ∀ r ∈ radii, r > 0 ∧ r ≤ 10000
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute the minimum x-coordinate for a cylinder given previous positions
def computeMinX (radii : List Nat) (positions : List Float) (i : Nat) : Float :=
  if i = 0 then
    radii[0]!.toFloat
  else
    let r_i := radii[i]!.toFloat
    let maxPos := List.range i |>.foldl (fun acc j =>
      let r_j := radii[j]!.toFloat
      let x_j := positions[j]!
      -- Distance between centers when cylinders touch
      -- Using Pythagorean theorem: horizontal distance = sqrt((r_i + r_j)^2 - (r_i - r_j)^2)
      let dist := Float.sqrt ((r_i + r_j) * (r_i + r_j) - (r_i - r_j) * (r_i - r_j))
      max acc (x_j + dist)
    ) r_i
    maxPos

-- Compute positions for all cylinders iteratively
def buildPositions (radii : List Nat) : List Float :=
  List.range radii.length |>.foldl (fun positions i =>
    let newPos := computeMinX radii positions i
    positions ++ [newPos]
  ) []

-- Main function definitions
def squeezeCylinders (radii : List Nat) (h_precond : squeezeCylinders_precond (radii)) : Float :=
  -- !benchmark @start code
  if radii.length = 1 then
      2.0 * radii[0]!.toFloat
    else
      let positions := buildPositions radii
      -- Find the maximum of (x_i + r_i) for all cylinders
      List.range radii.length |>.foldl (fun maxDist i =>
        let x_i := positions[i]!
        let r_i := radii[i]!.toFloat
        max maxDist (x_i + r_i)
      ) 0.0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to compute the minimum x-coordinate for cylinder i given previous positions
def minXCoord (radii : List Nat) (positions : List Float) (i : Nat) : Float :=
  if i = 0 then
    radii[0]!.toFloat
  else
    let r_i := radii[i]!.toFloat
    let maxPos := positions.take i |>.enum.foldl (fun acc (j, x_j) =>
      let r_j := radii[j]!.toFloat
      let dist := Float.sqrt ((r_i + r_j) * (r_i + r_j) - (r_i - r_j) * (r_i - r_j))
      max acc (x_j + dist)
    ) r_i
    maxPos

-- Compute optimal positions for all cylinders
def computePositions (radii : List Nat) : List Float :=
  List.range radii.length |>.foldl (fun positions i =>
    positions ++ [minXCoord radii positions i]
  ) []

-- The minimum distance is the maximum of (position + radius) over all cylinders
def minDistance (radii : List Nat) : Float :=
  let positions := computePositions radii
  positions.enum.foldl (fun acc (i, x_i) =>
    max acc (x_i + radii[i]!.toFloat)
  ) 0.0

-- Helper function to get the maximum value from a list of floats
def maxFloat (l : List Float) : Float :=
  l.foldl max 0.0

-- Postcondition definitions
@[reducible, simp]
def squeezeCylinders_postcond (radii : List Nat) (result: Float) (h_precond : squeezeCylinders_precond (radii)) : Prop :=
  -- !benchmark @start postcond
  -- The result should be the minimum distance between the two walls
  -- This is computed as the maximum rightmost point (x_i + r_i) among all cylinders
  -- where x_i is the optimal x-coordinate of cylinder i's center
  let positions := computePositions radii
  let expected := minDistance radii
  -- Allow for floating point error of at most 0.0001
  Float.abs (result - expected) ≤ 0.0001 ∧
  -- The result should be at least the diameter of the largest cylinder
  result ≥ 2.0 * maxFloat (radii.map (·.toFloat)) ∧
  -- For a single cylinder, result should be exactly 2 * radius
  (radii.length = 1 → Float.abs (result - 2.0 * radii[0]!.toFloat) ≤ 0.0001)
  -- !benchmark @end postcond


-- Proof content
theorem squeezeCylinders_postcond_satisfied (radii: List Nat) (h_precond : squeezeCylinders_precond (radii)) :
    squeezeCylinders_postcond (radii) (squeezeCylinders (radii) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_747_p00936