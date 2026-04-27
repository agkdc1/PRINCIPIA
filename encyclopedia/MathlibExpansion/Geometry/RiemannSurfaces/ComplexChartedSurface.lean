import Mathlib
import MathlibExpansion.Geometry.RiemannSurfaces.AbstractSurfaceCarrier

/-!
# Complex charted surfaces

This file packages Weyl's local-uniformizer boundary as a bundled complex
analytic atlas on top of an abstract surface carrier.
-/

open scoped Manifold ContDiff

universe u v

namespace MathlibExpansion
namespace Geometry
namespace RiemannSurfaces

/-- A Weyl-style complex charted surface: an abstract surface carrier equipped
with a one-dimensional complex analytic atlas. -/
class ComplexChartedSurface (X : Type u) [TopologicalSpace X] [T2Space X]
    extends ChartedSpace ℂ X, AnalyticManifold 𝓘(ℂ) X where
  toAbstractSurfaceCarrier : AbstractSurfaceCarrier X

attribute [instance] ComplexChartedSurface.toAbstractSurfaceCarrier

/-- Conformal equivalence is modeled as an analytic structomorphism between
complex charted surfaces. -/
abbrev ConformalEquiv
    (X : Type u) (Y : Type v)
    [TopologicalSpace X] [TopologicalSpace Y]
    [ChartedSpace ℂ X] [ChartedSpace ℂ Y]
    [HasGroupoid X (analyticGroupoid 𝓘(ℂ))]
    [HasGroupoid Y (analyticGroupoid 𝓘(ℂ))] :=
  Structomorph (analyticGroupoid 𝓘(ℂ)) X Y

/-- Weyl's local uniformizer theorem exposed as a single boundary: every point
admits a preferred local complex chart belonging to the atlas. -/
theorem exists_local_uniformizer
    (X : Type u) [TopologicalSpace X] [T2Space X] [ComplexChartedSurface X] (x : X) :
    ∃ e : PartialHomeomorph X ℂ, x ∈ e.source ∧ e ∈ atlas ℂ X := by
  exact ⟨chartAt ℂ x, mem_chart_source ℂ x, chart_mem_atlas ℂ x⟩

/-- Open subdomains of a complex charted surface inherit the same structure. -/
noncomputable instance instComplexChartedSurfaceOpens
    (X : Type u) [TopologicalSpace X] [T2Space X] [ComplexChartedSurface X]
    (U : TopologicalSpace.Opens X) : ComplexChartedSurface U where
  toAnalyticManifold :=
    { compatible := by
        intro e e' he he'
        exact (analyticGroupoid 𝓘(ℂ)).compatible he he' }
  toAbstractSurfaceCarrier :=
    { toIsManifold := inferInstance }

end RiemannSurfaces
end Geometry
end MathlibExpansion
