import MathlibExpansion.Geometry.Riemannian.Curvature

/-!
# Flatness criterion
-/

universe u v

namespace MathlibExpansion
namespace Geometry
namespace Riemannian

variable {M : Type u} {ι : Type v} [Fintype ι] [DecidableEq ι]

/-- A pointwise zero-curvature condition. -/
def ZeroRiemannAt (pkg : CurvaturePackage (M := M) (ι := ι) (g := g)) (x : M) : Prop :=
  ∀ i j k l, pkg.riemannTensor x i j k l = 0

/-- Local constancy of metric coefficients in some neighborhood. -/
def MetricCoefficientsLocallyConstantAt (g : MetricCoefficients M ι) (x : M) : Prop :=
  ∃ U : Set M, x ∈ U ∧ ∀ y ∈ U, g.coeff y = g.coeff x

/-- Flatness packaged as the equivalence between local constant coefficients
and vanishing curvature. -/
structure FlatnessPackage (g : MetricCoefficients M ι)
    (pkg : CurvaturePackage g) where
  criterion :
    ∀ x, MetricCoefficientsLocallyConstantAt g x ↔ ZeroRiemannAt pkg x

theorem exists_local_constantMetricCoefficients_iff_riemannTensor_eq_zero
    (g : MetricCoefficients M ι) (pkg : CurvaturePackage g)
    (flat : FlatnessPackage g pkg) (x : M) :
    MetricCoefficientsLocallyConstantAt g x ↔ ZeroRiemannAt pkg x :=
  flat.criterion x

end Riemannian
end Geometry
end MathlibExpansion
