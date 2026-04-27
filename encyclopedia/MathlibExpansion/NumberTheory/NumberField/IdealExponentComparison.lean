import MathlibExpansion.NumberTheory.NumberField.IdealDivisibility

/-!
# T20c_12_IDEAL_EXPONENT_COMPARISON — Hecke Ch.V §§21ff

In the ring of integers of a number field, ideal divisibility coincides with
reverse inclusion. Encyclopedia alias of `ideal_dvd_iff_reverse_inclusion`.

Citation: Hecke 1923 Ch.V §§21ff; Neukirch 1999, *Algebraic Number Theory*, I §3.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

open scoped NumberField

theorem t20c_12_idealExponent_comparison
    {K : Type*} [Field K] [NumberField K] {I J : Ideal (𝓞 K)} :
    I ∣ J ↔ J ≤ I :=
  MathlibExpansion.NumberTheory.ideal_dvd_iff_reverse_inclusion

end MathlibExpansion.Encyclopedia.T20c_12
