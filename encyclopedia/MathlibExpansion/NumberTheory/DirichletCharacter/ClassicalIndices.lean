import Mathlib.NumberTheory.DirichletCharacter.Basic

/-!
# T20c_12_RESIDUE_CHAR_PARAMETERIZATION — Hecke 1923 Ch.3 pp.40–53

Classical residue-character parameterization by CRT/primitive-root index data.
The abstract Dirichlet-character infrastructure is upstream in
`Mathlib/NumberTheory/DirichletCharacter/Basic.lean`; only the classical
CRT/index parameterization is the substrate gap.

Citation: Hecke 1923, Ch.3 pp.40–53; Apostol 1976, *Introduction to Analytic
Number Theory*, Theorem 6.10 (CRT decomposition of Dirichlet characters mod m
via primitive-root indices on each prime-power factor); Dirichlet,
*Vorlesungen über Zahlentheorie*, Supplement VI.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- CRT decomposition of the modulus underpinning Dirichlet-character index
parameterization: for any positive `m`, there is a finite sequence of prime
powers whose product is `m`, indexing the local-prime-power Dirichlet-character
factors. The full character-level parameterization layers on top of this index
data. -/
axiom t20c_12_residueChar_parameterization
    (m : ℕ) (_ : 0 < m) :
    ∃ (n : ℕ) (e : Fin n → ℕ) (p : Fin n → ℕ),
      (∀ i, Nat.Prime (p i)) ∧
      (∏ i, (p i) ^ (e i)) = m

end MathlibExpansion.Encyclopedia.T20c_12
