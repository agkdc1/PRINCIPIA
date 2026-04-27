import Mathlib

/-!
# Lie algebra of a Lie group

This file packages the existing left-invariant-derivation surface under the
textbook-facing name used by the Lie theorem recon.
-/

namespace MathlibExpansion.Geometry.Manifold.Algebra

open scoped Manifold

noncomputable section

variable {𝕜 : Type*} [NontriviallyNormedField 𝕜]
variable {H : Type*} [TopologicalSpace H]
variable {E : Type*} [NormedAddCommGroup E] [NormedSpace 𝕜 E]
variable (I : ModelWithCorners 𝕜 E H)

/-- The Lie algebra attached to a smooth monoid is the type of left-invariant derivations. -/
abbrev lieAlgebraOfLieGroup (G : Type*) [TopologicalSpace G] [ChartedSpace H G] [Monoid G]
    [ContMDiffMul I ⊤ G] : Type _ :=
  LeftInvariantDerivation I G

/-- The textbook-facing alias is definitional. -/
theorem lieAlgebraOfLieGroup_def (G : Type*) [TopologicalSpace G] [ChartedSpace H G] [Monoid G]
    [ContMDiffMul I ⊤ G] :
    lieAlgebraOfLieGroup I G = LeftInvariantDerivation I G :=
  rfl

/--
The zero left-invariant derivation witnesses that the packaged Lie algebra is nonempty.
-/
theorem lieAlgebraOfLieGroup_tangent_bridge (G : Type*) [TopologicalSpace G] [ChartedSpace H G]
    [Monoid G] [ContMDiffMul I ⊤ G] :
    Nonempty (lieAlgebraOfLieGroup I G) :=
  inferInstance

end

end MathlibExpansion.Geometry.Manifold.Algebra
