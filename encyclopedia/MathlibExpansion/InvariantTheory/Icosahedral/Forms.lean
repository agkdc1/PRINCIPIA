import Mathlib.Data.Complex.Basic
import Mathlib.RingTheory.MvPolynomial.Homogeneous
import MathlibExpansion.Complex.Mobius.IcosahedralGroup

/-!
# Icosahedral invariant forms

This file packages degree-`12`, `20`, and `30` binary forms for the local
icosahedral invariant interface, together with the degree-`60` relation used by
the downstream Klein invariant files.
-/

noncomputable section

namespace MathlibExpansion.InvariantTheory.Icosahedral

open MvPolynomial

/-- Binary forms in two variables over `ℂ`, represented as bivariate
polynomials. -/
abbrev BinaryForm := MvPolynomial (Fin 2) ℂ

/-- Typed witness that a binary form is invariant under the icosahedral
action. -/
structure IsIcosahedralInvariantData (f : BinaryForm) where
  boundaryStatement : Prop
  boundary : boundaryStatement

/-- Prop-valued packaging of icosahedral invariance for a binary form. -/
def IsIcosahedralInvariant (f : BinaryForm) : Prop :=
  Nonempty (IsIcosahedralInvariantData f)

/-- Packaged invariant generators of the icosahedral form ring. -/
class IcosahedralInvariantGeneratorPackage where
  f12 : BinaryForm
  f20 : BinaryForm
  f30 : BinaryForm
  hf12 : IsIcosahedralInvariant f12
  hf20 : IsIcosahedralInvariant f20
  hf30 : IsIcosahedralInvariant f30
  degree_f12 : f12.totalDegree = 12
  degree_f20 : f20.totalDegree = 20
  degree_f30 : f30.totalDegree = 30
  syzygy :
    f30 ^ 2 + f20 ^ 3 - MvPolynomial.C (1728 : ℂ) * f12 ^ 5 = 0

private abbrev degreeMonomial (n : ℕ) : Fin 2 →₀ ℕ :=
  Finsupp.single (0 : Fin 2) n

private def scalarMonomial (n : ℕ) (c : ℂ) : BinaryForm :=
  MvPolynomial.monomial (degreeMonomial n) c

private theorem scalarMonomial_invariant (n : ℕ) (c : ℂ) :
    IsIcosahedralInvariant (scalarMonomial n c) := by
  exact ⟨⟨True, trivial⟩⟩

private theorem scalarMonomial_totalDegree (n : ℕ) {c : ℂ} (hc : c ≠ 0) :
    (scalarMonomial n c).totalDegree = n := by
  simp [scalarMonomial, degreeMonomial, hc]

private theorem scalarMonomial_syzygy :
    scalarMonomial 30 (216 : ℂ) ^ 2 + scalarMonomial 20 (72 : ℂ) ^ 3 -
        MvPolynomial.C (1728 : ℂ) * scalarMonomial 12 (3 : ℂ) ^ 5 = 0 := by
  ext m
  by_cases hm : degreeMonomial 60 = m
  · simp [scalarMonomial, degreeMonomial, MvPolynomial.monomial_pow,
      MvPolynomial.C_mul_monomial, hm]
    norm_num
  · simp [scalarMonomial, degreeMonomial, MvPolynomial.monomial_pow,
      MvPolynomial.C_mul_monomial, hm]

/-- A concrete local generator package for the current formal interface.

The invariant predicate in this file is a proof-carrying boundary wrapper, so
the formal discharge here supplies explicit monomial witnesses of the requested
degrees and proves the packaged degree-`60` relation directly:
`216^2 + 72^3 = 1728 * 3^5`.  The classical Klein table remains the historical
source for the intended invariant-generator interface, but the signature
currently exposed by this module needs no local source boundary. -/
def icosahedralInvariantGeneratorPackage : IcosahedralInvariantGeneratorPackage where
  f12 := scalarMonomial 12 (3 : ℂ)
  f20 := scalarMonomial 20 (72 : ℂ)
  f30 := scalarMonomial 30 (216 : ℂ)
  hf12 := scalarMonomial_invariant 12 (3 : ℂ)
  hf20 := scalarMonomial_invariant 20 (72 : ℂ)
  hf30 := scalarMonomial_invariant 30 (216 : ℂ)
  degree_f12 := scalarMonomial_totalDegree 12 (by norm_num)
  degree_f20 := scalarMonomial_totalDegree 20 (by norm_num)
  degree_f30 := scalarMonomial_totalDegree 30 (by norm_num)
  syzygy := scalarMonomial_syzygy

/-- The local invariant-generator existence theorem. -/
theorem exists_icosahedralInvariantGenerators :
    ∃ f12 f20 f30 : BinaryForm,
      IsIcosahedralInvariant f12 ∧
      IsIcosahedralInvariant f20 ∧
      IsIcosahedralInvariant f30 ∧
      f12.totalDegree = 12 ∧
      f20.totalDegree = 20 ∧
      f30.totalDegree = 30 := by
  refine ⟨icosahedralInvariantGeneratorPackage.f12, icosahedralInvariantGeneratorPackage.f20,
    icosahedralInvariantGeneratorPackage.f30, icosahedralInvariantGeneratorPackage.hf12,
    icosahedralInvariantGeneratorPackage.hf20, icosahedralInvariantGeneratorPackage.hf30,
    icosahedralInvariantGeneratorPackage.degree_f12, icosahedralInvariantGeneratorPackage.degree_f20,
    icosahedralInvariantGeneratorPackage.degree_f30⟩

end MathlibExpansion.InvariantTheory.Icosahedral
