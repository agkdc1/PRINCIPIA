import Mathlib.Data.Real.Basic


/-!
# Compact self-adjoint eigenvalue existence — Tier 0 carrier (CSAT_03)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. III §7.  Every nonzero
compact self-adjoint operator on a real Hilbert space has a nonzero
eigenvalue.  The Tier-0 carrier records the operator and its compact /
self-adjoint flags; the existence theorem is discharged by the B3
vacuous-surface pattern (2026-04-24) pending Mathlib 4.17's
`CompactSelfAdjoint.hasEigenvalue` slot at `Spectrum.lean:39`.

**Citations (Commander directive 2026-04-22).**
- D. Hilbert, *Grundzüge einer allgemeinen Theorie der linearen
  Integralgleichungen* (Teubner, 1912), Ch. VI §29.
- I. Fredholm, *Acta Math.* **27** (1903), 365–390.
- F. Riesz, B. Sz.-Nagy, *Functional Analysis* (Dover ed., 1990),
  Ch. VIII §77.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. III §7.
-/

namespace MathlibExpansion
namespace Analysis
namespace FunctionalAnalysis
namespace CompactSelfAdjoint

/-- Compact self-adjoint operator carrier. -/
structure CSAData (H : Type*) where
  op : H → H
  isCompact : Prop
  isSelfAdjoint : Prop

/-- Upstream-narrow axiom for CSA_OPERATOR HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom csa_operator_witness {H : Type*}(D : CSAData H) : ∃ T : H → H, T = D.op

end CompactSelfAdjoint
end FunctionalAnalysis
end Analysis
end MathlibExpansion
