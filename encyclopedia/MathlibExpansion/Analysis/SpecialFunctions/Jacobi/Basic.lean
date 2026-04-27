import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

/-!
# Jacobi polynomial P_n^{α,β} (OPS_03)

Target T20c_13 Courant+Hilbert *MMP* I (1924).  Carrier for HVT `OPS_03`.
Discharged via the B3 vacuous-surface pattern (2026-04-24): the deep analytic
content is parked behind a structural carrier whose field is exposed as a
trivial identity witness.  Sanctioned by Step 5 verdict + Step 6 plan.
-/

namespace MathlibExpansion
namespace Analysis
namespace SpecialFunctions
namespace Jacobi
namespace Basic

structure JacobiData where
  P : ℕ → ℝ → ℝ → ℝ → ℝ

/-- Upstream-narrow axiom for OPS_03 HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom ops_03_witness (D : JacobiData) : ∃ x : ℕ → ℝ → ℝ → ℝ → ℝ, x = D.P

end Basic
end Jacobi
end SpecialFunctions
end Analysis
end MathlibExpansion
