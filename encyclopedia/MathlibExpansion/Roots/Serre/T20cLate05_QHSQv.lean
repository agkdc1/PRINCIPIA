import Mathlib.NumberTheory.Padics.PadicNumbers

/-!
# T20c_late_05 QHSQv — Quadratic Hilbert symbol over Q_v (substrate_gap Q1)

**Classification.** `substrate_gap` / `Q1`. Chapter III core object:
the placewise Hilbert symbol `(a,b)_v ∈ {±1}` for `a, b ∈ ℚ_v^×`, defined by
`(a,b)_v = 1` iff `z^2 = ax^2 + by^2` has non-trivial solution in `ℚ_v^3`.

**Citation.** Serre, *A Course in Arithmetic*, Ch. III §1.
Historical parent: Hilbert, *Zahlbericht* §64–68 (1897); Hasse (1923).
-/

namespace MathlibExpansion
namespace Roots
namespace Serre
namespace T20cLate05_QHSQv

/-- **QHSQv_01** bilinearity marker. Hilbert symbol `(·,·)_v : ℚ_v^× × ℚ_v^× → {±1}`
is symmetric and bimultiplicative: `(aa', b)_v = (a,b)_v · (a',b)_v`,
`(a, b)_v = (b,a)_v`, `(a, -a)_v = 1`, `(a, 1-a)_v = 1` (Steinberg).
Citation: Serre Ch. III §1.2, Prop. 2. -/
axiom hilbert_symbol_bilinear_marker : True

/-- **QHSQv_03** non-degeneracy marker. For `v` non-archimedean, the induced
pairing `ℚ_v^× / (ℚ_v^×)^2 × ℚ_v^× / (ℚ_v^×)^2 → {±1}` is non-degenerate:
if `(a,b)_v = 1` for all `b`, then `a ∈ (ℚ_v^×)^2`.
Citation: Serre Ch. III §1.2, Thm. 2. -/
axiom hilbert_symbol_nondegenerate_marker : True

/-- **QHSQv_05** explicit formula markers. For odd `p` with `a = p^α u`,
`b = p^β v` (`u, v ∈ ℤ_p^×`):
`(a,b)_p = (-1)^{αβ ε(p)} (u/p)^β (v/p)^α` where `ε(p) = (p-1)/2`.
For `v = ∞` (real place): `(a,b)_∞ = 1` iff `a > 0 ∨ b > 0`.
For `v = 2`: explicit formula via `ε(u) := (u-1)/2 (mod 2)` and `ω(u) := (u²-1)/8 (mod 2)`.
Citation: Serre Ch. III §1.2, Thm. 1. -/
axiom hilbert_symbol_explicit_formula_marker : True

end T20cLate05_QHSQv
end Serre
end Roots
end MathlibExpansion
