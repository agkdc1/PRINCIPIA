import MathlibExpansion.Logic.HilbertAckermann.Restricted.QuantifierTheorems

/-!
# Hilbert-Ackermann derivability from premises
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Restricted

def HARestrictedProvableFrom (Γ : Set Prop) (φ : Prop) : Prop :=
  (∀ ψ, ψ ∈ Γ → ψ) → φ

theorem provableFrom_mono {Γ Δ : Set Prop} {φ : Prop} (hΓΔ : Γ ⊆ Δ) :
    HARestrictedProvableFrom Γ φ → HARestrictedProvableFrom Δ φ := by
  intro hΓ hΔ
  apply hΓ
  intro ψ hψ
  exact hΔ ψ (hΓΔ hψ)

end MathlibExpansion.Logic.HilbertAckermann.Restricted
