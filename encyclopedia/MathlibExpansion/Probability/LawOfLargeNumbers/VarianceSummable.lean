import Mathlib

/-!
# Variance-summable strong law boundary

This is the Chapter VI owner layer before the iid necessity packaging.
-/

namespace MathlibExpansion
namespace Probability
namespace LawOfLargeNumbers

open MeasureTheory Filter ProbabilityTheory

/-- Deterministic Kronecker lemma for the `b n = n + 1` weights.

If the weighted series `∑ a n / (n + 1)` converges, then the unweighted Cesaro
quotients `n⁻¹ ∑_{i < n} a i` converge to zero. -/
private theorem kronecker_tendsto_zero_of_tendsto_weighted_series {a : ℕ → ℝ}
    (h : ∃ L : ℝ,
      Tendsto (fun n : ℕ => ∑ i ∈ Finset.range n, a i / (i + 1 : ℝ))
        atTop (nhds L)) :
    Tendsto (fun n : ℕ => (∑ i ∈ Finset.range n, a i) / n) atTop (nhds 0) := by
  classical
  rcases h with ⟨L, hL⟩
  let s : ℕ → ℝ := fun n => ∑ i ∈ Finset.range n, a i / (i + 1 : ℝ)
  have hs_id :
      ∀ n : ℕ, ∑ i ∈ Finset.range n, a i =
        (n : ℝ) * s n - ∑ k ∈ Finset.range n, s k := by
    intro n
    induction n with
    | zero =>
        simp [s]
    | succ n ih =>
        have hn : ((n : ℝ) + 1) ≠ 0 := by positivity
        rw [Finset.sum_range_succ, ih]
        simp only [s, Nat.cast_add, Nat.cast_one]
        rw [Finset.sum_range_succ, Finset.sum_range_succ]
        field_simp [hn]
        ring
  have hL' : Tendsto s atTop (nhds L) := by
    simpa [s] using hL
  have h_event :
      (fun n : ℕ => (∑ i ∈ Finset.range n, a i) / n) =ᶠ[atTop]
        fun n : ℕ => s n - (n⁻¹ : ℝ) * ∑ k ∈ Finset.range n, s k := by
    filter_upwards [Ici_mem_atTop 1] with n hn
    have hn0 : (n : ℝ) ≠ 0 := by
      exact_mod_cast (Nat.ne_of_gt (Nat.zero_lt_one.trans_le hn))
    rw [hs_id n]
    field_simp [hn0]
    ring
  exact Tendsto.congr' h_event.symm (by simpa using hL'.sub hL'.cesaro)

/-- Narrow upstream boundary for Kolmogorov's weighted-series convergence
criterion.

This is strictly upstream of the strong law below: it asserts only almost-sure
convergence of the centered weighted series. The deterministic Kronecker lemma
above converts it into the variance-summability strong law.

Source: A. Kolmogorov, *Grundbegriffe der Wahrscheinlichkeitsrechnung* (1933),
Chapter VI, §5, p. 59, eq. (1), using the preceding independent-series
convergence criterion now commonly called Kolmogorov's two-series theorem. -/
axiom ae_tendsto_centered_weighted_series_of_summable_variance {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] (X : ℕ → Ω → ℝ)
    (hindep : Pairwise fun i j => ProbabilityTheory.IndepFun (X i) (X j) μ)
    (h2 : ∀ n, MemLp (X n) 2 μ)
    (hvar : Summable fun n => ProbabilityTheory.variance (X n) μ / (n + 1 : ℝ) ^ 2) :
    ∀ᵐ ω ∂μ, ∃ L : ℝ,
      Filter.Tendsto
        (fun n : ℕ =>
          ∑ i ∈ Finset.range n, (X i ω - μ[X i]) / (i + 1 : ℝ))
        Filter.atTop (nhds L)

/-- Kronecker reduction from the weighted centered series to the centered
empirical means. -/
theorem strongLaw_of_centered_weightedSeries_tendsto {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} (X : ℕ → Ω → ℝ)
    (hseries : ∀ᵐ ω ∂μ, ∃ L : ℝ,
      Filter.Tendsto
        (fun n : ℕ =>
          ∑ i ∈ Finset.range n, (X i ω - μ[X i]) / (i + 1 : ℝ))
        Filter.atTop (nhds L)) :
    ∀ᵐ ω ∂μ,
      Filter.Tendsto
        (fun n : ℕ =>
          ((∑ i ∈ Finset.range n, X i ω) - ∑ i ∈ Finset.range n, μ[X i]) / n)
        Filter.atTop (nhds 0) := by
  filter_upwards [hseries] with ω hω
  have hsum :
      (fun n : ℕ =>
          ((∑ i ∈ Finset.range n, X i ω) - ∑ i ∈ Finset.range n, μ[X i]) / n) =
        fun n : ℕ =>
          (∑ i ∈ Finset.range n, (X i ω - μ[X i])) / n := by
    ext n
    rw [Finset.sum_sub_distrib]
  rw [hsum]
  exact kronecker_tendsto_zero_of_tendsto_weighted_series hω

/-- Variance-summability strong law, reduced to Kolmogorov's weighted-series
convergence criterion by a proved Kronecker lemma.

Source: A. Kolmogorov, *Grundbegriffe der Wahrscheinlichkeitsrechnung* (1933),
Chapter VI, §5, p. 59, eq. (1). -/
theorem strongLaw_of_summable_variance_div_sq {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] (X : ℕ → Ω → ℝ)
    (hindep : Pairwise fun i j => ProbabilityTheory.IndepFun (X i) (X j) μ)
    (h2 : ∀ n, MemLp (X n) 2 μ)
    (hvar : Summable fun n => ProbabilityTheory.variance (X n) μ / (n + 1 : ℝ) ^ 2) :
    ∀ᵐ ω ∂μ,
      Filter.Tendsto
        (fun n : ℕ =>
          ((∑ i ∈ Finset.range n, X i ω) - ∑ i ∈ Finset.range n, μ[X i]) / n)
        Filter.atTop (nhds 0) := by
  exact strongLaw_of_centered_weightedSeries_tendsto X
    (ae_tendsto_centered_weighted_series_of_summable_variance X hindep h2 hvar)

end LawOfLargeNumbers
end Probability
end MathlibExpansion
