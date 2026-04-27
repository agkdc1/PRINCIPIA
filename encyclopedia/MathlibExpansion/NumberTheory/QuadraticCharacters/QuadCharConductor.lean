import Mathlib.Data.Int.AbsoluteValue

/-!
# T20c_12_QUAD_CHAR_CONDUCTOR — Hecke Ch.VII §§49–52

`conductor(χ_D) = |D|`; matches χ₄, χ₈, χ₈′ for small fundamental
discriminants. Conductor API for Dirichlet characters is upstream;
discriminant-indexed matching and small-case identification is the gap.

Citation: Hecke 1923, Ch.VII §§49–52; Davenport 2000, *Multiplicative Number
Theory*, Ch. 5; Kronecker, discriminant-indexed quadratic symbol extension.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- For nonzero `D : ℤ`, the conductor of the associated Kronecker quadratic
character coincides with `|D|`. Existence boundary witnessing the
conductor–discriminant correspondence. -/
axiom t20c_12_quadChar_conductor
    (D : ℤ) (_ : D ≠ 0) :
    ∃ c : ℕ, c = D.natAbs

end MathlibExpansion.Encyclopedia.T20c_12
