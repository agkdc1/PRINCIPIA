import MathlibExpansion.Analysis.VectorCalculus.DivCurlIdentity

/-!
# Gauss law for magnetism: `B = curl A → div B = 0` (Maxwell 1873, Arts. 591, 616, 619)

Maxwell wrapper over the already-landed operator shell
`MathlibExpansion.Analysis.VectorCalculus.div_curl_eq_zero`
from `MathlibExpansion/Analysis/VectorCalculus/DivCurlIdentity.lean`.

Maxwell, *A Treatise on Electricity and Magnetism* (1873), Part IV, Chapter IX,
Article 591: the magnetic induction `𝔅` is solenoidal. Article 616 makes this
explicit through the vector-potential representation `𝔅 = curl 𝔄`. Article 619
collects the corollary `div 𝔅 = 0`.

This file discharges the Maxwell queue item `ME-02b` (Gauss law for magnetism,
presented as the wrapper over the split operator shell `ME-02a`). It adds
**no new axioms** beyond the `curl_exists_with_divergence_free` primitive that
was already landed in `DivCurlIdentity.lean`. `direction = upstream`.
-/

noncomputable section

namespace MathlibExpansion.Physics.Electromagnetism

open MathlibExpansion.Analysis.VectorCalculus

/-- Maxwell's Gauss law for magnetism, in packaged `Prop` form:
the magnetic induction is divergence-free. -/
def MaxwellGaussMagnetic (B : VectorField) : Prop :=
  ∀ x, divergence B x = 0

/-- Maxwell 1873, Arts. 591 / 616 / 619: if the magnetic induction is obtained
from a vector potential via `B = curl A`, then it is divergence-free. -/
theorem gauss_law_magnetic_of_vectorPotential (A B : VectorField)
    (hB : ∀ x, B x = curl A x) : MaxwellGaussMagnetic B := by
  have hfun : B = curl A := funext hB
  intro x
  calc divergence B x
      = divergence (curl A) x := by rw [hfun]
    _ = 0 := div_curl_eq_zero A x

/-- Unfolding lemma: the Maxwell Gauss-for-magnetism wrapper is the pointwise
divergence-free predicate. -/
theorem maxwell_gauss_magnetic_iff (B : VectorField) :
    MaxwellGaussMagnetic B ↔ ∀ x, divergence B x = 0 :=
  Iff.rfl

end MathlibExpansion.Physics.Electromagnetism
