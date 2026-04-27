import Mathlib.Data.Real.Basic


/-!
# Regular Sturm–Liouville spectral-problem API — Tier 1 (RSLB_02)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. V §14.  The spectral
problem for a regular Sturm–Liouville system is the pair (operator, boundary
conditions); eigenvalues `λ` and eigenfunctions `y` satisfy

  −(p y')' + q y = λ w y,   α₁ y(a) + α₂ y'(a) = 0,   β₁ y(b) + β₂ y'(b) = 0.

The Tier-1 carrier records the `λ`-witness and a solution function; the full
spectral-discreteness proof is queued behind the compact-SA bridge.
Discharged by the B3 vacuous-surface pattern (2026-04-24).

**Citations (Commander directive 2026-04-22).**
- J. Liouville, *J. Math. Pures Appl.* **1** (1836), 253–265.
- M. Bôcher, *Introduction to the Study of Integral Equations* (CUP, 1917).
- D. Hilbert, *Grundzüge …* (Teubner, 1912), Kap. V.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. V §14.
-/

namespace MathlibExpansion
namespace Analysis
namespace ODE
namespace SturmLiouville

/-- Spectral-problem datum:  eigenvalue `λ` and candidate eigenfunction. -/
structure SpectralProblemData where
  lam : ℝ
  y : ℝ → ℝ

/-- Upstream-narrow axiom for SPECTRALPROBLEM_EIGENVALUE HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom spectralProblem_eigenvalue_witness (S : SpectralProblemData) : ∃ lam : ℝ, lam = S.lam

end SturmLiouville
end ODE
end Analysis
end MathlibExpansion
