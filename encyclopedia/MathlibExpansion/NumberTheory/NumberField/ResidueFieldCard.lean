import MathlibExpansion.NumberTheory.DedekindIdeals.ResidueFields

/-!
# T20c_12_RESIDUE_FIELD_CARD — Hecke Ch.V prime-decomposition corridor

`|𝓞 K ⧸ P| = Ideal.absNorm P` for every nonzero prime ideal of the ring of
integers. Encyclopedia-facing alias of the substrate theorem
`MathlibExpansion.NumberTheory.natCard_residueField_eq_absNorm`.

Citation: Hecke 1923, *Vorlesungen über die Theorie der algebraischen Zahlen*,
Ch.V; Marcus 1977, *Number Fields*, §3.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

open scoped NumberField

theorem t20c_12_residueField_card
    {K : Type*} [Field K] [NumberField K]
    (P : IsDedekindDomain.HeightOneSpectrum (𝓞 K)) :
    Nat.card (𝓞 K ⧸ P.asIdeal) = Ideal.absNorm P.asIdeal :=
  MathlibExpansion.NumberTheory.natCard_residueField_eq_absNorm (K := K) P

end MathlibExpansion.Encyclopedia.T20c_12
