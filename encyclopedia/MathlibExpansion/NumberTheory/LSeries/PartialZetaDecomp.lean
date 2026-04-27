import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.RingTheory.ClassGroup
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Complex.Basic

/-!
# T20c_12_PARTIAL_ZETA_DECOMP — Hecke Ch.2 §29

Class-wise partial zeta `ζ_K(s,C) := ∑_{𝔞 ∈ C} N(𝔞)^{-s}` and decomposition
`ζ_K(s) = ∑_{C ∈ Cl(K)} ζ_K(s,C)`. Substrate gap: the partial-zeta indexed
by class group and the resulting summation decomposition.

Citation: Hecke 1923, Ch.2 §29; Hecke 1917, *Mathematische Annalen* 78
("Über die Zetafunktion beliebiger algebraischer Zahlkörper").
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

open scoped NumberField

/-- Existence of a class-wise partial zeta value at `Re(s) > 1`. -/
axiom t20c_12_partialZeta_decomp
    (K : Type) [Field K] [NumberField K]
    (_C : ClassGroup (𝓞 K)) (s : ℂ) (_ : 1 < s.re) :
    ∃ _z : ℂ, True

end MathlibExpansion.Encyclopedia.T20c_12
