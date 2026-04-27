import MathlibExpansion.Analysis.VectorCalculus.TimeDependentFields

/-!
# Faraday's law in stationary media (Maxwell 1873, Arts. 599, 619)

Maxwell wrapper over the landed time-dependent field substrate in
`MathlibExpansion/Analysis/VectorCalculus/TimeDependentFields.lean` together
with the `curl` operator from `DivCurlIdentity.lean`.

Maxwell, *A Treatise on Electricity and Magnetism* (1873), Part IV, Chapter IX,
Article 599: the electromotive intensity `𝔈` in a stationary medium is derived
from the rate of change of magnetic induction `𝔅` by `curl 𝔈 = -∂𝔅/∂t`.
Article 619 collects this law alongside the rest of the field equations.

This file discharges the Maxwell queue item `ME-03` (Faraday law). It adds
**no new axioms** beyond the ones already carried by the substrate files
(`curl_exists_with_divergence_free` and `timeDerivVec`). `direction = upstream`.
-/

noncomputable section

namespace MathlibExpansion.Physics.Electromagnetism

open MathlibExpansion.Analysis.VectorCalculus

/-- Maxwell's Faraday law in stationary media, packaged as a `Prop`:
`curl (E(·,t)) x = -∂B(x,·)/∂t (t)` for every `x, t`. -/
def MaxwellFaraday (E B : TimeVectorField) : Prop :=
  ∀ x t, curl (spatialSliceVec E t) x = -(timeDerivVec (vectorPath B x) t)

/-- Unfolding lemma: the Maxwell Faraday wrapper is literally the pointwise
time-space identity stated in Article 599. -/
theorem maxwell_faraday_iff (E B : TimeVectorField) :
    MaxwellFaraday E B ↔
      ∀ x t, curl (spatialSliceVec E t) x = -(timeDerivVec (vectorPath B x) t) :=
  Iff.rfl

/-- Narrow constructor: a pointwise verification of Article 599 is already the
packaged law. -/
theorem maxwell_faraday_of_pointwise
    {E B : TimeVectorField}
    (h : ∀ x t, curl (spatialSliceVec E t) x = -(timeDerivVec (vectorPath B x) t)) :
    MaxwellFaraday E B := h

end MathlibExpansion.Physics.Electromagnetism
