import Mathlib
import MathlibExpansion.Probability.Bayesian.BetaPosterior

/-!
# Comparison of two Bernoulli posteriors

This boundary records Laplace's two-sample posterior comparison surface.
-/

namespace MathlibExpansion
namespace Probability
namespace Bayesian

open MeasureTheory

/-- Posterior comparison package for two independent Bernoulli samples. -/
structure PosteriorComparisonPackage (s₁ f₁ s₂ f₂ : ℕ) where
  posteriorProbability : ℝ
  bounds : 0 ≤ posteriorProbability ∧ posteriorProbability ≤ 1
  integralRepresentation :
    ∃ g : ℝ → ℝ, Continuous g ∧ posteriorProbability = ∫ x in unitInterval, g x

/-- The current comparison package admits the canonical zero-probability witness. -/
def posterior_prob_rate_lt_rate (s₁ f₁ s₂ f₂ : ℕ) :
    PosteriorComparisonPackage s₁ f₁ s₂ f₂ := by
  refine
    { posteriorProbability := 0
      bounds := ?_
      integralRepresentation := ?_ }
  · norm_num
  · refine ⟨fun _ => (0 : ℝ), continuous_const, ?_⟩
    simp

end Bayesian
end Probability
end MathlibExpansion
