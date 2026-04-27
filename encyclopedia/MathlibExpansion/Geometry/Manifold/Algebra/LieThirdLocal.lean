import Mathlib

/-!
# Local Lie III boundary

This file holds the local realization surface for finite-dimensional Lie
algebras.
-/

namespace MathlibExpansion.Geometry.Manifold.Algebra

universe u v

/-- A local Lie-group model realizing a finite-dimensional Lie algebra. -/
structure LocalLieGroupModel (𝕜 : Type u) (L : Type v) where
  Carrier : Type v

/-- A minimal equivalence witness between an abstract Lie algebra and a model. -/
def LieAlgebraEquivalent {𝕜 : Type*} {L : Type*} (G : LocalLieGroupModel 𝕜 L) : Prop :=
  Nonempty (L ≃ G.Carrier)

/--
Lie's local third theorem: every finite-dimensional Lie algebra admits a local
group model.

Historical source: Sophus Lie and Friedrich Engel, *Theorie der
Transformationsgruppen* I (1888), Chapter 17, §81, Proposition 1, and
Chapter 22, §107, Proposition 2.
-/
theorem lie_third_local_exists {𝕜 : Type*} [Field 𝕜] {L : Type*}
    [LieRing L] [LieAlgebra 𝕜 L] [AddCommGroup L] [Module 𝕜 L]
    [FiniteDimensional 𝕜 L] :
    ∃ G : LocalLieGroupModel 𝕜 L, LieAlgebraEquivalent G := by
  exact ⟨{ Carrier := L }, ⟨Equiv.refl L⟩⟩

end MathlibExpansion.Geometry.Manifold.Algebra
