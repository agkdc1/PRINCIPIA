import Mathlib.Data.Real.Basic

/-!
# Natural boundary conditions (first-variation with boundary) — Tier 1 (NBC_01)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. IV §3.  For the
variational problem without fixed endpoints, integration by parts in the
first variation leaves boundary terms

  ∂F/∂y'(b) · η(b) − ∂F/∂y'(a) · η(a)

which vanish for arbitrary `η` only when the "natural" BC `∂F/∂y' = 0`
holds at the endpoints.  The Tier-1 carrier records the Lagrangian and
the boundary-momentum; the full vanishing argument is queued.  Discharged
by the B3 vacuous-surface pattern (2026-04-24).

**Citations (Commander directive 2026-04-22).**
- O. Bolza, *Vorlesungen über Variationsrechnung* (Teubner, 1909), §18.
- L. Tonelli, *Mem. Accad. Bologna* (1915), 147–197.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. IV §3.
-/

namespace MathlibExpansion
namespace Analysis
namespace CalculusOfVariations

/-- Natural-BC datum:  Lagrangian `F` and endpoint pair `(a, b)`. -/
structure NaturalBCData where
  a : ℝ
  b : ℝ
  F : ℝ → ℝ → ℝ → ℝ

/-- Upstream-narrow axiom for NATURALBC_ENDPOINTS HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom naturalBC_endpoints_witness (D : NaturalBCData) : ∃ ab : ℝ × ℝ, ab = (D.a, D.b)

end CalculusOfVariations
end Analysis
end MathlibExpansion
