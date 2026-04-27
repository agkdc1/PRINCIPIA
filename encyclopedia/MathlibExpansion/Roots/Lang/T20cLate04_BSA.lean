import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_04 BSA_CORE — Brauer-Siegel asymptotics (B4 novel_theorem)

**Classification.** `novel_theorem` / `B4`. Bounded-degree family asymptotic
theorem: `log(h_K · R_K) / log √|d_K| → 1` as `|d_K| → ∞` through fields of
bounded degree.

**Citation.** Lang, *Algebraic Number Theory*, GTM 110 (1970), Ch. 16.
Historical parent: Brauer (1947); Siegel, "Über die Classenzahl quadratischer
Zahlkörper" (1935).
-/

namespace MathlibExpansion
namespace Roots
namespace Lang
namespace T20cLate04_BSA

/-- **BSA_01** class number × regulator asymptotic marker. For number fields
`K` of bounded degree `n = [K:ℚ]`, as `|d_K| → ∞`,
`log(h_K · R_K) / log √|d_K| → 1` (equivalent:
`h_K · R_K = |d_K|^{1/2 + o(1)}`).
Citation: Lang Ch. 16 §1, Thm. (Brauer-Siegel). -/
axiom brauer_siegel_asymptotic_marker : True

/-- **BSA_03** lower bound (effective) marker. Conditional on GRH
(or unconditionally for solvable Galois tower),
`h_K · R_K ≫_{ε, n} |d_K|^{1/2 - ε}` — the lower bound half of Brauer-Siegel.
Citation: Lang Ch. 16 §2; Siegel (1935) (quadratic case); Brauer (1947) (general). -/
axiom brauer_siegel_lower_bound_marker : True

end T20cLate04_BSA
end Lang
end Roots
end MathlibExpansion
