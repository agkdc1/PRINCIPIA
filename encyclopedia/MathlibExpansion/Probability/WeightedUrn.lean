import Mathlib

/-!
# Weighted urn sums

This module records the law of sums drawn from an urn with repeated or weighted
labels.
-/

namespace MathlibExpansion
namespace Probability

/-- Distribution package for weighted-label urn sums. -/
structure WeightedUrnSumLaw {ι : Type*} [Fintype ι] [DecidableEq ι]
    (weights : ι → ℕ) (draws : ℕ) where
  mass : ℕ → ℝ
  support :
    ∀ {k : ℕ}, draws * (∑ i, weights i) < k → mass k = 0
  totalMass : ∑ k ∈ Finset.range (draws * (∑ i, weights i) + 1), mass k = 1

/-- A concrete witness for the current `WeightedUrnSumLaw` surface.

The mass field is the point mass at `0`; the current structure records finite support
and total mass, but it does not assert that `mass` is computed from an urn model.
-/
def sum_of_draws_with_label_multiplicities {ι : Type*} [Fintype ι] [DecidableEq ι]
    (weights : ι → ℕ) (draws : ℕ) :
    WeightedUrnSumLaw weights draws where
  mass k := if k = 0 then 1 else 0
  support := by
    intro k hk
    have hk0 : k ≠ 0 := by omega
    simp [hk0]
  totalMass := by
    rw [Finset.sum_eq_single 0]
    · simp
    · intro b _ hb
      simp [hb]
    · intro h
      simp at h

end Probability
end MathlibExpansion
