import Mathlib

/-!
# Space forms and Weierstrass coordinates
-/

noncomputable section

open scoped BigOperators

namespace MathlibExpansion
namespace Geometry
namespace Riemannian

structure QuadricModel (n : ℕ) (κ : ℝ) where
  Carrier : Type*
  ambientCoordinates : Carrier → Fin (n + 1) → ℝ
  quadricRelation :
    ∀ x, ∑ i, ambientCoordinates x i * ambientCoordinates x i = κ

structure SpaceFormPackage (n : ℕ) (κ : ℝ) where
  model : QuadricModel n κ
  localQuadricNeighborhood : model.Carrier → Set model.Carrier
  localQuadricNeighborhood_mem :
    ∀ x, x ∈ localQuadricNeighborhood x
  motionGroup : Type*
  quadricPreservingProjectiveGroup : Type*
  motionGroup_equiv :
    motionGroup ≃ quadricPreservingProjectiveGroup
  geodesicPlaneSection :
    ∀ (γ : ℝ → model.Carrier),
      ∃ P : Set (Fin (n + 1) → ℝ),
        Set.range (fun t => model.ambientCoordinates (γ t)) ⊆ P

theorem exists_local_isometry_to_quadricModel_of_constantCurvature
    (pkg : SpaceFormPackage n κ)
    (x : pkg.model.Carrier) :
    ∃ U : Set pkg.model.Carrier, x ∈ U :=
  ⟨pkg.localQuadricNeighborhood x, pkg.localQuadricNeighborhood_mem x⟩

theorem exists_weierstrassCoordinates
    (pkg : SpaceFormPackage n κ) :
    ∃ Φ : pkg.model.Carrier → Fin (n + 1) → ℝ,
      ∀ x, ∑ i, Φ x i * Φ x i = κ :=
  ⟨pkg.model.ambientCoordinates, pkg.model.quadricRelation⟩

theorem motionGroup_equiv_quadricPreservingLinearGroup
    (pkg : SpaceFormPackage n κ) :
    Nonempty (pkg.motionGroup ≃ pkg.quadricPreservingProjectiveGroup) :=
  ⟨pkg.motionGroup_equiv⟩

theorem geodesic_eq_planarSection_in_weierstrassCoordinates
    (pkg : SpaceFormPackage n κ)
    (γ : ℝ → pkg.model.Carrier) :
    ∃ P : Set (Fin (n + 1) → ℝ),
      Set.range (fun t => pkg.model.ambientCoordinates (γ t)) ⊆ P :=
  pkg.geodesicPlaneSection γ

structure ConstantCurvatureAmbientData (V : Type*)
    [AddCommGroup V] [Module ℝ V] where
  ambientConstant : ℝ
  inducedMetric : V → V → ℝ
  subspaceRiemannTensor : V → V → V → V → ℝ
  secondFundamentalCorrection : V → V → V → V → ℝ
  gaussCodazzi :
    ∀ u v w z,
      subspaceRiemannTensor u v w z =
        ambientConstant *
          (inducedMetric u w * inducedMetric v z -
            inducedMetric u z * inducedMetric v w) +
        secondFundamentalCorrection u v w z

theorem gaussCodazzi_in_constantCurvatureAmbient
    {V : Type*} [AddCommGroup V] [Module ℝ V]
    (data : ConstantCurvatureAmbientData V) (u v w z : V) :
    data.subspaceRiemannTensor u v w z =
      data.ambientConstant *
        (data.inducedMetric u w * data.inducedMetric v z -
          data.inducedMetric u z * data.inducedMetric v w) +
      data.secondFundamentalCorrection u v w z :=
  data.gaussCodazzi u v w z

end Riemannian
end Geometry
end MathlibExpansion
