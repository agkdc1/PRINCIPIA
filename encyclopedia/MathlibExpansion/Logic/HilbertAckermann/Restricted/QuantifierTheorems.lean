import MathlibExpansion.Logic.HilbertAckermann.Restricted.DerivedRules

/-!
# Hilbert-Ackermann restricted-calculus quantifier theorems
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Restricted

open Classical

theorem provable_forall_imp_exists {α : Type*} [Inhabited α] (φ : α → Prop) :
    HARestrictedProvable ((∀ x, φ x) → ∃ x, φ x) := by
  intro h
  exact ⟨default, h default⟩

theorem provable_forall_or_imp_transport {α : Type*} (A : Prop) (φ : α → Prop) :
    HARestrictedProvable
      (((∀ x, A ∨ φ x) ↔ (A ∨ ∀ x, φ x)) ∧
        ((∀ x, A → φ x) ↔ (A → ∀ x, φ x))) := by
  constructor
  · constructor
    · intro h
      by_cases hA : A
      · exact Or.inl hA
      · exact Or.inr (by intro x; rcases h x with hAx | hφx; exact False.elim (hA hAx); exact hφx)
    · rintro (hA | hAll) x
      · exact Or.inl hA
      · exact Or.inr (hAll x)
  · constructor
    · intro h hA x
      exact h x hA
    · intro h x hA
      exact h hA x

theorem provable_forall_and_transport {α : Type*} [Inhabited α] (A : Prop) (φ : α → Prop) :
    HARestrictedProvable ((∀ x, A ∧ φ x) ↔ (A ∧ ∀ x, φ x)) := by
  constructor
  · intro h
    refine ⟨(h default).1, ?_⟩
    intro x
    exact (h x).2
  · rintro ⟨hA, hφ⟩ x
    exact ⟨hA, hφ x⟩

theorem provable_forall_comm {α : Type*} (φ : α → α → Prop) :
    HARestrictedProvable ((∀ x, ∀ y, φ x y) ↔ ∀ y, ∀ x, φ x y) := by
  exact forall_forall_comm

theorem provable_quantifier_monotone_transport {α : Type*} (φ ψ : α → Prop) :
    HARestrictedProvable
      (((∀ x, φ x → ψ x) → ((∀ x, φ x) → ∀ x, ψ x)) ∧
        (((∀ x, φ x ↔ ψ x) → (((∀ x, φ x) ↔ (∀ x, ψ x)) ∧
          ((∃ x, φ x) ↔ ∃ x, ψ x))))) := by
  constructor
  · intro h hAll x
    exact h x (hAll x)
  · intro hEq
    constructor
    · constructor
      · intro hAll x
        exact (hEq x).1 (hAll x)
      · intro hAll x
        exact (hEq x).2 (hAll x)
    · constructor
      · rintro ⟨x, hx⟩
        exact ⟨x, (hEq x).1 hx⟩
      · rintro ⟨x, hx⟩
        exact ⟨x, (hEq x).2 hx⟩

theorem provable_exists_forall_to_forall_exists {α : Type*} (φ : α → α → Prop) :
    HARestrictedProvable ((∃ x, ∀ y, φ x y) → ∀ y, ∃ x, φ x y) := by
  rintro ⟨x, hx⟩ y
  exact ⟨x, hx y⟩

end MathlibExpansion.Logic.HilbertAckermann.Restricted
