import MathlibExpansion.Logic.HilbertAckermann.SecondOrder.PredicateCalculus

/-!
# Hilbert-Ackermann Chapter IV number concept
-/

namespace MathlibExpansion.Logic.HilbertAckermann.SecondOrder

def HAIsNumberPredicate {α : Type*} (φ : (α → Prop) → Prop) : Prop :=
  (∀ F G, φ F ∧ φ G → Nonempty ({x // F x} ≃ {x // G x})) ∧
    (∀ F G, φ F → Nonempty ({x // F x} ≃ {x // G x}) → φ G)

theorem ha_numberPredicate_of_self {α : Type*} (F : α → Prop) :
    HAIsNumberPredicate (fun G : α → Prop => Nonempty ({x // G x} ≃ {x // F x})) := by
  constructor
  · intro G H hGH
    rcases hGH with ⟨hG, hH⟩
    exact ⟨hG.some.trans hH.some.symm⟩
  · intro G H hG hGH
    exact ⟨hGH.some.symm.trans hG.some⟩

theorem ha_numberPredicate_invariant {α : Type*} {φ : (α → Prop) → Prop}
    (hφ : HAIsNumberPredicate φ) {F G : α → Prop}
    (hF : φ F) (hFG : Nonempty ({x // F x} ≃ {x // G x})) : φ G :=
  hφ.2 F G hF hFG

end MathlibExpansion.Logic.HilbertAckermann.SecondOrder
