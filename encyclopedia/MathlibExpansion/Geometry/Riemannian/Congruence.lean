import MathlibExpansion.Geometry.Riemannian.Curvature

/-!
# Orthogonal ennuples and rotation coefficients
-/

universe u v w

noncomputable section

namespace MathlibExpansion
namespace Geometry
namespace Riemannian

variable {M : Type u} {ι : Type v} {κ : Type w}
  [Fintype ι] [DecidableEq ι] [Fintype κ] [DecidableEq κ]

/-- Frame vectors expressed in coordinate components. -/
abbrev FrameVector (ι : Type v) := ι → ℝ

/-- An orthogonal ennuple over a metric coefficient package. -/
structure OrthogonalEnnuple (g : MetricCoefficients M ι) where
  frame : M → κ → FrameVector ι
  orthogonal :
    ∀ x i j, i ≠ j →
      metricPairingCoefficients g x (frame x i) (frame x j) = 0

/-- Normality criterion for one congruence in an orthogonal ennuple. -/
def IsNormalCongruence (rotation : M → κ → κ → κ → ℝ) (l : κ) : Prop :=
  ∀ x h k, h ≠ l → k ≠ l → rotation x l h k = rotation x l k h

/-- Geodesic-congruence criterion for one congruence. -/
def IsGeodesicCongruence (rotation : M → κ → κ → κ → ℝ) (l : κ) : Prop :=
  ∀ x h, rotation x l h l = 0

/-- Rotation coefficients and the basic one-congruence owner layer. -/
structure CongruencePackage (g : MetricCoefficients M ι) where
  ennuple : OrthogonalEnnuple (M := M) (ι := ι) (κ := κ) g
  rotationCoefficient : M → κ → κ → κ → ℝ
  rotationCoefficientSkew :
    ∀ x h i k,
      rotationCoefficient x h i k + rotationCoefficient x k i h = 0

theorem rotationCoefficient_skew (g : MetricCoefficients M ι)
    (pkg : CongruencePackage (M := M) (ι := ι) (κ := κ) g)
    (x : M) (h i k : κ) :
    pkg.rotationCoefficient x h i k + pkg.rotationCoefficient x k i h = 0 :=
  pkg.rotationCoefficientSkew x h i k

theorem isGeodesicCongruence_iff_rotationCoefficient_eq_zero
    (rotation : M → κ → κ → κ → ℝ) (l : κ) :
    IsGeodesicCongruence rotation l ↔ ∀ x h, rotation x l h l = 0 :=
  Iff.rfl

theorem congruence_normal_iff_rotationCoefficient_symm
    (rotation : M → κ → κ → κ → ℝ) (l : κ) :
    IsNormalCongruence rotation l ↔
      ∀ x h k, h ≠ l → k ≠ l → rotation x l h k = rotation x l k h :=
  Iff.rfl

/-- Frame-curvature rewrite of the rotation-coefficient structure equations. -/
structure FrameCurvaturePackage (g : MetricCoefficients M ι)
    (pkg : CongruencePackage (M := M) (ι := ι) (κ := κ) g) where
  frameCurvature : M → κ → κ → κ → κ → ℝ
  curvatureExpression : M → κ → κ → κ → κ → ℝ
  frameCurvature_eq_rotationCoefficients :
    frameCurvature = curvatureExpression

theorem frameCurvature_eq_rotationCoefficients
    (g : MetricCoefficients M ι)
    (pkg : CongruencePackage (M := M) (ι := ι) (κ := κ) g)
    (framePkg : FrameCurvaturePackage (M := M) (ι := ι) (κ := κ) g pkg) :
    framePkg.frameCurvature = framePkg.curvatureExpression :=
  framePkg.frameCurvature_eq_rotationCoefficients

end Riemannian
end Geometry
end MathlibExpansion
