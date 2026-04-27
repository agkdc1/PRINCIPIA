import Mathlib.FieldTheory.Finite.GaloisField
import Mathlib.FieldTheory.PrimitiveElement
import Mathlib.Algebra.Algebra.ZMod

/-!
# Primitive generators and irreducible degrees over finite prime fields

This chapter covers the low-risk half of Steinitz `FFC_07`.

The primitive-generator statement is already an immediate consequence of
Mathlib's finite-field primitive element theorem. The irreducible-polynomial
existence statement follows from the `GaloisField p n` construction and the
degree computation for a primitive generator.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 15`,
  theorem `7`.
-/

noncomputable section

open scoped Classical

namespace MathlibExpansion.FieldTheory.Finite

open IntermediateField

variable {K : Type*} [Field K] [Fintype K]
variable (p : ℕ) [Fact p.Prime] [Algebra (ZMod p) K]

/-- Every finite field is simple over its prime field.

Primary source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 15`, theorem `7`; discharged by Mathlib
`Field.exists_primitive_element_of_finite_top`. -/
theorem exists_primitive_generator_of_finiteField :
    ∃ α : K, IntermediateField.adjoin (ZMod p) ({α} : Set K) = ⊤ := by
  haveI : _root_.Finite K := _root_.Finite.of_fintype K
  simpa using Field.exists_primitive_element_of_finite_top (ZMod p) K

/-- For every positive degree there is an irreducible polynomial of that degree
over `ZMod p`.

Primary source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 15`, theorem `7`; discharged via Mathlib `GaloisField p n`,
`Field.exists_primitive_element_of_finite_top`, and `GaloisField.finrank`. -/
theorem exists_irreducible_zmod_natDegree
    (n : ℕ) (hn : 0 < n) :
    ∃ f : Polynomial (ZMod p), Irreducible f ∧ f.natDegree = n := by
  let E := GaloisField p n
  obtain ⟨α, hα⟩ := Field.exists_primitive_element_of_finite_top (ZMod p) E
  refine ⟨minpoly (ZMod p) α, minpoly.irreducible (IsIntegral.of_finite (ZMod p) α), ?_⟩
  have hn0 : n ≠ 0 := Nat.ne_of_gt hn
  have hdeg :
      (minpoly (ZMod p) α).natDegree = Module.finrank (ZMod p) E :=
    (Field.primitive_element_iff_minpoly_natDegree_eq (F := ZMod p) (E := E) α).mp hα
  simpa [E, GaloisField.finrank p hn0] using hdeg

end MathlibExpansion.FieldTheory.Finite
