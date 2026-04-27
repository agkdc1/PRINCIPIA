import MathlibExpansion.Logic.HilbertAckermann.Restricted.DerivabilityFrom

/-!
# Hilbert-Ackermann contextual replacement
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Restricted

structure FormulaCtx where
  fill : Prop → Prop
  congr : ∀ {φ ψ : Prop}, (φ ↔ ψ) → (fill φ ↔ fill ψ)

theorem ha_replacement_rule (C : FormulaCtx) {φ ψ : Prop} (h : φ ↔ ψ) :
    C.fill φ ↔ C.fill ψ :=
  C.congr h

end MathlibExpansion.Logic.HilbertAckermann.Restricted
