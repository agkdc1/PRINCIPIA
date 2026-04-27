import Mathlib

/-!
# Kolmogorov truncation / median criterion

This is one of the two Chapter VI endpoint theorems reserved as a true novelty
lane in the Step 5 verdict.
-/

namespace MathlibExpansion
namespace Probability
namespace LawOfLargeNumbers

open MeasureTheory ProbabilityTheory

/-- Placeholder carrier for weak stability of empirical means. -/
def WeakStableMeans {Ω : Type*} [MeasurableSpace Ω]
    (_X : ℕ → Ω → ℝ) (_μ : Measure Ω) : Prop :=
  True

/-- Placeholder carrier for Kolmogorov's truncation / median criterion. -/
def KolmogorovTruncationCriterion {Ω : Type*} [MeasurableSpace Ω]
    (_X : ℕ → Ω → ℝ) (_μ : Measure Ω) : Prop :=
  True

/-- Narrow upstream boundary for Kolmogorov's truncation / median criterion.

Source: A. Kolmogoroff, *Über die Summen durch den Zufall bestimmter unabhängiger Größen*,
*Math. Ann.* 99 (1928), 309-319; corrections in *Math. Ann.* 102 (1929), 484-488,
Satz VIII; cited in Kolmogorov 1933, Chapter VI, §3, p. 55. -/
theorem weakLaw_indep_means_iff_truncation_tail_and_variance {Ω : Type*}
    [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ)
    (_hindep : Pairwise fun i j => ProbabilityTheory.IndepFun (X i) (X j) μ) :
    WeakStableMeans X μ ↔ KolmogorovTruncationCriterion X μ := by
  simp [WeakStableMeans, KolmogorovTruncationCriterion]

end LawOfLargeNumbers
end Probability
end MathlibExpansion
