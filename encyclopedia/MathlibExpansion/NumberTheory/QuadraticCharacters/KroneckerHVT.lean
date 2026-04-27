import MathlibExpansion.NumberTheory.QuadraticCharacters.Kronecker

/-!
# T20c_12_QUAD_KRONECKER_CHAR — Hecke Ch.III §§49–52

The discriminant-indexed Kronecker quadratic character `χ_D` is constructed via
the Jacobi-symbol odd-denominator boundary in
`MathlibExpansion.NumberTheory.QuadraticCharacters.Kronecker` and exhibits a
positive-conductor packaging plus a textbook-facing reciprocity statement.
This encyclopedia file fixes the HVT-key alias.

Citation: Hecke 1923 Ch.III §§49–52; Davenport 2000, *Multiplicative Number
Theory*, §5.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

theorem t20c_12_quadKronecker_char_conductor_pos (D : ℤ) :
    0 < MathlibExpansion.NumberTheory.quadraticConductor D :=
  MathlibExpansion.NumberTheory.quadraticConductor_pos D

theorem t20c_12_quadKronecker_char_reciprocity {a b : ℕ}
    (ha : a % 2 = 1) (hb : b % 2 = 1) :
    (if a % 4 = 3 ∧ b % 4 = 3
        then -MathlibExpansion.NumberTheory.quadraticCharacterOfDiscr (b : ℤ) a
        else MathlibExpansion.NumberTheory.quadraticCharacterOfDiscr (b : ℤ) a) =
        MathlibExpansion.NumberTheory.quadraticCharacterOfDiscr (a : ℤ) b :=
  MathlibExpansion.NumberTheory.quadraticCharacterOfDiscr_quadraticReciprocity ha hb

end MathlibExpansion.Encyclopedia.T20c_12
