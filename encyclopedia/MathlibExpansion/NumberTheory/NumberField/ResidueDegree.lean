import MathlibExpansion.NumberTheory.DedekindIdeals.ResidueFields

/-!
# T20c_12_RESIDUE_DEGREE — Hecke Ch.V prime-decomposition corridor

`N(P) = p^f` for some rational prime `p` and residue degree `f`.
Encyclopedia alias of `exists_prime_nat_and_residue_degree`.

Citation: Hecke 1923 Ch.V; Neukirch 1999, *Algebraic Number Theory*, I §8.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

open scoped NumberField

theorem t20c_12_residue_degree
    {K : Type*} [Field K] [NumberField K]
    (P : IsDedekindDomain.HeightOneSpectrum (𝓞 K)) :
    ∃ p f : ℕ, Nat.Prime p ∧ Ideal.absNorm P.asIdeal = p ^ f :=
  MathlibExpansion.NumberTheory.exists_prime_nat_and_residue_degree (K := K) P

end MathlibExpansion.Encyclopedia.T20c_12
