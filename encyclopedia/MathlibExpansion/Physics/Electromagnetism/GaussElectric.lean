import MathlibExpansion.Analysis.VectorCalculus.GaussPoisson

/-!
# Gauss law for electricity (Maxwell 1873, Art. 612)

Maxwell wrapper over the landed divergence shell
`MathlibExpansion/Analysis/VectorCalculus/GaussPoisson.lean`.

Maxwell, *A Treatise on Electricity and Magnetism* (1873), Part IV, Chapter IX,
Article 612: "The volume-density of the electrification in any part of the field
is equal to the divergence of the electric displacement at that point", i.e.
`ρ = div 𝔇`.

This file discharges the Maxwell queue item `ME-01` (Gauss law for electricity)
as a sibling-library wrapper over the reusable `divergence` operator. It adds
**no new axioms** and imports no new upstream Mathlib modules beyond the ones
already pulled in by `GaussPoisson.lean`. `direction = upstream`.
-/

noncomputable section

namespace MathlibExpansion.Physics.Electromagnetism

open MathlibExpansion.Analysis.VectorCalculus

/-- Maxwell's Gauss law for electricity, in packaged `Prop` form:
the electric charge density at every point equals the divergence of
the electric displacement field at that point. -/
def MaxwellGaussElectric (D : VectorField) (ρ : ScalarField) : Prop :=
  ∀ x, divergence D x = ρ x

/-- Unfolding lemma: the Maxwell Gauss-for-electricity wrapper really is the
pointwise identity `div D x = ρ x`. -/
theorem gauss_law_electric (D : VectorField) (ρ : ScalarField) :
    MaxwellGaussElectric D ρ ↔ ∀ x, divergence D x = ρ x :=
  Iff.rfl

/-- Reflexive witness: if the electric displacement is literally defined as a
divergence consumer of the charge-density `ρ`, then Maxwell's Gauss law holds
on the nose. This is the narrowest useful corollary and is meant to plug into
later consumer lemmas that build `D` from `ρ` directly. -/
theorem gauss_law_electric_of_eq {D : VectorField} {ρ : ScalarField}
    (h : ∀ x, divergence D x = ρ x) : MaxwellGaussElectric D ρ := h

end MathlibExpansion.Physics.Electromagnetism
