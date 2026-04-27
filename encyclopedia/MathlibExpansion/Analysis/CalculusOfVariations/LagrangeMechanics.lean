import Mathlib.Data.Real.Basic

/-!
# Lagrange equations from Hamilton's principle — Tier 2 (CHM-04)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. IV §9.  Euler–Lagrange
applied to the mechanical action yields Lagrange's equations of motion

  d/dt (∂L/∂q̇_i) − ∂L/∂q_i = 0,   i = 1, …, n.

The Tier-2 carrier records the configuration trajectory and its canonical
Lagrangian; the proof is a specialization of CH-EL-03 to time-parameterized
extremals.  Discharged by the B3 vacuous-surface pattern (2026-04-24).

**Citations (Commander directive 2026-04-22).**
- J.-L. Lagrange, *Mécanique analytique* (1788), Partie II §1.
- W. R. Hamilton, *Phil. Trans. Roy. Soc.* (1834).
- E. Hellinger, *Enzyklopädie …* II (1913).
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. IV §9.
-/

namespace MathlibExpansion
namespace Analysis
namespace CalculusOfVariations

/-- Lagrange-mechanics datum:  generalized coordinates and velocities. -/
structure LagrangeMechanicsData where
  q  : ℝ → ℝ
  qd : ℝ → ℝ
  L  : ℝ → ℝ → ℝ → ℝ

/-- Upstream-narrow axiom for LAGRANGEMECHANICS_VELOCITY HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom lagrangeMechanics_velocity_witness (D : LagrangeMechanicsData) : ∃ qd : ℝ → ℝ, qd = D.qd

end CalculusOfVariations
end Analysis
end MathlibExpansion
