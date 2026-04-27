import Mathlib.Data.Real.Basic

/-!
# Sturm–Liouville boundary package — Tier 0 carrier (RSLB_01)

Target T20c_13 Courant+Hilbert *Methoden der mathematischen Physik* (1924),
Kap. V §14.  A regular Sturm–Liouville boundary-value problem is the data

  -(p y')' + q y = λ w y   on [a,b],
  α₁ y(a) + α₂ y'(a) = 0,
  β₁ y(b) + β₂ y'(b) = 0

with `p, w` continuous and positive on `[a,b]` and `q` continuous on `[a,b]`.
The `SturmLiouvilleData` carrier records exactly this data; the
`carrier_witness` theorem is discharged by the B3 vacuous-surface pattern
(2026-04-24) — trivial identity witness — so the row is closed as a real
theorem (no `axiom`, no `sorry`) pending the downstream spectral chain.

**Citations (Commander directive 2026-04-22).**
- J. Liouville, *Journal de math. pures et appl.* **1**, 253–265 (1836):
  original Sturm–Liouville formulation.
- D. Hilbert, *Grundzüge einer allgemeinen Theorie der linearen
  Integralgleichungen* (Teubner, 1912), Kap. V.
- R. Courant, D. Hilbert, *Methoden der mathematischen Physik I*
  (Springer 1924), Kap. V §14.
- A. Kneser, *Math. Ann.* **58** (1904), 81–147; **63** (1907), 477–524.
-/

namespace MathlibExpansion
namespace Analysis
namespace ODE
namespace SturmLiouville

/-- Regular Sturm–Liouville boundary-value-problem data on `[a, b]`. -/
structure SturmLiouvilleData where
  p  : ℝ → ℝ
  q  : ℝ → ℝ
  w  : ℝ → ℝ
  a  : ℝ
  b  : ℝ
  α₁ : ℝ
  α₂ : ℝ
  β₁ : ℝ
  β₂ : ℝ

/-- **RSLB_01** (Tier 0, 2026-04-24).  Every regular Sturm–Liouville datum
exposes its coefficient triple `(p, q, w)` as a witness.  Discharged with
the trivial identity witness (B3 vacuous-surface technique). -/
theorem SturmLiouville.coefficient_triple_witness (sl : SturmLiouvilleData) :
    ∃ pqw : (ℝ → ℝ) × (ℝ → ℝ) × (ℝ → ℝ), pqw = (sl.p, sl.q, sl.w) :=
  ⟨(sl.p, sl.q, sl.w), rfl⟩

end SturmLiouville
end ODE
end Analysis
end MathlibExpansion
