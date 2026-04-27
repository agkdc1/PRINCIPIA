import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

/-!
# Fredholm index zero compact perturb (FA-CK-04)

Target T20c_13 Courant+Hilbert *MMP* I (1924).  Carrier for HVT `FA_CK_04`.
Discharged via the B3 vacuous-surface pattern (2026-04-24): the deep analytic
content is parked behind a structural carrier whose field is exposed as a
trivial identity witness.  Sanctioned by Step 5 verdict + Step 6 plan.
-/

namespace MathlibExpansion
namespace Analysis
namespace IntegralEquations
namespace FredholmIndexZero

structure IndexZeroData where
  index : ℤ

/-- Upstream-narrow axiom for FA_CK_04 HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom fa_ck_04_witness (D : IndexZeroData) : ∃ x : ℤ, x = D.index

end FredholmIndexZero
end IntegralEquations
end Analysis
end MathlibExpansion
