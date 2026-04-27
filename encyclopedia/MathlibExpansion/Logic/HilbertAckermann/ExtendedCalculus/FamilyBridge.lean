import Mathlib

/-!
# Hilbert-Ackermann Chapter IV family bridge
-/

namespace MathlibExpansion.Logic.HilbertAckermann.ExtendedCalculus

theorem family_of_sets_eq_iff {α : Type*} {F G : Set (Set α)} :
    F = G ↔ ∀ P : Set α, P ∈ F ↔ P ∈ G := by
  constructor
  · intro h P
    simpa [h]
  · intro h
    ext P
    exact h P

theorem mem_sUnion_iff {α : Type*} {x : α} {F : Set (Set α)} :
    x ∈ ⋃₀ F ↔ ∃ P ∈ F, x ∈ P := by
  simp

theorem mem_sInter_iff {α : Type*} {x : α} {F : Set (Set α)} :
    x ∈ ⋂₀ F ↔ ∀ P ∈ F, x ∈ P := by
  simp

end MathlibExpansion.Logic.HilbertAckermann.ExtendedCalculus
