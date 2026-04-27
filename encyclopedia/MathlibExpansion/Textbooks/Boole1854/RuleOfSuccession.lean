import MathlibExpansion.Probability.Bayesian.BetaBinomial

/-!
# Boole 1854 rule of succession

This file keeps the probabilistic architecture explicit by consuming the local
beta-binomial posterior-predictive boundary.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Boole1854

open MathlibExpansion.Probability.Bayesian

/-- Explicit Laplace-style model parameters for the rule of succession. -/
structure UniformPriorBernoulliModel where
  successes : ℕ
  failures : ℕ

/-- Boole's rule of succession under the explicit beta-binomial model boundary. -/
theorem ruleOfSuccession_uniformPrior (M : UniformPriorBernoulliModel) :
    (posterior_predictive_binomial_uniform M.successes M.failures 1).mass 1 =
      (M.successes + 1 : ℝ) / (M.successes + M.failures + 2) :=
  posterior_predictive_ruleOfSuccession M.successes M.failures

end Boole1854
end Textbooks
end MathlibExpansion
