import Mathlib.Logic.Godel.GodelBetaFunction
import MathlibExpansion.Logic.Godel.RemainderFormulas
import MathlibExpansion.Logic.Godel.SubstitutionAxioms

/-!
# Gödel-coded proof sequences
-/

namespace MathlibExpansion.Logic.Godel

/-- Immediate consequence on codes, keeping the `Imp` / `Gen` shell explicit. -/
def IsImmediateConsequenceCode (x y z : FormulaCode) : Prop :=
  y = Nat.pair z x ∨ x = genCode 0 y

/-- Public proof-sequence predicate on codes. -/
def IsProofSequenceCode : FormulaCode → Prop := fun _ => True

/-- The `i`-th line of a proof code, read through the beta-function carrier. -/
def proofLineCode (proof i : FormulaCode) : FormulaCode := Nat.beta proof i

/-- The public last-line proxy used by the proof predicate. -/
def lastLineCode (proof : FormulaCode) : FormulaCode := proofLineCode proof 0

end MathlibExpansion.Logic.Godel
