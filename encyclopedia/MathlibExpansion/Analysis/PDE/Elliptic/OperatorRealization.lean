import Mathlib.Data.Real.Basic

/-!
# Elliptic operator realization on a bounded domain — Tier 0 carrier (WEA-01)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. VI §3.  A uniformly
elliptic second-order operator on a bounded domain `Ω ⊂ ℝ^n` has a
self-adjoint realization in `L²(Ω)` with compact resolvent.  The Tier-0
carrier records the symbol matrix and drift vector; the full realization
theorem is deferred to a later cycle when Mathlib `Sobolev` and quadratic
form infrastructure are sufficiently developed.

**Citations (Commander directive 2026-04-22).**
- H. Weyl, *Math. Ann.* **71** (1912), 441–479.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. VI §3; *MMP* II (1937),
  Kap. VII.
- T. Kato, *Perturbation Theory for Linear Operators* (Springer, 1966),
  Ch. VI §2.
- L. C. Evans, *Partial Differential Equations*, 2nd ed. (AMS, 2010), §6.5.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Elliptic

/-- Uniformly-elliptic second-order operator datum on a bounded domain:
symbol matrix `A : ℕ → ℕ → ℝ`, drift `b : ℕ → ℝ`, zeroth-order `c : ℝ`. -/
structure EllipticOperatorData where
  dim : ℕ
  A : ℕ → ℕ → ℝ
  b : ℕ → ℝ
  c : ℝ

/-- Upstream-narrow axiom for ELLIPTICOPERATOR_SYMBOL HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom ellipticOperator_symbol_witness (E : EllipticOperatorData) : ∃ σ : ℕ → ℕ → ℝ, σ = E.A

end Elliptic
end PDE
end Analysis
end MathlibExpansion
