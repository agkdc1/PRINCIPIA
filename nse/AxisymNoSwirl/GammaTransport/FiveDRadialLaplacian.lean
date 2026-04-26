import NavierStokes.AxisymNoSwirl.GammaTransport.GammaBridge

/-!
# NavierStokes.AxisymNoSwirl.GammaTransport.FiveDRadialLaplacian

Structural `ℝ⁵` radial-Laplacian export for the B5 interface.

This file defines a concrete coordinate Laplacian on `EuclideanSpace ℝ (Fin 5)` and the
axis-aligned radial lift `p ↦ (rCyl p, 0, 0, 0, z)`. The fully automatic derivation of the
five second-partial identities from `F(y,z) = Γ(|y|, z)` is exactly the missing second-order
radial calculus surface identified in the recon. We therefore package those identities
explicitly and reduce them to `gammaDiffusion` kernel-cleanly.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

namespace NavierStokes.AxisymNoSwirl.GammaTransport

open NavierStokes.Geometry.Cylindrical

/-- The ambient 5D Euclidean carrier used by the 5D lift. -/
abbrev R5 := EuclideanSpace ℝ (Fin 5)

/-- Freeze all coordinates except `i` and vary the `i`th coordinate. -/
def coordSlice (i : Fin 5) (F : R5 → ℝ) (x : R5) : ℝ → ℝ :=
  fun t => F (Function.update x i t)

/-- Coordinate second derivative in the `i`th slot. -/
def secondPartialDeriv5 (i : Fin 5) (F : R5 → ℝ) (x : R5) : ℝ :=
  deriv (fun t => deriv (coordSlice i F x) t) (x i)

/-- Coordinate Laplacian on `R5`. -/
def laplacian5 (F : R5 → ℝ) (x : R5) : ℝ :=
  ∑ i : Fin 5, secondPartialDeriv5 i F x

/-- Radius in the first four coordinates of `R5`. -/
def radialRadius4 (x : R5) : ℝ :=
  Real.sqrt (x 0 ^ 2 + x 1 ^ 2 + x 2 ^ 2 + x 3 ^ 2)

/-- Radial lift of `Γ` from `(r,z)`-data into `R5`. -/
def radialLift (Γ : GammaField) (x : R5) : ℝ :=
  Γ (radialRadius4 x, 0, x 4)

/-- Axis-aligned embedding of the cylindrical slice into `R5`. -/
def radialEmbed (p : E3) : R5 :=
  ![rCyl p, 0, 0, 0, p.2.2]

/-- Pointwise package of the five second-partial identities needed for the 5D bridge. -/
structure HasFiveDRadialLaplacianData
    (Γ : GammaField) (F : R5 → ℝ) (p : E3) : Prop where
  second_0 :
    secondPartialDeriv5 0 F (radialEmbed p) = radialDeriv (radialDeriv Γ) p
  second_1 :
    secondPartialDeriv5 1 F (radialEmbed p) = (1 / rCyl p) * radialDeriv Γ p
  second_2 :
    secondPartialDeriv5 2 F (radialEmbed p) = (1 / rCyl p) * radialDeriv Γ p
  second_3 :
    secondPartialDeriv5 3 F (radialEmbed p) = (1 / rCyl p) * radialDeriv Γ p
  second_4 :
    secondPartialDeriv5 4 F (radialEmbed p) = verticalDeriv (verticalDeriv Γ) p

/-- Structural 5D radial-Laplacian bridge for B5 consumption. -/
theorem gammaDiffusion_is_5D_radial_Laplacian
    (Γ : GammaField) (F : R5 → ℝ)
    (hF : ∀ x : R5, F x = radialLift Γ x)
    (p : E3) (hp : p ∈ puncturedSpace)
    (hdata : HasFiveDRadialLaplacianData Γ F p) :
    laplacian5 F (radialEmbed p) = gammaDiffusion Γ p := by
  unfold laplacian5 gammaDiffusion
  rw [Fin.sum_univ_five]
  rw [hdata.second_0, hdata.second_1, hdata.second_2, hdata.second_3, hdata.second_4]
  ring

end NavierStokes.AxisymNoSwirl.GammaTransport

end
