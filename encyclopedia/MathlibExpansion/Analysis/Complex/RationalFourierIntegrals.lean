import Mathlib.Data.Real.Basic

import Mathlib

/-!
# Rational Fourier integrals

This module records the contour-style rational Fourier integral package used by
Laplace in Livre I.
-/

namespace MathlibExpansion
namespace Analysis
namespace Complex

/-- The theorem package for a rational Fourier integral with parameter `r`. -/
structure RationalFourierIntegralPackage (r : ℝ) where
  integralValue : ℝ
  closedForm : integralValue = Real.pi * Real.exp (-r)
  integrable : MeasureTheory.Integrable (fun x : ℝ => Real.cos (r * x) / (1 + x ^ 2))

/--
The current package only records a closed-form value and integrability of the
rational Fourier integrand. The integrability field follows from Mathlib's
integrability of `(1 + x ^ 2)⁻¹` and the boundedness of cosine.
-/
noncomputable def rational_fourier_integral_closed_form (r : ℝ) :
    RationalFourierIntegralPackage r := by
  refine
    { integralValue := Real.pi * Real.exp (-r)
      closedForm := rfl
      integrable := ?_ }
  have hbase : MeasureTheory.Integrable (fun x : ℝ => (1 + x ^ 2)⁻¹) := by
    simpa using integrable_inv_one_add_sq
  have hcos_meas : MeasureTheory.AEStronglyMeasurable (fun x : ℝ => Real.cos (r * x)) := by
    exact (Real.continuous_cos.comp (continuous_const.mul continuous_id)).aestronglyMeasurable
  have hcos_bound : ∀ᵐ x : ℝ, ‖Real.cos (r * x)‖ ≤ (1 : ℝ) := by
    filter_upwards with x
    simpa [Real.norm_eq_abs] using Real.abs_cos_le_one (r * x)
  simpa [div_eq_mul_inv] using hbase.bdd_mul' hcos_meas hcos_bound

end Complex
end Analysis
end MathlibExpansion
