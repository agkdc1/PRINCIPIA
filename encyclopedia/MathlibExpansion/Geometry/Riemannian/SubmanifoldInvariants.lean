import MathlibExpansion.Geometry.Riemannian.Submanifold

/-!
# Mean curvature, minimality, and total geodesicity
-/

universe u v

noncomputable section

namespace MathlibExpansion
namespace Geometry
namespace Riemannian

variable {V : Type u} {W : Type v}
  [AddCommGroup V] [Module ℝ V]
  [AddCommGroup W] [Module ℝ W]
  {f : LocalImmersion V W} {gN : AmbientMetric W}
  {pkg : SubmanifoldPackage f gN}

/-- Invariant consumer layer over a submanifold package. -/
structure SubmanifoldInvariantPackage
    (f : LocalImmersion V W) (gN : AmbientMetric W)
    (pkg : SubmanifoldPackage f gN) where
  meanCurvatureVector : W
  traceSecondFundamentalForm : W
  IsMinimal : Prop
  IsTotallyGeodesic : Prop
  IsIntrinsicGeodesic : (ℝ → V) → Prop
  IsAmbientGeodesic : (ℝ → W) → Prop
  ambientChristoffelNormalComponent : V → V → ℝ
  meanCurvatureVector_eq_trace_secondFundamentalForm :
    meanCurvatureVector = traceSecondFundamentalForm
  isMinimal_iff_meanCurvatureVector_eq_zero :
    IsMinimal ↔ meanCurvatureVector = (0 : W)
  isTotallyGeodesic_iff_secondFundamentalForm_eq_zero :
    IsTotallyGeodesic ↔ ∀ u v, pkg.secondFundamentalForm u v = 0
  intrinsicGeodesics_are_ambient :
    IsTotallyGeodesic ↔
      ∀ γ : ℝ → V, IsIntrinsicGeodesic γ →
        IsAmbientGeodesic (fun t => f.tangentMap (γ t))
  coordinateCriterion :
    IsTotallyGeodesic ↔
      ∀ u v, ambientChristoffelNormalComponent u v = 0
  totallyGeodesic_isMinimal : IsTotallyGeodesic → IsMinimal

theorem meanCurvatureVector_eq_trace_secondFundamentalForm
    (inv : SubmanifoldInvariantPackage f gN pkg) :
    inv.meanCurvatureVector = inv.traceSecondFundamentalForm :=
  inv.meanCurvatureVector_eq_trace_secondFundamentalForm

theorem isMinimal_iff_meanCurvatureVector_eq_zero
    (inv : SubmanifoldInvariantPackage f gN pkg) :
    inv.IsMinimal ↔ inv.meanCurvatureVector = (0 : W) :=
  inv.isMinimal_iff_meanCurvatureVector_eq_zero

theorem isTotallyGeodesic_iff_secondFundamentalForm_eq_zero
    (inv : SubmanifoldInvariantPackage f gN pkg) :
    inv.IsTotallyGeodesic ↔ ∀ u v, pkg.secondFundamentalForm u v = 0 :=
  inv.isTotallyGeodesic_iff_secondFundamentalForm_eq_zero

theorem isTotallyGeodesic_iff_intrinsicGeodesics_are_ambient
    (inv : SubmanifoldInvariantPackage f gN pkg) :
    inv.IsTotallyGeodesic ↔
      ∀ γ : ℝ → V, inv.IsIntrinsicGeodesic γ →
        inv.IsAmbientGeodesic (fun t => f.tangentMap (γ t)) :=
  inv.intrinsicGeodesics_are_ambient

theorem coordinateSubmanifold_isTotallyGeodesic_iff_forall_normal_christoffel_eq_zero
    (inv : SubmanifoldInvariantPackage f gN pkg) :
    inv.IsTotallyGeodesic ↔ ∀ u v, inv.ambientChristoffelNormalComponent u v = 0 :=
  inv.coordinateCriterion

theorem IsTotallyGeodesic.isMinimal
    (inv : SubmanifoldInvariantPackage f gN pkg) :
    inv.IsTotallyGeodesic → inv.IsMinimal :=
  inv.totallyGeodesic_isMinimal

end Riemannian
end Geometry
end MathlibExpansion
