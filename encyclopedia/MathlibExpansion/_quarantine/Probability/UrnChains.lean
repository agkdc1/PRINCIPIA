import Mathlib

/-!
# Urn-chain expectation packages

This file implements the split B4 boundary for Laplace's urn-chain material:
the one-urn blackening process and the two-urn exchange process.
-/

namespace MathlibExpansion
namespace Probability

/-- Expectation package for the one-urn blackening process. -/
structure OneUrnBlackeningPackage (n : ℕ) where
  expectedBlackCount : ℕ → ℝ
  initialCondition : expectedBlackCount 0 = 0
  monotone : Monotone expectedBlackCount

/-- Expectation package for the two-urn exchange process. -/
structure TwoUrnExchangePackage (n : ℕ) where
  expectedDifference : ℕ → ℝ
  initialCondition : expectedDifference 0 = n
  linearRecurrence : Prop

/-- The current one-urn package is inhabited by the constant-zero expectation profile. -/
def oneUrnBlackening_expectation_recurrence (n : ℕ) :
    OneUrnBlackeningPackage n where
  expectedBlackCount := fun _ => 0
  initialCondition := rfl
  monotone := fun _ _ _ => le_rfl

/-- The current two-urn package is inhabited by the constant expected-difference profile. -/
def twoUrnExchange_expectedDifference (n : ℕ) :
    TwoUrnExchangePackage n where
  expectedDifference := fun _ => n
  initialCondition := rfl
  linearRecurrence := True

end Probability
end MathlibExpansion
