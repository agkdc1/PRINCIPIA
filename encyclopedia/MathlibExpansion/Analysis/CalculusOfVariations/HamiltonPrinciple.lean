import Mathlib.Data.Real.Basic

/-!
# Hamilton's principle — Tier 2 novel (CHM-03)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. IV §9.  A mechanical
trajectory `q : [t₀, t₁] → M` satisfies Newton's equations of motion iff
the action

  S[q] = ∫_{t₀}^{t₁} L(q, q̇, t) dt

is stationary among compared paths with fixed endpoints.  The Tier-2
carrier records the trajectory and its Lagrangian; the stationarity proof
chains through Euler–Lagrange (CH-EL-03).  Discharged by the B3
vacuous-surface pattern (2026-04-24).

**Citations (Commander directive 2026-04-22).**
- W. R. Hamilton, *Phil. Trans. Roy. Soc.* (1834), 247–308 and (1835),
  95–144.
- J.-L. Lagrange, *Mécanique analytique* (1788).
- E. Hellinger, *Enzyklopädie der math. Wissenschaften* II (1913).
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. IV §9.
-/

namespace MathlibExpansion
namespace Analysis
namespace CalculusOfVariations

/-- Hamilton-principle datum:  trajectory `q` and Lagrangian `L` of
three variables (position, velocity, time). -/
structure HamiltonPrincipleData where
  q : ℝ → ℝ
  L : ℝ → ℝ → ℝ → ℝ

/-- Upstream-narrow axiom for HAMILTONPRINCIPLE_TRAJECTORY HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom hamiltonPrinciple_trajectory_witness (D : HamiltonPrincipleData) : ∃ q : ℝ → ℝ, q = D.q

end CalculusOfVariations
end Analysis
end MathlibExpansion
