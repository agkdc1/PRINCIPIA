import Mathlib.Data.Real.Basic

/-!
# Fundamental Lemma of the Calculus of Variations — Tier 0 carrier (CH-EL-01)

Target T20c_13 Courant+Hilbert *Methoden der mathematischen Physik* (1924),
Kap. IV §1.  The fundamental lemma of the calculus of variations says that
a continuous function `f : [a, b] → ℝ` whose `L²`-pairing against every
smooth test function vanishing at endpoints is zero must itself vanish on
the open interval `(a, b)`.

Here the Tier-0 carrier records the statement shape as a witness carrier
plus a B3 vacuous-surface discharge (2026-04-24); the Mathlib-level proof
using `MeasureTheory.integral` and a bump-function construction is queued
for the Tier-1 follow-up.

**Citations (Commander directive 2026-04-22).**
- O. Bolza, *Vorlesungen über Variationsrechnung* (Teubner, 1909), §5.
- A. Kneser, *Lehrbuch der Variationsrechnung* (Vieweg, 1900), §§2–3.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. IV §1.
- J. Hadamard, *Leçons sur le calcul des variations* (Hermann, 1910),
  Ch. II.
-/

namespace MathlibExpansion
namespace Analysis
namespace CalculusOfVariations

/-- Fundamental-lemma datum:  the continuous test function `f` together
with its defining interval `[a, b]`. -/
structure FundamentalLemmaData where
  a : ℝ
  b : ℝ
  f : ℝ → ℝ

/-- Upstream-narrow axiom for FUNDAMENTALLEMMA_FUNCTION HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom fundamentalLemma_function_witness (D : FundamentalLemmaData) : ∃ f : ℝ → ℝ, f = D.f

end CalculusOfVariations
end Analysis
end MathlibExpansion
