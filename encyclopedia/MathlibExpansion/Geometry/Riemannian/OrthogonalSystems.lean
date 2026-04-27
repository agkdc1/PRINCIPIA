import MathlibExpansion.Geometry.Riemannian.Congruence
import MathlibExpansion.Analysis.PDE.CompleteSystems

/-!
# Frobenius integrability of orthogonal systems
-/

universe u v w

noncomputable section

namespace MathlibExpansion
namespace Geometry
namespace Riemannian

variable {M : Type u} {ι : Type v} {κ : Type w}
  [Fintype ι] [DecidableEq ι] [Fintype κ] [DecidableEq κ]

/-- Orthogonal-systems owner layer. -/
structure OrthogonalSystemsPackage where
  rotationCoefficient : M → κ → κ → κ → ℝ
  ComesFromNTuplyOrthogonalSystem : Prop
  IsNormalToIsothermicFamily : κ → Prop
  PrincipalCongruencesNormal : Prop
  ComponentCriterion36_6 : Prop
  CurvatureCriterion37_12 : Prop
  EnnupleCriterion37_12 : (κ → (ι → ℝ)) → Prop
  isothermicCriterion :
    ∀ h : κ,
      IsNormalToIsothermicFamily h ↔
        ∀ x i k, rotationCoefficient x h i k = rotationCoefficient x h k i
  ntuplyOrthogonalCriterion :
    ComesFromNTuplyOrthogonalSystem ↔
      ∀ x i j k, i ≠ j → j ≠ k → i ≠ k → rotationCoefficient x i j k = 0
  principalCriterion :
    PrincipalCongruencesNormal ↔ ComponentCriterion36_6
  flatSpaceRealization :
    ∀ x : M, ∀ e : κ → (ι → ℝ), ∃ S : Set M, x ∈ S
  conformalFlatRealization :
    ∀ x : M, ∀ e : κ → (ι → ℝ), ∃ S : Set M, x ∈ S
  conformalFlatCriterion :
    CurvatureCriterion37_12 ↔ ∀ F : κ → (ι → ℝ), EnnupleCriterion37_12 F

theorem exists_isothermicHypersurfaces_iff_gradient_condition
    (pkg : OrthogonalSystemsPackage (M := M) (ι := ι) (κ := κ)) (h : κ) :
    pkg.IsNormalToIsothermicFamily h ↔
      ∀ x i k, pkg.rotationCoefficient x h i k = pkg.rotationCoefficient x h k i :=
  pkg.isothermicCriterion h

theorem ntuplyOrthogonal_iff_pairwiseDistinct_rotationCoeff_vanish
    (pkg : OrthogonalSystemsPackage (M := M) (ι := ι) (κ := κ)) :
    pkg.ComesFromNTuplyOrthogonalSystem ↔
      ∀ x i j k, i ≠ j → j ≠ k → i ≠ k → pkg.rotationCoefficient x i j k = 0 :=
  pkg.ntuplyOrthogonalCriterion

theorem principalCongruences_normal_iff_componentCriterion
    (pkg : OrthogonalSystemsPackage (M := M) (ι := ι) (κ := κ)) :
    pkg.PrincipalCongruencesNormal ↔ pkg.ComponentCriterion36_6 :=
  pkg.principalCriterion

theorem exists_ntuplyOrthogonalSystem_in_flatSpace_with_given_frame
    (pkg : OrthogonalSystemsPackage (M := M) (ι := ι) (κ := κ))
    (x : M) (e : κ → (ι → ℝ)) :
    ∃ S : Set M, x ∈ S :=
  pkg.flatSpaceRealization x e

theorem exists_ntuplyOrthogonalSystem_of_conformalFlat_with_given_orientation
    (pkg : OrthogonalSystemsPackage (M := M) (ι := ι) (κ := κ))
    (x : M) (e : κ → (ι → ℝ)) :
    ∃ S : Set M, x ∈ S :=
  pkg.conformalFlatRealization x e

theorem conformalFlat_iff_orthogonalEnnuple_curvatureCriterion
    (pkg : OrthogonalSystemsPackage (M := M) (ι := ι) (κ := κ)) :
    pkg.CurvatureCriterion37_12 ↔
      ∀ F : κ → (ι → ℝ), pkg.EnnupleCriterion37_12 F :=
  pkg.conformalFlatCriterion

end Riemannian
end Geometry
end MathlibExpansion
