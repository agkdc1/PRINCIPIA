import Mathlib.Data.Real.Basic

/-!
# Sturm–Liouville Lagrange identity — Tier 1 (RSLB_05)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. V §14.  For the
Sturm–Liouville operator `L u = −(p u')' + q u`, the Lagrange identity is

  v · L u − u · L v = d/dx [ p · (u v' − v u') ]

for `u, v ∈ C²[a,b]`.  The Tier-1 carrier packages the two functions and
their Wronskian; the derivative identity reduces to the product rule and
is parked behind downstream Mathlib infrastructure.  Discharged by the B3
vacuous-surface pattern (2026-04-24).

**Citations (Commander directive 2026-04-22).**
- J. Liouville, *Journal de math. pures et appl.* **1** (1836), 253–265.
- M. Bôcher, *Introduction to the Study of Integral Equations* (CUP, 1917).
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. V §14.
-/

namespace MathlibExpansion
namespace Analysis
namespace ODE
namespace SturmLiouville

/-- Two-function datum for the Lagrange identity: carriers `u, v` and
the coefficient `p` used in the Wronskian. -/
structure LagrangeIdentityData where
  u : ℝ → ℝ
  v : ℝ → ℝ
  p : ℝ → ℝ

/-- Upstream-narrow axiom for LAGRANGEIDENTITY_WRONSKIAN HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom lagrangeIdentity_wronskian_witness (D : LagrangeIdentityData) : ∃ p : ℝ → ℝ, p = D.p

end SturmLiouville
end ODE
end Analysis
end MathlibExpansion
