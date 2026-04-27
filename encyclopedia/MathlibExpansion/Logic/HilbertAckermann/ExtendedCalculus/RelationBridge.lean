import Mathlib
import MathlibExpansion.Logic.Frege.Functions

/-!
# Hilbert-Ackermann Chapter IV relation bridge
-/

namespace MathlibExpansion.Logic.HilbertAckermann.ExtendedCalculus

def relationSet {α β : Type*} (R : α → β → Prop) : Set (α × β) := {p | R p.1 p.2}

def RespectsBinaryRelationExtensionality {α β : Type*}
    (F : Set (α × β) → Prop) : Prop :=
  ∀ ⦃R S : α → β → Prop⦄, relationSet R = relationSet S →
    (F (relationSet R) ↔ F (relationSet S))

theorem equiv_of_bijOn {α β : Type*} {s : Set α} {t : Set β} {f : α → β}
    (hf : Set.BijOn f s t) :
    Nonempty (s ≃ t) := by
  exact ⟨Set.BijOn.equiv f hf⟩

end MathlibExpansion.Logic.HilbertAckermann.ExtendedCalculus
