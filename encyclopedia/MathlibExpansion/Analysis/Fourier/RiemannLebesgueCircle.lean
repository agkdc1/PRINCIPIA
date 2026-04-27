import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

import Mathlib.Analysis.Fourier.AddCircle
import Mathlib.Analysis.Fourier.RiemannLebesgueLemma
import Mathlib.Order.Filter.AtTopBot.Archimedean
import Mathlib.Topology.Order.Compact

/-!
# Riemann-Lebesgue wrappers for textbook Fourier intervals

This file packages the interval cutoff that turns a finite-interval Fourier
coefficient problem into a standard Fourier-integral problem on `ℝ`.
-/

noncomputable section

open scoped FourierTransform Topology
open Filter MeasureTheory Set

namespace MathlibExpansion
namespace Analysis
namespace Fourier

/-- Cut a function down to the half-open interval `(a, b]`. This is the
compactly supported bridge from interval coefficients to Fourier integrals. -/
def intervalCutoff (a b : ℝ) (f : ℝ → ℂ) : ℝ → ℂ :=
  Set.indicator (Set.Ioc a b) f

@[simp] theorem intervalCutoff_apply_inside {a b x : ℝ} {f : ℝ → ℂ}
    (hx : x ∈ Set.Ioc a b) :
    intervalCutoff a b f x = f x := by
  simp [intervalCutoff, hx]

@[simp] theorem intervalCutoff_apply_outside {a b x : ℝ} {f : ℝ → ℂ}
    (hx : x ∉ Set.Ioc a b) :
    intervalCutoff a b f x = 0 := by
  simp [intervalCutoff, hx]

/-- The Riemann-Lebesgue lemma applied to the compactly supported interval
cutoff of a function. -/
theorem tendsto_zero_fourierIntegral_intervalCutoff_cocompact
    (a b : ℝ) (f : ℝ → ℂ) :
    Tendsto (𝓕 (intervalCutoff a b f)) (cocompact ℝ) (𝓝 0) :=
  Real.zero_at_infty_fourierIntegral (intervalCutoff a b f)

/-- The textbook interval Fourier coefficient is the scaled Fourier integral of
the cutoff function, evaluated at the discrete frequency `n / (b - a)`. -/
theorem fourierCoeffOn_eq_inv_length_smul_fourierIntegral_intervalCutoff
    {a b : ℝ} (hab : a < b) (f : ℝ → ℂ) (n : ℤ) :
    AddCircle.fourierCoeffOn hab f n =
      ((b - a : ℝ)⁻¹ : ℂ) • 𝓕 (intervalCutoff a b f) ((n : ℝ) / (b - a)) := by
  rw [AddCircle.fourierCoeffOn_eq_integral (a := a) (b := b) (f := f) (n := n) hab]
  have hsupport :
      Function.support
        (fun x : ℝ =>
          Complex.exp (↑(-2 * π * x * ((n : ℝ) / (b - a))) * Complex.I) *
            intervalCutoff a b f x) ⊆ Set.Ioc a b := by
    intro x hx
    by_contra hxa
    have hzero : intervalCutoff a b f x = 0 := by
      simp [intervalCutoff, hxa]
    simp [hzero] at hx
  calc
    ((b - a : ℝ)⁻¹ : ℂ) • ∫ x in a..b, AddCircle.fourier (-n) (x : AddCircle (b - a)) • f x
      = ((b - a : ℝ)⁻¹ : ℂ) •
          ∫ x in a..b,
            Complex.exp (↑(-2 * π * x * ((n : ℝ) / (b - a))) * Complex.I) •
              intervalCutoff a b f x := by
        congr 1
        refine intervalIntegral.integral_congr_ae' ?_ ?_
        · filter_upwards with x hx
          simp [intervalCutoff, hx, AddCircle.fourier_coe_apply]
          congr 1
          ring
        · filter_upwards with x hx
          exfalso
          simpa [hab.not_le] using hx
    _ = ((b - a : ℝ)⁻¹ : ℂ) •
          ∫ x : ℝ,
            Complex.exp (↑(-2 * π * x * ((n : ℝ) / (b - a))) * Complex.I) •
              intervalCutoff a b f x := by
        congr 1
        symm
        exact intervalIntegral.integral_eq_integral_of_support_subset hsupport
    _ = ((b - a : ℝ)⁻¹ : ℂ) • 𝓕 (intervalCutoff a b f) ((n : ℝ) / (b - a)) := by
        rw [Real.fourierIntegral_real_eq_integral_exp_smul]

/-- The scaled Fourier-integral bridge used to encode interval coefficients
tends to `0` at infinity. -/
theorem tendsto_zero_inv_length_smul_fourierIntegral_intervalCutoff_cocompact
    {a b : ℝ} (f : ℝ → ℂ) :
    Tendsto
      (fun ξ : ℝ => ((b - a : ℝ)⁻¹ : ℂ) • 𝓕 (intervalCutoff a b f) ξ)
      (cocompact ℝ) (𝓝 0) := by
  simpa using
    (tendsto_zero_fourierIntegral_intervalCutoff_cocompact a b f).const_smul
      (((b - a : ℝ)⁻¹ : ℂ))

end Fourier
end Analysis
end MathlibExpansion
