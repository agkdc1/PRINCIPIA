import MathlibExpansion.Geometry.Riemannian.Curvature

/-!
# Sectional curvature
-/

universe u v

noncomputable section

open scoped BigOperators

namespace MathlibExpansion
namespace Geometry
namespace Riemannian

variable {M : Type u} {ι : Type v} [Fintype ι] [DecidableEq ι]

/-- Gram determinant of a pair of vectors relative to metric coefficients. -/
def gramDet (g : MetricCoefficients M ι) (x : M) (u v : ι → ℝ) : ℝ :=
  metricPairingCoefficients g x u u * metricPairingCoefficients g x v v -
    metricPairingCoefficients g x u v * metricPairingCoefficients g x u v

/-- The Riemann-curvature numerator attached to a pair of vectors. -/
def riemannCurvatureQuad (g : MetricCoefficients M ι) (pkg : CurvaturePackage g)
    (x : M) (u v : ι → ℝ) : ℝ :=
  ∑ i, ∑ j, ∑ k, ∑ l,
    u i * v j * u k * v l * pkg.riemannTensor x i j k l

/-- Pair-based sectional curvature. -/
def sectionalCurvaturePair (g : MetricCoefficients M ι) (pkg : CurvaturePackage g)
    (x : M) (u v : ι → ℝ) : ℝ :=
  riemannCurvatureQuad g pkg x u v / gramDet g x u v

theorem sectionalCurvaturePair_eq_riemannDivGramDet
    (g : MetricCoefficients M ι) (pkg : CurvaturePackage g)
    (x : M) (u v : ι → ℝ) (hdet : gramDet g x u v ≠ 0) :
    sectionalCurvaturePair g pkg x u v =
      riemannCurvatureQuad g pkg x u v / gramDet g x u v :=
  rfl

/-- Plane invariance of sectional curvature as an explicit package field. -/
structure SectionalCurvatureInvariant (g : MetricCoefficients M ι)
    (pkg : CurvaturePackage g) where
  eq_of_span_eq :
    ∀ (x : M) {u v u' v' : ι → ℝ}
      (hdet : gramDet g x u v ≠ 0)
      (hdet' : gramDet g x u' v' ≠ 0)
      (hspan :
        Submodule.span ℝ ({u, v} : Set (ι → ℝ)) =
          Submodule.span ℝ ({u', v'} : Set (ι → ℝ))),
      sectionalCurvaturePair g pkg x u v = sectionalCurvaturePair g pkg x u' v'

theorem sectionalCurvaturePair_eq_of_span_eq
    (g : MetricCoefficients M ι) (pkg : CurvaturePackage g)
    (inv : SectionalCurvatureInvariant g pkg)
    (x : M) {u v u' v' : ι → ℝ}
    (hdet : gramDet g x u v ≠ 0)
    (hdet' : gramDet g x u' v' ≠ 0)
    (hspan :
      Submodule.span ℝ ({u, v} : Set (ι → ℝ)) =
        Submodule.span ℝ ({u', v'} : Set (ι → ℝ))) :
    sectionalCurvaturePair g pkg x u v = sectionalCurvaturePair g pkg x u' v' :=
  inv.eq_of_span_eq x hdet hdet' hspan

end Riemannian
end Geometry
end MathlibExpansion
