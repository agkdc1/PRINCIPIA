import Mathlib.Data.Real.Basic

import Mathlib.Analysis.SpecialFunctions.Gaussian.FourierTransform
import MathlibExpansion.Analysis.PDE.Heat.KernelBasic

/-!
# Euclidean heat-kernel formula

This file names the standard Euclidean heat-kernel formula in finite-dimensional
real inner-product spaces and relates the one-dimensional specialization to the
named line kernel.
-/

noncomputable section

open scoped Real

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Heat

variable (V : Type*) [NormedAddCommGroup V] [InnerProductSpace ℝ V]
  [FiniteDimensional ℝ V] [MeasurableSpace V] [BorelSpace V]

/-- The Euclidean heat kernel in finite-dimensional real inner-product spaces,
defined to be zero outside the positive-time regime. -/
def heatKernelEuclidean (κ t : ℝ) (x : V) : ℝ :=
  if h : 0 < κ * t then
    (4 * Real.pi * κ * t) ^ (-(Module.finrank ℝ V : ℝ) / 2) *
      Real.exp (-‖x‖ ^ 2 / (4 * κ * t))
  else
    0

theorem heatKernelEuclidean_eq_formula {κ t : ℝ} (h : 0 < κ * t) (x : V) :
    heatKernelEuclidean V κ t x =
      (4 * Real.pi * κ * t) ^ (-(Module.finrank ℝ V : ℝ) / 2) *
        Real.exp (-‖x‖ ^ 2 / (4 * κ * t)) := by
  simp [heatKernelEuclidean, h, h.ne']

@[simp] theorem heatKernelEuclidean_eq_zero_of_nonpos {κ t : ℝ} (h : κ * t ≤ 0) (x : V) :
    heatKernelEuclidean V κ t x = 0 := by
  simp [heatKernelEuclidean, not_lt.mpr h]

/-- In dimension one, the Euclidean kernel agrees with the named `heatKernel1D`
formula. -/
theorem heatKernelEuclidean_real_eq_heatKernel1D {κ t x : ℝ} :
    heatKernelEuclidean ℝ κ t x =
      if h : 0 < κ * t then
        (4 * Real.pi * κ * t) ^ (-(1 : ℝ) / 2) * Real.exp (-(x ^ 2) / (4 * κ * t))
      else
        0 := by
  by_cases h : 0 < κ * t
  · simp [heatKernelEuclidean, h, Module.finrank_self, Real.norm_eq_abs, sq_abs]
  · simp [heatKernelEuclidean, h, Module.finrank_self, Real.norm_eq_abs, sq_abs]

end Heat
end PDE
end Analysis
end MathlibExpansion
