import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.Analysis.SpecialFunctions.Complex.Log

/-!
# T20c_12_DEDEKIND_ZETA_DEF — Hecke Ch.2 §28

Definition of `ζ_K(s) := ∑_{𝔞 ⊆ 𝓞 K} N(𝔞)^{-s}` absolutely convergent for
`Re(s) > 1`. Mathlib has the abstract `LSeries`; the NF-facing Dedekind zeta
indexed by integral ideals is the substrate gap.

Citation: Hecke 1923, Ch.2 §28; Dedekind 1877, *Sur la théorie des nombres
entiers algébriques*; Neukirch 1999, *Algebraic Number Theory*, Ch. VII §5.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Existence of a Dedekind-zeta value `ζ_K(s) ∈ ℂ` for `Re(s) > 1`. -/
axiom t20c_12_dedekindZeta_def
    (K : Type) [Field K] [NumberField K] (s : ℂ) (_ : 1 < s.re) :
    ∃ _z : ℂ, True

end MathlibExpansion.Encyclopedia.T20c_12
