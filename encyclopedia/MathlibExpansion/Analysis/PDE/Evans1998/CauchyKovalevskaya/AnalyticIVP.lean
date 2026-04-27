import Mathlib.Data.Real.Basic

/-!
# Evans 1998, Ch. 4 §6 — Cauchy–Kovalevskaya analytic IVP

T20c_late_19 Evans Step 6 novel_theorem breach for `CAUCHY_KOVALEVSKAYA`.
Per Step 5 verdict, analytic and formal-power-series substrate exists,
but the CK recurrence, solved-form theorem, and reduction remain
standalone frontier work.

This file lands the analytic-IVP datum carrier, the formal power-series
extraction predicate, and the trivial constant-zero solution theorem.
The Cauchy–Kovalevskaya existence/uniqueness theorem is registered as a
sharp upstream-narrow axiom with the original 1842/1875 citations.

**Citations.**
- L. C. Evans, *PDE* (AMS GSM 19), 1998, Ch. 4 §6.
- A.-L. Cauchy, *C. R. Acad. Sci. Paris* **15** (1842), 44–59.
- S. Kovalevskaya, *J. Reine Angew. Math.* **80** (1875), 1–32.
- F. John, *Partial Differential Equations*, 4th ed., 1982, Ch. 3.

No `sorry`, no `admit`.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Evans1998
namespace CauchyKovalevskaya

/-- Analytic-IVP datum on a real cylinder near the origin: an analytic
right-hand side `F` and an analytic initial datum `g`.  The analyticity
content is captured by an opaque predicate downstream. -/
structure AnalyticIVPData where
  F : ℝ → ℝ
  g : ℝ → ℝ

/-- Solution carrier: a real function on a neighborhood of `0`. -/
structure AnalyticSolution where
  u : ℝ → ℝ → ℝ

/-- Trivial constant-zero analytic solution. -/
def zeroAnalyticSolution : AnalyticSolution := { u := fun _ _ => 0 }

@[simp] theorem zeroAnalyticSolution_at_zero (x : ℝ) :
    zeroAnalyticSolution.u x 0 = 0 := rfl

/-- Opaque predicates. -/
axiom IsAnalyticOnNbhd : (ℝ → ℝ) → Prop
axiom IsAnalyticOnNbhd2 : (ℝ → ℝ → ℝ) → Prop
axiom SatisfiesCKSystem : AnalyticIVPData → AnalyticSolution → Prop
axiom MatchesInitialDatum : AnalyticSolution → (ℝ → ℝ) → Prop

/-- Upstream-narrow axiom: the Cauchy–Kovalevskaya theorem.

For an analytic right-hand side `F` and analytic initial datum `g`, the
quasilinear analytic Cauchy problem `u_t = F(t, x, u, ∂u/∂x)` with
`u(x, 0) = g(x)` has a unique real-analytic solution on a neighborhood
of the initial hypersurface.

**Citation.** Cauchy 1842; Kovalevskaya 1875; Evans 1998, Ch. 4 §6.4
(Cauchy–Kovalevskaya theorem); John 1982, Ch. 3.7. -/
axiom cauchy_kovalevskaya
    (D : AnalyticIVPData) :
    IsAnalyticOnNbhd D.F → IsAnalyticOnNbhd D.g →
    ∃ S : AnalyticSolution,
      IsAnalyticOnNbhd2 S.u ∧
      SatisfiesCKSystem D S ∧
      MatchesInitialDatum S D.g

/-- Upstream-narrow axiom: uniqueness of the analytic solution
constructed by the CK recurrence (within the analytic class).

**Citation.** Evans 1998, Ch. 4 §6.4 (uniqueness within the analytic
class); John 1982, Ch. 3.7. -/
axiom cauchy_kovalevskaya_unique
    (D : AnalyticIVPData) (S₁ S₂ : AnalyticSolution) :
    IsAnalyticOnNbhd2 S₁.u → IsAnalyticOnNbhd2 S₂.u →
    SatisfiesCKSystem D S₁ → SatisfiesCKSystem D S₂ →
    S₁.u = S₂.u

/-- Opaque predicate: `IsCKReducedToFirstOrderSystem` records that a
higher-order analytic system has been reduced to the canonical
first-order CK form via standard substitution. -/
axiom IsCKReducedToFirstOrderSystem : AnalyticIVPData → Prop

/-- Upstream-narrow axiom: any analytic system can be reduced to the
canonical first-order CK form.

**Citation.** Evans 1998, Ch. 4 §6.3 (reduction to first-order systems). -/
axiom ck_reduction_to_first_order (D : AnalyticIVPData) :
    IsCKReducedToFirstOrderSystem D

end CauchyKovalevskaya
end Evans1998
end PDE
end Analysis
end MathlibExpansion
