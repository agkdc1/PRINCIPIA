import MathlibExpansion.Roots.Diamond1996.AlgebraicCriterion

/-!
# Axiom accounting for the Diamond1996 breach.

Run `#print axioms` on every named theorem / axiom introduced by the
Diamond1996 breach to verify the axiom budget lock.

Doctrine v2: every kernel axiom listed here must be either
(1) `propext`, `Classical.choice`, `Quot.sound` — the standard Lean
    kernel axioms inherited from Mathlib.

Any other named axiom is a breach violation. Contingent
`HeckeProjection` axiom and the former `cotangentComparisonBridge` axiom were
**reclaimed** as typed data plus definition-land packaging.
-/

namespace MathlibExpansion.Roots.Diamond1996.AxiomsCheck

#print axioms MathlibExpansion.Roots.Diamond1996.cotangentComparisonBridge
#print axioms MathlibExpansion.Roots.Diamond1996.algebraicCriterion_RT
#print axioms MathlibExpansion.Roots.Diamond1996.fittingLengthAPI_ofFiniteLength
#print axioms MathlibExpansion.Roots.Diamond1996.diamondAlgebraicCriterion
#print axioms MathlibExpansion.Roots.Diamond1996.diamondAlgebraicCriterion_injective
#print axioms MathlibExpansion.Roots.Diamond1996.diamondAlgebraicCriterion_surjective

end MathlibExpansion.Roots.Diamond1996.AxiomsCheck
