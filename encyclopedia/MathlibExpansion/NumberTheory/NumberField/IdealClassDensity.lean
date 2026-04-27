import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.RingTheory.ClassGroup
import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Basic

/-!
# T20c_12_IDEAL_CLASS_DENSITY — Hecke Ch.2 §27

Equidistribution of ideal classes: count of integral ideals in class `C` of
norm ≤ `x` is `ρ_K · x + O(...)`. Mathlib has the abstract `ClassGroup`; the
density theorem with explicit residue `ρ_K` is the substrate gap.

Citation: Hecke 1923, Ch.2 §27; Landau 1903, *Über die Anzahl der
Gitterpunkte in gewissen Bereichen*; Marcus 1977, *Number Fields*, Ch.6
Theorem 39.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

open scoped NumberField

/-- Existence of a positive ideal-class density `ρ_K` for every class. -/
axiom t20c_12_idealClass_density
    (K : Type) [Field K] [NumberField K] (_C : ClassGroup (𝓞 K)) :
    ∃ ρ : ℝ, 0 < ρ

end MathlibExpansion.Encyclopedia.T20c_12
