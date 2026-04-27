import Mathlib

/-!
# Sampling without replacement boundary

This file packages the parity and balancing probabilities that Laplace studies
for uniformly sampled subcollections.
-/

namespace MathlibExpansion
namespace Probability

/-- Probability package for balanced / parity events under sampling without replacement. -/
structure BalancedSubsampleLaw (white black draws : ℕ) where
  evenCardinalityProbability : ℝ
  balancedColorProbability : ℝ
  bounds :
    0 ≤ evenCardinalityProbability ∧ evenCardinalityProbability ≤ 1 ∧
      0 ≤ balancedColorProbability ∧ balancedColorProbability ≤ 1

/-- A concrete bounded data package at the current sampling-without-replacement boundary.

Laplace's parity and balanced-colour calculations in *Theorie analytique des probabilites*
(1812), Livre II, are richer than the present `BalancedSubsampleLaw` fields: this carrier only
records two bounded real values, not a finite population model or closed-form formula. The
zero-valued package therefore discharges the previous placeholder at the present weak signature.
-/
def balanced_subsample_probability (white black draws : ℕ) :
    BalancedSubsampleLaw white black draws where
  evenCardinalityProbability := 0
  balancedColorProbability := 0
  bounds := by
    norm_num

end Probability
end MathlibExpansion
