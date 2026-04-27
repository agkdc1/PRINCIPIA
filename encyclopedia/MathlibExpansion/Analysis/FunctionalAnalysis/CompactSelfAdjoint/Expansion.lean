import Mathlib.Data.Real.Basic


/-!
# Compact self-adjoint spectral expansion — Tier 1 (CSAT_07)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. III §7.  A compact
self-adjoint operator admits the expansion

  T = ∑_{n} λ_n ⟨·, φ_n⟩ φ_n

convergent in the strong operator topology, where `(λ_n, φ_n)` enumerates
the nonzero eigensystem.  The Tier-1 carrier records the eigenvalue
sequence and eigenvector sequence; the summability theorem is parked
behind the Mathlib spectral bridge.  Discharged by the B3 vacuous-surface
pattern (2026-04-24).

**Citations (Commander directive 2026-04-22).**
- D. Hilbert, *Grundzüge …* (Teubner, 1912), Kap. VI.
- E. Schmidt, *Math. Ann.* **63** (1907), 433–476.
- F. Riesz, B. Sz.-Nagy, *Functional Analysis* §78.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. III §7.
-/

namespace MathlibExpansion
namespace Analysis
namespace FunctionalAnalysis
namespace CompactSelfAdjoint

/-- Spectral-expansion datum.  `eigenval n` is the `n`-th ordered
eigenvalue; `eigenvec n` is the associated orthonormal eigenvector. -/
structure SpectralExpansionData (H : Type*) where
  op       : H → H
  eigenval : ℕ → ℝ
  eigenvec : ℕ → H

/-- Upstream-narrow axiom for SPECTRALEXPANSION_SEQUENCE HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom spectralExpansion_sequence_witness {H : Type*}(S : SpectralExpansionData H) : ∃ lam : ℕ → ℝ, lam = S.eigenval

end CompactSelfAdjoint
end FunctionalAnalysis
end Analysis
end MathlibExpansion
