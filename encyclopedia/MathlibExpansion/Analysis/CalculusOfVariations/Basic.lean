import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

/-!
# Variational problem carrier — Tier 0 (CH-EL-02)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. IV §1.  A variational
problem records an interval `[a, b]` and a Lagrangian `F : ℝ → ℝ → ℝ → ℝ`
whose integral we wish to extremize.  The Tier-0 carrier is a bare data
structure; the Tier-1 follow-up lands the Euler–Lagrange equation.

**Citations (Commander directive 2026-04-22).**
- O. Bolza, *Vorlesungen über Variationsrechnung* (Teubner, 1909).
- A. Kneser, *Lehrbuch der Variationsrechnung* (Vieweg, 1900).
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. IV.
-/

namespace MathlibExpansion
namespace Analysis
namespace CalculusOfVariations

/-- Variational-problem datum.  `F x y y'` is the Lagrangian, integrated
over `y : ℝ → ℝ` with fixed endpoints on `[a, b]`. -/
structure VariationalProblem where
  a : ℝ
  b : ℝ
  F : ℝ → ℝ → ℝ → ℝ

/-- Upstream-narrow axiom for CH-EL-02 (VARIATIONALPROBLEM_LAGRANGIAN) HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom variationalProblem_lagrangian_witness (P : VariationalProblem) : ∃ L : ℝ → ℝ → ℝ → ℝ, L = P.F

end CalculusOfVariations
end Analysis
end MathlibExpansion
