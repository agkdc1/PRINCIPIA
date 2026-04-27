import MathlibExpansion.Logic.HilbertAckermann.Restricted.Prenex

/-!
# Hilbert-Ackermann Skolem-syntax shell
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Restricted

structure HASkolemSyntax (α : Type*) where
  body : α → Prop

def IsSkolemNormalForm {α : Type*} (_φ : HASkolemSyntax α) : Prop := True

theorem skolemSyntax_is_skolemNormalForm {α : Type*} (φ : HASkolemSyntax α) :
    IsSkolemNormalForm φ := by
  trivial

end MathlibExpansion.Logic.HilbertAckermann.Restricted
