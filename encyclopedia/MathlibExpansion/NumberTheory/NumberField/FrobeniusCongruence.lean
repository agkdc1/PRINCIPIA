import MathlibExpansion.NumberTheory.DedekindIdeals.ResidueFields

/-!
# T20c_12_FROBENIUS_CONGRUENCE — Hecke Ch.V prime-decomposition corridor

For every `x ∈ 𝓞 K`, `x^{p^f} ≡ x (mod P)` where `p, f` are the residue
parameters of `P`. Encyclopedia alias of `frobenius_congruence`.

Citation: Hecke 1923 Ch.V; Marcus 1977, *Number Fields*, §4.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

open scoped NumberField

theorem t20c_12_frobenius_congruence
    {K : Type*} [Field K] [NumberField K]
    (P : IsDedekindDomain.HeightOneSpectrum (𝓞 K)) :
    ∃ p f : ℕ, Nat.Prime p ∧ Ideal.absNorm P.asIdeal = p ^ f ∧
      ∀ x : 𝓞 K, x ^ (p ^ f) - x ∈ P.asIdeal :=
  MathlibExpansion.NumberTheory.frobenius_congruence (K := K) P

end MathlibExpansion.Encyclopedia.T20c_12
