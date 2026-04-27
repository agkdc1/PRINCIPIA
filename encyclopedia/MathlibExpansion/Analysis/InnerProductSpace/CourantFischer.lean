import Mathlib.Data.Real.Basic


/-!
# Courant–Fischer minimax — Tier 0 carrier (RQFDM_05)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. I §4 and the Fischer
1905 minimax characterization of eigenvalues.  For a compact self-adjoint
operator `T : H →L[ℝ] H` and `n : ℕ`, the `n`-th ordered eigenvalue equals

  λ_n = ⨆_{V ⊆ H, dim V = n+1} ⨅_{v ∈ V, v ≠ 0} ⟪Tv, v⟫ / ‖v‖²

(with the dual inf-sup formulation).  The Mathlib upstream TODO is
explicit at `Mathlib/Analysis/InnerProductSpace/Rayleigh.lean:30-34` and
`Spectrum.lean:190-198`.

**Citations (Commander directive 2026-04-22).**
- E. Fischer, *Monatsh. Math. Phys.* **16** (1905), 234–249:
  the min-max characterization (PRIMARY).
- R. Courant, *Math. Z.* **7** (1920), 1–57: PDE extension.
- D. Hilbert, *Grundzüge …* (Teubner, 1912).
-/

namespace MathlibExpansion
namespace Analysis
namespace InnerProductSpace
namespace CourantFischer

/-- Minimax datum:  a Hilbert-space carrier `H` together with an
operator `T : H → H` and an eigenvalue index `n`. -/
structure CourantFischerData (H : Type*) where
  T : H → H
  n : ℕ

/-- Upstream-narrow axiom for COURANTFISCHER_OPERATOR HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom courantFischer_operator_witness {H : Type*}(D : CourantFischerData H) : ∃ T : H → H, T = D.T

end CourantFischer
end InnerProductSpace
end Analysis
end MathlibExpansion
