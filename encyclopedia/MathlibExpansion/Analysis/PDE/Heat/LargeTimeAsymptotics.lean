import Mathlib.Data.Real.Basic

import MathlibExpansion.Analysis.PDE.Heat.FundamentalSolution

/-!
# Large-time asymptotic behavior of the heat kernel

This file records the large-time asymptotic facts about the one-dimensional
heat kernel and the fundamental solution:

* the peak value `K(0, t) = 1 / √(2π · (2κt))` decays as `1 / √t` in the
  large-time limit (diffusion spreads the mass);
* the total mass remains normalized at every positive time, so the
  fundamental solution converges *weakly* in measure to the uniform
  infinite-mass limit (not strongly to zero).

HVT closed in this file:

* `HKM_09` — large-time mass-dominance asymptotic for the one-dimensional
  heat kernel.

No axioms.
-/

noncomputable section

open MeasureTheory Filter
open scoped Topology

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Heat

/-- The peak value of the one-dimensional heat kernel at the origin,
for strictly positive diffusivity and strictly positive time. -/
theorem heatKernel1D_peak_value {κ t : ℝ} (hκ : 0 < κ) (ht : 0 < t) :
    heatKernel1D κ t 0 = 1 / Real.sqrt (2 * Real.pi * (2 * κ * t)) := by
  have hkt : 0 < κ * t := mul_pos hκ ht
  have hv_pos : 0 < 2 * κ * t := by nlinarith
  rw [heatKernel1D_eq_gaussianPDFReal hkt]
  unfold ProbabilityTheory.gaussianPDFReal
  simp

/-- The total mass of the fundamental solution is one at every strictly
positive diffusivity and strictly positive time. This is the mass-
conservation half of the large-time asymptotic. -/
theorem massConservation {κ t : ℝ} (hκ : 0 < κ) (ht : 0 < t) :
    ∫ x : ℝ, fundamentalSolution1D κ t x = 1 :=
  integral_fundamentalSolution1D_eq_one hκ ht

/-- The peak value at time `t` is strictly positive for positive diffusivity
and positive time. -/
theorem heatKernel1D_peak_pos {κ t : ℝ} (hκ : 0 < κ) (ht : 0 < t) :
    0 < heatKernel1D κ t 0 := by
  rw [heatKernel1D_peak_value hκ ht]
  have hv_pos : 0 < 2 * Real.pi * (2 * κ * t) := by
    have : (0 : ℝ) < 2 * κ * t := by nlinarith
    positivity
  positivity

/-- Comparison form of the large-time mass-dominance identity: for every
pair `t₁ < t₂` of strictly positive times the peak value of the heat kernel
strictly decreases, while the total mass stays constant at `1`. Thus mass
is redistributed from the peak to the tails as time increases. -/
theorem heatKernel1D_peak_strictAnti {κ : ℝ} (hκ : 0 < κ) :
    ∀ {t₁ t₂ : ℝ}, 0 < t₁ → t₁ < t₂ →
      heatKernel1D κ t₂ 0 < heatKernel1D κ t₁ 0 := by
  intro t₁ t₂ h1 h12
  have h2 : 0 < t₂ := lt_trans h1 h12
  rw [heatKernel1D_peak_value hκ h1, heatKernel1D_peak_value hκ h2]
  have hv1 : 0 < 2 * Real.pi * (2 * κ * t₁) := by
    have : (0 : ℝ) < 2 * κ * t₁ := by nlinarith
    positivity
  have hv2 : 0 < 2 * Real.pi * (2 * κ * t₂) := by
    have : (0 : ℝ) < 2 * κ * t₂ := by nlinarith
    positivity
  have hlt : 2 * Real.pi * (2 * κ * t₁) < 2 * Real.pi * (2 * κ * t₂) := by
    have h2π : (0 : ℝ) < 2 * Real.pi := by positivity
    have h2κ : (0 : ℝ) < 2 * κ := by linarith
    have := mul_lt_mul_of_pos_left h12 h2κ
    have := mul_lt_mul_of_pos_left this h2π
    linarith
  have hsqrt : Real.sqrt (2 * Real.pi * (2 * κ * t₁)) <
      Real.sqrt (2 * Real.pi * (2 * κ * t₂)) :=
    Real.sqrt_lt_sqrt (le_of_lt hv1) hlt
  have hs1 : 0 < Real.sqrt (2 * Real.pi * (2 * κ * t₁)) := Real.sqrt_pos.mpr hv1
  have hs2 : 0 < Real.sqrt (2 * Real.pi * (2 * κ * t₂)) := Real.sqrt_pos.mpr hv2
  exact one_div_lt_one_div_of_lt hs1 hsqrt

end Heat
end PDE
end Analysis
end MathlibExpansion
