import Mathlib

-- Precondition auxiliary definitions
structure Customer where
  hasMadePurchase : Bool
  deriving Repr

-- Precondition definitions
@[reducible, simp]
def remove_unwanted_customers_precond (customer_list : List Customer) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to check if a customer has made a purchase
def customer_has_purchased (c : Customer) : Bool :=
  c.hasMadePurchase

-- Helper function for the while loop implementation
partial def remove_unwanted_while_loop (customers : List Customer) (acc : List Customer) : List Customer :=
  match customers with
  | [] => acc.reverse
  | c :: cs => 
    if c.hasMadePurchase then
      remove_unwanted_while_loop cs (c :: acc)
    else
      remove_unwanted_while_loop cs acc

-- Main function definitions
def remove_unwanted_customers (customer_list : List Customer) (h_precond : remove_unwanted_customers_precond (customer_list)) : List Customer :=
  -- !benchmark @start code
  let rec loop (remaining : List Customer) (result : List Customer) : List Customer :=
    match remaining with
    | [] => result.reverse
    | customer :: rest =>
      if customer.hasMadePurchase then
        loop rest (customer :: result)
      else
        loop rest result
  loop customer_list []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def hasMadePurchase? (c : Customer) : Bool :=
  c.hasMadePurchase

-- Postcondition definitions
@[reducible, simp]
def remove_unwanted_customers_postcond (customer_list : List Customer) (result: List Customer) (h_precond : remove_unwanted_customers_precond (customer_list)) : Prop :=
  -- !benchmark @start postcond
  result = customer_list.filter (λ c => c.hasMadePurchase)
  -- !benchmark @end postcond


-- Proof content
theorem remove_unwanted_customers_postcond_satisfied (customer_list: List Customer) (h_precond : remove_unwanted_customers_precond (customer_list)) :
    remove_unwanted_customers_postcond (customer_list) (remove_unwanted_customers (customer_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof