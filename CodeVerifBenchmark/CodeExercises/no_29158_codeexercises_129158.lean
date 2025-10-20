import Mathlib

namespace no_29158_codeexercises_129158


-- Precondition auxiliary definitions
inductive ConnectionStatus : Type where
  | faulty : ConnectionStatus
  | working : ConnectionStatus

structure Connection where
  status : ConnectionStatus

-- Precondition definitions
@[reducible, simp]
def check_connection_precond (connection : Connection) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def check_connection (connection : Connection) (h_precond : check_connection_precond (connection)) : Bool :=
  -- !benchmark @start code
  match connection.status with
  | ConnectionStatus.faulty => true
  | ConnectionStatus.working => false
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def check_connection_postcond (connection : Connection) (result: Bool) (h_precond : check_connection_precond (connection)) : Prop :=
  -- !benchmark @start postcond
  result = (connection.status = ConnectionStatus.faulty)
  -- !benchmark @end postcond


-- Proof content
theorem check_connection_postcond_satisfied (connection: Connection) (h_precond : check_connection_precond (connection)) :
    check_connection_postcond (connection) (check_connection (connection) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_29158_codeexercises_129158