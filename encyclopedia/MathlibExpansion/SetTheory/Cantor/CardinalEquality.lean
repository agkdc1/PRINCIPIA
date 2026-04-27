import Mathlib.SetTheory.Cardinal.Basic

/-!
# Cantor cardinal equality for sets

This file packages Cantor's "same cardinal iff equivalent" slogan in the
modern subset-as-type presentation used by Mathlib.
-/

namespace MathlibExpansion.SetTheory.Cantor

theorem cardinal_eq_iff_nonempty_equiv (s : Set α) (t : Set β) :
    Cardinal.mk s = Cardinal.mk t ↔ Nonempty (s ≃ t) := by
  simpa using (_root_.Cardinal.eq (α := s) (β := t))

end MathlibExpansion.SetTheory.Cantor
