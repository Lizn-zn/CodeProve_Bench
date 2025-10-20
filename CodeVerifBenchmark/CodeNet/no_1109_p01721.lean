import Mathlib

namespace no_1109_p01721


-- Precondition definitions
@[reducible, simp]
def waveAttack_precond (w : Nat) (h : Nat) (v : Nat) (t : Nat) (x : Nat) (y : Nat) (p : Nat) (q : Nat) : Prop :=
  -- !benchmark @start precond
  -- The room has width w and height h (both at least 2)
  w ≥ 2 ∧ h ≥ 2 ∧
  -- The shockwave device is inside the room (strictly between walls)
  0 < x ∧ x < w ∧
  0 < y ∧ y < h ∧
  -- Big Bridge Earl is inside the room (strictly between walls)
  0 < p ∧ p < w ∧
  0 < q ∧ q < h ∧
  -- The device and Earl are at different positions
  (x ≠ p ∨ y ≠ q) ∧
  -- The shockwave travels at most 10^6 meters
  v * t ≤ 1000000
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute integer square root
def isqrt (n : Nat) : Nat :=
  if n = 0 then 0
  else
    let rec loop (x : Nat) : Nat :=
      let y := (x + n / x) / 2
      if y < x then loop y else x
    decreasing_by sorry
    loop n

-- Count hits for a specific virtual Earl position
def countForPosition (w h v t x y : Nat) (a b : Int) : Nat :=
  let C := v * t
  let CSq := C * C
  let rec loopPositive (ky : Int) (acc : Nat) : Nat :=
    let B := b + 2 * (h : Int) * ky
    let diff := B - (y : Int)
    let diffSq := (diff * diff).toNat
    if diffSq > CSq then acc
    else
      let D := CSq - diffSq
      let SQ := isqrt D
      let k0 := ((x : Int) - a - (SQ : Int)) / (2 * (w : Int))
      let k1 := ((x : Int) - a + (SQ : Int)) / (2 * (w : Int))
      let count := max (k1 - k0) 0
      loopPositive (ky + 1) (acc + count.toNat)
  decreasing_by sorry
  let rec loopNegative (ky : Int) (acc : Nat) : Nat :=
    let B := b + 2 * (h : Int) * ky
    let diff := B - (y : Int)
    let diffSq := (diff * diff).toNat
    if diffSq > CSq then acc
    else
      let D := CSq - diffSq
      let SQ := isqrt D
      let k0 := ((x : Int) - a - (SQ : Int)) / (2 * (w : Int))
      let k1 := ((x : Int) - a + (SQ : Int)) / (2 * (w : Int))
      let count := max (k1 - k0) 0
      loopNegative (ky - 1) (acc + count.toNat)
  decreasing_by sorry
  loopPositive 0 0 + loopNegative (-1) 0

-- Main function definitions
def waveAttack (w : Nat) (h : Nat) (v : Nat) (t : Nat) (x : Nat) (y : Nat) (p : Nat) (q : Nat) (h_precond : waveAttack_precond (w) (h) (v) (t) (x) (y) (p) (q)) : Nat :=
  -- !benchmark @start code
  let ans1 := countForPosition w h v t x y (p : Int) (q : Int)
  let ans2 := countForPosition w h v t x y (p : Int) (2 * (h : Int) - (q : Int))
  let ans3 := countForPosition w h v t x y (2 * (w : Int) - (p : Int)) (q : Int)
  let ans4 := countForPosition w h v t x y (2 * (w : Int) - (p : Int)) (2 * (h : Int) - (q : Int))
  ans1 + ans2 + ans3 + ans4
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper to compute squared Euclidean distance
def distSquared (x1 y1 x2 y2 : Int) : Nat :=
  ((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)).toNat

-- Check if a reflected position hits the Earl within time t
-- We model reflections by considering virtual positions of the Earl
-- obtained by reflecting across walls
def hitsEarl (w h v t x y p q : Nat) (kx ky : Int) : Bool :=
  let vx := if kx % 2 = 0 then p else w - p
  let vy := if ky % 2 = 0 then q else h - q
  let px := vx + 2 * w * kx
  let py := vy + 2 * h * ky
  let maxDist := v * t
  distSquared x y px py ≤ maxDist * maxDist

-- Count all valid reflections that hit the Earl
-- We need to check all reflection combinations within the reachable distance
def countHits (w h v t x y p q : Nat) : Nat :=
  let maxDist := v * t
  let maxKx := maxDist / w + 1
  let maxKy := maxDist / h + 1
  let rec countInRange (kxMin kxMax kyMin kyMax : Int) : Nat :=
    let rec loopKx (kx : Int) (accOuter : Nat) : Nat :=
      if kx > kxMax then accOuter
      else
        let rec loopKy (ky : Int) (accInner : Nat) : Nat :=
          if ky > kyMax then accInner
          else
            let newCount := if (kx = 0 ∧ ky = 0) then
              if hitsEarl w h v t x y p q kx ky then accInner + 1 else accInner
            else
              if hitsEarl w h v t x y p q kx ky then accInner + 1 else accInner
            loopKy (ky + 1) newCount
        decreasing_by sorry
        loopKx (kx + 1) (accOuter + loopKy kyMin 0)
    decreasing_by sorry
    loopKx kxMin 0
  countInRange (-(maxKx : Int)) maxKx (-(maxKy : Int)) maxKy

-- Postcondition definitions
@[reducible, simp]
def waveAttack_postcond (w : Nat) (h : Nat) (v : Nat) (t : Nat) (x : Nat) (y : Nat) (p : Nat) (q : Nat) (result: Nat) (h_precond : waveAttack_precond (w) (h) (v) (t) (x) (y) (p) (q)) : Prop :=
  -- !benchmark @start postcond
  -- The result counts the number of times the shockwave hits Big Bridge Earl
  -- This includes direct hits and hits after reflections off walls
  -- Multiple simultaneous hits from different directions count separately
  -- The shockwave is valid for exactly t seconds (inclusive)
  result = countHits w h v t x y p q
  -- !benchmark @end postcond


-- Proof content
theorem waveAttack_postcond_satisfied (w: Nat) (h: Nat) (v: Nat) (t: Nat) (x: Nat) (y: Nat) (p: Nat) (q: Nat) (h_precond : waveAttack_precond (w) (h) (v) (t) (x) (y) (p) (q)) :
    waveAttack_postcond (w) (h) (v) (t) (x) (y) (p) (q) (waveAttack (w) (h) (v) (t) (x) (y) (p) (q) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1109_p01721