import Mathlib.Logic.Equiv.Set

/-!
# Cantor disjoint unions

This file packages the disjoint-union equivalence used in Cantor's additive
construction on cardinal magnitudes.
-/

namespace MathlibExpansion.SetTheory.Cantor

noncomputable def disjointUnionEquiv {α β : Type*} {s t : Set α} {s' t' : Set β}
    (hs : Disjoint s t) (hs' : Disjoint s' t') (e₁ : s ≃ s') (e₂ : t ≃ t') :
    (s ∪ t : Set α) ≃ (s' ∪ t' : Set β) := by
  classical
  exact (Equiv.Set.union hs).trans <| (e₁.sumCongr e₂).trans <| (Equiv.Set.union hs').symm

theorem disjoint_union_congr {α β : Type*} {s t : Set α} {s' t' : Set β}
    (hs : Disjoint s t) (hs' : Disjoint s' t') (e₁ : s ≃ s') (e₂ : t ≃ t') :
    Nonempty ((s ∪ t : Set α) ≃ (s' ∪ t' : Set β)) :=
  ⟨disjointUnionEquiv hs hs' e₁ e₂⟩

end MathlibExpansion.SetTheory.Cantor
