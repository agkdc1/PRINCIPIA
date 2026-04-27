import Mathlib.Data.Real.Basic

import MathlibExpansion.Analysis.VectorCalculus.GradientPotential

/-!
# Gauss law and Poisson equation shell for Maxwell

This chapter stays decoupled from the curl-facing substrate. It packages the
divergence/Laplacian side of the first Maxwell breach wave on the shared
`EuclideanSpace ℝ (Fin 3)` carrier.
-/

noncomputable section

open scoped BigOperators

namespace MathlibExpansion.Analysis.VectorCalculus

/-- Coordinate divergence for vector fields on `EuclideanSpace ℝ (Fin 3)`. -/
def divergence (F : VectorField) (x : SpatialPoint) : ℝ :=
  ∑ i : Fin 3, partialDeriv i (fun y => F y i) x

/-- Coordinate Laplacian for scalar fields on `EuclideanSpace ℝ (Fin 3)`. -/
def laplacian (V : ScalarField) (x : SpatialPoint) : ℝ :=
  divergence (gradientField V) x

/-- Maxwell's Poisson equation shell. -/
def poissonEq (V ρ : ScalarField) : Prop :=
  ∀ x, laplacian V x = -((4 * Real.pi) * ρ x)

/-- Maxwell's Gauss-law shell in potential form. -/
def GaussLaw (V ρ : ScalarField) : Prop :=
  poissonEq V ρ

/-- The Laplacian is the divergence of the gradient. -/
theorem laplacian_eq_divergence_gradient (V : ScalarField) :
    laplacian V = fun x => divergence (gradientField V) x :=
  rfl

/-- Maxwell's Gauss law and Poisson equation are the same shell at this stage. -/
theorem gauss_law_iff_poisson (V ρ : ScalarField) :
    GaussLaw V ρ ↔ poissonEq V ρ :=
  Iff.rfl

end MathlibExpansion.Analysis.VectorCalculus
