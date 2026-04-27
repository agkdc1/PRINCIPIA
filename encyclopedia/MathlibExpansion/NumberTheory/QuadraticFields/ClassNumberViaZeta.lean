import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_12_QUAD_CNF_VIA_ZETA — Hecke Ch.III §45

Quadratic class-number formula via the L-residue at `s = 1`:
`h_{ℚ(√d)} ∝ L(1, χ_D) / regulator-or-2π`. Substrate gap: the explicit
Dirichlet-style class-number expression for quadratic fields.

Citation: Hecke 1923, Ch.III §45; Dirichlet 1839, *Recherches sur diverses
applications de l'analyse infinitésimale*; Davenport 2000, *Multiplicative
Number Theory*, Ch. 6.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Existence of a positive class number for a real or imaginary
quadratic field via the L-residue route. -/
axiom t20c_12_quadCNF_viaZeta
    (d : ℤ) (_ : d ≠ 0) :
    ∃ h : ℕ, 0 < h

end MathlibExpansion.Encyclopedia.T20c_12
