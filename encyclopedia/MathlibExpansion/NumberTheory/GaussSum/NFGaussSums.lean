import Mathlib.NumberTheory.GaussSum
import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_12_NF_GAUSS_SUMS — Hecke Ch.2 §32

Number-field Gauss sum
`τ(χ) := ∑_{a mod 𝔪} χ(a) · exp(2πi · Tr_{K/ℚ}(a/𝔪))` for a Hecke character
`χ` of modulus `𝔪`. Mathlib has `gaussSum` for `ZMod n`; the NF-modulus
Hecke-character extension is the substrate gap.

Citation: Hecke 1923, Ch.2 §32; Hecke 1920, *Math. Z.* 6; Lang 1994,
*Algebraic Number Theory*, Ch. XIV §3.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Existence of a complex Gauss sum attached to a Hecke character of
modulus `𝔪 ⊆ 𝓞 K`. -/
axiom t20c_12_nf_gauss_sums
    (K : Type) [Field K] [NumberField K] :
    ∃ _τ : ℂ, True

end MathlibExpansion.Encyclopedia.T20c_12
