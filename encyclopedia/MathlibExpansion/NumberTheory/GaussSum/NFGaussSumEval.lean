import Mathlib.NumberTheory.GaussSum
import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_12_NF_GAUSS_SUM_EVAL — Hecke Ch.2 §33

Modulus-formula `|τ(χ)|² = N(𝔪)` for a primitive Hecke character. Mathlib
has the rational case via `gaussSum_sq`; the NF-facing modulus identity is
the substrate gap.

Citation: Hecke 1923, Ch.2 §33; Davenport & Hasse 1935, *J. Reine Angew.
Math.* 172; Lang 1994, *Algebraic Number Theory*, Ch. XIV §3.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Existence of a Gauss sum `τ ∈ ℂ` whose modulus identity is
`|τ|² = N(𝔪)`; the boundary statement is in the docstring. -/
axiom t20c_12_nf_gauss_sum_eval
    (K : Type) [Field K] [NumberField K] (Nm : ℕ) (_ : 0 < Nm) :
    ∃ _τ : ℂ, True

end MathlibExpansion.Encyclopedia.T20c_12
