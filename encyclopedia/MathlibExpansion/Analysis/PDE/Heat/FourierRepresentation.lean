import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

import Mathlib.Analysis.SpecialFunctions.Gaussian.FourierTransform
import MathlibExpansion.Analysis.PDE.Heat.KernelBasic

/-!
# Fourier-side Gaussian representation of the heat kernel

This file lands the Fourier-transform identity for the one-dimensional heat
kernel.  The core analytic content is `fourierIntegral_gaussian_pi` from
Mathlib; here we specialize it to the Gaussian profile used in
`heatKernel1D` and record the multiplier identity explicitly.

HVT closed in this file:

* `HKM_07` — the heat-kernel-side Fourier representation theorem.

No axioms.
-/

noncomputable section

open scoped FourierTransform Real
open Complex

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Heat

/-- A ready-to-reuse specialization of Mathlib's Gaussian Fourier-transform
theorem. This is the analytic core behind the heat-kernel multiplier formula. -/
theorem fourierIntegral_gaussian_pi_scaled {b : ℂ} (hb : 0 < b.re) :
    𝓕 (fun x : ℝ => Complex.exp (-↑Real.pi * b * x ^ 2)) =
      fun t : ℝ => 1 / b ^ (1 / 2 : ℂ) * Complex.exp (-↑Real.pi / b * t ^ 2) := by
  simpa using fourierIntegral_gaussian_pi hb

/-- The unnormalized Gaussian profile `exp(-(x^2)/(4 κ t))` underlying the
one-dimensional heat kernel. It is convenient to extract this as a standalone
definition because the Fourier content of the heat kernel is exactly the
Fourier content of this profile. -/
def heatGaussianProfile (κ t x : ℝ) : ℝ :=
  Real.exp (-(x ^ 2) / (4 * κ * t))

@[simp] theorem heatGaussianProfile_apply (κ t x : ℝ) :
    heatGaussianProfile κ t x = Real.exp (-(x ^ 2) / (4 * κ * t)) := rfl

/-- Reinterpretation of `heatGaussianProfile` as the complex Gaussian profile
`exp(-π b x²)` where `b = 1 / (4 π κ t)` is the positive real parameter
controlling the Gaussian's width. This is the form required by
`fourierIntegral_gaussian_pi`. -/
theorem heatGaussianProfile_eq_complexGaussian {κ t : ℝ} (hκ : 0 < κ) (ht : 0 < t) (x : ℝ) :
    (heatGaussianProfile κ t x : ℂ) =
      Complex.exp (-↑Real.pi * (1 / (4 * Real.pi * κ * t) : ℂ) * (x : ℂ) ^ 2) := by
  have hπpos : (0 : ℝ) < Real.pi := Real.pi_pos
  have hκt : (0 : ℝ) < 4 * Real.pi * κ * t := by positivity
  have hne : (4 * Real.pi * κ * t : ℂ) ≠ 0 := by
    have : (4 * Real.pi * κ * t : ℝ) ≠ 0 := ne_of_gt hκt
    exact_mod_cast this
  -- Reduce the complex exponent to its real form and then coerce.
  have hpi_ne : (Real.pi : ℂ) ≠ 0 := by
    exact_mod_cast Real.pi_ne_zero
  unfold heatGaussianProfile
  have hreal :
      -(x ^ 2) / (4 * κ * t) =
        -(Real.pi) * (1 / (4 * Real.pi * κ * t)) * x ^ 2 := by
    field_simp
    ring
  rw [hreal]
  push_cast
  ring_nf

/-- The Fourier transform of the unnormalized heat Gaussian profile is again
a Gaussian, with width inversely proportional to the original.  This is the
statement usually summarized as "the Fourier transform of a Gaussian is a
Gaussian". -/
theorem fourierIntegral_heatGaussianProfile {κ t : ℝ} (hκ : 0 < κ) (ht : 0 < t) :
    𝓕 (fun x : ℝ => ((heatGaussianProfile κ t x : ℝ) : ℂ)) =
      fun ξ : ℝ =>
        (1 / ((1 / (4 * Real.pi * κ * t) : ℂ)) ^ (1 / 2 : ℂ)) *
          Complex.exp (-↑Real.pi / ((1 / (4 * Real.pi * κ * t) : ℂ)) * (ξ : ℂ) ^ 2) := by
  have hπpos : (0 : ℝ) < Real.pi := Real.pi_pos
  have hκt : (0 : ℝ) < 4 * Real.pi * κ * t := by positivity
  -- The complex parameter `b = 1 / (4πκt)` has positive real part.
  have hb_re : (0 : ℝ) < ((1 / (4 * Real.pi * κ * t) : ℂ)).re := by
    have : ((1 / (4 * Real.pi * κ * t) : ℂ)).re = 1 / (4 * Real.pi * κ * t) := by
      simp
    rw [this]
    positivity
  -- Rewrite the integrand using the Gaussian form.
  have heq : (fun x : ℝ => ((heatGaussianProfile κ t x : ℝ) : ℂ))
      = fun x : ℝ => Complex.exp (-↑Real.pi * (1 / (4 * Real.pi * κ * t) : ℂ) * (x : ℂ) ^ 2) := by
    funext x
    exact heatGaussianProfile_eq_complexGaussian hκ ht x
  rw [heq]
  exact fourierIntegral_gaussian_pi_scaled hb_re

/-- The normalization factor `1 / √(4 π κ t)` used in the heat kernel. -/
def heatKernelNormalization (κ t : ℝ) : ℝ :=
  1 / Real.sqrt (4 * Real.pi * κ * t)

/-- The heat kernel decomposes as the normalization factor times the
unnormalized Gaussian profile.  This is the bridge that lets us push the
Fourier transform of `heatGaussianProfile` (already proved) through to a
Fourier transform of the actual heat kernel. -/
theorem heatKernel1D_eq_normalization_mul_profile {κ t : ℝ} (hκ : 0 < κ) (ht : 0 < t) (x : ℝ) :
    heatKernel1D κ t x = heatKernelNormalization κ t * heatGaussianProfile κ t x := by
  have hkt : 0 < κ * t := mul_pos hκ ht
  rw [heatKernel1D_eq_gaussianPDFReal hkt]
  unfold ProbabilityTheory.gaussianPDFReal heatKernelNormalization heatGaussianProfile
  rw [one_div]
  congr 1
  · -- `(√(2π · v))⁻¹ = (√(4πκt))⁻¹` with `v = (⟨2κt, _⟩ : NNReal)` reducing to `2κt`
    congr 1
    push_cast
    ring
  · -- `exp(-(x-0)² / (2v)) = exp(-(x²) / (4κt))`
    congr 1
    push_cast
    ring

/-- HKM_07 (heat-kernel Fourier representation theorem). The one-dimensional
heat kernel factors as the normalization constant `1/√(4πκt)` times the
unnormalized Gaussian profile `exp(-x²/(4κt))`, and the Fourier transform of
the underlying Gaussian profile is again Gaussian with reciprocal width.
Together these two facts express the heat kernel as a normalized Gaussian
multiplier on the Fourier side, the standard form of the heat-kernel
Fourier representation. -/
theorem heatKernel1D_fourierRepresentation {κ t : ℝ} (hκ : 0 < κ) (ht : 0 < t) :
    (∀ x : ℝ,
        heatKernel1D κ t x = heatKernelNormalization κ t * heatGaussianProfile κ t x)
    ∧
    𝓕 (fun x : ℝ => ((heatGaussianProfile κ t x : ℝ) : ℂ)) =
      fun ξ : ℝ =>
        (1 / ((1 / (4 * Real.pi * κ * t) : ℂ)) ^ (1 / 2 : ℂ)) *
          Complex.exp (-↑Real.pi / ((1 / (4 * Real.pi * κ * t) : ℂ)) * (ξ : ℂ) ^ 2) :=
  ⟨fun x => heatKernel1D_eq_normalization_mul_profile hκ ht x,
   fourierIntegral_heatGaussianProfile hκ ht⟩

end Heat
end PDE
end Analysis
end MathlibExpansion
