import Mathlib.GroupTheory.Index
import Mathlib.GroupTheory.Perm.Subgroup

namespace MathlibExpansion
namespace GroupTheory
namespace PermutationGroups

/-- Cayley's theorem packaged in the local namespace. -/
noncomputable abbrev cayleyEmbedding (G H : Type*) [Group G] [MulAction G H] [FaithfulSMul G H] :
    G ≃* (MulAction.toPermHom G H).range :=
  Equiv.Perm.subgroupOfMulAction G H

/--
If a subgroup of permutations acts transitively on a finite set and has the same cardinality as the
underlying set, then every point stabilizer is trivial.
-/
theorem stabilizer_eq_bot_of_card_eq_degree {α : Type*} [Fintype α] [DecidableEq α]
    {G : Subgroup (Equiv.Perm α)} (htrans : MulAction.IsPretransitive G α)
    (hcard : Nat.card G = Nat.card α) :
    ∀ a : α, MulAction.stabilizer G a = ⊥ := by
  letI : MulAction.IsPretransitive G α := htrans
  intro a
  letI : Nonempty α := ⟨a⟩
  have hGpos : 0 < Nat.card G := by
    rw [hcard]
    exact Nat.card_pos
  have hindex : (MulAction.stabilizer G a).index = Nat.card G := by
    rw [MulAction.index_stabilizer_of_transitive (G := G) (x := a), hcard]
  have hmul := (MulAction.stabilizer G a).card_mul_index
  rw [hindex] at hmul
  have hstab : Nat.card (MulAction.stabilizer G a) = 1 := by
    refine Nat.eq_of_mul_eq_mul_right hGpos ?_
    simpa using hmul
  exact (Subgroup.card_eq_one (H := MulAction.stabilizer G a)).mp hstab

end PermutationGroups
end GroupTheory
end MathlibExpansion
