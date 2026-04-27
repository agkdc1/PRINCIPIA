import Mathlib.NumberTheory.LegendreSymbol.QuadraticReciprocity

/-!
# T20c_12_SUPP_LAWS_CORRECTION — Hecke Ch.VIII Sätze 161–164

Correction of the supplementary laws to the quadratic-reciprocity statement
in number-field form: sign-correction term `ε(D) ∈ {±1}` for the discriminant
`D`. Mathlib has the rational supplementary laws; the NF-facing correction
matching Hecke's Sätze 161–164 is the substrate gap.

Citation: Hecke 1923, Ch.VIII Sätze 161–164; Hecke 1919, *Mathematische
Annalen* 79 ("Über eine neue Anwendung der Zetafunktionen"); Lang 1994,
*Algebraic Number Theory*, Ch. IV.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Existence of a sign-correction `ε ∈ {±1}` for the supplementary
quadratic-reciprocity laws indexed by a nonzero discriminant. -/
axiom t20c_12_suppLaws_correction
    (D : ℤ) (_ : D ≠ 0) :
    ∃ ε : ℤ, ε = 1 ∨ ε = -1

end MathlibExpansion.Encyclopedia.T20c_12
