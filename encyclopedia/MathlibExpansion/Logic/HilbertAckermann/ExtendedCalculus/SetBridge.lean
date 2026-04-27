import Mathlib
import MathlibExpansion.Logic.Frege.Functions

/-!
# Hilbert-Ackermann Chapter IV set bridge
-/

namespace MathlibExpansion.Logic.HilbertAckermann.ExtendedCalculus

open MathlibExpansion.Logic.Frege

def RespectsUnarySetExtensionality {α : Type*} (F : Set α → Prop) : Prop :=
  ∀ ⦃P Q : Set α⦄, P = Q → (F P ↔ F Q)

theorem conceptSet_or {α : Type*} (P Q : α → Prop) :
    conceptSet P ∪ conceptSet Q = conceptSet (fun x => P x ∨ Q x) := by
  ext x
  simp [conceptSet]

theorem conceptSet_and {α : Type*} (P Q : α → Prop) :
    conceptSet P ∩ conceptSet Q = conceptSet (fun x => P x ∧ Q x) := by
  ext x
  simp [conceptSet]

theorem conceptSet_subset_iff {α : Type*} {P Q : α → Prop} :
    conceptSet P ⊆ conceptSet Q ↔ ∀ x, P x → Q x := by
  constructor
  · intro h x hx
    exact h hx
  · intro h x hx
    exact h x hx

end MathlibExpansion.Logic.HilbertAckermann.ExtendedCalculus
