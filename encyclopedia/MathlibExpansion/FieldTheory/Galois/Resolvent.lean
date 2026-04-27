import Mathlib.FieldTheory.PolynomialGaloisGroup
import MathlibExpansion.FieldTheory.Galois.PrimitiveGeneratorForFixedField

namespace MathlibExpansion
namespace FieldTheory
namespace Galois

open scoped Polynomial IntermediateField

variable {F : Type*} [Field F] {E : Type*} [Field E] [Algebra F E]

/--
Data of a subgroup-index resolvent polynomial in Jordan's sense.
-/
structure ResolventData [FiniteDimensional F E] [IsGalois F E] (H : Subgroup (E ≃ₐ[F] E)) where
  polynomial : F[X]
  irreducible' : Irreducible polynomial
  natDegree_eq_index :
    polynomial.natDegree = Nat.card (E ≃ₐ[F] E) / Nat.card H

/-- A subgroup-index resolvent exists via a primitive generator of the fixed field. -/
theorem exists_resolventData_of_subgroup [FiniteDimensional F E] [IsGalois F E]
    (H : Subgroup (E ≃ₐ[F] E)) :
    Nonempty (ResolventData (F := F) (E := E) H) := by
  obtain ⟨α, _, hdeg⟩ := exists_primitive_generator_of_fixedField (F := F) (E := E) H
  exact ⟨{
    polynomial := minpoly F α
    irreducible' := minpoly.irreducible (IsIntegral.of_finite F α)
    natDegree_eq_index := hdeg
  }⟩

/-- A subgroup admits a resolvent polynomial whose degree is its index. -/
theorem exists_irreducible_resolvent_of_subgroup [FiniteDimensional F E] [IsGalois F E]
    (H : Subgroup (E ≃ₐ[F] E)) :
    ∃ p : F[X], Irreducible p ∧ p.natDegree = Nat.card (E ≃ₐ[F] E) / Nat.card H := by
  rcases exists_resolventData_of_subgroup (F := F) (E := E) H with ⟨R⟩
  exact ⟨R.polynomial, R.irreducible', R.natDegree_eq_index⟩

/-- The same resolvent package specialized to a fixing subgroup. -/
theorem exists_irreducible_resolvent_of_fixingSubgroup [FiniteDimensional F E] [IsGalois F E]
    (L : IntermediateField F E) :
    ∃ p : F[X], Irreducible p ∧
      p.natDegree = Nat.card (E ≃ₐ[F] E) / Nat.card L.fixingSubgroup :=
  exists_irreducible_resolvent_of_subgroup (F := F) (E := E) L.fixingSubgroup

end Galois
end FieldTheory
end MathlibExpansion
