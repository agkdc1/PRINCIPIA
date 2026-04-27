import Mathlib.FieldTheory.PrimitiveElement
import MathlibExpansion.FieldTheory.Galois.StabilizerDegree

namespace MathlibExpansion
namespace FieldTheory
namespace Galois

open scoped IntermediateField

variable {F : Type*} [Field F] {E : Type*} [Field E] [Algebra F E]

/--
Every subgroup of a finite Galois group is the fixing subgroup of a single
primitive generator of its fixed field.
-/
theorem exists_generator_of_fixedField_fixingSubgroup [FiniteDimensional F E] [IsGalois F E]
    (H : Subgroup (E ≃ₐ[F] E)) :
    ∃ α : E,
      IntermediateField.fixingSubgroup (F⟮α⟯ : IntermediateField F E) = H := by
  let K : IntermediateField F E := IntermediateField.fixedField H
  obtain ⟨α, hα⟩ := Field.exists_primitive_element F K
  refine ⟨α, ?_⟩
  have hle : (F⟮(α : E)⟯ : IntermediateField F E) ≤ K := by
    rw [IntermediateField.adjoin_simple_le_iff]
    exact α.2
  have hfinrank :
      Module.finrank F K =
        Module.finrank F (F⟮(α : E)⟯ : IntermediateField F E) := by
    have hnat : (minpoly F α).natDegree = Module.finrank F K :=
      (Field.primitive_element_iff_minpoly_natDegree_eq (F := F) (E := K) α).mp hα
    calc
      Module.finrank F K = (minpoly F α).natDegree := hnat.symm
      _ = (minpoly F (α : E)).natDegree := by rw [IntermediateField.minpoly_eq]
      _ = Module.finrank F (F⟮(α : E)⟯ : IntermediateField F E) := by
        symm
        exact IntermediateField.adjoin.finrank
          (K := F) (L := E) (x := α) (IsIntegral.of_finite F (α : E))
  have hEq : (F⟮(α : E)⟯ : IntermediateField F E) = K :=
    IntermediateField.eq_of_le_of_finrank_eq hle hfinrank.symm
  rw [hEq]
  exact IntermediateField.fixingSubgroup_fixedField H

/--
Every subgroup of `Gal(E/F)` arises from a primitive generator of its fixed
field, and the generator's minimal polynomial has degree equal to the subgroup
index.
-/
theorem exists_primitive_generator_of_fixedField [FiniteDimensional F E] [IsGalois F E]
    (H : Subgroup (E ≃ₐ[F] E)) :
    ∃ α : E, IntermediateField.fixingSubgroup (F⟮α⟯ : IntermediateField F E) = H ∧
      (minpoly F α).natDegree = Nat.card (E ≃ₐ[F] E) / Nat.card H := by
  obtain ⟨α, hfix⟩ := exists_generator_of_fixedField_fixingSubgroup (F := F) (E := E) H
  refine ⟨α, hfix, ?_⟩
  have hstab : MulAction.stabilizer (E ≃ₐ[F] E) α = H := by
    calc
      MulAction.stabilizer (E ≃ₐ[F] E) α =
          pointStabilizerSubgroup (F := F) α := by
            ext σ
            rfl
      _ = IntermediateField.fixingSubgroup (F⟮α⟯ : IntermediateField F E) := by
            symm
            exact fixingSubgroup_adjoin_simple_eq_pointStabilizer (F := F) (E := E) α
      _ = H := hfix
  simpa [hstab] using minpoly_natDegree_eq_index_stabilizer (F := F) (E := E) α

end Galois
end FieldTheory
end MathlibExpansion
