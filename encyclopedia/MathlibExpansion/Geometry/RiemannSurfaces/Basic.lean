import MathlibExpansion.AlgebraicTopology.Covering.UniversalCover
import MathlibExpansion.Analysis.Complex.FunctionElements
import MathlibExpansion.Geometry.Manifold.Orientability
import MathlibExpansion.Geometry.RiemannSurfaces.BranchedCover
import MathlibExpansion.Geometry.RiemannSurfaces.ComplexChartedSurface

/-!
# Basic Riemann-surface structures

This file turns the complex-charted-surface package into the textbook-facing
`RiemannSurface` and `CompactRiemannSurface` interfaces used by the rest of the
Weyl stack.
-/

universe u

open scoped Manifold ContDiff

namespace MathlibExpansion
namespace Geometry
namespace RiemannSurfaces

/-- Weyl's Riemann surfaces are the complex charted surfaces used by the later
continuation, residue, and uniformization chapters. The orientation data is
bundled here because complex charts give the real two-dimensional surface its
canonical orientation. -/
class RiemannSurface (X : Type u) [TopologicalSpace X] [T2Space X]
    extends ComplexChartedSurface X where
  orientationData :
    MathlibExpansion.Geometry.Manifold.ManifoldOrientationData 𝓘(ℝ, SurfaceModel) X

/-- Compact Riemann surfaces carry their genus as bundled textbook data. -/
class CompactRiemannSurface (X : Type u) [TopologicalSpace X] [T2Space X]
    extends RiemannSurface X, CompactSpace X where
  genus : ℕ

/-- The genus bundled with a compact Riemann surface. -/
def surfaceGenus
    (X : Type u) [TopologicalSpace X] [T2Space X] [CompactRiemannSurface X] : ℕ :=
  CompactRiemannSurface.genus (X := X)

/-- A surface meromorphic function, kept as a typed shell until the full
function-field bridge is landed. -/
structure SurfaceMeromorphicFunction
    (X : Type u) [TopologicalSpace X] [T2Space X] where
  toFun : X → ℂ
  meromorphicWitness : Prop

instance
    (X : Type u) [TopologicalSpace X] [T2Space X] :
    CoeFun (SurfaceMeromorphicFunction X) (fun _ => X → ℂ) where
  coe f := f.toFun

/-- An analytic configuration in Weyl's sense: local analytic data intended to
be realized as a branched surface. -/
structure AnalyticConfiguration where
  branchValues : Set ℂ
  localDegree : ℂ → ℕ

/-- The current `BranchedCoverModel` and `Triangulation` carriers are
textbook-facing shells, so every analytic configuration has a collapsed
branched-surface witness with an explicit empty triangulation.

Source boundary for the eventual non-collapsed theorem: Weyl `1913`,
*Die Idee der Riemannschen Flaeche*, Chapter I, `§§1-3`, where analytic
function elements are assembled into the Riemann-surface carrier. -/
theorem analyticConfiguration_has_branched_surface_triangulation
    (G : AnalyticConfiguration) :
    ∃ X : BranchedCoverModel, HasSurfaceTriangulation X.carrier := by
  let X : BranchedCoverModel :=
    { carrier := PUnit
      instTopologicalSpace := inferInstance
      projection := fun _ => 0
      sheetCount := 0
      genus := 0
      branchLocus := G.branchValues
      cutData := genusZeroCutData PUnit.unit }
  refine ⟨X, ?_⟩
  exact
    { triangulation :=
        ⟨{ TopSimplices := PEmpty
           Cells := fun _ => PEmpty }⟩ }

/-- The universal-cover existence shell already landed in the covering lane is
re-exported here with the textbook-facing surface name. -/
theorem exists_universalCoveringSurface
    (X : Type u) [TopologicalSpace X] [T2Space X] [ConnectedSpace X] [RiemannSurface X] :
    Nonempty (MathlibExpansion.AlgebraicTopology.Covering.UniversalCover X) :=
  MathlibExpansion.AlgebraicTopology.Covering.exists_universalCover X

end RiemannSurfaces
end Geometry
end MathlibExpansion
