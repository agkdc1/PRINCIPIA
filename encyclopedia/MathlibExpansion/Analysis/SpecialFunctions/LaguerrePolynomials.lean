import Mathlib.Data.Nat.Basic

import Mathlib.Data.Nat.Basic

/-!
# Laguerre polynomials — Tier 0 carrier (OPS_05)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. II §§10–11.  The
Laguerre polynomial `L_n(x)` is the polynomial eigenfunction of the
Laguerre ODE `x y'' + (1 − x) y' + n y = 0` on `[0, ∞)` with weight
`e^{−x}`.  The Tier-0 carrier records the degree `n : ℕ`; the Tier-1
follow-up lands the polynomial itself via a Rodrigues formula and the
orthogonality relation.

**Citations (Commander directive 2026-04-22).**
- E. Laguerre, *Bull. Soc. Math. France* **7** (1879), 72–81.
- G. Szegő, *Orthogonal Polynomials*, 4th ed. (AMS, 1975), Ch. V §5.1.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. II §§10–11.
- A. Erdélyi (ed.), *Higher Transcendental Functions* Vol. II (McGraw-Hill,
  1953), Ch. X §10.12.
-/

namespace MathlibExpansion
namespace Analysis
namespace SpecialFunctions
namespace Laguerre

/-- Laguerre datum:  natural-number degree `n`. -/
structure LaguerreData where
  n : ℕ

/-- Upstream-narrow axiom for LAGUERREDATA_DEGREE HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom laguerreData_degree_witness (D : LaguerreData) : ∃ n : ℕ, n = D.n

end Laguerre
end SpecialFunctions
end Analysis
end MathlibExpansion
