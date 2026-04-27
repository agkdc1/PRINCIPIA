import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

import Mathlib.Analysis.Fourier.AddCircle

/-!
# Fourier interval wrappers on `[-π, π]`

This file packages textbook-facing wrappers around Mathlib's `AddCircle`
Fourier-coefficient API for the standard interval `[-π, π]`.
-/

noncomputable section

open scoped Topology Real
open AddCircle
open Complex MeasureTheory

namespace MathlibExpansion
namespace Analysis
namespace Fourier

local instance : Fact (0 < 2 * Real.pi) := ⟨by positivity⟩

/-- The standard Fourier interval inequality `-π < π`. -/
theorem neg_pi_lt_pi : (-Real.pi : ℝ) < Real.pi := by
  nlinarith [Real.pi_pos]

/-- The `n`-th Fourier coefficient of a function on `[-π, π]`. -/
def fourierCoeffNegPiPi (f : ℝ → ℂ) (n : ℤ) : ℂ :=
  fourierCoeffOn neg_pi_lt_pi f n

/-- Cosine coefficient on `[0, π]` in Fourier's textbook normalization. -/
def cosineCoeff (f : ℝ → ℝ) (n : ℕ) : ℝ :=
  (1 / Real.pi) * ∫ x in (0 : ℝ)..Real.pi, f x * Real.cos (n * x)

/-- Sine coefficient on `[0, π]` in Fourier's textbook normalization. -/
def sineCoeff (f : ℝ → ℝ) (n : ℕ) : ℝ :=
  (1 / Real.pi) * ∫ x in (0 : ℝ)..Real.pi, f x * Real.sin (n * x)

/-- `fourierCoeffNegPiPi` is exactly Mathlib's interval coefficient specialized
to the textbook interval `[-π, π]`. -/
theorem fourierCoeffNegPiPi_eq (f : ℝ → ℂ) (n : ℤ) :
    fourierCoeffNegPiPi f n = fourierCoeffOn neg_pi_lt_pi f n :=
  rfl

/-- Integral formula for the `[-π, π]` coefficient package. -/
theorem fourierCoeffNegPiPi_eq_integral (f : ℝ → ℂ) (n : ℤ) :
    fourierCoeffNegPiPi f n =
      ((1 / (2 * Real.pi : ℝ)) : ℂ) *
        ∫ x in (-Real.pi)..Real.pi,
          fourier (-n) (x : AddCircle (2 * Real.pi)) * f x := by
  simpa [fourierCoeffNegPiPi, neg_pi_lt_pi, sub_eq_add_neg, two_mul, smul_eq_mul] using
    (fourierCoeffOn_eq_integral (a := -Real.pi) (b := Real.pi) f n neg_pi_lt_pi)

/-- Pointwise Fourier-series reconstruction on `[-π, π]` for summable
coefficients, directly specialized from the circle-side theorem in Mathlib. -/
theorem has_pointwise_sum_fourierSeries_neg_pi_pi_of_summable
    (f : C(AddCircle (2 * Real.pi), ℂ))
    (h : Summable (fourierCoeff f))
    (x : ℝ) :
    HasSum
      (fun n : ℤ => fourierCoeff f n * fourier n (x : AddCircle (2 * Real.pi)))
      (f x) := by
  simpa [smul_eq_mul] using
    (has_pointwise_sum_fourier_series_of_summable (f := f) h
      (x := (x : AddCircle (2 * Real.pi))))

end Fourier
end Analysis
end MathlibExpansion
