import Mathlib.NumberTheory.Padics.PadicNumbers

/-!
# T20c_late_05 PUFS — p-adic unit filtration & squareclasses (substrate_gap Q1)

**Classification.** `substrate_gap` / `Q1`. Chapter II wrapper substrate:
the descending filtration `U_n := 1 + p^n ℤ_p` on `ℤ_p^×`, the isomorphism
`ℤ_p^× ≅ μ_{p-1} × U_1` (for odd `p`), and the squareclass group
`ℚ_p^× / (ℚ_p^×)^2` — the prerequisite for Chapter III Hilbert symbol.

**Citation.** Serre, *A Course in Arithmetic*, Ch. II §3.
Historical parent: Hasse, "Äquivalenz quadratischer Formen" (1923); Minkowski (1890).
-/

namespace MathlibExpansion
namespace Roots
namespace Serre
namespace T20cLate05_PUFS

/-- **PUFS_01** unit filtration marker. The descending chain
`U_0 = ℤ_p^× ⊇ U_1 = 1+pℤ_p ⊇ U_2 = 1+p^2ℤ_p ⊇ ...` is a fundamental system
of open subgroups; `U_n/U_{n+1} ≅ F_p^+` for `n ≥ 1`; `ℤ_p^× ≅ μ_{p-1} × U_1`
for odd `p` and `ℤ_2^× ≅ {±1} × U_2` for `p = 2`.
Citation: Serre Ch. II §3.1–3.3. -/
axiom padic_unit_filtration_marker : True

/-- **PUFS_03** squareclass cardinality marker. `|ℚ_p^× / (ℚ_p^×)^2| = 4`
for odd `p` with representatives `{1, u, p, up}` (`u` a non-square unit);
`|ℚ_2^× / (ℚ_2^×)^2| = 8` with representatives `{±1, ±5, ±2, ±10}`.
Citation: Serre Ch. II §3.3, Cor. 1, 2. -/
axiom padic_squareclass_cardinality_marker : True

/-- **PUFS_05** Hensel-to-squareclass bridge marker. For odd `p`, a unit
`u ∈ ℤ_p^×` is a square iff its residue `ū ∈ F_p^×` is a square; for `p = 2`,
a unit `u ∈ ℤ_2^×` is a square iff `u ≡ 1 (mod 8)`.
Citation: Serre Ch. II §3.3, Thm. 3. -/
axiom padic_squareclass_hensel_bridge_marker : True

end T20cLate05_PUFS
end Serre
end Roots
end MathlibExpansion
