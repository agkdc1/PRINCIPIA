import Mathlib.Data.Real.Basic

import Mathlib.Probability.Distributions.Gaussian

/-!
# Basic one-dimensional heat kernel

This file names the standard one-dimensional heat kernel with diffusivity `κ`
and packages the normalization theorem from the Gaussian PDF already available
in Mathlib.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Heat

/-- The one-dimensional heat kernel for `∂ₜ u = κ ∂ₓₓ u`, defined to be zero
outside the positive-time regime. -/
def heatKernel1D (κ t x : ℝ) : ℝ :=
  if h : 0 < κ * t then
    gaussianPDFReal (0 : ℝ) (⟨2 * κ * t, by nlinarith [h]⟩ : NNReal) x
  else
    0

@[simp] theorem heatKernel1D_eq_zero_of_nonpos {κ t x : ℝ} (h : κ * t ≤ 0) :
    heatKernel1D κ t x = 0 := by
  simp [heatKernel1D, not_lt.mpr h]

theorem heatKernel1D_eq_gaussianPDFReal {κ t : ℝ} (h : 0 < κ * t) :
    heatKernel1D κ t =
      gaussianPDFReal (0 : ℝ) (⟨2 * κ * t, by nlinarith [h]⟩ : NNReal) := by
  ext x
  simp [heatKernel1D, h, h.ne']

theorem heatKernel1D_nonneg (κ t x : ℝ) : 0 ≤ heatKernel1D κ t x := by
  by_cases h : 0 < κ * t
  · rw [heatKernel1D_eq_gaussianPDFReal h]
    exact gaussianPDFReal_nonneg 0 (⟨2 * κ * t, by nlinarith [h]⟩ : NNReal) x
  · simp [heatKernel1D, h]

/-- The one-dimensional heat kernel has total mass `1` for positive diffusivity
and positive time. -/
theorem integral_heatKernel1D_eq_one {κ t : ℝ} (hκ : 0 < κ) (ht : 0 < t) :
    ∫ x : ℝ, heatKernel1D κ t x = 1 := by
  have hkt : 0 < κ * t := mul_pos hκ ht
  let v : NNReal := ⟨2 * κ * t, by nlinarith [hkt]⟩
  rw [heatKernel1D_eq_gaussianPDFReal hkt]
  have hvar_pos : 0 < v := by
    change 0 < 2 * κ * t
    nlinarith [hκ, ht]
  simpa [v] using integral_gaussianPDFReal_eq_one (0 : ℝ) (show v ≠ 0 from ne_of_gt hvar_pos)

end Heat
end PDE
end Analysis
end MathlibExpansion
