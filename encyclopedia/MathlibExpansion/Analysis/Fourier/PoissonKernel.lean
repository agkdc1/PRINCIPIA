/-
# GKFPAS_05 / HPKU_05 — Poisson kernel on the unit disc
# (Stein-Shakarchi 2003 Ch.2-3; Poisson 1823)
-/
import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.Analysis.Fourier.PoissonKernel

/-- **Poisson kernel** on the unit disc: `P_r(θ) = (1 - r²) / (1 - 2r·cosθ + r²)`. -/
noncomputable def poissonKernel (r θ : ℝ) : ℝ :=
  (1 - r^2) / (1 - 2*r*Real.cos θ + r^2)

/-- At `r = 0` the kernel collapses to `1`. -/
@[simp] theorem poissonKernel_at_zero (θ : ℝ) :
    poissonKernel 0 θ = 1 := by
  unfold poissonKernel; simp

/-- **Symmetry** under θ ↦ -θ (cos is even). -/
@[simp] theorem poissonKernel_neg_theta (r θ : ℝ) :
    poissonKernel r (-θ) = poissonKernel r θ := by
  unfold poissonKernel; rw [Real.cos_neg]

/-- **Numerator nonneg for** `|r| ≤ 1`. -/
theorem poisson_numerator_nonneg {r : ℝ} (h : r^2 ≤ 1) : 0 ≤ 1 - r^2 := by linarith

end MathlibExpansion.Analysis.Fourier.PoissonKernel
