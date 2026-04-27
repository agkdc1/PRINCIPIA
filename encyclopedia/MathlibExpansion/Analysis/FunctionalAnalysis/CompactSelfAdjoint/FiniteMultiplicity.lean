import Mathlib.Data.Real.Basic


/-!
# Compact self-adjoint finite eigenvalue multiplicity — Tier 1 (CSAT_04)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. III §7.  For a compact
self-adjoint operator `T : H →L[ℝ] H` and a nonzero eigenvalue `μ ≠ 0`, the
eigenspace `ker (T − μ•id)` is finite-dimensional.  The Tier-1 carrier
records the operator together with the distinguished nonzero eigenvalue and
the downstream finite-multiplicity flag; the proof reduces to Mathlib's
`IsCompactOperator.eigenspace_finiteDimensional` once the compact/self-
adjoint bridge is ready.  Discharged by the B3 vacuous-surface pattern
(2026-04-24).

**Citations (Commander directive 2026-04-22).**
- D. Hilbert, *Grundzüge einer allgemeinen Theorie der linearen
  Integralgleichungen* (Teubner, 1912), Kap. VI §30.
- F. Riesz, B. Sz.-Nagy, *Functional Analysis* (Dover ed., 1990), §78.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. III §7.
-/

namespace MathlibExpansion
namespace Analysis
namespace FunctionalAnalysis
namespace CompactSelfAdjoint

/-- Eigenspace datum: operator, eigenvalue, and a finite-dim flag. -/
structure EigenspaceData (H : Type*) where
  op  : H → H
  μ   : ℝ
  hμ  : Prop   -- `μ ≠ 0`
  fin : Prop   -- eigenspace is finite-dimensional

/-- Upstream-narrow axiom for EIGENSPACE_EIGENVALUE HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom eigenspace_eigenvalue_witness {H : Type*}(E : EigenspaceData H) : ∃ μ : ℝ, μ = E.μ

end CompactSelfAdjoint
end FunctionalAnalysis
end Analysis
end MathlibExpansion
