import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_04 ICIC_CORE — Ideal class group & ideal counting (B0 substrate_gap)

**Classification.** `substrate_gap` / `B0`. Class group itself is closed
upstream; open frontier is classwise ideal counting + asymptotic density +
partial-zeta packaging.

**Citation.** Lang, *Algebraic Number Theory*, GTM 110 (1970), Ch. 6.
Historical parent: Hecke, *Vorlesungen über die Theorie der algebraischen
Zahlen* (1923).
-/

namespace MathlibExpansion
namespace Roots
namespace Lang
namespace T20cLate04_ICIC

/-- **ICIC_01** classwise ideal-counting function marker. `j_K(C, x) :=
#{𝔞 ∈ C : N(𝔞) ≤ x}` with asymptotic `j_K(C, x) ~ ρ_K · x + O(x^{1 - 1/n})`.
Citation: Lang Ch. 6 §3, Thm. 3. -/
axiom classwise_ideal_counting_marker : True

/-- **ICIC_03** partial zeta function marker. `ζ_K(s, C) := Σ_{𝔞 ∈ C} N(𝔞)^{-s}`
converges for `Re s > 1` and extends meromorphically with simple pole at `s = 1`.
Citation: Lang Ch. 6 §3, Cor. -/
axiom partial_zeta_marker : True

end T20cLate04_ICIC
end Lang
end Roots
end MathlibExpansion
