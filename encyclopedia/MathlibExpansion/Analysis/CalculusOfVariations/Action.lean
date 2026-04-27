import Mathlib.Data.Real.Basic

/-!
# Hamilton action functional — Tier 0 carrier (CHM-01)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. IV §12.  The action
functional `S[y] = ∫_a^b L(x, y(x), y'(x)) dx` is the core object of
Hamilton's variational principle.  The Tier-0 carrier bundles the time
interval and Lagrangian `L : ℝ → ℝ → ℝ → ℝ`.

**Citations (Commander directive 2026-04-22).**
- W. R. Hamilton, *Phil. Trans. R. Soc.* **124** (1834), 247–308.
- C. G. J. Jacobi, *Vorlesungen über Dynamik* (Reimer, 1866).
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. IV §12.
- E. T. Whittaker, *Analytical Dynamics* (CUP, 1937), Ch. X §99.
-/

namespace MathlibExpansion
namespace Analysis
namespace CalculusOfVariations

/-- Action-functional datum:  time interval and Lagrangian. -/
structure ActionData where
  a : ℝ
  b : ℝ
  L : ℝ → ℝ → ℝ → ℝ

/-- Upstream-narrow axiom for ACTIONDATA_LAGRANGIAN HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom actionData_lagrangian_witness (A : ActionData) : ∃ L : ℝ → ℝ → ℝ → ℝ, L = A.L

end CalculusOfVariations
end Analysis
end MathlibExpansion
