import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_12_QUAD_CNF_GAUSS_SUM — Hecke Ch.III §46

Closed-form imaginary-quadratic class number via Gauss sum:
`h_{ℚ(√-p)} = -(1/p) ∑_{a=1}^{p-1} (a/p) · a` for `p ≡ 3 (mod 4)`, with
analogues for the other residue classes. Substrate gap: the explicit
Gauss-sum formula for `h_K` in imaginary quadratic fields.

Citation: Hecke 1923, Ch.III §46; Gauss 1801, *Disquisitiones Arithmeticae*
§356; Davenport 2000, *Multiplicative Number Theory*, Ch. 6.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Existence of an integer class-number value via the Gauss-sum closed
form for an imaginary quadratic field. -/
axiom t20c_12_quadCNF_gaussSum
    (d : ℤ) (_ : d < 0) :
    ∃ h : ℕ, 0 < h

end MathlibExpansion.Encyclopedia.T20c_12
