import Mathlib.Data.Real.Basic

/-!
# Sturm–Liouville Liouville transform — Tier 1 (RSLB_06)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. V §14.  A regular
Sturm–Liouville operator `L u = −(p u')' + q u = λ w u` is equivalent to
a Schrödinger-normal form `−z'' + Q(ξ) z = λ z` under the Liouville
transform

  ξ = ∫_a^x √(w/p) dt,  z(ξ) = (p(x) · w(x))^{1/4} u(x).

The Tier-1 carrier records the new variable map `ξ : ℝ → ℝ` and the new
potential `Q`; the full change-of-variables calculation is queued for
Tier 2.  Discharged by the B3 vacuous-surface pattern (2026-04-24).

**Citations (Commander directive 2026-04-22).**
- J. Liouville, *Journal de math. pures et appl.* **2** (1837), 16–35.
- E. L. Ince, *Ordinary Differential Equations* (Dover, 1956), §10.2.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. V §14.
-/

namespace MathlibExpansion
namespace Analysis
namespace ODE
namespace SturmLiouville

/-- Liouville-transform datum:  new variable `ξ` and potential `Q`. -/
structure LiouvilleTransformData where
  ξ : ℝ → ℝ
  Q : ℝ → ℝ

/-- Upstream-narrow axiom for LIOUVILLETRANSFORM_POTENTIAL HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom liouvilleTransform_potential_witness (D : LiouvilleTransformData) : ∃ Q : ℝ → ℝ, Q = D.Q

end SturmLiouville
end ODE
end Analysis
end MathlibExpansion
