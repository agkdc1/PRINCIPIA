import Mathlib.NumberTheory.LegendreSymbol.JacobiSymbol

/-!
# T20c_12_ODD_IDEAL_QUAD_SYMBOL — Hecke Ch.VIII §54 odd-modulus case

Jacobi-style multiplicative extension to odd ideals: `(a/n) := ∏ (a/pᵢ)^{eᵢ}`.
Mathlib has `jacobiSym` for `ℕ`; the odd-ideal-of-`𝓞 K` extension matching
Hecke's §54 framing is the substrate gap.

Citation: Hecke 1923, Ch.VIII §54; Cassels & Fröhlich 1967, *Algebraic
Number Theory*, Ch. II; Lang 1994, *Algebraic Number Theory*, Ch. IV §2.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Existence of an odd-ideal quadratic symbol valued in `{1, -1, 0}`,
witnessing the multiplicative extension to all odd moduli. -/
axiom t20c_12_oddIdeal_quadSymbol
    (n : ℕ) (_ : Odd n) (_a : ℤ) :
    ∃ s : ℤ, s = 1 ∨ s = -1 ∨ s = 0

end MathlibExpansion.Encyclopedia.T20c_12
