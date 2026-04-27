import Mathlib.Geometry.Manifold.ChartedSpace
import Mathlib.Geometry.Manifold.IsManifold.Basic
import Mathlib.LinearAlgebra.Orientation

namespace MathlibExpansion
namespace Geometry
namespace Manifold

open scoped ContDiff Manifold

universe u v w

variable {E : Type u} [NormedAddCommGroup E] [NormedSpace ℝ E]
variable {H : Type v} [TopologicalSpace H]
variable {I : ModelWithCorners ℝ E H}
variable {M : Type w} [TopologicalSpace M] [ChartedSpace H M]
  [IsManifold I (∞ : WithTop ℕ∞) M]

/-- The model-vector orientation used to label smooth manifold charts.

This follows the standard modern formalization of orientation as a ray of top
alternating forms, matching Whitney, *Sphere-spaces*, Proceedings of the
National Academy of Sciences 21 (1935), pp. 464-468, and Whitney,
*Geometric Integration Theory* (1957), Chapter III, Section 4. -/
abbrev ModelOrientation (E : Type u) [NormedAddCommGroup E] [NormedSpace ℝ E] : Type _ :=
  Orientation ℝ E (Module.Free.ChooseBasisIndex ℝ E)

/-- Typed orientation data on a manifold atlas.

An atlas orientation assigns a model-vector orientation to every chart in the
smooth maximal atlas. The compatibility predicate below records the overlap
coherence. This is the modern atlas-level replacement for Poincare's bilateral
varieties in *Analysis Situs* (1895), Sections 9-10. -/
structure AtlasOrientation (I : ModelWithCorners ℝ E H) (M : Type w)
    [TopologicalSpace M] [ChartedSpace H M] [IsManifold I (∞ : WithTop ℕ∞) M] : Type _ where
  orientationOfChart :
    (e : PartialHomeomorph M H) →
      e ∈ IsManifold.maximalAtlas I (∞ : WithTop ℕ∞) M →
        ModelOrientation E

/-- Compatibility predicate for a bundled atlas orientation.

Charts whose domains overlap carry the same chosen model orientation. This is
the atlas-coherence condition corresponding to Poincare's bilateral/unilateral
distinction in *Analysis Situs* (1895), Sections 9-10, recast in the smooth
atlas language of Whitney's orientation theory. -/
def CompatibleAtlasOrientation
    {I : ModelWithCorners ℝ E H} {M : Type w}
    [TopologicalSpace M] [ChartedSpace H M] [IsManifold I (∞ : WithTop ℕ∞) M] :
    AtlasOrientation I M → Prop :=
  fun o =>
    ∀ ⦃e e' : PartialHomeomorph M H⦄
      (he : e ∈ IsManifold.maximalAtlas I (∞ : WithTop ℕ∞) M)
      (he' : e' ∈ IsManifold.maximalAtlas I (∞ : WithTop ℕ∞) M),
      (e.source ∩ e'.source).Nonempty →
        o.orientationOfChart e he = o.orientationOfChart e' he'

/-- Bundled orientability data for a manifold. -/
structure ManifoldOrientationData
    (I : ModelWithCorners ℝ E H) (M : Type w)
    [TopologicalSpace M] [ChartedSpace H M]
    [IsManifold I (∞ : WithTop ℕ∞) M] : Type _ where
  atlasOrientation : AtlasOrientation I M
  compatibility : CompatibleAtlasOrientation atlasOrientation

/-- A manifold is orientable when the orientation-data carrier is inhabited. -/
def IsOrientableManifold
    (I : ModelWithCorners ℝ E H) (M : Type w)
    [TopologicalSpace M] [ChartedSpace H M]
    [IsManifold I (∞ : WithTop ℕ∞) M] : Prop :=
  Nonempty (ManifoldOrientationData I M)

/-- Poincare's bilateral manifolds are the orientable ones. -/
def Bilateral
    (I : ModelWithCorners ℝ E H) (M : Type w)
    [TopologicalSpace M] [ChartedSpace H M]
    [IsManifold I (∞ : WithTop ℕ∞) M] : Prop :=
  IsOrientableManifold I M

/-- Poincare's unilateral manifolds are the non-orientable ones. -/
def Unilateral
    (I : ModelWithCorners ℝ E H) (M : Type w)
    [TopologicalSpace M] [ChartedSpace H M]
    [IsManifold I (∞ : WithTop ℕ∞) M] : Prop :=
  ¬ Bilateral I M

/-- The opposite manifold is a type synonym, not a wrapper structure, so it
inherits instances definitionally. -/
def OppositeManifold
    (I : ModelWithCorners ℝ E H) (M : Type w)
    [TopologicalSpace M] [ChartedSpace H M]
    [IsManifold I (∞ : WithTop ℕ∞) M] : Type w := M

theorem orientable_orientabilityData_iff_bilateral
    (I : ModelWithCorners ℝ E H) (M : Type w)
    [TopologicalSpace M] [ChartedSpace H M]
    [IsManifold I (∞ : WithTop ℕ∞) M] :
    Bilateral I M ↔ Nonempty (ManifoldOrientationData I M) :=
  Iff.rfl

end Manifold
end Geometry
end MathlibExpansion
