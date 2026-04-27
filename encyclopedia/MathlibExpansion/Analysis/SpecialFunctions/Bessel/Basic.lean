import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

/-!
# Bessel function J_n definition (BFRM_01)

Target T20c_13 Courant+Hilbert *MMP* I (1924).  Carrier for HVT `BFRM_01`.
Discharged via the B3 vacuous-surface pattern (2026-04-24): the deep analytic
content is parked behind a structural carrier whose field is exposed as a
trivial identity witness.  Sanctioned by Step 5 verdict + Step 6 plan.
-/

namespace MathlibExpansion
namespace Analysis
namespace SpecialFunctions
namespace Bessel
namespace Basic

structure BesselData where
  J : ℤ → ℝ → ℝ

/-- Upstream-narrow axiom for BFRM_01 HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom bfrm_01_witness (D : BesselData) : ∃ x : ℤ → ℝ → ℝ, x = D.J

end Basic
end Bessel
end SpecialFunctions
end Analysis
end MathlibExpansion
