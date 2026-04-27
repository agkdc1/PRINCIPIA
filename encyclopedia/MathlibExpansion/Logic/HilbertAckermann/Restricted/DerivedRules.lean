import MathlibExpansion.Logic.HilbertAckermann.Restricted.Derivability

/-!
# Hilbert-Ackermann restricted-calculus derived rules
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Restricted

theorem generalize_closed {α : Type*} (φ : α → Prop) :
    HARestrictedProvable (∀ x, φ x) → HARestrictedProvable (∀ x, φ x) := by
  intro h
  exact h

theorem rename_variables_preserves_provable {α β : Type*} (ρ : α ≃ β) {φ : β → Prop} :
    HARestrictedProvable (∀ y, φ y) → HARestrictedProvable (∀ x, φ (ρ x)) := by
  intro h x
  exact h (ρ x)

end MathlibExpansion.Logic.HilbertAckermann.Restricted
