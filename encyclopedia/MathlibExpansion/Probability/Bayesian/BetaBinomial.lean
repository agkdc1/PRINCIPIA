import Mathlib
import MathlibExpansion.Probability.Bayesian.BetaPosterior

/-!
# Beta-binomial predictive boundary for Laplace 1812

This file packages the posterior-predictive law for future Bernoulli trials.
It keeps the predictive distribution explicit as a mass function over
`{0, ..., m}` and records the rule-of-succession corollary separately.
-/

namespace MathlibExpansion
namespace Probability
namespace Bayesian

/-- Posterior-predictive law for `m` future Bernoulli trials. -/
structure BetaBinomialPredictiveLaw (s f m : ℕ) where
  mass : ℕ → ℝ
  support : ∀ {k : ℕ}, m < k → mass k = 0
  totalMass : ∑ k ∈ Finset.range (m + 1), mass k = 1

/-- Rising factorial `(a)_n` over the reals, for natural parameters. -/
noncomputable def betaBinomialRising (a n : ℕ) : ℝ :=
  ∏ i ∈ Finset.range n, (a + i : ℝ)

/-- Unnormalized beta-binomial posterior-predictive weight. -/
noncomputable def betaBinomialPredictiveWeight (s f m k : ℕ) : ℝ :=
  if k ≤ m then
    (m.choose k : ℝ) * betaBinomialRising (s + 1) k *
      betaBinomialRising (f + 1) (m - k)
  else 0

/-- The finite normalizing denominator for the beta-binomial weights. -/
noncomputable def betaBinomialPredictiveDenominator (s f m : ℕ) : ℝ :=
  ∑ k ∈ Finset.range (m + 1), betaBinomialPredictiveWeight s f m k

/-- The one-step Laplace rule-of-succession probability. -/
noncomputable def ruleOfSuccessionProbability (s f : ℕ) : ℝ :=
  (s + 1 : ℝ) / (s + f + 2)

/-- The normalized beta-binomial posterior-predictive mass. -/
noncomputable def betaBinomialPredictiveMass (s f m k : ℕ) : ℝ :=
  betaBinomialPredictiveWeight s f m k / betaBinomialPredictiveDenominator s f m

lemma betaBinomialRising_nonneg (a n : ℕ) : 0 ≤ betaBinomialRising a n := by
  unfold betaBinomialRising
  exact Finset.prod_nonneg fun i _ => by positivity

lemma betaBinomialRising_pos_of_pos {a n : ℕ} (ha : 0 < a) :
    0 < betaBinomialRising a n := by
  unfold betaBinomialRising
  exact Finset.prod_pos fun i _ => by positivity

lemma betaBinomialPredictiveWeight_nonneg (s f m k : ℕ) :
    0 ≤ betaBinomialPredictiveWeight s f m k := by
  by_cases hk : k ≤ m
  · simp [betaBinomialPredictiveWeight, hk, mul_nonneg, betaBinomialRising_nonneg]
  · simp [betaBinomialPredictiveWeight, hk]

lemma betaBinomialPredictiveWeight_zero_pos (s f m : ℕ) :
    0 < betaBinomialPredictiveWeight s f m 0 := by
  simp [betaBinomialPredictiveWeight, betaBinomialRising_pos_of_pos]

lemma betaBinomialPredictiveDenominator_pos (s f m : ℕ) :
    0 < betaBinomialPredictiveDenominator s f m := by
  unfold betaBinomialPredictiveDenominator
  have hmem : 0 ∈ Finset.range (m + 1) := by simp
  have hle : betaBinomialPredictiveWeight s f m 0 ≤
      ∑ k ∈ Finset.range (m + 1), betaBinomialPredictiveWeight s f m k := by
    exact Finset.single_le_sum
      (fun k _ => betaBinomialPredictiveWeight_nonneg s f m k) hmem
  exact lt_of_lt_of_le (betaBinomialPredictiveWeight_zero_pos s f m) hle

lemma betaBinomialPredictiveDenominator_ne_zero (s f m : ℕ) :
    betaBinomialPredictiveDenominator s f m ≠ 0 :=
  ne_of_gt (betaBinomialPredictiveDenominator_pos s f m)

/-- The beta-binomial predictive-law package used by the downstream boundary. -/
noncomputable def betaBinomialPredictiveLaw (s f m : ℕ) : BetaBinomialPredictiveLaw s f m where
  mass := betaBinomialPredictiveMass s f m
  support := by
    intro k hk
    have hnot : ¬ k ≤ m := Nat.not_le_of_gt hk
    simp [betaBinomialPredictiveMass, betaBinomialPredictiveWeight, hnot]
  totalMass := by
    unfold betaBinomialPredictiveMass betaBinomialPredictiveDenominator
    rw [← Finset.sum_div]
    exact div_self (betaBinomialPredictiveDenominator_ne_zero s f m)

lemma betaBinomialPredictiveDenominator_one (s f : ℕ) :
    betaBinomialPredictiveDenominator s f 1 = (s + f + 2 : ℝ) := by
  rw [betaBinomialPredictiveDenominator]
  rw [Finset.sum_range_succ, Finset.sum_range_succ]
  simp [betaBinomialPredictiveWeight, betaBinomialRising]
  ring

/-- The one-step predictive corollary is Laplace's rule of succession. -/
theorem ruleOfSuccession (s f : ℕ) :
    (betaBinomialPredictiveLaw s f 1).mass 1 = (s + 1 : ℝ) / (s + f + 2) := by
  simp [betaBinomialPredictiveLaw, betaBinomialPredictiveMass, betaBinomialPredictiveWeight,
    betaBinomialRising, betaBinomialPredictiveDenominator_one, ruleOfSuccessionProbability]

noncomputable def posterior_predictive_binomial_uniform (s f m : ℕ) :
    BetaBinomialPredictiveLaw s f m :=
  betaBinomialPredictiveLaw s f m

theorem posterior_predictive_support (s f m k : ℕ) (hk : m < k) :
    (posterior_predictive_binomial_uniform s f m).mass k = 0 :=
  (posterior_predictive_binomial_uniform s f m).support hk

theorem posterior_predictive_totalMass (s f m : ℕ) :
    ∑ k ∈ Finset.range (m + 1),
      (posterior_predictive_binomial_uniform s f m).mass k = 1 :=
  (posterior_predictive_binomial_uniform s f m).totalMass

theorem posterior_predictive_ruleOfSuccession (s f : ℕ) :
    (posterior_predictive_binomial_uniform s f 1).mass 1 = (s + 1 : ℝ) / (s + f + 2) :=
  ruleOfSuccession s f

end Bayesian
end Probability
end MathlibExpansion
