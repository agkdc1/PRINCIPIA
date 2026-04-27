import Mathlib

/-!
# Hilbert-Ackermann Chapter II combined calculus
-/

namespace MathlibExpansion.Logic.HilbertAckermann.ChapterII

def CombinedParticularAffirmative {α : Type*} (X Y : Set α) : Prop := (X ∩ Y).Nonempty
def CombinedUniversalNegative {α : Type*} (X Y : Set α) : Prop := Disjoint X Y

inductive HACategoricalForm
  | a
  | i
  | e
  | o
  deriving DecidableEq, Repr

def HACategoricalForm.Holds {α : Type*} : HACategoricalForm → Set α → Set α → Prop
  | .a, X, Y => X ⊆ Y
  | .i, X, Y => (X ∩ Y).Nonempty
  | .e, X, Y => Disjoint X Y
  | .o, X, Y => (X ∩ Yᶜ).Nonempty

theorem particularAffirmative_iff_not_universalNegative
    {α : Type*} {X Y : Set α} :
    CombinedParticularAffirmative X Y ↔ (X ∩ Y).Nonempty := by
  rfl

end MathlibExpansion.Logic.HilbertAckermann.ChapterII
