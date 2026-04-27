import Mathlib

/-!
# Hilbert-Ackermann restricted-calculus syntax shell

This file keeps a thin typed wrapper around the existing first-order APIs while
also exposing the safe-shadow predicate forms used by the sibling-library
breach files.
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Restricted

abbrev HLanguage := FirstOrder.Language
abbrev HARestrictedUnaryFormula (α : Type*) := α → Prop
abbrev HARestrictedBinaryFormula (α : Type*) := α → α → Prop
abbrev HARestrictedSentence := Prop

theorem forall_forall_comm {α β : Type*} {A : α → β → Prop} :
    (∀ x, ∀ y, A x y) ↔ ∀ y, ∀ x, A x y := by
  constructor <;> intro h <;> intro _ <;> intro _ <;> exact h _ _

theorem exists_exists_comm {α β : Type*} {A : α → β → Prop} :
    (∃ x, ∃ y, A x y) ↔ ∃ y, ∃ x, A x y := by
  constructor
  · rintro ⟨x, y, hxy⟩
    exact ⟨y, x, hxy⟩
  · rintro ⟨y, x, hxy⟩
    exact ⟨x, y, hxy⟩

theorem exists_forall_imp_forall_exists {α β : Type*} {A : α → β → Prop} :
    (∃ y, ∀ x, A x y) → ∀ x, ∃ y, A x y := by
  rintro ⟨y, hy⟩ x
  exact ⟨y, hy x⟩

end MathlibExpansion.Logic.HilbertAckermann.Restricted
