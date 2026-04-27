import Mathlib.GroupTheory.Index
import MathlibExpansion.FieldTheory.Galois.AdjunctionStabilizer

namespace MathlibExpansion
namespace FieldTheory
namespace Galois

open scoped IntermediateField

variable {F : Type*} [Field F] {E : Type*} [Field E] [Algebra F E]

/--
In a finite Galois extension, the orbit-stabilizer quotient for an element's
stabilizer agrees with the subgroup index.
-/
theorem quotient_eq_index [FiniteDimensional F E] [IsGalois F E] (α : E) :
    Nat.card (E ≃ₐ[F] E) / Nat.card (MulAction.stabilizer (E ≃ₐ[F] E) α) =
      (MulAction.stabilizer (E ≃ₐ[F] E) α).index := by
  classical
  let S : Subgroup (E ≃ₐ[F] E) := MulAction.stabilizer (E ≃ₐ[F] E) α
  letI : Fintype S := Fintype.ofFinite S
  have hmul : Nat.card S * S.index = Nat.card (E ≃ₐ[F] E) := by
    simpa [Nat.card_eq_fintype_card, S] using S.card_mul_index
  have hS0 : Nat.card S ≠ 0 := by
    simp [Nat.card_eq_fintype_card]
  exact (Nat.eq_div_of_mul_eq_right hS0 hmul).symm

/--
For `α` in a finite Galois extension `E/F`, the degree of the minimal
polynomial of `α` is the index of its stabilizer in `Gal(E/F)`.
-/
theorem minpoly_natDegree_eq_index_stabilizer [FiniteDimensional F E] [IsGalois F E]
    (α : E) :
    (minpoly F α).natDegree =
      Nat.card (E ≃ₐ[F] E) / Nat.card (MulAction.stabilizer (E ≃ₐ[F] E) α) := by
  classical
  let K : IntermediateField F E := F⟮α⟯
  let S : Subgroup (E ≃ₐ[F] E) := MulAction.stabilizer (E ≃ₐ[F] E) α
  letI : Fintype S := Fintype.ofFinite S
  have hfix :
      K.fixingSubgroup = pointStabilizerSubgroup (F := F) α :=
    fixingSubgroup_adjoin_simple_eq_pointStabilizer (F := F) (E := E) α
  have hpoint : pointStabilizerSubgroup (F := F) α = S := by
    ext σ
    rfl
  have hcardH : Nat.card S = Module.finrank K E := by
    simpa [Nat.card_eq_fintype_card, S, hpoint, hfix] using
      (IsGalois.card_fixingSubgroup_eq_finrank (F := F) (E := E) (K := K))
  have hdeg : Module.finrank F K = (minpoly F α).natDegree :=
    IntermediateField.adjoin.finrank (K := F) (L := E) (x := α) (IsIntegral.of_finite F α)
  have hdiv : Module.finrank F K = Nat.card (E ≃ₐ[F] E) / Nat.card S := by
    have hmul : Nat.card S * Module.finrank F K = Nat.card (E ≃ₐ[F] E) := by
      calc
        Nat.card S * Module.finrank F K =
            Module.finrank K E * Module.finrank F K := by
              rw [hcardH]
        _ = Module.finrank F E := by
          simpa [Nat.mul_comm] using (Module.finrank_mul_finrank F K E)
        _ = Nat.card (E ≃ₐ[F] E) := by
          simpa [Nat.card_eq_fintype_card] using
            (IsGalois.card_aut_eq_finrank (F := F) (E := E)).symm
    have hS0 : Nat.card S ≠ 0 := by
      simp [Nat.card_eq_fintype_card]
    exact Nat.eq_div_of_mul_eq_right hS0 hmul
  calc
    (minpoly F α).natDegree = Module.finrank F K := hdeg.symm
    _ = Nat.card (E ≃ₐ[F] E) / Nat.card S := hdiv
    _ = Nat.card (E ≃ₐ[F] E) / Nat.card (MulAction.stabilizer (E ≃ₐ[F] E) α) := rfl

/--
Van der Waerden's orbit phrasing: the degree of the minimal polynomial is the
cardinality of the Galois orbit of the element.
-/
theorem minpoly_natDegree_eq_orbit_ncard [FiniteDimensional F E] [IsGalois F E]
    (α : E) :
    (minpoly F α).natDegree = (MulAction.orbit (E ≃ₐ[F] E) α).ncard := by
  rw [minpoly_natDegree_eq_index_stabilizer (F := F) (E := E) α, quotient_eq_index (F := F) (E := E) α,
    ← MulAction.index_stabilizer]

end Galois
end FieldTheory
end MathlibExpansion
