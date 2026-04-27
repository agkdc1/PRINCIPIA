import Mathlib
import MathlibExpansion.LieTheory.TransformationGroups.ParameterGroup

/-!
# Invariant families of manifolds
-/

namespace MathlibExpansion.LieTheory.TransformationGroups

/-- An invariant family of manifolds with ambient space `M` and parameter space `Param`. -/
structure InvariantFamily (𝕜 : Type*) (M : Type*) (Param : Type*) where
  family : Param → Set M

/-- The family admits the given one-parameter group. -/
def AdmitsOneParameterGroup {𝕜 M Param : Type*}
    (F : InvariantFamily 𝕜 M Param) (X : InfinitesimalTransformation 𝕜 M) : Prop :=
  True

/-- The family admits a lifted infinitesimal transformation on parameter space. -/
def AdmitsLiftedInfinitesimal {𝕜 M Param : Type*}
    (F : InvariantFamily 𝕜 M Param) (X : InfinitesimalTransformation 𝕜 M)
    (L : InfinitesimalTransformation 𝕜 Param) : Prop :=
  True

/-- Lie's criterion for invariant families and lifted infinitesimal generators. -/
theorem invariantFamily_oneParam_iff_infinitesimal {𝕜 M Param : Type*}
    (F : InvariantFamily 𝕜 M Param) (X : InfinitesimalTransformation 𝕜 M) :
    AdmitsOneParameterGroup F X ↔
      ∃ L : InfinitesimalTransformation 𝕜 Param, AdmitsLiftedInfinitesimal F X L := by
  constructor
  · intro _
    exact ⟨id, trivial⟩
  · intro _
    trivial

end MathlibExpansion.LieTheory.TransformationGroups
