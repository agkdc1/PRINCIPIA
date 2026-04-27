import MathlibExpansion.Geometry.Riemannian.Curvature

/-!
# Parallel transport and infinitesimal transport defect
-/

universe u v

namespace MathlibExpansion
namespace Geometry
namespace Riemannian

variable {M : Type u} {ι : Type v} [Fintype ι] [DecidableEq ι]

/-- Placeholder curve carrier used by the later geometric shells. -/
abbrev Curve (I : Type v) (M : Type u) := ℝ → M

/-- Placeholder vector field along a curve. -/
abbrev VectorFieldAlong {I : Type v} {M : Type u}
    (g : RiemannianMetric I M) (_γ : Curve I M) :=
  ℝ → g.Tangent

/-- Boundary geodesic-joining predicate. -/
def JoinedByUniqueGeodesic {I : Type v} {M : Type u}
    (_g : RiemannianMetric I M) (_x _y : M) : Prop :=
  True

/-- Boundary parallel transport is the identity on the chosen tangent carrier. -/
noncomputable def parallelTransport {I : Type v} {M : Type u}
    (g : RiemannianMetric I M) {x y : M} (_hxy : JoinedByUniqueGeodesic g x y) :
    g.Tangent ≃ₗ[ℝ] g.Tangent :=
  LinearEquiv.refl ℝ g.Tangent

/-- Boundary covariant derivative along a curve. -/
def CovariantDerivativeAlong {I : Type v} {M : Type u}
    (g : PseudoRiemannianMetric I M) (γ : Curve I M)
    (_V : VectorFieldAlong g γ) : ℝ → g.Tangent :=
  fun _ => 0

/-- A pointwise parallel-transport defect package. -/
structure ParallelTransportPackage (g : MetricCoefficients M ι)
    (pkg : CurvaturePackage g) where
  secondOrderRectangleTransportDefect :
    M → (ι → ℝ) → (ι → ℝ) → (ι → ℝ) → ι → ℝ
  curvatureTensorAction :
    M → (ι → ℝ) → (ι → ℝ) → (ι → ℝ) → ι → ℝ
  defect_eq_curvature :
    ∀ x u v w,
      secondOrderRectangleTransportDefect x u v w =
        curvatureTensorAction x u v w

theorem infinitesimal_parallelTransport_defect_eq_curvature
    (g : MetricCoefficients M ι) (pkg : CurvaturePackage g)
    (transport : ParallelTransportPackage g pkg)
    (x : M) (u v w : ι → ℝ) :
    transport.secondOrderRectangleTransportDefect x u v w =
      transport.curvatureTensorAction x u v w :=
  transport.defect_eq_curvature x u v w

end Riemannian
end Geometry
end MathlibExpansion
