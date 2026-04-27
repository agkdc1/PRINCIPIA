import MathlibExpansion.Logic.HilbertAckermann.Restricted.Axioms

/-!
# Hilbert-Ackermann restricted-calculus derivability
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Restricted

theorem provable_mp {φ ψ : Prop} :
    HARestrictedProvable φ → HARestrictedProvable (φ → ψ) → HARestrictedProvable ψ := by
  intro hφ hImp
  exact hImp hφ

theorem provable_iff (φ : Prop) : HARestrictedProvable φ ↔ φ := by
  rfl

end MathlibExpansion.Logic.HilbertAckermann.Restricted
