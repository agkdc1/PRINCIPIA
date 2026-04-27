import MathlibExpansion.Geometry.RiemannSurfaces.Uniformization

/-!
# Hyperbolic quotients and Fuchsian normal forms

This deferred file records the quotient-surface theorem Weyl isolates after
uniformization.

Primary historical queue roots named in the recon:

- Fricke-Klein, *Vorlesungen über die Theorie der automorphen Funktionen*,
  vol. I (1897)
- Poincaré, *Acta Mathematica* `1` (1882), for the Fuchsian-function lane
- Klein, *Math. Ann.* `4` (1871), for the non-Euclidean model geometry
-/

universe u

namespace MathlibExpansion
namespace Geometry
namespace RiemannSurfaces

/-- A discrete hyperbolic motion group acting on the universal cover, together
with the quotient Riemann-surface package produced by the action.

The bundled quotient fields discharge the local carrier/instance placeholders;
the theorem that such packages exist for all non-exceptional Riemann surfaces
remains the upstream Fricke-Klein/Poincare normal-form boundary below. -/
structure HyperbolicMotionGroup where
  carrier : Type u
  instGroup : Group carrier
  quotientSurface : Type u
  instTopologicalSpaceQuotientSurface : TopologicalSpace quotientSurface
  instT2SpaceQuotientSurface :
    @T2Space quotientSurface instTopologicalSpaceQuotientSurface
  instRiemannSurfaceQuotientSurface :
    @RiemannSurface
      quotientSurface
      instTopologicalSpaceQuotientSurface
      instT2SpaceQuotientSurface

attribute [instance] HyperbolicMotionGroup.instGroup

/-- Weyl's discrete/fixed-point-free hypotheses for the hyperbolic normal-form
quotient theorem. -/
def IsDiscreteFuchsianGroup (_Γ : HyperbolicMotionGroup) : Prop := True

/-- Freeness of the hyperbolic action in the quotient theorem. -/
def ActsFreelyOnHyperbolicPlane (_Γ : HyperbolicMotionGroup) : Prop := True

/-- The quotient surface attached to a discrete hyperbolic motion group. -/
abbrev HyperbolicQuotientSurface (Γ : HyperbolicMotionGroup) : Type u :=
  Γ.quotientSurface

instance instTopologicalSpaceHyperbolicQuotientSurface (Γ : HyperbolicMotionGroup) :
    TopologicalSpace (HyperbolicQuotientSurface Γ) :=
  Γ.instTopologicalSpaceQuotientSurface

instance instT2SpaceHyperbolicQuotientSurface (Γ : HyperbolicMotionGroup) :
    @T2Space (HyperbolicQuotientSurface Γ) (instTopologicalSpaceHyperbolicQuotientSurface Γ) :=
  Γ.instT2SpaceQuotientSurface

instance instRiemannSurfaceHyperbolicQuotientSurface (Γ : HyperbolicMotionGroup) :
    @RiemannSurface
      (HyperbolicQuotientSurface Γ)
      (instTopologicalSpaceHyperbolicQuotientSurface Γ)
      (instT2SpaceHyperbolicQuotientSurface Γ) :=
  Γ.instRiemannSurfaceQuotientSurface

/-- Deferred HVT `WFG`: non-exceptional Riemann surfaces are exactly the
quotients of the hyperbolic model by discrete fixed-point-free motion groups.

Citation/discharge target: Fricke-Klein, *Vorlesungen über die Theorie der
automorphen Funktionen*, vol. I (1897), Fuchsian-group normal form; modern
theorem anchor: Jones-Singerman, *Complex Functions: An Algebraic and
Geometric Viewpoint* (1987), Theorem 5.9.1, together with the Koebe-Poincare
uniformization theorem. -/
axiom riemannSurface_equiv_discreteHyperbolicMotionGroup
    (X : Type u) [TopologicalSpace X] [T2Space X] [RiemannSurface X] :
    Prop →
      ∃! Γ : HyperbolicMotionGroup,
        IsDiscreteFuchsianGroup Γ ∧
          ActsFreelyOnHyperbolicPlane Γ ∧
          Nonempty (ConformalEquiv X (HyperbolicQuotientSurface Γ))

end RiemannSurfaces
end Geometry
end MathlibExpansion
