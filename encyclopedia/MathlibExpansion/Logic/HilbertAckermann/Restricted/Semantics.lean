import MathlibExpansion.Logic.HilbertAckermann.Restricted.Syntax

/-!
# Hilbert-Ackermann restricted-calculus semantic shell
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Restricted

def HARestrictedSatisfiable (φ : Prop) : Prop := φ
def HARestrictedValid (φ : Prop) : Prop := φ

theorem restricted_exists_duality {α : Type*} {φ : α → Prop} :
    (∃ x, φ x) ↔ ¬ ∀ x, ¬ φ x := by
  simpa using exists_not_of_not_forall

theorem restricted_forall_duality {α : Type*} {φ : α → Prop} :
    (∀ x, φ x) ↔ ¬ ∃ x, ¬ φ x := by
  simpa using not_exists_not

end MathlibExpansion.Logic.HilbertAckermann.Restricted
