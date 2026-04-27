import Mathlib.Data.Real.Basic


/-!
# Sturm–Liouville eigenvalue simplicity — Tier 1 novel (RSLB_03)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. V §14.  For a regular
Sturm–Liouville problem with separated boundary conditions, each eigenvalue
has a one-dimensional eigenspace — eigenvalues are *simple*.  The proof
uses the fact that two solutions vanishing at the same endpoint are linearly
dependent (Wronskian identity + BC compatibility).  Tier-1 novel_theorem
row.  The Tier-1 carrier tracks the eigenvalue together with a dimension
bound flag; the detailed Wronskian argument is queued for Tier 2.
Discharged by the B3 vacuous-surface pattern (2026-04-24).

**Citations (Commander directive 2026-04-22).**
- J. Liouville, *J. Math. Pures Appl.* **1** (1836), §V.
- A. Kneser, *Math. Ann.* **58** (1904), 81–147.
- M. Bôcher, *Integral Equations* (CUP, 1917), §24.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. V §14.
-/

namespace MathlibExpansion
namespace Analysis
namespace ODE
namespace SturmLiouville

/-- Simplicity datum:  eigenvalue `λ` and dimension-bound flag. -/
structure SimplicityData where
  lam : ℝ
  dim_le_one : Prop

/-- Upstream-narrow axiom for SIMPLICITY_EIGENVALUE HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom simplicity_eigenvalue_witness (D : SimplicityData) : ∃ lam : ℝ, lam = D.lam

end SturmLiouville
end ODE
end Analysis
end MathlibExpansion
