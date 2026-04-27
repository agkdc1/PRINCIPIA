import Mathlib.SetTheory.Cardinal.Aleph
import Mathlib.SetTheory.Ordinal.Basic

/-!
# Cantor's second number-class

This file packages the set of countable infinite ordinals under Cantor's
historical "second number-class" name.
-/

namespace MathlibExpansion.SetTheory.Ordinal

universe u

def secondNumberClass : Set _root_.Ordinal.{u} :=
  {o | _root_.Ordinal.omega0 ≤ o ∧ o.card ≤ _root_.Cardinal.aleph0}

@[simp] theorem mem_secondNumberClass_iff {o : _root_.Ordinal.{u}} :
    o ∈ secondNumberClass ↔
      _root_.Ordinal.omega0 ≤ o ∧ o.card ≤ _root_.Cardinal.aleph0 :=
  Iff.rfl

theorem mem_secondNumberClass_iff_card_eq_aleph0 {o : _root_.Ordinal.{u}} :
    o ∈ secondNumberClass ↔ o.card = _root_.Cardinal.aleph0 := by
  constructor
  · intro h
    have hle : _root_.Cardinal.aleph0 ≤ o.card := (_root_.Ordinal.aleph0_le_card).2 h.1
    exact le_antisymm h.2 hle
  · intro h
    constructor
    · exact (_root_.Ordinal.aleph0_le_card).1 h.symm.le
    · exact h.le

end MathlibExpansion.SetTheory.Ordinal
