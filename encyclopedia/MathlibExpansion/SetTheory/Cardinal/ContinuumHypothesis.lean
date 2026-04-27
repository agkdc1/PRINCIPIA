import Mathlib.SetTheory.Cardinal.Aleph
import Mathlib.SetTheory.Cardinal.Continuum

/-!
# The continuum hypothesis

This file introduces a local `ContinuumHypothesis` proposition and packages the
standard "no intermediate cardinal" formulation.
-/

namespace MathlibExpansion.SetTheory.Cardinal

universe u

/-- The modern continuum hypothesis in Cantor's cardinal notation. -/
abbrev ContinuumHypothesis : Prop :=
  (_root_.Cardinal.aleph 1 : _root_.Cardinal.{u}) =
    (_root_.Cardinal.continuum : _root_.Cardinal.{u})

theorem continuumHypothesis_iff_no_intermediate :
    ((_root_.Cardinal.aleph 1 : _root_.Cardinal.{u}) =
      (_root_.Cardinal.continuum : _root_.Cardinal.{u})) ↔
      ¬ ∃ c : _root_.Cardinal.{u},
        _root_.Cardinal.aleph0 < c ∧ c < _root_.Cardinal.continuum := by
  constructor
  · intro hCH
    rintro ⟨c, hc0, hc1⟩
    have hAleph1 : _root_.Cardinal.aleph 1 ≤ c := by
      rw [← show Order.succ _root_.Cardinal.aleph0 = _root_.Cardinal.aleph 1 by
        simp [_root_.Cardinal.succ_aleph0]]
      exact Order.succ_le_of_lt hc0
    have hc1' : c < _root_.Cardinal.aleph 1 :=
      hc1.trans_le hCH.symm.le
    exact (not_le_of_gt hc1') hAleph1
  · intro hno
    have hle : _root_.Cardinal.aleph 1 ≤ _root_.Cardinal.continuum := by
      simpa using _root_.Cardinal.aleph_one_le_continuum
    rcases lt_or_eq_of_le hle with hlt | hEq
    · exfalso
      exact hno ⟨_root_.Cardinal.aleph 1, by simpa using _root_.Cardinal.aleph0_lt_aleph_one, hlt⟩
    · exact hEq

end MathlibExpansion.SetTheory.Cardinal
