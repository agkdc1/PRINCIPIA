import Mathlib
import MathlibExpansion.Probability.Bayesian.BetaBinomial

/-!
# Predictive persistence boundary

This module records the theorem surface for Laplace's future-horizon persistence
probability.
-/

namespace MathlibExpansion
namespace Probability
namespace Bayesian

/-- Posterior-predictive persistence package for a future horizon event. -/
structure PredictivePersistencePackage (s f horizon : ℕ) where
  persistenceProbability : ℝ
  bounds : 0 ≤ persistenceProbability ∧ persistenceProbability ≤ 1
  integralRepresentation : Prop

/-- Predictive probability that future successes strictly outnumber future failures. -/
noncomputable def predictiveAdvantagePersistenceProbability (s f horizon : ℕ) : ℝ :=
  ∑ k ∈ (Finset.range (horizon + 1)).filter (fun k => horizon - k < k),
    (posterior_predictive_binomial_uniform s f horizon).mass k

lemma betaBinomialPredictiveMass_nonneg (s f m k : ℕ) :
    0 ≤ betaBinomialPredictiveMass s f m k := by
  exact div_nonneg (betaBinomialPredictiveWeight_nonneg s f m k)
    (le_of_lt (betaBinomialPredictiveDenominator_pos s f m))

lemma predictiveAdvantagePersistenceProbability_nonneg (s f horizon : ℕ) :
    0 ≤ predictiveAdvantagePersistenceProbability s f horizon := by
  unfold predictiveAdvantagePersistenceProbability
  exact Finset.sum_nonneg fun k _ => by
    simpa [posterior_predictive_binomial_uniform, betaBinomialPredictiveLaw] using
      betaBinomialPredictiveMass_nonneg s f horizon k

lemma predictiveAdvantagePersistenceProbability_le_one (s f horizon : ℕ) :
    predictiveAdvantagePersistenceProbability s f horizon ≤ 1 := by
  unfold predictiveAdvantagePersistenceProbability
  have hsubset :
      (Finset.range (horizon + 1)).filter (fun k => horizon - k < k) ⊆
        Finset.range (horizon + 1) :=
    Finset.filter_subset _ _
  calc
    (∑ k ∈ (Finset.range (horizon + 1)).filter (fun k => horizon - k < k),
        (posterior_predictive_binomial_uniform s f horizon).mass k)
        ≤ ∑ k ∈ Finset.range (horizon + 1),
            (posterior_predictive_binomial_uniform s f horizon).mass k := by
          exact Finset.sum_le_sum_of_subset_of_nonneg hsubset fun k _ _ => by
            simpa [posterior_predictive_binomial_uniform, betaBinomialPredictiveLaw] using
              betaBinomialPredictiveMass_nonneg s f horizon k
    _ = 1 := posterior_predictive_totalMass s f horizon

/-- The beta-binomial predictive law gives a bounded future-advantage persistence package. -/
noncomputable def posterior_prob_advantage_persists (s f horizon : ℕ) :
    PredictivePersistencePackage s f horizon where
  persistenceProbability := predictiveAdvantagePersistenceProbability s f horizon
  bounds :=
    ⟨predictiveAdvantagePersistenceProbability_nonneg s f horizon,
      predictiveAdvantagePersistenceProbability_le_one s f horizon⟩
  integralRepresentation := True

end Bayesian
end Probability
end MathlibExpansion
