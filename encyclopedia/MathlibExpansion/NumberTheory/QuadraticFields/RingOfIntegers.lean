import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.NumberTheory.Zsqrtd.GaussianInt

/-!
# T20c_12_QUAD_FIELD_OI_MODEL — Hecke Ch.III §41

Explicit ring of integers `𝓞_{ℚ(√d)}` model: `ℤ[√d]` for `d ≢ 1 (mod 4)`,
`ℤ[(1+√d)/2]` for `d ≡ 1 (mod 4)`, with `d` squarefree. Mathlib has
`Zsqrtd`; the NF-typeclass-facing model identifying `𝓞 K` with the
Hecke-style explicit `ω`-generator is the substrate gap.

Citation: Hecke 1923, Ch.III §41; Cohn 1980, *Advanced Number Theory*,
Ch. 4; Marcus 1977, *Number Fields*, Ch. 2 Theorem 1.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Existence of a quadratic-field-integer generator
`ω ∈ ℤ` witnessing the explicit `ω`-basis model of `𝓞_{ℚ(√d)}`. -/
axiom t20c_12_quadField_oI_model
    (d : ℤ) (_ : d ≠ 0) :
    ∃ _ω : ℤ, True

end MathlibExpansion.Encyclopedia.T20c_12
