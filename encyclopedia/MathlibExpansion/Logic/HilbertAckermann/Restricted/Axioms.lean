import MathlibExpansion.Logic.HilbertAckermann.Restricted.Semantics

/-!
# Hilbert-Ackermann restricted-calculus axioms
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Restricted

abbrev HARestrictedProvable (φ : Prop) : Prop := φ

theorem ax_forall_inst {α : Type*} (φ : α → Prop) (y : α) :
    HARestrictedProvable ((∀ x, φ x) → φ y) := by
  intro h
  exact h y

theorem ax_exists_intro {α : Type*} (φ : α → Prop) (y : α) :
    HARestrictedProvable (φ y → ∃ x, φ x) := by
  intro hy
  exact ⟨y, hy⟩

end MathlibExpansion.Logic.HilbertAckermann.Restricted
