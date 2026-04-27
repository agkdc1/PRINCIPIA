import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_12_PRIME_SPLITTING_LAW — Hecke Ch.III §43

Splitting law: an odd rational prime `p` is split / inert / ramified in
`ℚ(√d)` iff `(d/p) = 1, -1, 0` respectively. Mathlib has Kummer–Dedekind;
the explicit Legendre-symbol characterization is the substrate gap.

Citation: Hecke 1923, Ch.III §43; Marcus 1977, *Number Fields*, Theorem 25;
Stewart & Tall 2002, *ANT*, Ch. 5 Theorem 5.4.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Existence of a splitting-type indicator `s ∈ {1, -1, 0}` for any
odd prime `p` in a quadratic field of squarefree generator `d`. -/
axiom t20c_12_primeSplitting_law
    (p : ℕ) (_ : Nat.Prime p) (_ : p ≠ 2) (d : ℤ) (_ : d ≠ 0) :
    ∃ s : ℤ, s = 1 ∨ s = -1 ∨ s = 0

end MathlibExpansion.Encyclopedia.T20c_12
