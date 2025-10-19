import Mathlib

-- Precondition auxiliary definitions
/-- A helper inductive predicate to define valid selections of fruits with associated prices,
tastiness, coupons used, and total cost. -/
inductive FruitSelection : List Nat → List Nat → Nat → Nat → Nat → Nat → Prop where
  | empty :
    FruitSelection [] [] maxAmount maxCoupons 0 0
  | skip {p ts rest_p rest_ts maxAmount maxCoupons res_cost res_taste} :
    FruitSelection rest_p rest_ts maxAmount maxCoupons res_cost res_taste →
    FruitSelection (p::rest_p) (ts::rest_ts) maxAmount maxCoupons res_cost res_taste
  | buy_regular {p ts rest_p rest_ts maxAmount maxCoupons res_cost res_taste} :
    res_cost + p ≤ maxAmount →
    FruitSelection rest_p rest_ts maxAmount maxCoupons res_cost res_taste →
    FruitSelection (p::rest_p) (ts::rest_ts) maxAmount maxCoupons (res_cost + p) (res_taste + ts)
  | buy_with_coupon {p ts rest_p rest_ts maxAmount maxCoupons res_cost res_taste} :
    maxCoupons > 0 →
    (res_cost + p / 2) ≤ maxAmount →
    FruitSelection rest_p rest_ts maxAmount (maxCoupons - 1) res_cost res_taste →
    FruitSelection (p::rest_p) (ts::rest_ts) maxAmount maxCoupons (res_cost + p / 2) (res_taste + ts)

/-- The maximum total tastiness achievable under constraints. -/
def MaxTastinessAchievable (price : List Nat) (tastiness : List Nat) (maxAmount : Nat) (maxCoupons : Nat) (total_taste : Nat) : Prop :=
  ∃ cost ≤ maxAmount, ∃ coupons_used ≤ maxCoupons,
    FruitSelection price tastiness maxAmount coupons_used cost total_taste

/-- No selection exceeds the allowed total amount or coupons. -/
def ValidFruitSelection (price : List Nat) (tastiness : List Nat) (maxAmount : Nat) (maxCoupons : Nat) : Prop :=
  ∀ (cost total_taste : Nat),
    FruitSelection price tastiness maxAmount maxCoupons cost total_taste →
      cost ≤ maxAmount

-- Precondition definitions
@[reducible, simp]
def maxTastiness_precond (price : List Nat) (tastiness : List Nat) (maxAmount : Nat) (maxCoupons : Nat) : Prop :=
  -- !benchmark @start precond
  price.length = tastiness.length ∧
  maxAmount ≥ 0 ∧ maxCoupons ≥ 0
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function to compute the discounted price using a coupon. -/
def discountedPrice (p : Nat) : Nat := p / 2

/-- Dynamic programming approach to compute maximum tastiness. -/
def maxTastinessDP (price : List Nat) (tastiness : List Nat) (maxAmount : Nat) (maxCoupons : Nat) : Nat :=
  match price, tastiness with
  | [], [] => 0
  | p :: rest_p, ts :: rest_ts =>
    let n := price.length
    -- dp[i][j][k] = max tastiness using first i fruits, with j amount and k coupons
    -- We'll use a functional approach with List.foldl and List.range to simulate DP.
    -- Initialize a 2D array: dp : Array (Array Nat) where dp[j][k] stores max tastiness for amount j and coupons k.
    let dpInit := fun (maxAmt : Nat) (maxCoup : Nat) => 
      List.range (maxAmt + 1) |> List.map (fun _ => List.replicate (maxCoup + 1) 0)
    
    let initialDP := dpInit maxAmount maxCoupons
    
    let finalDP := List.foldl (fun dpAcc i =>
      let p_i := price.get! i
      let ts_i := tastiness.get! i
      let discounted := discountedPrice p_i
      List.range (maxAmount + 1) |> List.map (fun j =>
        List.range (maxCoupons + 1) |> List.map (fun k =>
          let currentVal := (dpAcc.get! j).get! k
          let options : List Nat := [
            currentVal, -- Skip the fruit
            if p_i ≤ j then 
              (dpAcc.get! (j - p_i)).get! k + ts_i 
            else 
              0, -- Buy without coupon
            if k > 0 ∧ discounted ≤ j then 
              (dpAcc.get! (j - discounted)).get! (k - 1) + ts_i 
            else 
              0  -- Buy with coupon
          ]
          options.foldl (· ⊔ ·) 0
        )
      )
    ) initialDP (List.range n)
    
    -- The result is the maximum value in the final DP table
    finalDP.foldl (fun acc row => 
      row.foldl (· ⊔ ·) acc
    ) 0
  | _, _ => 0 -- Should not happen due to precondition

-- Main function definitions
def maxTastiness (price : List Nat) (tastiness : List Nat) (maxAmount : Nat) (maxCoupons : Nat) (h_precond : maxTastiness_precond (price) (tastiness) (maxAmount) (maxCoupons)) : Nat :=
  -- !benchmark @start code
  maxTastinessDP price tastiness maxAmount maxCoupons
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def maxTastiness_postcond (price : List Nat) (tastiness : List Nat) (maxAmount : Nat) (maxCoupons : Nat) (result: Nat) (h_precond : maxTastiness_precond (price) (tastiness) (maxAmount) (maxCoupons)) : Prop :=
  -- !benchmark @start postcond
  MaxTastinessAchievable price tastiness maxAmount maxCoupons result ∧
  ∀ t, MaxTastinessAchievable price tastiness maxAmount maxCoupons t → t ≤ result
  -- !benchmark @end postcond


-- Proof content
theorem maxTastiness_postcond_satisfied (price: List Nat) (tastiness: List Nat) (maxAmount: Nat) (maxCoupons: Nat) (h_precond : maxTastiness_precond (price) (tastiness) (maxAmount) (maxCoupons)) :
    maxTastiness_postcond (price) (tastiness) (maxAmount) (maxCoupons) (maxTastiness (price) (tastiness) (maxAmount) (maxCoupons) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof