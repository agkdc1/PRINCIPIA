import Mathlib.Data.Real.Basic

import MathlibExpansion.Analysis.PDE.Heat.KernelBasic

/-!
# Line solutions by Gaussian convolution

This file packages the standard heat-kernel solution operator on the line as a
convolution with the one-dimensional heat kernel.
-/

noncomputable section

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Heat

/-- The line heat solution operator at time `t`, written in the standard
Gaussian-convolution form. -/
def lineSolution (κ t : ℝ) (f : ℝ → ℝ) : ℝ → ℝ :=
  fun x => ∫ y : ℝ, heatKernel1D κ t y * f (x - y)

@[simp] theorem lineSolution_eq_integral_operator (κ t : ℝ) (f : ℝ → ℝ) :
    lineSolution κ t f = fun x => ∫ y : ℝ, heatKernel1D κ t y * f (x - y) :=
  rfl

theorem lineSolution_apply (κ t : ℝ) (f : ℝ → ℝ) (x : ℝ) :
    lineSolution κ t f x = ∫ y : ℝ, heatKernel1D κ t y * f (x - y) := by
  rfl

@[simp] theorem lineSolution_zero (κ t : ℝ) :
    lineSolution κ t (0 : ℝ → ℝ) = 0 := by
  ext x
  simp [lineSolution]

end Heat
end PDE
end Analysis
end MathlibExpansion
