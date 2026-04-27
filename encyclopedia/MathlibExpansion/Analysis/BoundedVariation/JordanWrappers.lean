import Mathlib.Data.Real.Basic

import Mathlib.MeasureTheory.Integral.IntervalIntegral
import Mathlib.Order.Monotone.Extension
import Mathlib.Topology.EMetricSpace.BoundedVariation
import Mathlib.Topology.Order.LeftRightLim

noncomputable section

open MeasureTheory
open Set Filter Function

namespace MathlibExpansion
namespace Analysis
namespace BoundedVariation

/--
`BVJD_02`: bounded variation implies interval integrability on compact
intervals.

Classical source: Camille Jordan, 1881, "Sur la série de Fourier",
C. R. Acad. Sci. Paris 92, 228-230; formal discharge via Mathlib's
Jordan-decomposition theorem
`LocallyBoundedVariationOn.exists_monotoneOn_sub_monotoneOn` and monotone
interval integrability.
-/
theorem intervalIntegrable_of_locallyBoundedVariationOn {f : ℝ → ℝ} {a b : ℝ}
    (h : LocallyBoundedVariationOn f (Set.uIcc a b)) :
    IntervalIntegrable f volume a b := by
  rcases h.exists_monotoneOn_sub_monotoneOn with ⟨p, q, hp, hq, hpq⟩
  rw [hpq]
  exact hp.intervalIntegrable.sub hq.intervalIntegrable

/--
Auxiliary monotone extensions for Jordan-decomposition components on a compact
interval.

Classical source: Camille Jordan, 1881, "Sur la série de Fourier",
C. R. Acad. Sci. Paris 92, 228-230. Formal source:
`LocallyBoundedVariationOn.exists_monotoneOn_sub_monotoneOn` plus
`MonotoneOn.exists_monotone_extension`.
-/
private theorem exists_monotone_extensions_of_locallyBoundedVariationOn
    {f : ℝ → ℝ} {a b : ℝ}
    (h : LocallyBoundedVariationOn f (Set.Icc a b)) :
    ∃ p q P Q : ℝ → ℝ,
      MonotoneOn p (Set.Icc a b) ∧
        MonotoneOn q (Set.Icc a b) ∧
        Monotone P ∧
        Monotone Q ∧
        EqOn p P (Set.Icc a b) ∧
        EqOn q Q (Set.Icc a b) ∧
        f = p - q := by
  rcases h.exists_monotoneOn_sub_monotoneOn with ⟨p, q, hp, hq, hpq⟩
  have hp_bddBelow : BddBelow (p '' Set.Icc a b) := by
    by_cases hab : a ≤ b
    · exact hp.map_bddBelow (Subset.refl _) ⟨a, (fun y hy => hy.1), ⟨le_rfl, hab⟩⟩
    · simp [Set.Icc_eq_empty hab]
  have hp_bddAbove : BddAbove (p '' Set.Icc a b) := by
    by_cases hab : a ≤ b
    · exact hp.map_bddAbove (Subset.refl _) ⟨b, (fun y hy => hy.2), ⟨hab, le_rfl⟩⟩
    · simp [Set.Icc_eq_empty hab]
  have hq_bddBelow : BddBelow (q '' Set.Icc a b) := by
    by_cases hab : a ≤ b
    · exact hq.map_bddBelow (Subset.refl _) ⟨a, (fun y hy => hy.1), ⟨le_rfl, hab⟩⟩
    · simp [Set.Icc_eq_empty hab]
  have hq_bddAbove : BddAbove (q '' Set.Icc a b) := by
    by_cases hab : a ≤ b
    · exact hq.map_bddAbove (Subset.refl _) ⟨b, (fun y hy => hy.2), ⟨hab, le_rfl⟩⟩
    · simp [Set.Icc_eq_empty hab]
  rcases hp.exists_monotone_extension hp_bddBelow hp_bddAbove with ⟨P, hP, hpP⟩
  rcases hq.exists_monotone_extension hq_bddBelow hq_bddAbove with ⟨Q, hQ, hqQ⟩
  exact ⟨p, q, P, Q, hp, hq, hP, hQ, hpP, hqQ, hpq⟩

/--
`BVJD_03a`: discontinuities of a bounded-variation function on a compact
interval are at most countable.

Classical source: Camille Jordan, 1881, "Sur la série de Fourier",
C. R. Acad. Sci. Paris 92, 228-230. The proof uses Jordan decomposition and
Mathlib's theorem `Monotone.countable_not_continuousAt`.
-/
theorem countable_discontinuities_of_locallyBoundedVariationOn
    {f : ℝ → ℝ} {a b : ℝ}
    (h : LocallyBoundedVariationOn f (Set.Icc a b)) :
    Set.Countable {x | x ∈ Set.Icc a b ∧ ¬ ContinuousWithinAt f (Set.Icc a b) x} := by
  rcases exists_monotone_extensions_of_locallyBoundedVariationOn h with
    ⟨p, q, P, Q, _hp, _hq, hP, hQ, hpP, hqQ, hpq⟩
  have hP_count : Set.Countable {x | ¬ ContinuousAt P x} := hP.countable_not_continuousAt
  have hQ_count : Set.Countable {x | ¬ ContinuousAt Q x} := hQ.countable_not_continuousAt
  refine (hP_count.union hQ_count).mono ?_
  rintro x ⟨hxIcc, hxnot⟩
  by_contra hxmem
  have hxP : ContinuousAt P x := by
    by_contra hxP
    exact hxmem (Set.mem_union_left _ hxP)
  have hxQ : ContinuousAt Q x := by
    by_contra hxQ
    exact hxmem (Set.mem_union_right _ hxQ)
  have hsub : ContinuousWithinAt (fun y => P y - Q y) (Set.Icc a b) x :=
    (hxP.sub hxQ).continuousWithinAt
  have hf_eq : ∀ y ∈ Set.Icc a b, f y = P y - Q y := by
    intro y hy
    calc
      f y = p y - q y := by
        simpa [Pi.sub_apply] using congrFun hpq y
      _ = P y - Q y := by rw [hpP hy, hqQ hy]
  exact hxnot (hsub.congr_of_mem hf_eq hxIcc)

/--
`BVJD_03b`: a bounded-variation function admits one-sided limits from inside
the compact interval.

This is the endpoint-correct sharpening of the classical statement: bounded
variation on `Set.Icc a b` controls the strict left/right filters only after
restricting them to the interval. The unrestricted left filter at `a` and right
filter at `b` depend on values outside the interval.

Classical source: Camille Jordan, 1881, "Sur la série de Fourier",
C. R. Acad. Sci. Paris 92, 228-230; formal source:
`Monotone.tendsto_leftLim` and `Monotone.tendsto_rightLim`.
-/
theorem oneSidedLimitsWithin_Icc_of_locallyBoundedVariationOn
    {f : ℝ → ℝ} {a b : ℝ}
    (h : LocallyBoundedVariationOn f (Set.Icc a b)) :
    ∀ x ∈ Set.Icc a b,
      ∃ l r : ℝ,
        Filter.Tendsto f (nhdsWithin x (Set.Icc a b ∩ Set.Iio x)) (nhds l) ∧
          Filter.Tendsto f (nhdsWithin x (Set.Icc a b ∩ Set.Ioi x)) (nhds r) := by
  rcases exists_monotone_extensions_of_locallyBoundedVariationOn h with
    ⟨p, q, P, Q, _hp, _hq, hP, hQ, hpP, hqQ, hpq⟩
  intro x _hxIcc
  have hf_eq : ∀ y ∈ Set.Icc a b, f y = P y - Q y := by
    intro y hy
    calc
      f y = p y - q y := by
        simpa [Pi.sub_apply] using congrFun hpq y
      _ = P y - Q y := by rw [hpP hy, hqQ hy]
  refine ⟨Function.leftLim P x - Function.leftLim Q x,
    Function.rightLim P x - Function.rightLim Q x, ?_, ?_⟩
  · have hlim :
        Filter.Tendsto (fun y => P y - Q y) (nhdsWithin x (Set.Iio x))
          (nhds (Function.leftLim P x - Function.leftLim Q x)) :=
      (hP.tendsto_leftLim x).sub (hQ.tendsto_leftLim x)
    have hlim' :
        Filter.Tendsto (fun y => P y - Q y) (nhdsWithin x (Set.Icc a b ∩ Set.Iio x))
          (nhds (Function.leftLim P x - Function.leftLim Q x)) :=
      hlim.mono_left (nhdsWithin_mono x Set.inter_subset_right)
    exact Tendsto.congr'
      (mem_of_superset self_mem_nhdsWithin fun y hy => (hf_eq y hy.1).symm) hlim'
  · have hlim :
        Filter.Tendsto (fun y => P y - Q y) (nhdsWithin x (Set.Ioi x))
          (nhds (Function.rightLim P x - Function.rightLim Q x)) :=
      (hP.tendsto_rightLim x).sub (hQ.tendsto_rightLim x)
    have hlim' :
        Filter.Tendsto (fun y => P y - Q y) (nhdsWithin x (Set.Icc a b ∩ Set.Ioi x))
          (nhds (Function.rightLim P x - Function.rightLim Q x)) :=
      hlim.mono_left (nhdsWithin_mono x Set.inter_subset_right)
    exact Tendsto.congr'
      (mem_of_superset self_mem_nhdsWithin fun y hy => (hf_eq y hy.1).symm) hlim'

end BoundedVariation
end Analysis
end MathlibExpansion
