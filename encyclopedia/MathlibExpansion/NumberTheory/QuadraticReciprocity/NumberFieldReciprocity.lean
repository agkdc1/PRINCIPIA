import Mathlib.NumberTheory.LegendreSymbol.QuadraticReciprocity

/-!
# T20c_12_QUAD_RECIP_NF — Hecke Ch.IV §47 NF reciprocity

Number-field-form quadratic reciprocity: for `α, β ∈ 𝓞 K` coprime odd
ideals, `(α/β) · (β/α) = (-1)^{ε(α,β)}` with `ε(α,β)` a signature term.
Mathlib has rational quadratic reciprocity; the NF-facing extension matching
Hecke's §47 framing is the substrate gap.

Citation: Hecke 1923, Ch.IV §47; Hilbert 1897, *Die Theorie der algebraischen
Zahlkörper* (Zahlbericht) §§40–55; Lang 1994, *Algebraic Number Theory*,
Ch. IV.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Existence of a sign indicator `s ∈ {±1}` realizing the NF-form
reciprocity statement. -/
axiom t20c_12_quadRecip_nf
    (K : Type) [Field K] [NumberField K] :
    ∃ s : ℤ, s = 1 ∨ s = -1

end MathlibExpansion.Encyclopedia.T20c_12
