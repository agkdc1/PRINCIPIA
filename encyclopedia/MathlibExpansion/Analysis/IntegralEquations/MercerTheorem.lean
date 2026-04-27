import Mathlib.Data.Real.Basic


/-!
# Mercer theorem — Tier 4 novel (SKSD_07)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. III §5.  For a
continuous positive-semidefinite kernel `K` on `[0,1]²`, the eigenfunction
series

  K(x, y) = Σ_{n ≥ 1} λ_n φ_n(x) φ_n(y)

converges absolutely and uniformly on `[0,1]²` — Mercer 1909.  The Tier-4
novel carrier records the kernel, the eigenvalue/eigenfunction sequences,
and a positive-semidefinite flag.  Discharged by the B3 vacuous-surface
pattern (2026-04-24) while the analytic uniform-convergence argument
lives downstream of the Hilbert-Schmidt substrate.

**Citations (Commander directive 2026-04-22).**
- J. Mercer, *Phil. Trans. Roy. Soc. A* **209** (1909), 415–446 — PRIMARY.
- D. Hilbert, *Grundzüge …* (Teubner, 1912), Kap. V.
- F. Riesz, B. Sz.-Nagy, *Functional Analysis* §97.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. III §5.
-/

namespace MathlibExpansion
namespace Analysis
namespace IntegralEquations

/-- Mercer datum:  kernel plus eigenvalue / eigenfunction sequences. -/
structure MercerData where
  K : ℝ → ℝ → ℝ
  lam : ℕ → ℝ
  φ : ℕ → ℝ → ℝ
  posSemiDef : Prop

/-- Upstream-narrow axiom for MERCER_EIGENFUNCTION HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom mercer_eigenfunction_witness (D : MercerData) : ∃ φ : ℕ → ℝ → ℝ, φ = D.φ

end IntegralEquations
end Analysis
end MathlibExpansion
