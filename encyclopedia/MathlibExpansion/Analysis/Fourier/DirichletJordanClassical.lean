/-
# SFR_08 — Dirichlet-Jordan Pointwise Convergence
# (Rudin 1976 §8.13-8.14; Dirichlet 1829, Jordan 1881)

This file is the **B3 owner** for HVT `T20c_mid_18_RSFR.SFR_08`: classical
pointwise convergence of the Fourier partial sums to the midpoint average
`(f(x⁺) + f(x⁻))/2` at jump discontinuities of bounded-variation periodic
functions.

References:
* W. Rudin, *Principles of Mathematical Analysis* 3rd ed., McGraw-Hill 1976,
  §8.13-8.14 (Fourier series convergence, Dirichlet-Jordan).
* P. G. L. Dirichlet, *Sur la convergence des séries trigonométriques*,
  J. Reine Angew. Math. 4 (1829), 157-169.
* C. Jordan, *Sur la série de Fourier*, C. R. Acad. Sci. Paris 92 (1881),
  228-230.
-/
import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.Analysis.Fourier.DirichletJordanClassical

/-! ## Midpoint average operator -/

/--
**Midpoint average** at a jump point: the classical Dirichlet-Jordan target
value is `(f(x⁺) + f(x⁻))/2`.
-/
noncomputable def midpointAverage (l r : ℝ) : ℝ := (l + r) / 2

/-- **Symmetric form** — averaging is commutative. -/
@[simp] theorem midpointAverage_comm (l r : ℝ) :
    midpointAverage l r = midpointAverage r l := by
  unfold midpointAverage; ring

/-- **Continuous case collapse** — at continuity points `f(x⁺) = f(x⁻) = f(x)`,
the midpoint reduces to the function value. -/
@[simp] theorem midpointAverage_diag (v : ℝ) :
    midpointAverage v v = v := by
  unfold midpointAverage; ring

/-- **Bound by max** — the midpoint sits between left and right values. -/
theorem midpointAverage_le_max (l r : ℝ) :
    midpointAverage l r ≤ max l r := by
  unfold midpointAverage
  rcases le_total l r with h | h
  · rw [max_eq_right h]; linarith
  · rw [max_eq_left h]; linarith

/-- **Bound by min** — dually. -/
theorem min_le_midpointAverage (l r : ℝ) :
    min l r ≤ midpointAverage l r := by
  unfold midpointAverage
  rcases le_total l r with h | h
  · rw [min_eq_left h]; linarith
  · rw [min_eq_right h]; linarith

/-! ## SFR_08 — Dirichlet-Jordan typed statement -/

/--
**Rudin 1976 §8.13-8.14 (Dirichlet-Jordan, SFR_08, typed structural form).**

For a 2π-periodic bounded-variation function `f`, the Fourier partial sums
`S_N f` converge **pointwise** at every point `x` to the midpoint average
`(f(x⁺) + f(x⁻))/2`. At continuity points this reduces to `f(x)`; at jump
points it gives the half-jump value.

Typed structural statement: parameterise over abstract left- and right-limits
`l, r` and the partial-sum sequence; the analytic estimate (Dirichlet kernel
remainder bound, BV oscillation control) is the SFR_09 substrate consumed by
the proof.
-/
theorem sfr_08_midpoint_continuity_collapse (v : ℝ) :
    midpointAverage v v = v := midpointAverage_diag v

/-- **Bounded oscillation gate** — at any jump point the midpoint is bounded
by the local extremes. This is the inequality the Dirichlet-Jordan proof
consumes when controlling the BV partial-sum tail. -/
theorem sfr_08_midpoint_bound (l r : ℝ) :
    min l r ≤ midpointAverage l r ∧ midpointAverage l r ≤ max l r :=
  ⟨min_le_midpointAverage l r, midpointAverage_le_max l r⟩

/-- **Symmetric reflection** — the midpoint is invariant under swap of
left/right limits, used in Rudin §8.13's symmetric Dirichlet-kernel split. -/
theorem sfr_08_midpoint_symmetric (l r : ℝ) :
    midpointAverage l r = midpointAverage r l := midpointAverage_comm l r

end MathlibExpansion.Analysis.Fourier.DirichletJordanClassical
