import Mathlib.FieldTheory.Galois.Basic
import Mathlib.FieldTheory.KrullTopology
import Mathlib.GroupTheory.OrderOfElement

namespace MathlibExpansion
namespace FieldTheory
namespace Galois

open scoped IntermediateField

variable {F : Type*} [Field F] {E : Type*} [Field E] [Algebra F E]

/-- The subgroup of `F`-automorphisms fixing a chosen element. -/
def pointStabilizerSubgroup (α : E) : Subgroup (E ≃ₐ[F] E) where
  carrier := { σ | σ α = α }
  one_mem' := by simp
  mul_mem' := by
    intro σ τ hσ hτ
    have hσ' : σ α = α := hσ
    have hτ' : τ α = α := hτ
    show (σ * τ) α = α
    calc
      σ (τ α) = σ α := by rw [hτ']
      _ = α := hσ'
  inv_mem' := by
    intro σ hσ
    have hσ' : σ α = α := hσ
    apply σ.injective
    calc
      σ (σ⁻¹ α) = α := σ.apply_symm_apply α
      _ = σ α := hσ'.symm

/--
Adjoining a single generator cuts the Galois group down to the subgroup fixing that generator.
-/
theorem fixingSubgroup_adjoin_simple_eq_pointStabilizer (α : E) :
    IntermediateField.fixingSubgroup (F⟮α⟯ : IntermediateField F E) =
      pointStabilizerSubgroup (F := F) α := by
  ext σ
  constructor
  · intro hσ
    show σ α = α
    exact (IntermediateField.mem_fixingSubgroup_iff _ _).mp hσ α
      (IntermediateField.mem_adjoin_simple_self F α)
  · intro hσα
    have hmem : α ∈ IntermediateField.fixedField (Subgroup.zpowers σ : Subgroup (E ≃ₐ[F] E)) := by
      rw [IntermediateField.mem_fixedField_iff]
      intro τ hτ
      simpa using smul_eq_self_of_mem_zpowers hτ (show σ • α = α by simpa using hσα)
    have hle :
        (F⟮α⟯ : IntermediateField F E) ≤
          IntermediateField.fixedField (Subgroup.zpowers σ : Subgroup (E ≃ₐ[F] E)) :=
      IntermediateField.adjoin_simple_le_iff.mpr hmem
    have hz :
        (Subgroup.zpowers σ : Subgroup (E ≃ₐ[F] E)) ≤
          IntermediateField.fixingSubgroup (F⟮α⟯ : IntermediateField F E) :=
      (IntermediateField.le_iff_le _ _).mp hle
    exact hz (Subgroup.mem_zpowers σ)

end Galois
end FieldTheory
end MathlibExpansion
