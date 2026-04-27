import MathlibExpansion.Probability.MeasureConvolution.IndepSum
import MathlibExpansion.Probability.StableLaw.CharacteristicFunction

/-!
# Closure of stable laws under weighted sums

This file records the weighted-sum closure theorem for strictly stable symmetric
laws.
-/

namespace MathlibExpansion
namespace Probability
namespace StableLaw

open MeasureTheory
open MathlibExpansion.Probability.CharacteristicFunction
open MathlibExpansion.Probability.MeasureConvolution

/-- The `alpha`-power weight sum `sum_i |a_i|^alpha`. -/
noncomputable def weightAlphaNormSum {n : ℕ} (a : Fin n → ℝ) (alpha : ℝ) : ℝ :=
  ∑ i, Real.rpow |a i| alpha

/-- Law of a normalized finite weighted sum of iid real variables with common law `mu`.

The one-coordinate law is transported by `x |-> (a i / A) * x`, and the finite
sum is built by iterated independent convolution. The empty sum is the Dirac law
at `0`.

Source boundary for the stable-law normalization later used with this definition:
Samorodnitsky--Taqqu (1994), *Stable Non-Gaussian Random Processes*, Definition
1.1.1, Theorem 1.1.2, and equation (1.3.1). -/
noncomputable def weightedSumLaw :
    {n : ℕ} → ProbabilityMeasure ℝ → (Fin n → ℝ) → ℝ → ProbabilityMeasure ℝ
  | 0, _μ, _a, _A => MeasureTheory.diracProba 0
  | n + 1, μ, a, A =>
      indepSumLaw (weightedSumLaw μ (fun i : Fin n => a i.castSucc) A)
        (affineImage μ (a ⟨n, Nat.lt_succ_self n⟩ / A) 0)

/-- Characteristic-function boundary for closure of symmetric alpha-stable laws under
nonzero finite weighted sums.

For iid symmetric alpha-stable variables with characteristic function
`t |-> exp (-|t|^alpha)`, the normalized weighted sum by
`(sum_i |a_i|^alpha)^(1/alpha)` has the same law.

Exact source boundary: Samorodnitsky--Taqqu (1994), *Stable Non-Gaussian Random
Processes*, Definition 1.1.1 (two-term stability), Theorem 1.1.2 (`C^alpha =
A^alpha + B^alpha`), Definition 1.1.4 (finite iid sums), Definition 1.1.6
(characteristic-function form), and equation (1.3.1) (symmetric alpha-stable
characteristic function). This axiom remains because Mathlib currently has no
formal stable-distribution characteristic-function classification or Fourier
uniqueness theorem strong enough to discharge this finite weighted-sum theorem. -/
axiom stable_weighted_sum_closed_of_characteristicFunction {n : ℕ}
    (μ : ProbabilityMeasure ℝ) {alpha : ℝ} (hα0 : 0 < alpha) (hα2 : alpha ≤ 2)
    (hμ : characteristicFunction μ = stableCFSymmetric alpha) (a : Fin n → ℝ)
    (hnorm : 0 < weightAlphaNormSum a alpha) :
    weightedSumLaw μ a (Real.rpow (weightAlphaNormSum a alpha) (1 / alpha)) = μ

private theorem weightAlphaNormSum_pos_of_exists_ne_zero {n : ℕ} {a : Fin n → ℝ}
    {alpha : ℝ} (ha : ∃ i, a i ≠ 0) :
    0 < weightAlphaNormSum a alpha := by
  classical
  rcases ha with ⟨i, hi⟩
  unfold weightAlphaNormSum
  refine Finset.sum_pos' (fun j _ => ?_) ⟨i, Finset.mem_univ i, ?_⟩
  · exact Real.rpow_nonneg (abs_nonneg (a j)) alpha
  · exact Real.rpow_pos_of_pos (abs_pos.mpr hi) alpha

/-- Weighted sums of a strictly stable symmetric law remain in the same law family,
for nonzero finite weight vectors.

The old unrestricted statement was too broad for a genuine finite-sum law: at
`n = 0` there is no nonzero normalizing constant making the empty-sum law equal
to an arbitrary stable law. The nonzero-weight hypothesis is the sharp upstream
shape consumed by the characteristic-function theorem above. -/
theorem stable_weighted_sum_closed {n : ℕ} (μ : ProbabilityMeasure ℝ)
    (hμ : IsStrictlyStableSymmetricLaw μ) (a : Fin n → ℝ) (ha : ∃ i, a i ≠ 0) :
    ∃ A : ℝ, 0 < A ∧ weightedSumLaw μ a A = μ := by
  obtain ⟨alpha, hα0, hα2, hcf⟩ :=
    (isStrictlyStableSymmetricLaw_iff_exists_alpha μ).1 hμ
  let A := Real.rpow (weightAlphaNormSum a alpha) (1 / alpha)
  have hnorm : 0 < weightAlphaNormSum a alpha :=
    weightAlphaNormSum_pos_of_exists_ne_zero ha
  refine ⟨A, ?_, ?_⟩
  · exact Real.rpow_pos_of_pos hnorm (1 / alpha)
  · simpa [A] using
      stable_weighted_sum_closed_of_characteristicFunction μ hα0 hα2 hcf a hnorm

end StableLaw
end Probability
end MathlibExpansion
