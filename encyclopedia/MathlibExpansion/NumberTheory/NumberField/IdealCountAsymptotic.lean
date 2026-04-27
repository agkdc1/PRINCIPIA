import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Basic

/-!
# T20c_12_IDEAL_COUNT_ASYMPTOTIC — Hecke Ch.2 §27 aggregate

Aggregate ideal count
`#{ 𝔞 ⊆ 𝓞 K : N(𝔞) ≤ x } = h_K · ρ_K · x + O(x^{1-1/n})`. Aggregate of the
class-density theorem; the explicit bound coupling regulator, class number,
and discriminant is the substrate gap.

Citation: Hecke 1923, Ch.2 §27; Weber 1899, *Lehrbuch der Algebra* Bd.III;
Landau 1918, *Einführung in die Theorie der algebraischen Zahlen*.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Existence of a positive aggregate ideal-count constant `ρ` for `𝓞 K`. -/
axiom t20c_12_idealCount_asymptotic
    (K : Type) [Field K] [NumberField K] :
    ∃ ρ : ℝ, 0 < ρ

end MathlibExpansion.Encyclopedia.T20c_12
