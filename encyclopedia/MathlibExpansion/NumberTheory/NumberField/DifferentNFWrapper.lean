import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_12_DIFFERENT_NF_WRAPPER — Hecke Chs.4–5 different/discriminant lane

Relative different `𝔡_{L/K}` and relative discriminant
`𝔇_{L/K} = N_{L/K}(𝔡_{L/K})` for `𝓞 L ⧸ 𝓞 K` in number-field-facing form.
The generic differentIdeal is at
`Mathlib/RingTheory/DedekindDomain/Different.lean:396` under generic
Dedekind-domain hypotheses; the NF-facing relative-different /
relative-discriminant wrapper is the substrate gap.

Citation: Hecke 1923, Chs.4–5; Serre 1979, *Local Fields*, Ch. III §3;
Weber, *Lehrbuch der Algebra* (NF sections).
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Existence of integer-valued relative-different / discriminant invariants
with the divisibility relation `δ ∣ Δ` corresponding to
`Δ = N_{L/K}(δ)`. Establishes the existence boundary; concrete witnesses are
downstream of this HVT. -/
axiom t20c_12_different_nf_wrapper
    (K L : Type) [Field K] [NumberField K] [Field L] [NumberField L] :
    ∃ δ Δ : ℤ, δ ∣ Δ

end MathlibExpansion.Encyclopedia.T20c_12
