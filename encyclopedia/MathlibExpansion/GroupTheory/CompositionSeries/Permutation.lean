import Mathlib.GroupTheory.Perm.Subgroup
import MathlibExpansion.GroupTheory.CompositionSeries.Basic

namespace MathlibExpansion
namespace GroupTheory
namespace CompositionSeries

/--
Permutation-group wrapper for Jordan-Hölder uniqueness on subgroup chains.
-/
theorem subgroup_compositionSeries_equiv {α : Type*} [Fintype α] [DecidableEq α]
    (G : Subgroup (Equiv.Perm α)) {s₁ s₂ : GroupCompositionSeries G}
    (hb₁ : s₁.head = ⊥) (ht₁ : s₁.last = ⊤) (hb₂ : s₂.head = ⊥) (ht₂ : s₂.last = ⊤) :
    CompositionSeries.Equivalent s₁ s₂ :=
  group_jordan_holder_bot_top hb₁ ht₁ hb₂ ht₂

/-- The full symmetric group enjoys the same uniqueness statement as Jordan's permutation chains. -/
theorem permutationGroup_jordan_holder {α : Type*} [Fintype α] [DecidableEq α]
    {s₁ s₂ : GroupCompositionSeries (Equiv.Perm α)}
    (hb₁ : s₁.head = ⊥) (ht₁ : s₁.last = ⊤) (hb₂ : s₂.head = ⊥) (ht₂ : s₂.last = ⊤) :
    CompositionSeries.Equivalent s₁ s₂ :=
  group_jordan_holder_bot_top hb₁ ht₁ hb₂ ht₂

end CompositionSeries
end GroupTheory
end MathlibExpansion
