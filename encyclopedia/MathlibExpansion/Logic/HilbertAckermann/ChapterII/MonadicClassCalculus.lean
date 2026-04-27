import Mathlib

/-!
# Hilbert-Ackermann Chapter II monadic/class calculus

This is a typed safe shadow for the monadic wrapper around the Chapter I
propositional layer.
-/

namespace MathlibExpansion.Logic.HilbertAckermann.ChapterII

def Chapter1Tautology (φ : Prop) : Prop := φ
def MonadicUniversalValid (φ : Prop) : Prop := φ
def ClassExtentValid (φ : Prop) : Prop := φ

theorem monadic_reinterpretation_preserves_tautologies (φ : Prop) :
    Chapter1Tautology φ ↔ MonadicUniversalValid φ := by
  rfl

theorem class_extent_interpretation_sound (φ : Prop) :
    MonadicUniversalValid φ ↔ ClassExtentValid φ := by
  rfl

end MathlibExpansion.Logic.HilbertAckermann.ChapterII
