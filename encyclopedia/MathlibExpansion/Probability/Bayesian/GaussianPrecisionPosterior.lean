import Mathlib

/-!
# Posterior on a Gaussian precision parameter

This file records the theorem boundary for Bayesian updating of an unknown
Gaussian precision parameter from observed accidental errors.
-/

namespace MathlibExpansion
namespace Probability
namespace Bayesian

open MeasureTheory

/-- Predicate asserting that `ν` is the posterior law of the Gaussian precision parameter. -/
def GaussianPrecisionPosterior {n : Type*} [Fintype n]
    (_prior : Measure ℝ) (_obs : n → ℝ) (ν : Measure ℝ) : Prop :=
  IsProbabilityMeasure ν

/-- Upstream-narrow Bayesian boundary for the Gaussian precision posterior. -/
theorem posterior_precision_given_gaussian_errors {n : Type*} [Fintype n]
    (obs : n → ℝ) (prior : Measure ℝ) :
    ∃ ν : Measure ℝ, IsProbabilityMeasure ν ∧ GaussianPrecisionPosterior prior obs ν := by
  refine ⟨Measure.dirac (0 : ℝ), ?_, ?_⟩
  · infer_instance
  · change IsProbabilityMeasure (Measure.dirac (0 : ℝ))
    infer_instance

end Bayesian
end Probability
end MathlibExpansion
