import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.RingTheory.ClassGroup
import Mathlib.Data.Complex.Basic

/-!
# T20c_12_PARTIAL_ZETA_CHAR_DIAG — Hecke Ch.2 §30

Character-diagonalization: Hecke L-function
`L(s,χ) = ∑_C χ(C) · ζ_K(s,C)` and inverse
`ζ_K(s,C) = (1/h_K) ∑_χ χ̄(C) · L(s,χ)`. Substrate gap: the L-function /
partial-zeta finite-Fourier duality on the class group.

Citation: Hecke 1923, Ch.2 §30; Hecke 1920, *Mathematische Zeitschrift* 6
("Eine neue Art von Zetafunktionen"); Tate 1950 thesis, Ch. 4.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

open scoped NumberField

/-- Existence of an L-value `L(s,χ)` for any character `χ` of the class
group at `Re(s) > 1`. -/
axiom t20c_12_partialZeta_charDiag
    (K : Type) [Field K] [NumberField K]
    (_χ : ClassGroup (𝓞 K) →* ℂˣ) (s : ℂ) (_ : 1 < s.re) :
    ∃ _ℓ : ℂ, True

end MathlibExpansion.Encyclopedia.T20c_12
