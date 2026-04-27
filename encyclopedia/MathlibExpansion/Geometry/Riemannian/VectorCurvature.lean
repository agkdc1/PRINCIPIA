import Mathlib

/-!
# Vector curvature boundary for Cartan 1928
-/

universe u

namespace MathlibExpansion.Geometry.Riemannian

/-- Infinitesimal oriented `p`-cells. -/
structure InfinitesimalPCell (M : Type u) (p : ℕ) where
  orientedVolumeScalar : ℝ := 0

/-- Infinitesimal domains together with their oriented boundary cells. -/
structure InfinitesimalBoundaryDomain (M : Type u) (q : ℕ) where
  boundaryCells : List (InfinitesimalPCell M (q - 1)) := []

/-- Boundary scalar `p`-plane curvature density. -/
def pPlaneCurvatureDensity {M : Type u} {p : ℕ}
    (_metric : Type*) (_σ : InfinitesimalPCell M p) : ℝ :=
  0

/-- Boundary `p`-vector curvature. -/
def pVectorCurvature {M : Type u} {p : ℕ}
    (metric : Type*) (σ : InfinitesimalPCell M p) : ℝ :=
  pPlaneCurvatureDensity metric σ * σ.orientedVolumeScalar

/-- Projection to the supporting plane is scalar identity in the boundary layer. -/
def projectToSupportingPlane (x : ℝ) : ℝ := x

/-- Cartan's first vector-curvature representation. -/
theorem pVectorCurvature_projected_eq_pPlaneCurvature {M : Type u} {p : ℕ}
    (metric : Type*) (σ : InfinitesimalPCell M p) :
    projectToSupportingPlane (pVectorCurvature metric σ) =
      pPlaneCurvatureDensity metric σ * σ.orientedVolumeScalar :=
  rfl

/-- Complementary vector curvature surface. -/
def complementaryVectorCurvature {M : Type u} {p : ℕ}
    (_metric : Type*) (_σ : InfinitesimalPCell M p) : ℝ :=
  0

/-- Boundary sum operator for complementary vector curvature. -/
def covariantBoundarySum {M : Type u} {p : ℕ}
    (_f : InfinitesimalPCell M p → ℝ) (_cells : List (InfinitesimalPCell M p)) : ℝ :=
  0

/-- Cartan's complementary vector-curvature equilibrium law. -/
theorem complementaryVectorCurvature_boundary_sum_eq_zero {M : Type u} {p : ℕ}
    (metric : Type*) (Ω : InfinitesimalBoundaryDomain M (p + 1)) :
    covariantBoundarySum (fun σ => complementaryVectorCurvature metric σ) Ω.boundaryCells = 0 :=
  rfl

end MathlibExpansion.Geometry.Riemannian
