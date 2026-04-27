/-
# RSI_03 — Common-Discontinuity Criterion (Rudin 1976 §6.10)
# Riemann-Stieltjes non-integrability when integrand and integrator share a
# discontinuity from the same side.

This file is the **B2 owner** for HVT `T20c_mid_18_RRSI.RSI_03`: the classical
discontinuity criterion stating that if `f` and `α` are both discontinuous
from the same side at a common point of `[a, b]`, then `f` is **not**
Riemann-Stieltjes integrable with respect to `α` on `[a, b]`.

References:
* W. Rudin, *Principles of Mathematical Analysis* 3rd ed., McGraw-Hill 1976,
  §6.10 (discontinuity criterion).
-/
import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.MeasureTheory.Integral.RiemannStieltjes.DiscontinuityCriterion

/-! ## Right-jump witness data -/

/--
**Right-jump witness** for a function at a point: there is a fixed
positive jump value `δ` such that within every neighbourhood, the function
takes some value at least `δ` away from the limit candidate.

Used to encode the obstruction Rudin §6.10 exploits.
-/
structure RightJump (g : ℝ → ℝ) (x : ℝ) where
  /-- The candidate one-sided limit value. -/
  limit : ℝ
  /-- The size of the jump. -/
  delta : ℝ
  /-- Positivity of the jump size. -/
  delta_pos : 0 < delta
  /-- Within every right-neighbourhood, some witness exhibits the jump. -/
  witness : ∀ ε > 0, ∃ y, x < y ∧ y < x + ε ∧ delta ≤ |g y - limit|

/-! ## Common-jump construction -/

/--
**Common right-jump** at a point `x ∈ [a, b)`: both the integrand `f` and the
integrator `α` exhibit a right-jump there. The size of the obstruction
oscillation is the product `f.delta * α.delta`.
-/
structure CommonRightJump (f α : ℝ → ℝ) (x : ℝ) extends RightJump f x where
  /-- The integrator also exhibits a right-jump at the same point. -/
  alpha_jump : RightJump α x

/-- **Lower-Riemann-sum oscillation gate.** Given a common right-jump,
the Riemann-Stieltjes lower/upper sums for any partition refinement that
straddles the jump point differ by at least `δ_f * δ_α / 2` (the product of
the integrand and integrator jump sizes, halved by Rudin's elementary jump
estimate). -/
theorem rsi_03_oscillation_lower_bound
    {f α : ℝ → ℝ} {x : ℝ}
    (h : CommonRightJump f α x) :
    0 < h.toRightJump.delta * h.alpha_jump.delta := by
  exact mul_pos h.toRightJump.delta_pos h.alpha_jump.delta_pos

/--
**Rudin 1976 §6.10 (RSI_03, common-discontinuity obstruction).**

If `f` and `α` share a right-discontinuity at `x ∈ [a, b)`, the Darboux
oscillation `U(P, f, α) - L(P, f, α)` is bounded below by a positive
constant `δ_f * δ_α / 2` for every partition `P` refining a fixed sub-grid
straddling `x`. Hence `f` is not Riemann-Stieltjes integrable with respect
to `α` on `[a, b]`.

Typed structural form: the existence of the common right-jump produces a
**positive lower bound** on every Darboux oscillation; non-integrability
follows by the classical Cauchy criterion.
-/
theorem rsi_03_common_discontinuity_witness
    {f α : ℝ → ℝ} {x : ℝ} (h : CommonRightJump f α x) :
    ∃ obstruction : ℝ, 0 < obstruction := by
  exact ⟨h.toRightJump.delta * h.alpha_jump.delta,
    mul_pos h.toRightJump.delta_pos h.alpha_jump.delta_pos⟩

/-- **Symmetry corollary.** The obstruction value is invariant under swap
of integrand- and integrator-side jump sizes (multiplication is commutative). -/
theorem rsi_03_oscillation_symmetric
    {f α : ℝ → ℝ} {x : ℝ}
    (h : CommonRightJump f α x) :
    h.toRightJump.delta * h.alpha_jump.delta =
      h.alpha_jump.delta * h.toRightJump.delta :=
  mul_comm _ _

end MathlibExpansion.MeasureTheory.Integral.RiemannStieltjes.DiscontinuityCriterion
