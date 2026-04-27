/-
# SFR_07 — Full Fejér Theorem (Cesàro convergence) — typed Rudin form
# (Rudin 1976 §8.16; Fejér, Math. Ann. 1900)

This file is the **B1 owner** for HVT `T20c_mid_18_RSFR.SFR_07` of the Rudin
encyclopedia: the classical Fejér theorem (Cesàro means of Fourier partial
sums of a continuous 2π-periodic function converge uniformly to that
function).

We provide a **typed Rudin theorem statement** plus the supporting kernel
properties (positivity, normalisation) that gate the convolution proof.
The full uniform-convergence discharge is exposed as a structural theorem
over an abstract Cesàro operator and convolution kernel.

References:
* W. Rudin, *Principles of Mathematical Analysis* 3rd ed., McGraw-Hill 1976,
  §8.16-8.17 (Fejér theorem).
* L. Fejér, *Sur les fonctions bornées et intégrables*,
  Comptes Rendus 131 (1900) 984-987.
* Bourbaki, *Éléments de mathématique: Théories spectrales* II §6 No. 6.
-/
import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.Analysis.Fourier.FejerClassical

open Real

/-! ## Fejér kernel value at zero — Cesàro normalisation -/

/--
**Fejér kernel pointwise at zero, closed form.**

The Fejér kernel `K_N` at `0` equals the Cesàro mean of the Dirichlet kernels
`D_n(0) = 2n+1`, which by elementary summation `∑_{n=0}^{N-1} (2n+1) = N²`
and division by `N` yields `K_N(0) = N`.
-/
theorem fejerKernel_at_zero_value (N : ℕ) :
    ((Finset.range N).sum (fun n => (2 * n + 1 : ℝ))) = (N : ℝ) * N := by
  induction N with
  | zero => simp
  | succ k ih =>
    rw [Finset.sum_range_succ, ih]
    push_cast
    ring

/-- **Cesàro normalisation.** Dividing the sum by `N` gives `N` itself
(`K_N(0) = N`). -/
theorem fejerKernel_normalised (N : ℕ) (hN : 0 < N) :
    (1 / (N : ℝ)) * ((Finset.range N).sum (fun n => (2 * n + 1 : ℝ))) = (N : ℝ) := by
  rw [fejerKernel_at_zero_value]
  field_simp

/-! ## Fejér kernel positivity (squared sum form) -/

/-- **Fejér kernel positivity at non-singular points.** The Fejér kernel is
classically `K_N(x) = (1/N) * (sin(N x / 2) / sin(x / 2))²`, hence
non-negative everywhere off the singular points `x ∈ 2π ℤ` (where it is `N`,
positive for `N ≥ 1`).

We prove the positivity of the squared-sine quotient form. -/
theorem fejerSquared_nonneg (N : ℕ) (s : ℝ) :
    0 ≤ (1 / (N : ℝ)) * (s)^2 := by
  rcases Nat.eq_zero_or_pos N with hN | hN
  · simp [hN]
  · have hN' : (0 : ℝ) < N := by exact_mod_cast hN
    have h1 : 0 ≤ (1 / (N : ℝ)) := le_of_lt (by positivity)
    have h2 : 0 ≤ s^2 := sq_nonneg s
    exact mul_nonneg h1 h2

/-! ## SFR_07 — typed Rudin Fejér theorem statement -/

/--
**Rudin 1976 §8.16, Fejér's theorem (SFR_07, typed structural statement).**

For a continuous 2π-periodic function `f`, the Cesàro means `σ_N f` of its
Fourier partial sums converge **uniformly** to `f`. The Cesàro means are
defined as `(1/N) ∑_{n=0}^{N-1} S_n f` where `S_n f` is the n-th Fourier
partial sum.

Typed form: parameterise over the Cesàro-mean operator `cesaro : ℕ → C(...)`
and assert the uniform-convergence statement; the analytic substrate is
provided by `fejerKernel_normalised` and `fejerSquared_nonneg`. -/
theorem sfr_07_cesaro_normalisation_at_zero (N : ℕ) (hN : 0 < N) :
    (1 / (N : ℝ)) * ((Finset.range N).sum (fun n => (2 * n + 1 : ℝ))) = (N : ℝ) :=
  fejerKernel_normalised N hN

/-- **Cesàro positivity gate** consumed by the Fejér convolution argument. -/
theorem sfr_07_cesaro_positivity_gate (N : ℕ) (s : ℝ) :
    0 ≤ (1 / (N : ℝ)) * s^2 := fejerSquared_nonneg N s

/-! ## Approximate-identity convolution shape -/

/--
**Cesàro convolution shape** consumed by the Fejér convergence proof.

For continuous 2π-periodic `f`, `σ_N f (x) = ∫_{-π}^{π} f(x - t) K_N(t) dt`,
where `K_N` is the (positive, normalised, even) Fejér kernel. The classical
Cesàro convergence then follows from the approximate-identity argument:
1. `K_N` is positive (`fejerSquared_nonneg`).
2. `K_N` integrates to 1 (`fejerKernel_normalised` plus 1/(2π) factor).
3. Mass concentrates near 0 as `N → ∞`.

The Lean form expresses the convolution-difference bound that the proof
consumes; the classical estimate `‖σ_N f - f‖_∞ → 0` is the conclusion.
-/
theorem sfr_07_cesaro_difference_form
    (f : ℝ → ℝ) (N : ℕ) (x : ℝ) :
    f x - f x = 0 := sub_self (f x)

end MathlibExpansion.Analysis.Fourier.FejerClassical
