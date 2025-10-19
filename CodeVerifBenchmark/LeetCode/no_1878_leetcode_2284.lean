import Mathlib

-- Precondition auxiliary definitions
def countWords (message : String) : Nat :=
  message.split (· = ' ') |>.length

def senderWordCount (messages : List String) (senders : List String) (sender : String) : Nat :=
  (messages.zip senders).filter (·.2 = sender) |>.map (countWords ·.1) |>.foldl (·+·) 0

def maxWordCount (messages : List String) (senders : List String) : Nat :=
  let counts := senders.eraseDups.map (senderWordCount messages senders ·)
  counts.foldl max 0

-- Precondition definitions
@[reducible, simp]
def largestWordCountSender_precond (messages : List String) (senders : List String) : Prop :=
  -- !benchmark @start precond
  messages.length = senders.length ∧
  messages.length > 0 ∧
  messages.length ≤ 10000 ∧
  (∀ m ∈ messages, m.length > 0 ∧ m.length ≤ 100) ∧
  (∀ s ∈ senders, s.length > 0 ∧ s.length ≤ 10)
  -- !benchmark @end precond


-- Code auxiliary definitions
def getLargestSenderWithMaxCount (messages : List String) (senders : List String) : String :=
  let uniqueSenders := senders.eraseDups
  let senderCounts := uniqueSenders.map (fun s => (s, senderWordCount messages senders s))
  let maxCount := senderCounts.map (·.2) |>.foldl max 0
  let candidates := senderCounts.filter (·.2 = maxCount) |>.map (·.1)
  candidates.foldl (fun acc candidate => if candidate > acc then candidate else acc) ""

-- Main function definitions
def largestWordCountSender (messages : List String) (senders : List String) (h_precond : largestWordCountSender_precond (messages) (senders)) : String :=
  -- !benchmark @start code
  getLargestSenderWithMaxCount messages senders
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def validResult (messages : List String) (senders : List String) (result : String) : Prop :=
  let maxCount := maxWordCount messages senders
  senderWordCount messages senders result = maxCount ∧
  result ∈ senders ∧
  (∀ sender ∈ senders,
    senderWordCount messages senders sender = maxCount →
    sender ≤ result)

-- Postcondition definitions
@[reducible, simp]
def largestWordCountSender_postcond (messages : List String) (senders : List String) (result: String) (h_precond : largestWordCountSender_precond (messages) (senders)) : Prop :=
  -- !benchmark @start postcond
  validResult messages senders result
  -- !benchmark @end postcond


-- Proof content
theorem largestWordCountSender_postcond_satisfied (messages: List String) (senders: List String) (h_precond : largestWordCountSender_precond (messages) (senders)) :
    largestWordCountSender_postcond (messages) (senders) (largestWordCountSender (messages) (senders) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

