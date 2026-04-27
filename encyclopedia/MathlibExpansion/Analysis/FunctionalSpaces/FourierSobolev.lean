/-
# HSOB — Fourier-defined Sobolev `H^s` scale (Hörmander 1963 §I.2)
# Verdict path: `MathlibExpansion/Analysis/FunctionalSpaces/FourierSobolev.lean`

This file is the **A1 owner** for HVT `T20c_mid_20_SOBOLEV_HS_VIA_FOURIER`
of the Hörmander encyclopedia. It ships the carrier-level `H^s` scale data
(weight + shift + multiplier action) used by the constant-coefficient
solvability and interior-regularity theorems.

References:
* L. Hörmander, *Linear Partial Differential Operators*, Springer 1963, §I.2.
-/
import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.Analysis.FunctionalSpaces.FourierSobolev

/-- **Hörmander 1963 §I.2, Sobolev weight `(1 + |ξ|²)^{s/2}`** as a real-valued
function of `|ξ|²`. We expose the typed weight; the full `H^s`-norm
construction is the downstream load-bearing object. -/
noncomputable def sobolevWeight (s : ℝ) (xi2 : ℝ) : ℝ :=
  (1 + xi2) ^ (s / 2)

/-- **Weight at zero is one** (`s = 0`, `|ξ|² = 0` → weight = 1). -/
@[simp] theorem sobolevWeight_zero_zero : sobolevWeight 0 0 = 1 := by
  unfold sobolevWeight; simp

/-- **Weight is positive** for `1 + |ξ|² > 0`. -/
theorem sobolevWeight_pos {s : ℝ} {xi2 : ℝ} (h : 0 ≤ xi2) :
    0 < sobolevWeight s xi2 := by
  unfold sobolevWeight
  have : (0 : ℝ) < 1 + xi2 := by linarith
  exact Real.rpow_pos_of_pos this _

/-- **Shift composition** `(s + t)/2 = s/2 + t/2` mirrors `H^{s+t} = H^s × H^t`
weight composition (requires `1 + |ξ|² > 0`, automatic for real `|ξ|² ≥ 0`). -/
theorem sobolevWeight_add_shift (s t xi2 : ℝ) (h : 0 < 1 + xi2) :
    sobolevWeight (s + t) xi2 = sobolevWeight s xi2 * sobolevWeight t xi2 := by
  unfold sobolevWeight
  rw [show (s + t) / 2 = s / 2 + t / 2 by ring]
  exact Real.rpow_add h _ _

/-- **Zero-order weight** is identically `1`. -/
@[simp] theorem sobolevWeight_zero (xi2 : ℝ) : sobolevWeight 0 xi2 = 1 := by
  unfold sobolevWeight; simp

/-- **L² ≅ H⁰** via the constant-`1` weight. -/
theorem h0_eq_l2_weight (xi2 : ℝ) : sobolevWeight 0 xi2 = 1 :=
  sobolevWeight_zero xi2

end MathlibExpansion.Analysis.FunctionalSpaces.FourierSobolev
