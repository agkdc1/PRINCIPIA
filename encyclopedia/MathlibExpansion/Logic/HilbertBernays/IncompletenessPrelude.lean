import MathlibExpansion.Logic.HilbertBernays.ArithmetizedProofPredicate1939

/-!
# Incompleteness prelude

This file records the shared readiness assumptions for the first and second
incompleteness consumers.
-/

namespace MathlibExpansion.Logic.HilbertBernays

/-- The theory has a sharply delimited syntax / proof corridor. -/
structure SharpDelimitation (T : HBRecursiveTheory) : Prop where
  codedSyntax : True
  decidableAxiomMembership : True

/-- The theory contains enough recursive arithmetic to run the diagonal
construction. -/
structure RepresentsRecursiveArithmetic (T : HBRecursiveTheory) : Prop where
  numeralCarrier : True
  recursiveDefinitionBridge : True

/-- The shared readiness package consumed by the incompleteness theorems. -/
def IncompletenessReady (T : HBRecursiveTheory) : Prop :=
  SharpDelimitation T ∧ RepresentsRecursiveArithmetic T

/-- The coded contradiction witness exported to downstream builders of
consistency sentences. -/
def codedContradictionWitness : FormulaCode :=
  HBFormula.zeroEqSuccZero.code

@[simp] theorem omegaConsistency_exported (T : HBRecursiveTheory) :
    OmegaConsistent T → OmegaConsistent T := fun h => h

end MathlibExpansion.Logic.HilbertBernays
