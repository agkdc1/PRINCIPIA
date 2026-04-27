import Mathlib
import MathlibExpansion.Probability.Bayesian.BetaPosterior

/-!
# Asymptotics of the Bernoulli posterior

This file records the posterior mode and concentration package used by Laplace's
large-sample Bernoulli asymptotics.
-/

namespace MathlibExpansion
namespace Probability
namespace Bayesian

/--
The mode and concentration package for a Beta posterior.

The current interface records the concentration component as a proposition-valued
slot; it does not yet assert the analytic concentration theorem.
-/
structure PosteriorModePackage (s f : ℕ) where
  mode : ℝ
  mode_eq : mode = (s : ℝ) / (s + f : ℝ)
  concentration : Prop

/-- The current posterior-mode package admits the canonical beta-mode witness. -/
noncomputable def posterior_mode_bernoulli_uniform (s f : ℕ) (_ : 0 < s) (_ : 0 < f) :
    PosteriorModePackage s f := by
  exact
    { mode := (s : ℝ) / (s + f : ℝ)
      mode_eq := rfl
      concentration := True }

end Bayesian
end Probability
end MathlibExpansion
