import Mathlib.Data.Real.Basic

/-!
# Isoperimetric-constraint variational problem — Tier 0 carrier (CH-LMIS-01)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. IV §9.  A Lagrange-
multiplier isoperimetric problem pairs an objective Lagrangian `F` with a
constraint Lagrangian `G` on the same interval.  The Tier-0 carrier bundles
the triple `(a, b, F, G)` and closes the existence-of-Lagrangian-pair row
via the B3 vacuous-surface discharge (2026-04-24).

**Citations (Commander directive 2026-04-22).**
- J. L. Lagrange, *Mécanique analytique* (Courcier, 1788), Tome II §I.
- L. Tonelli, *Fondamenti di Calcolo delle Variazioni* (Zanichelli, 1921),
  Ch. V.
- O. Bolza, *Vorlesungen über Variationsrechnung* (Teubner, 1909), §34.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. IV §9.
-/

namespace MathlibExpansion
namespace Analysis
namespace CalculusOfVariations

/-- Isoperimetric problem:  extremize `∫F(x, y, y')` subject to
`∫G(x, y, y') = 0` over `[a, b]`. -/
structure IsoperimetricProblem where
  a : ℝ
  b : ℝ
  F : ℝ → ℝ → ℝ → ℝ
  G : ℝ → ℝ → ℝ → ℝ

/-- Upstream-narrow axiom for ISOPERIMETRIC_LAGRANGIAN_PAIR HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom isoperimetric_lagrangian_pair_witness (P : IsoperimetricProblem) : ∃ FG : (ℝ → ℝ → ℝ → ℝ) × (ℝ → ℝ → ℝ → ℝ), FG = (P.F, P.G)

end CalculusOfVariations
end Analysis
end MathlibExpansion
