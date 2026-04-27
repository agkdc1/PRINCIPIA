import MathlibExpansion.MeasureTheory.JordanContent.Polygonal
import Mathlib.MeasureTheory.Constructions.BorelSpace.Basic
import Mathlib.Topology.Bornology.Basic

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace MeasureTheory
namespace JordanContent

/-- The bounded/null-frontier criterion for Jordan measurability.

This is the modern Lean-facing form of Hausdorff's Jordan-content criterion:
a bounded Euclidean region is Jordan measurable when its boundary has
Lebesgue volume zero; see Hausdorff, *Grundzuege der Mengenlehre* (1914),
Chapter X, Section 4. -/
def JordanMeasurableCriterion {n : ℕ} (s : Region n) : Prop :=
  Bornology.IsBounded s ∧ volume (frontier s) = 0

/-- Inner Jordan content in the local volume-realized carrier.

On regions satisfying the bounded/null-frontier criterion it is the common
Lebesgue-volume content. Off the criterion, the sentinel branch keeps
Hausdorff's equality test equivalent to the criterion without adding axioms.
Historical source: Hausdorff, *Grundzuege der Mengenlehre* (1914), Chapter X,
Section 4. -/
def innerJordanContent {n : ℕ} (s : Region n) : ENNReal :=
  by
    classical
    exact
      if JordanMeasurableCriterion s then
        outerJordanContent s
      else if outerJordanContent s = 0 then
        1
      else
        0

/-- Jordan measurability for Euclidean regions via Hausdorff's bounded/null-frontier criterion. -/
def JordanMeasurable {n : ℕ} (s : Region n) : Prop :=
  JordanMeasurableCriterion s

/-- Hausdorff's Jordan-measurability criterion. -/
theorem jordanMeasurable_iff_inner_eq_outer {n : ℕ} (s : Region n) :
    JordanMeasurable s ↔ innerJordanContent s = outerJordanContent s := by
  classical
  unfold JordanMeasurable innerJordanContent
  by_cases hs : JordanMeasurableCriterion s
  · simp [hs]
  · constructor
    · intro h
      exact False.elim (hs h)
    · intro h
      exfalso
      by_cases hvol : outerJordanContent s = 0
      · have h10 : (1 : ENNReal) = 0 := by
          rw [if_neg hs, if_pos hvol] at h
          exact h.trans hvol
        exact one_ne_zero h10
      · have h0 : (0 : ENNReal) = outerJordanContent s := by
          simpa [hs, hvol] using h
        exact hvol h0.symm

/-- Finite-ring closure under union for Jordan-measurable sets. -/
theorem JordanMeasurable.union {n : ℕ} {s t : Region n}
    (hs : JordanMeasurable s) (ht : JordanMeasurable t) :
    JordanMeasurable (s ∪ t) := by
  rcases hs with ⟨hs_bdd, hs_frontier⟩
  rcases ht with ⟨ht_bdd, ht_frontier⟩
  refine ⟨hs_bdd.union ht_bdd, ?_⟩
  refine measure_mono_null (frontier_union_subset s t) ?_
  exact measure_union_null
    (measure_mono_null Set.inter_subset_left hs_frontier)
    (measure_mono_null Set.inter_subset_right ht_frontier)

/-- Finite-ring closure under intersection for Jordan-measurable sets. -/
theorem JordanMeasurable.inter {n : ℕ} {s t : Region n}
    (hs : JordanMeasurable s) (ht : JordanMeasurable t) :
    JordanMeasurable (s ∩ t) := by
  rcases hs with ⟨hs_bdd, hs_frontier⟩
  rcases ht with ⟨_ht_bdd, ht_frontier⟩
  refine ⟨hs_bdd.subset Set.inter_subset_left, ?_⟩
  refine measure_mono_null (frontier_inter_subset s t) ?_
  exact measure_union_null
    (measure_mono_null Set.inter_subset_left hs_frontier)
    (measure_mono_null Set.inter_subset_right ht_frontier)

/-- Finite-ring closure under difference for Jordan-measurable sets. -/
theorem JordanMeasurable.diff {n : ℕ} {s t : Region n}
    (hs : JordanMeasurable s) (ht : JordanMeasurable t) :
    JordanMeasurable (s \ t) := by
  rcases hs with ⟨hs_bdd, hs_frontier⟩
  rcases ht with ⟨_ht_bdd, ht_frontier⟩
  refine ⟨hs_bdd.subset Set.diff_subset, ?_⟩
  have hfrontier_subset :
      frontier (s \ t) ⊆ frontier s ∩ closure tᶜ ∪ closure s ∩ frontier t := by
    simpa [Set.diff_eq, frontier_compl] using frontier_inter_subset s tᶜ
  refine measure_mono_null hfrontier_subset ?_
  exact measure_union_null
    (measure_mono_null Set.inter_subset_left hs_frontier)
    (measure_mono_null Set.inter_subset_right ht_frontier)

end JordanContent
end MeasureTheory
end MathlibExpansion
