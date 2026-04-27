import Mathlib

/-!
# Countable Bayes formula

This file records the posterior-of-causes theorem for countable exhaustive
hypothesis families.
-/

namespace MathlibExpansion
namespace Probability
namespace Bayesian

open MeasureTheory

/-- Posterior weight inside a countable exhaustive family. -/
noncomputable def countablePosteriorWeight {Ω ι : Type*} [MeasurableSpace Ω]
    [MeasurableSpace ι] [Countable ι] (μ : ProbabilityMeasure Ω) (X : Ω → ι)
    (E : Set Ω) (i : ι) : ℝ :=
  (((μ : Measure Ω) (X ⁻¹' {i} ∩ E)).toReal) /
    (∑' j, ((μ : Measure Ω) (X ⁻¹' {j} ∩ E)).toReal)

/-- Countable exhaustive families of causes give a normalized posterior weight function
when the normalizing denominator is nonzero. -/
theorem posterior_of_countable_partition {Ω ι : Type*} [MeasurableSpace Ω]
    [MeasurableSpace ι] [Countable ι] (μ : ProbabilityMeasure Ω) (X : Ω → ι)
    (_hX : Measurable X) (E : Set Ω) (_hE : MeasurableSet E)
    (hden :
      (∑' j, ((μ : Measure Ω) (X ⁻¹' {j} ∩ E)).toReal) ≠ 0) :
    (∑' i, countablePosteriorWeight μ X E i) = 1 := by
  simp_rw [countablePosteriorWeight, div_eq_mul_inv]
  rw [tsum_mul_right]
  exact mul_inv_cancel₀ hden

end Bayesian
end Probability
end MathlibExpansion
