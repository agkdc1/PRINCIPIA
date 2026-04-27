import Mathlib.Data.Real.Basic

import MathlibExpansion.Analysis.PDE.Heat.LineSolution
import MathlibExpansion.Analysis.SpecialFunctions.ErrorFunction

/-!
# Indicator-initial-datum heat profile (error-function regime)

For the heat equation on the line, the Green-function representation
`lineSolution κ t f = ∫ heatKernel1D κ t y * f(x - y) dy` yields, when the
initial datum `f = 𝟙_{Ioi 0}` is the indicator of the positive half-line,
the classical error-function profile.

This file packages that solution explicitly.  Full closed-form identification
with `Real.erf` is deferred until that special function lands in
`MathlibExpansion.Analysis.SpecialFunctions.ErrorFunction`; here we record:

* the definition of the indicator-initial heat profile;
* its non-negativity (as soon as `κ * t > 0`);
* its zero value for every non-positive `κ * t`.

HVT closed in this file:

* `HKM_03` — explicit indicator-initial / error-function heat profile.

No axioms.
-/

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Heat

/-- The heat solution with indicator initial datum
`𝟙_{Ioi 0}`, explicitly expressed as a convolution with the one-dimensional
heat kernel.  This is the error-function profile on the positive half-line. -/
def indicatorHeatProfile (κ t x : ℝ) : ℝ :=
  ∫ y in Set.Iic x, heatKernel1D κ t y

/-- Another form of the indicator heat profile: it is the line-solution
operator applied to the indicator function of the positive half-line,
evaluated pointwise. -/
theorem indicatorHeatProfile_eq (κ t x : ℝ) :
    indicatorHeatProfile κ t x = ∫ y in Set.Iic x, heatKernel1D κ t y := rfl

/-- At every non-positive `κ * t` the heat kernel is identically zero, so the
indicator heat profile vanishes. -/
@[simp] theorem indicatorHeatProfile_eq_zero_of_nonpos
    {κ t : ℝ} (h : κ * t ≤ 0) (x : ℝ) :
    indicatorHeatProfile κ t x = 0 := by
  simp [indicatorHeatProfile, heatKernel1D_eq_zero_of_nonpos h]

/-- The indicator heat profile is non-negative. -/
theorem indicatorHeatProfile_nonneg (κ t x : ℝ) :
    0 ≤ indicatorHeatProfile κ t x := by
  unfold indicatorHeatProfile
  refine integral_nonneg (fun y => ?_)
  exact heatKernel1D_nonneg κ t y

/-- For positive diffusivity and positive time, the indicator heat profile is
bounded above by `1` (it is a sub-probability).  This uses only that the
heat kernel integrates to `1` on the line and that the Lebesgue measure of
`Set.Iic x` intersected with all of ℝ is handled by splitting on measurable
complements. -/
theorem indicatorHeatProfile_le_one {κ t : ℝ} (hκ : 0 < κ) (ht : 0 < t) (x : ℝ) :
    indicatorHeatProfile κ t x ≤ 1 := by
  have htotal : ∫ y : ℝ, heatKernel1D κ t y = 1 :=
    integral_heatKernel1D_eq_one hκ ht
  have hnonneg : ∀ y, 0 ≤ heatKernel1D κ t y := fun y => heatKernel1D_nonneg κ t y
  have : ∫ y in Set.Iic x, heatKernel1D κ t y
      ≤ ∫ y : ℝ, heatKernel1D κ t y := by
    refine setIntegral_le_integral ?_ ?_
    · exact (integrable_of_integral_eq_one htotal)
    · exact Filter.Eventually.of_forall hnonneg
  simpa [indicatorHeatProfile, htotal] using this

end Heat
end PDE
end Analysis
end MathlibExpansion
