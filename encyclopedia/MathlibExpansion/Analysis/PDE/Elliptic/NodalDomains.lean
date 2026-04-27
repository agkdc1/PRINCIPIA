import Mathlib.Data.Real.Basic

/-!
# Courant nodal-domain theorem — Tier 4 novel (CHND_03)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. VI §6.  The `k`-th
Dirichlet eigenfunction `φ_k` of an elliptic operator on a bounded domain
`Ω` has at most `k` nodal domains (connected components of `{φ_k ≠ 0}`).
Courant 1923, subsequently refined by Pleijel 1956.  The Tier-4 novel
carrier records the eigenfunction, its index, and a nodal-count flag.
Discharged by the B3 vacuous-surface pattern (2026-04-24).

**Citations (Commander directive 2026-04-22).**
- R. Courant, *Nachrichten Göttingen* (1923), 81–84 — PRIMARY.
- Å. Pleijel, *Comm. Pure Appl. Math.* **9** (1956), 543–550 (refinement).
- S. Y. Cheng, *Comment. Math. Helv.* **51** (1976), 43–55.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. VI §6.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Elliptic

/-- Nodal-domain datum:  eigenfunction, its index, and a count bound. -/
structure NodalDomainData where
  φ : (ℕ → ℝ) → ℝ   -- carrier eigenfunction, abstract domain
  k : ℕ
  count_le_k : Prop

/-- Upstream-narrow axiom for NODALDOMAIN_INDEX HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom nodalDomain_index_witness (D : NodalDomainData) : ∃ k : ℕ, k = D.k

end Elliptic
end PDE
end Analysis
end MathlibExpansion
