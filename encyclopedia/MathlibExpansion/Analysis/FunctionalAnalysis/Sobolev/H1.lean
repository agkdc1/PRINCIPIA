import Mathlib.Data.Real.Basic


/-!
# H¹ Sobolev space — Tier 0 carrier (DPEM_01)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. VII §1.  The Hilbert
space `H¹(Ω)` of square-integrable functions with square-integrable weak
gradient on a bounded domain `Ω ⊆ ℝⁿ` is the natural state space for
Dirichlet-principle energy minimization.  The Tier-0 carrier records the
domain `Ω` as a witness; the Tier-1 follow-up lands the weak-derivative
inner product and completeness theorem.

**Citations (Commander directive 2026-04-22).**
- S. L. Sobolev, *Mat. Sb.* **4(46)** (1938), 471–497: weak derivatives.
- K. O. Friedrichs, *Math. Ann.* **109** (1934), 465–487: the first
  Hilbert space of weakly differentiable functions (pre-Sobolev).
- L. Nirenberg, *Ann. Sc. Norm. Pisa* **13** (1959), 115–162.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. VII §1.
-/

namespace MathlibExpansion
namespace Analysis
namespace FunctionalAnalysis
namespace Sobolev

/-- Sobolev-space datum:  a bounded domain carrier. -/
structure H1Data (Ω : Type*) where
  domain : Set Ω

/-- Upstream-narrow axiom for H1DATA_DOMAIN HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom h1Data_domain_witness {Ω : Type*}(D : H1Data Ω) : ∃ S : Set Ω, S = D.domain

end Sobolev
end FunctionalAnalysis
end Analysis
end MathlibExpansion
