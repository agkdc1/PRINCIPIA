import MathlibExpansion.Geometry.Riemannian.Curvature

/-!
# Submanifolds, second fundamental forms, and Gauss-Codazzi packages
-/

universe u v

noncomputable section

namespace MathlibExpansion
namespace Geometry
namespace Riemannian

variable {V : Type u} {W : Type v}
  [AddCommGroup V] [Module ℝ V]
  [AddCommGroup W] [Module ℝ W]

/-- A lightweight ambient metric package. -/
structure AmbientMetric (V : Type u) [AddCommGroup V] [Module ℝ V] where
  pairing : V → V → ℝ
  orthogonalComplement : Submodule ℝ V → Submodule ℝ V

/-- A local immersion recorded by its tangent map. -/
structure LocalImmersion (V : Type u) (W : Type v)
    [AddCommGroup V] [Module ℝ V] [AddCommGroup W] [Module ℝ W] where
  tangentMap : V →ₗ[ℝ] W

/-- The normal space is the ambient orthogonal complement of the tangent image. -/
def normalSpace (f : LocalImmersion V W) (gN : AmbientMetric W) : Submodule ℝ W :=
  gN.orthogonalComplement (LinearMap.range f.tangentMap)

theorem normalSpace_eq_orthogonal (f : LocalImmersion V W) (gN : AmbientMetric W) :
    normalSpace f gN = gN.orthogonalComplement (LinearMap.range f.tangentMap) :=
  rfl

/-- Core submanifold package for first/second fundamental forms and
Gauss-Codazzi identities. -/
structure SubmanifoldPackage (f : LocalImmersion V W) (gN : AmbientMetric W) where
  inducedMetric : AmbientMetric V
  ambientCovariantDeriv : V → V → W
  tangentCovariantDeriv : V → V → V
  secondFundamentalForm : V → V → ℝ
  secondFundamentalFormVec : V → V → W
  covariantDerivSecondFundamental : V → V → V → ℝ
  normalCovariantDerivSecondFundamental : V → V → V → W
  unitNormal : W
  ambientCurvatureTangential : V → V → V → V → ℝ
  submanifoldCurvature : V → V → V → V → ℝ
  ambientCurvatureNormalComponent : V → V → V → ℝ
  innerNormalBundle : W → W → ℝ
  geodesicCurvatureSq : V → ℝ
  normalCurvatureSq : V → ℝ
  ambientCurvatureSq : V → ℝ
  ambientCurveCurvatureVector : V → W
  tangentialCurvatureVector : V → W
  relativeNormalCurvatureVector : V → W
  ambientCovariantDeriv_eq_tangent_plus_secondFundamental :
    ∀ u v,
      ambientCovariantDeriv u v =
        f.tangentMap (tangentCovariantDeriv u v) + secondFundamentalForm u v • unitNormal
  gaussEquation_hypersurface :
    ∀ u v w z,
      submanifoldCurvature u v w z =
        ambientCurvatureTangential u v w z +
          secondFundamentalForm u z * secondFundamentalForm v w -
          secondFundamentalForm u w * secondFundamentalForm v z
  codazziEquation_hypersurface :
    ∀ u v w,
      covariantDerivSecondFundamental u v w -
        covariantDerivSecondFundamental v u w =
          ambientCurvatureNormalComponent u v w
  gaussEquation_immersed :
    ∀ u v w z,
      submanifoldCurvature u v w z =
        ambientCurvatureTangential u v w z +
          innerNormalBundle (secondFundamentalFormVec u z) (secondFundamentalFormVec v w) -
          innerNormalBundle (secondFundamentalFormVec u w) (secondFundamentalFormVec v z)
  codazziEquation_immersed :
    ∀ u v w,
      normalCovariantDerivSecondFundamental u v w -
        normalCovariantDerivSecondFundamental v u w =
          secondFundamentalFormVec u w - secondFundamentalFormVec v w
  ambientCurvatureSq_eq_geodesicSq_add_normalSq :
    ∀ γ, ambientCurvatureSq γ = geodesicCurvatureSq γ + normalCurvatureSq γ
  ambientCurveCurvature_decomp :
    ∀ γ,
      ambientCurveCurvatureVector γ =
        tangentialCurvatureVector γ + relativeNormalCurvatureVector γ

/-- Pullback metric alias for the induced metric. -/
def pullbackMetric {f : LocalImmersion V W} {gN : AmbientMetric W}
    (pkg : SubmanifoldPackage f gN) : AmbientMetric V :=
  pkg.inducedMetric

theorem inducedMetric_eq_pullback {f : LocalImmersion V W} {gN : AmbientMetric W}
    (pkg : SubmanifoldPackage f gN) :
    pkg.inducedMetric = pullbackMetric pkg :=
  rfl

theorem ambientCovariantDeriv_eq_tangent_plus_secondFundamental
    {f : LocalImmersion V W} {gN : AmbientMetric W}
    (pkg : SubmanifoldPackage f gN) (u v : V) :
    pkg.ambientCovariantDeriv u v =
      f.tangentMap (pkg.tangentCovariantDeriv u v) +
        pkg.secondFundamentalForm u v • pkg.unitNormal :=
  pkg.ambientCovariantDeriv_eq_tangent_plus_secondFundamental u v

theorem gaussEquation_hypersurface {f : LocalImmersion V W} {gN : AmbientMetric W}
    (pkg : SubmanifoldPackage f gN) (u v w z : V) :
    pkg.submanifoldCurvature u v w z =
      pkg.ambientCurvatureTangential u v w z +
        pkg.secondFundamentalForm u z * pkg.secondFundamentalForm v w -
        pkg.secondFundamentalForm u w * pkg.secondFundamentalForm v z :=
  pkg.gaussEquation_hypersurface u v w z

theorem codazziEquation_hypersurface {f : LocalImmersion V W} {gN : AmbientMetric W}
    (pkg : SubmanifoldPackage f gN) (u v w : V) :
    pkg.covariantDerivSecondFundamental u v w -
      pkg.covariantDerivSecondFundamental v u w =
        pkg.ambientCurvatureNormalComponent u v w :=
  pkg.codazziEquation_hypersurface u v w

theorem gaussEquation_immersed {f : LocalImmersion V W} {gN : AmbientMetric W}
    (pkg : SubmanifoldPackage f gN) (u v w z : V) :
    pkg.submanifoldCurvature u v w z =
      pkg.ambientCurvatureTangential u v w z +
        pkg.innerNormalBundle (pkg.secondFundamentalFormVec u z) (pkg.secondFundamentalFormVec v w) -
        pkg.innerNormalBundle (pkg.secondFundamentalFormVec u w) (pkg.secondFundamentalFormVec v z) :=
  pkg.gaussEquation_immersed u v w z

theorem codazziEquation_immersed {f : LocalImmersion V W} {gN : AmbientMetric W}
    (pkg : SubmanifoldPackage f gN) (u v w : V) :
    pkg.normalCovariantDerivSecondFundamental u v w -
      pkg.normalCovariantDerivSecondFundamental v u w =
        pkg.secondFundamentalFormVec u w - pkg.secondFundamentalFormVec v w :=
  pkg.codazziEquation_immersed u v w

theorem ambientCurvatureSq_eq_geodesicSq_add_normalSq
    {f : LocalImmersion V W} {gN : AmbientMetric W}
    (pkg : SubmanifoldPackage f gN) (γ : V) :
    pkg.ambientCurvatureSq γ = pkg.geodesicCurvatureSq γ + pkg.normalCurvatureSq γ :=
  pkg.ambientCurvatureSq_eq_geodesicSq_add_normalSq γ

theorem ambientCurveCurvature_decomp_immersed
    {f : LocalImmersion V W} {gN : AmbientMetric W}
    (pkg : SubmanifoldPackage f gN) (γ : V) :
    pkg.ambientCurveCurvatureVector γ =
      pkg.tangentialCurvatureVector γ + pkg.relativeNormalCurvatureVector γ :=
  pkg.ambientCurveCurvature_decomp γ

end Riemannian
end Geometry
end MathlibExpansion
