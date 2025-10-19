import Mathlib

-- Postcondition auxiliary definitions
-- Vector subtraction for 3D points
def vec_sub (p1 p2 : Int × Int × Int) : Int × Int × Int :=
  (p1.1 - p2.1, p1.2.1 - p2.2.1, p1.2.2 - p2.2.2)

-- Dot product of two 3D vectors
def dot_product (v1 v2 : Int × Int × Int) : Int :=
  v1.1 * v2.1 + v1.2.1 * v2.2.1 + v1.2.2 * v2.2.2

-- Cross product of two 3D vectors
def cross_product (v1 v2 : Int × Int × Int) : Int × Int × Int :=
  (v1.2.1 * v2.2.2 - v1.2.2 * v2.2.1,
   v1.2.2 * v2.1 - v1.1 * v2.2.2,
   v1.1 * v2.2.1 - v1.2.1 * v2.1)

-- Check if a ray from origin in direction dir intersects with triangle (p1, p2, p3)
-- Returns true if the beam from ship to enemy intersects the barrier triangle
def ray_intersects_triangle (ship enemy barrier1 barrier2 barrier3 : Int × Int × Int) : Bool :=
  let dir := vec_sub enemy ship
  let v0 := vec_sub barrier1 ship
  let v1 := vec_sub barrier2 ship
  let v2 := vec_sub barrier3 ship
  
  -- Compute normal vector of the triangle
  let edge1 := vec_sub barrier2 barrier1
  let edge2 := vec_sub barrier3 barrier1
  let normal := cross_product edge1 edge2
  
  -- Check if triangle is degenerate (normal is zero)
  if normal.1 == 0 && normal.2.1 == 0 && normal.2.2 == 0 then
    false
  else
    -- Compute determinant (using barycentric coordinates approach)
    let denom := dot_product normal dir
    
    if denom == 0 then
      false  -- Ray is parallel to triangle
    else
      -- Compute intersection point using parametric form
      let d := dot_product normal (vec_sub barrier1 ship)
      let t_num := d
      
      -- Check if intersection is in the positive direction (between ship and enemy)
      let t_denom := denom
      
      -- We need t in [0, 1] range (from ship towards enemy, not beyond)
      let t_valid := (t_num * t_denom ≥ 0) && 
                     (t_num.natAbs ≤ t_denom.natAbs || 
                      (t_num * t_denom > 0 && t_num.natAbs ≤ (dot_product dir dir).natAbs * t_denom.natAbs))
      
      if !t_valid then
        false
      else
        -- Compute barycentric coordinates to check if point is inside triangle
        -- Using the approach from the Python code
        let v := vec_sub enemy ship
        let a1 := vec_sub barrier2 ship
        let a2 := vec_sub barrier3 ship
        let a3 := vec_sub barrier1 ship
        
        -- Compute determinant D0 = det([a1, a2, a3])
        let d0 := a1.1 * a2.2.1 * a3.2.2 + a2.1 * a3.2.1 * a1.2.2 + a3.1 * a1.2.1 * a2.2.2 -
                  a1.1 * a3.2.1 * a2.2.2 - a2.1 * a1.2.1 * a3.2.2 - a3.1 * a2.2.1 * a1.2.2
        
        if d0 == 0 then
          false
        else
          -- Compute r1, r2, r3 (barycentric coordinates)
          let d1 := v.1 * a2.2.1 * a3.2.2 + a2.1 * a3.2.1 * v.2.2 + a3.1 * v.2.1 * a2.2.2 -
                    v.1 * a3.2.1 * a2.2.2 - a2.1 * v.2.1 * a3.2.2 - a3.1 * a2.2.1 * v.2.2
          let d2 := a1.1 * v.2.1 * a3.2.2 + v.1 * a3.2.1 * a1.2.2 + a3.1 * a1.2.1 * v.2.2 -
                    a1.1 * a3.2.1 * v.2.2 - v.1 * a1.2.1 * a3.2.2 - a3.1 * v.2.1 * a1.2.2
          let d3 := a1.1 * a2.2.1 * v.2.2 + a2.1 * v.2.1 * a1.2.2 + v.1 * a1.2.1 * a2.2.2 -
                    a1.1 * v.2.1 * a2.2.2 - a2.1 * a1.2.1 * v.2.2 - v.1 * a2.2.1 * a1.2.2
          
          -- Check if all barycentric coordinates are non-negative and sum >= d0
          (d1 * d0 ≥ 0) && (d2 * d0 ≥ 0) && (d3 * d0 ≥ 0) && 
          ((d1 + d2 + d3) * d0 ≥ d0 * d0)

-- Precondition definitions
@[reducible, simp]
def beamHitCheck_precond (ship : (Int × Int × Int)) (enemy : (Int × Int × Int)) (barrier1 : (Int × Int × Int)) (barrier2 : (Int × Int × Int)) (barrier3 : (Int × Int × Int)) : Prop :=
  -- !benchmark @start precond
  -- The ship and enemy are at different positions
  ship ≠ enemy ∧
  -- All coordinates are within bounds
  (let (sx, sy, sz) := ship;
   let (ex, ey, ez) := enemy;
   let (b1x, b1y, b1z) := barrier1;
   let (b2x, b2y, b2z) := barrier2;
   let (b3x, b3y, b3z) := barrier3;
   -100 ≤ sx ∧ sx ≤ 100 ∧ -100 ≤ sy ∧ sy ≤ 100 ∧ -100 ≤ sz ∧ sz ≤ 100 ∧
   -100 ≤ ex ∧ ex ≤ 100 ∧ -100 ≤ ey ∧ ey ≤ 100 ∧ -100 ≤ ez ∧ ez ≤ 100 ∧
   -100 ≤ b1x ∧ b1x ≤ 100 ∧ -100 ≤ b1y ∧ b1y ≤ 100 ∧ -100 ≤ b1z ∧ b1z ≤ 100 ∧
   -100 ≤ b2x ∧ b2x ≤ 100 ∧ -100 ≤ b2y ∧ b2y ≤ 100 ∧ -100 ≤ b2z ∧ b2z ≤ 100 ∧
   -100 ≤ b3x ∧ b3x ≤ 100 ∧ -100 ≤ b3y ∧ b3y ≤ 100 ∧ -100 ≤ b3z ∧ b3z ≤ 100)
  -- !benchmark @end precond


-- Main function definitions
def beamHitCheck (ship : (Int × Int × Int)) (enemy : (Int × Int × Int)) (barrier1 : (Int × Int × Int)) (barrier2 : (Int × Int × Int)) (barrier3 : (Int × Int × Int)) (h_precond : beamHitCheck_precond (ship) (enemy) (barrier1) (barrier2) (barrier3)) : String :=
  -- !benchmark @start code
  if ray_intersects_triangle ship enemy barrier1 barrier2 barrier3 then
      "MISS"
    else
      "HIT"
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def beamHitCheck_postcond (ship : (Int × Int × Int)) (enemy : (Int × Int × Int)) (barrier1 : (Int × Int × Int)) (barrier2 : (Int × Int × Int)) (barrier3 : (Int × Int × Int)) (result: String) (h_precond : beamHitCheck_precond (ship) (enemy) (barrier1) (barrier2) (barrier3)) : Prop :=
  -- !benchmark @start postcond
  -- The result is "HIT" if the beam does not intersect the barrier triangle
  -- The result is "MISS" if the beam intersects the barrier triangle
  (result = "HIT" ∧ ¬ray_intersects_triangle ship enemy barrier1 barrier2 barrier3) ∨
  (result = "MISS" ∧ ray_intersects_triangle ship enemy barrier1 barrier2 barrier3)
  -- !benchmark @end postcond


-- Proof content
theorem beamHitCheck_postcond_satisfied (ship: (Int × Int × Int)) (enemy: (Int × Int × Int)) (barrier1: (Int × Int × Int)) (barrier2: (Int × Int × Int)) (barrier3: (Int × Int × Int)) (h_precond : beamHitCheck_precond (ship) (enemy) (barrier1) (barrier2) (barrier3)) :
    beamHitCheck_postcond (ship) (enemy) (barrier1) (barrier2) (barrier3) (beamHitCheck (ship) (enemy) (barrier1) (barrier2) (barrier3) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof