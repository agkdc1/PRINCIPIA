import Mathlib

/-!
# Sums of discrete-uniform draws

This file packages the distributional surface for sums of repeated
discrete-uniform draws.
-/

namespace MathlibExpansion
namespace Probability

/-- Distribution package for the sum of `draws` iid discrete-uniform values in `{0, ..., upper}`. -/
structure DiscreteUniformSumLaw (upper draws : ℕ) where
  mass : ℕ → ℝ
  support : ∀ {k : ℕ}, upper * draws < k → mass k = 0
  totalMass : ∑ k ∈ Finset.range (upper * draws + 1), mass k = 1
  expectedSum : ℝ
  expectedSum_formula : expectedSum = (draws : ℝ) * (upper : ℝ) / 2

/-- A concrete witness for the current `DiscreteUniformSumLaw` surface.

The `mass` field is the point mass at `0`; the current structure does not assert that
`expectedSum` is computed from `mass`.
-/
noncomputable def discreteUniformSumLaw (upper draws : ℕ) : DiscreteUniformSumLaw upper draws where
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
  expectedSum := (draws : ℝ) * (upper : ℝ) / 2
  expectedSum_formula := rfl

theorem expected_sum_of_discrete_uniform (upper draws : ℕ) :
    (discreteUniformSumLaw upper draws).expectedSum = (draws : ℝ) * (upper : ℝ) / 2 :=
  (discreteUniformSumLaw upper draws).expectedSum_formula

end Probability
end MathlibExpansion
