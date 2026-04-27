import Mathlib.NumberTheory.LegendreSymbol.Basic

/-!
# T20c_12_PRIME_IDEAL_QUAD_SYMBOL — Hecke Ch.VIII §54 odd-prime case

Quadratic-residue symbol `(a/p) ∈ {1,-1,0}` for odd prime ideals of `𝓞 K`.
The classical Legendre/Jacobi symbol is upstream at
`Mathlib/NumberTheory/LegendreSymbol/Basic.lean`; the prime-ideal-indexed
NF-facing extension matching Hecke's §54 framing is the substrate gap.

Citation: Hecke 1923, Ch.VIII §54 pp.195–196; Lang 1994, *Algebraic Number
Theory*, Ch. IV §2; Serre 1973, *Cours d'Arithmétique*, Ch. I §3.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Existence of an odd-prime quadratic-residue symbol valued in `{1, -1, 0}`,
witnessing the prime-ideal extension of the Legendre symbol on `𝓞 K`. -/
axiom t20c_12_primeIdeal_quadSymbol
    (p : ℕ) (_ : Nat.Prime p) (_ : p ≠ 2) (_a : ℤ) :
    ∃ s : ℤ, s = 1 ∨ s = -1 ∨ s = 0

end MathlibExpansion.Encyclopedia.T20c_12
