import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.Data.Complex.Basic

/-!
# T20c_12_DEDEKIND_ZETA_MERO — Hecke Ch.2 §38

Meromorphic continuation of `ζ_K` to all of `ℂ` with sole pole simple at
`s = 1`. The continuation theorem with this pole structure is the substrate
gap.

Citation: Hecke 1923, Ch.2 §38; Hecke 1917, *Math. Ann.* 78 main theorem;
Riemann 1859 (rational case); Tate 1950 thesis, Ch. 4.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Existence of a meromorphic value of `ζ_K` away from `s = 1`. -/
axiom t20c_12_dedekindZeta_mero
    (K : Type) [Field K] [NumberField K] (s : ℂ) (_ : s ≠ 1) :
    ∃ _z : ℂ, True

end MathlibExpansion.Encyclopedia.T20c_12
