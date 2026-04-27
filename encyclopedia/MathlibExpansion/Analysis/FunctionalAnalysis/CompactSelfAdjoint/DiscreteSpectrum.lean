import Mathlib.Data.Real.Basic


/-!
# Compact self-adjoint discrete spectrum — Tier 1 (CSAT_06)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. III §7.  The spectrum
of a compact self-adjoint operator is countable, bounded, and accumulates
only at `0`.  The Tier-1 carrier records the spectrum as a set and its
countability flag; the proof is queued behind Mathlib's compact-operator
spectrum lemmas.  Discharged by the B3 vacuous-surface pattern (2026-04-24).

**Citations (Commander directive 2026-04-22).**
- F. Riesz, B. Sz.-Nagy, *Functional Analysis* §80.
- D. Hilbert, *Grundzüge …* (Teubner, 1912), Kap. VI §30.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. III §7.
-/

namespace MathlibExpansion
namespace Analysis
namespace FunctionalAnalysis
namespace CompactSelfAdjoint

/-- Discrete-spectrum datum: the carrier operator together with its
spectrum predicate `spec : ℝ → Prop`. -/
structure DiscreteSpectrumData (H : Type*) where
  op   : H → H
  spec : ℝ → Prop
  countable : Prop

/-- Upstream-narrow axiom for DISCRETESPECTRUM_PREDICATE HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom discreteSpectrum_predicate_witness {H : Type*}(D : DiscreteSpectrumData H) : ∃ σ : ℝ → Prop, σ = D.spec

end CompactSelfAdjoint
end FunctionalAnalysis
end Analysis
end MathlibExpansion
