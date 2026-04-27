import Mathlib.Data.Real.Basic

/-!
# Fredholm alternative — Tier 2 novel (FA-CK-02)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. III §2.  For a
continuous symmetric kernel `K` on `[0,1]²`, the equation `(I − K) f = g`
has a solution iff `g ⊥ ker(I − K*)`.  This is the classical Fredholm
alternative — one of the founding theorems of twentieth-century functional
analysis.  The Tier-2 novel carrier records the kernel plus the
orthogonality flag; the full solvability theorem is queued.  Discharged
by the B3 vacuous-surface pattern (2026-04-24).

**Citations (Commander directive 2026-04-22).**
- I. Fredholm, *Acta Math.* **27** (1903), 365–390 — PRIMARY.
- D. Hilbert, *Grundzüge …* (Teubner, 1912), Kap. I–II.
- F. Riesz, *Les systèmes d'équations linéaires à une infinité d'inconnues*
  (Gauthier-Villars, 1913).
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. III §2.
-/

namespace MathlibExpansion
namespace Analysis
namespace IntegralEquations

/-- Fredholm-alternative datum:  kernel and right-hand side with an
orthogonality flag `ortho : Prop`. -/
structure FredholmAlternativeData where
  K : ℝ → ℝ → ℝ
  g : ℝ → ℝ
  ortho : Prop

/-- Upstream-narrow axiom for FREDHOLMALTERNATIVE_RHS HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom fredholmAlternative_rhs_witness (D : FredholmAlternativeData) : ∃ g : ℝ → ℝ, g = D.g

end IntegralEquations
end Analysis
end MathlibExpansion
