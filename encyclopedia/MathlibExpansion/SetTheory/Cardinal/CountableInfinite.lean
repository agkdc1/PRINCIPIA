import Mathlib.Logic.Denumerable
import Mathlib.SetTheory.Cardinal.Basic

/-!
# Countable infinite cardinals

This file packages the textbook-facing equivalence between having cardinal
`ℵ₀` and being countably infinite.
-/

namespace MathlibExpansion.SetTheory.Cardinal

theorem mk_eq_aleph0_iff_countable_infinite (α : Type*) :
    _root_.Cardinal.mk α = _root_.Cardinal.aleph0 ↔ Countable α ∧ Infinite α := by
  constructor
  · intro h
    exact nonempty_denumerable_iff.mp (_root_.Cardinal.denumerable_iff.mpr h)
  · intro h
    exact _root_.Cardinal.denumerable_iff.mp (nonempty_denumerable_iff.mpr h)

end MathlibExpansion.SetTheory.Cardinal
