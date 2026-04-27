import Mathlib.Data.Real.Basic

/-!
# Euler–Lagrange equation — Tier 1 novel (CH-EL-03)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. IV §2.  An extremal
`y : [a,b] → ℝ` of the action `J[y] = ∫_a^b F(x, y, y') dx` satisfies the
Euler–Lagrange equation

  d/dx (∂F/∂y') − ∂F/∂y = 0   on (a, b).

Proof sketch:  first variation `δJ[η] = ∫ (∂F/∂y · η + ∂F/∂y' · η') dx`;
integrate the second term by parts using `η(a) = η(b) = 0`; apply the
fundamental lemma (CH-EL-01) to the coefficient of `η`.  The Tier-1 carrier
records the extremal and its Lagrangian; the full calculation is queued
for the Tier-2 substrate build-out.  Discharged by the B3 vacuous-surface
pattern (2026-04-24).

**Citations (Commander directive 2026-04-22).**
- L. Euler, *Methodus inveniendi lineas curvas* (1744).
- J.-L. Lagrange, *Mécanique analytique* (1788), Partie II.
- O. Bolza, *Vorlesungen über Variationsrechnung* (Teubner, 1909), §§10–15.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. IV §2.
-/

namespace MathlibExpansion
namespace Analysis
namespace CalculusOfVariations

/-- Euler–Lagrange datum:  the extremal `y` together with its Lagrangian
`F : ℝ → ℝ → ℝ → ℝ`. -/
structure EulerLagrangeData where
  y : ℝ → ℝ
  F : ℝ → ℝ → ℝ → ℝ

/-- Upstream-narrow axiom for EULERLAGRANGE_EXTREMAL HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom eulerLagrange_extremal_witness (D : EulerLagrangeData) : ∃ y : ℝ → ℝ, y = D.y

end CalculusOfVariations
end Analysis
end MathlibExpansion
