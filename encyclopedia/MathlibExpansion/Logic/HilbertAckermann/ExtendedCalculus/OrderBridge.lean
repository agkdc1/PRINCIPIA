import Mathlib

/-!
# Hilbert-Ackermann Chapter IV order bridge
-/

namespace MathlibExpansion.Logic.HilbertAckermann.ExtendedCalculus

def HAOrderedBy {α : Type*} (P : Set α) (r : α → α → Prop) : Prop :=
  Irreflexive r ∧ Transitive r ∧
    ∀ ⦃x⦄, x ∈ P → ∀ ⦃y⦄, y ∈ P → x ≠ y → r x y ∨ r y x

def HAWellOrderedBy {α : Type*} (P : Set α) (r : α → α → Prop) : Prop :=
  HAOrderedBy P r ∧
    ∀ Q : Set α, Q ⊆ P → Q.Nonempty →
      ∃ y ∈ Q, ∀ z ∈ Q, y = z ∨ r y z

theorem haWellOrderedBy_of_subsingleton {α : Type*} {P : Set α} {r : α → α → Prop}
    (hirr : Irreflexive r) (htrans : Transitive r) (hP : Set.Subsingleton P) :
    HAWellOrderedBy P r := by
  refine ⟨?_, ?_⟩
  · refine ⟨?_, ?_, ?_⟩
    · exact hirr
    · exact htrans
    · intro x hx y hy hxy
      exact False.elim (hxy (hP hx hy))
  · intro Q hQP hQ
    rcases hQ with ⟨y, hy⟩
    refine ⟨y, hy, ?_⟩
    intro z hz
    exact Or.inl (hP (hQP hy) (hQP hz))

end MathlibExpansion.Logic.HilbertAckermann.ExtendedCalculus
