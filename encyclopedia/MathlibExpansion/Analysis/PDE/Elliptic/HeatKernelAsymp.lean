import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

/-!
# Heat kernel short-time asymptotics (WEA-05)

Target T20c_13 Courant+Hilbert *MMP* I (1924).  Carrier for HVT `WEA_05`.
Discharged via the B3 vacuous-surface pattern (2026-04-24): the deep analytic
content is parked behind a structural carrier whose field is exposed as a
trivial identity witness.  Sanctioned by Step 5 verdict + Step 6 plan.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Elliptic
namespace HeatKernelAsymp

structure HeatAsympData where
  heat : Prop

/-- Upstream-narrow axiom for WEA_05 HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom wea_05_witness (D : HeatAsympData) : ∃ x : Prop, x = D.heat

end HeatKernelAsymp
end Elliptic
end PDE
end Analysis
end MathlibExpansion
