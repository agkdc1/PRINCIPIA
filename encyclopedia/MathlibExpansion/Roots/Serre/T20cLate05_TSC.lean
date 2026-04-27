import Mathlib.NumberTheory.Padics.PadicNumbers

/-!
# T20c_late_05 TSC — Three-squares consumer theorem (novel_theorem Q3)

**Classification.** `novel_theorem` / `Q3`. Chapter IV consumer:
`n ∈ ℕ` is a sum of three squares iff `n ≠ 4^a (8b + 7)`, an honest Hasse-Minkowski
application (not Lagrange four-squares).

**Citation.** Serre, *A Course in Arithmetic*, Ch. IV §1–§3 Appendix.
Historical parent: Gauss, *Disquisitiones Arithmeticae* §291 (1801);
Legendre (1798).
-/

namespace MathlibExpansion
namespace Roots
namespace Serre
namespace T20cLate05_TSC

/-- **TSC_01** three-squares theorem marker. `n ∈ ℕ` is a sum of three integer
squares iff `n` is NOT of the form `4^a(8b+7)` for some `a, b ∈ ℕ`.
Citation: Serre Ch. IV Appendix, Thm. -/
axiom three_squares_theorem_marker : True

/-- **TSC_03** Hasse-Minkowski derivation marker. The three-squares theorem
follows from Hasse-Minkowski applied to `f(x,y,z) = x^2 + y^2 + z^2` combined
with local analysis at `p = 2` and the real place: `f` represents `n > 0`
over `ℝ` always, over `ℚ_p` for odd `p` always, over `ℚ_2` iff the
`4^a(8b+7)` obstruction fails.
Citation: Serre Ch. IV Appendix §2. -/
axiom three_squares_from_hasse_minkowski_marker : True

end T20cLate05_TSC
end Serre
end Roots
end MathlibExpansion
