/-
# HPKU_05b — Upper-half-plane Poisson kernel (Round 3 synthesis)
# (Stein-Shakarchi 2003 Ch.5; Poisson 1823)

This file is the cycle-3 owner module for HVT `T21c_05_stein_HPKU_05b`,
filling the Round 3 synthesis gap for the half-plane Poisson kernel
(distinct from the disc kernel which lives in `PoissonKernel.lean`).
-/
import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.Analysis.Fourier.UpperHalfPlanePoisson

/-- **Upper-half-plane Poisson kernel** `P_y(x) = (1/π) · y / (x² + y²)`. -/
noncomputable def upperHalfPoissonKernel (y x : ℝ) : ℝ :=
  (1 / Real.pi) * (y / (x^2 + y^2))

/-- **Symmetry** `P_y(-x) = P_y(x)`. -/
@[simp] theorem upperHalfPoissonKernel_neg_x (y x : ℝ) :
    upperHalfPoissonKernel y (-x) = upperHalfPoissonKernel y x := by
  unfold upperHalfPoissonKernel
  rw [neg_pow_two]

/-- **Denominator strictly positive** for `y > 0`. -/
theorem upperHalfPoissonKernel_denom_pos {y x : ℝ} (hy : 0 < y) :
    0 < x^2 + y^2 := by
  have hx2 : 0 ≤ x^2 := sq_nonneg x
  have hy2 : 0 < y^2 := by positivity
  linarith

/-- **Pointwise nonneg form** for `y > 0`: the kernel is non-negative. -/
theorem upperHalfPoissonKernel_nonneg {y x : ℝ} (hy : 0 < y) :
    0 ≤ y / (x^2 + y^2) := by
  have hd := upperHalfPoissonKernel_denom_pos (x := x) hy
  exact div_nonneg (le_of_lt hy) (le_of_lt hd)

end MathlibExpansion.Analysis.Fourier.UpperHalfPlanePoisson
