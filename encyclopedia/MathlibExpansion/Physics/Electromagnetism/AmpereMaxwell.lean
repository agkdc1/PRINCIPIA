import MathlibExpansion.Analysis.VectorCalculus.TimeDependentFields

/-!
# Ampère-Maxwell law (Maxwell 1873, Arts. 607, 610, 619)

Maxwell wrapper combining the conduction-current law of Article 607 with the
displacement-current correction of Article 610, so that the curl of the
magnetic intensity sees both. Article 619 collects this in the recap of the
field equations.

Discharges Maxwell queue item `ME-04`.

Adds **no new axioms** beyond the substrate primitives (`curl`,
`timeDerivVec`) already introduced by the upstream substrate files.
`direction = upstream`.
-/

noncomputable section

namespace MathlibExpansion.Physics.Electromagnetism

open MathlibExpansion.Analysis.VectorCalculus

/-- Maxwell's Ampère-Maxwell law, packaged as a `Prop`:
`curl (H(·,t)) x = 4π (K(x,t) + ∂D(x,·)/∂t (t))` for every `x, t`. -/
def MaxwellAmpere (H K D : TimeVectorField) : Prop :=
  ∀ x t, curl (spatialSliceVec H t) x =
      (4 * Real.pi) • (K x t + timeDerivVec (vectorPath D x) t)

/-- Unfolding lemma: the Maxwell Ampère-Maxwell wrapper is the pointwise
relation from Articles 607 / 610 / 619. -/
theorem maxwell_ampere_iff (H K D : TimeVectorField) :
    MaxwellAmpere H K D ↔
      ∀ x t, curl (spatialSliceVec H t) x =
        (4 * Real.pi) • (K x t + timeDerivVec (vectorPath D x) t) :=
  Iff.rfl

/-- Narrow constructor: a pointwise verification is the packaged law. -/
theorem maxwell_ampere_of_pointwise
    {H K D : TimeVectorField}
    (h : ∀ x t, curl (spatialSliceVec H t) x =
        (4 * Real.pi) • (K x t + timeDerivVec (vectorPath D x) t)) :
    MaxwellAmpere H K D := h

end MathlibExpansion.Physics.Electromagnetism
