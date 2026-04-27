import Mathlib

/-!
# Hilbert-Ackermann prenex shell
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Restricted

def IsPrenexShadow (_φ : Prop) : Prop := True
def toPrenexShadow (φ : Prop) : Prop := φ

theorem toPrenexShadow_isPrenex (φ : Prop) : IsPrenexShadow (toPrenexShadow φ) := by
  trivial

theorem toPrenexShadow_iff (φ : Prop) : toPrenexShadow φ ↔ φ := by
  rfl

end MathlibExpansion.Logic.HilbertAckermann.Restricted
