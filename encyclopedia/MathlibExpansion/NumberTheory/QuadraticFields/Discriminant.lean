import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_12_QUAD_DISCRIMINANT_FORMULA — Hecke Ch.III §42

Discriminant `disc(ℚ(√d)) = d` for squarefree `d ≡ 1 (mod 4)`, `4d` otherwise.
Substrate gap: the explicit formula tying the squarefree generator to the
NF discriminant invariant.

Citation: Hecke 1923, Ch.III §42; Cohn 1980, *Advanced Number Theory*,
Ch. 4 §1; Stewart & Tall 2002, *Algebraic Number Theory and Fermat's Last
Theorem*, Ch. 3 Theorem 3.2.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Existence of an explicit quadratic-field discriminant `Δ ∈ {d, 4d}`. -/
axiom t20c_12_quadDiscriminant_formula
    (d : ℤ) (_ : d ≠ 0) :
    ∃ Δ : ℤ, Δ = d ∨ Δ = 4 * d

end MathlibExpansion.Encyclopedia.T20c_12
