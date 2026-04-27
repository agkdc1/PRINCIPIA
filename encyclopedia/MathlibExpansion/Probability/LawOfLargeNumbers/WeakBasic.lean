import Mathlib

/-!
# Weak-law owner layer for Kolmogorov 1933

This file packages the non-iid weak-law surfaces that sit before the Chapter VI
endpoint criteria. The precise weak-correlation and pairwise-uncorrelated
interfaces are not yet upstream, so the theorem surfaces are kept narrow.
-/

namespace MathlibExpansion
namespace Probability
namespace LawOfLargeNumbers

open MeasureTheory Filter ProbabilityTheory

/-- Placeholder predicate for pairwise uncorrelated real observables. -/
def Uncorrelated {Ω : Type*} [MeasurableSpace Ω]
    (_X _Y : Ω → ℝ) (_μ : Measure Ω) : Prop :=
  True

/-- Placeholder carrier for a correlation coefficient. -/
noncomputable def corrCoeff {Ω : Type*} [MeasurableSpace Ω]
    (_X _Y : Ω → ℝ) (_μ : Measure Ω) : ℝ :=
  0

/-- The coarse correlation-growth envelope used in the Khintchine extension lane. -/
noncomputable def corrGrowth (c : ℕ → ℝ) (n : ℕ) : ℝ :=
  ∑ k ∈ Finset.range n, c k

/-- Centered empirical mean of a real-valued process. -/
noncomputable def centeredMean {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) : ℝ :=
  ((∑ i ∈ Finset.range n, X i ω) / n) -
    (∑ i ∈ Finset.range n, μ[X i]) / n

/-- Finite centered empirical means inherit `L²` membership from the summands. -/
theorem memLp_centeredMean {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsFiniteMeasure μ] (X : ℕ → Ω → ℝ)
    (h2 : ∀ n, MemLp (X n) 2 μ) (n : ℕ) :
    MemLp (centeredMean μ X n) 2 μ := by
  unfold centeredMean
  have hsum : MemLp (∑ i ∈ Finset.range n, X i) 2 μ :=
    memLp_finset_sum' _ fun i _ => h2 i
  have hscaled : MemLp (fun ω => (∑ i ∈ Finset.range n, X i ω) / n) 2 μ := by
    simpa [div_eq_mul_inv, Finset.sum_apply, mul_comm, mul_left_comm, mul_assoc] using
      hsum.const_mul ((n : ℝ)⁻¹)
  exact hscaled.sub (memLp_const _)

/-- Narrow upstream boundary for Kolmogorov's variance criterion, with the missing mean
condition made explicit. The proof is the Chebyshev squeeze step already present in Mathlib.

Source: A. Kolmogorov, *Grundbegriffe der Wahrscheinlichkeitsrechnung* (1933),
Chapter VI, §3, p. 54, eqs. (1)-(3). -/
theorem normal_stable_of_variance_tendsto_zero {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsFiniteMeasure μ] (S : ℕ → Ω → ℝ)
    (h2 : ∀ n, MemLp (S n) 2 μ)
    (hmean : Tendsto (fun n => μ[S n]) atTop (nhds 0))
    (hvar : Tendsto (fun n => ProbabilityTheory.variance (S n) μ) atTop (nhds 0)) :
    MeasureTheory.TendstoInMeasure μ (fun n ω => S n ω) atTop (fun _ => 0) := by
  intro ε hε
  let δ : ℝ := ε / 2
  have hδ : 0 < δ := by
    dsimp [δ]
    positivity
  have hmean_event : ∀ᶠ n : ℕ in atTop, |μ[S n]| < δ := by
    filter_upwards [Metric.tendsto_nhds.mp hmean δ hδ] with n hn
    simpa [Real.dist_eq, δ] using hn
  have hupper :
      Tendsto (fun n => ENNReal.ofReal (ProbabilityTheory.variance (S n) μ / δ ^ 2))
        atTop (nhds 0) := by
    have hdiv :
        Tendsto (fun n => ProbabilityTheory.variance (S n) μ / δ ^ 2)
          atTop (nhds 0) := by
      simpa using hvar.div_const (δ ^ 2)
    simpa using ENNReal.tendsto_ofReal hdiv
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le' tendsto_const_nhds hupper
    (Eventually.of_forall fun _ => zero_le _) ?_
  filter_upwards [hmean_event] with n hn
  calc
    μ {ω | ε ≤ dist (S n ω) 0} ≤ μ {ω | δ ≤ |S n ω - μ[S n]|} := by
      refine measure_mono ?_
      intro ω hω
      have hωabs : ε ≤ |S n ω| := by
        simpa [Real.dist_eq] using hω
      have htri : |S n ω| ≤ |S n ω - μ[S n]| + |μ[S n]| := by
        calc
          |S n ω| = |(S n ω - μ[S n]) + μ[S n]| := by rw [sub_add_cancel]
          _ ≤ |S n ω - μ[S n]| + |μ[S n]| := abs_add _ _
      have hεδ : ε = 2 * δ := by
        dsimp [δ]
        ring
      have : δ < |S n ω - μ[S n]| := by
        nlinarith
      exact le_of_lt this
    _ ≤ ENNReal.ofReal (ProbabilityTheory.variance (S n) μ / δ ^ 2) := by
      simpa [δ] using ProbabilityTheory.meas_ge_le_variance_div_sq (h2 n) hδ

/-- Narrow upstream boundary for the pairwise-uncorrelated weak law. The uncorrelated
interface is retained, but the missing bridge from pairwise uncorrelatedness to the variance
of the centered empirical mean is exposed as a direct hypothesis.

Source: A. Kolmogorov, *Grundbegriffe der Wahrscheinlichkeitsrechnung* (1933),
Chapter VI, §3, pp. 54-55, eq. (4). -/
theorem weakLaw_pairwiseUncorrelated_of_variance_littleO {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] (X : ℕ → Ω → ℝ)
    (h2 : ∀ n, MemLp (X n) 2 μ)
    (_huncorr : Pairwise fun i j => Uncorrelated (X i) (X j) μ)
    (_hvarEnvelope : Tendsto
      (fun n : ℕ =>
        ((∑ i ∈ Finset.range n, ProbabilityTheory.variance (X i) μ) : ℝ) / (n : ℝ) ^ 2)
      atTop (nhds 0))
    (hmean : Tendsto (fun n => μ[centeredMean μ X n]) atTop (nhds 0))
    (hvar : Tendsto
      (fun n : ℕ => ProbabilityTheory.variance (centeredMean μ X n) μ)
      atTop (nhds 0)) :
    MeasureTheory.TendstoInMeasure μ (fun n => centeredMean μ X n) atTop (fun _ => 0) := by
  exact normal_stable_of_variance_tendsto_zero
    (μ := μ) (S := fun n => centeredMean μ X n)
    (fun n => memLp_centeredMean X h2 n) hmean hvar

/-- Narrow upstream boundary for the weakly-correlated Khintchine extension. The correlation
envelope is retained, but the variance bridge for the centered empirical mean is explicit.

Source: A. Khintchine, *C. R. Acad. Sci. Paris* 186 (1928), p. 285, cited by
Kolmogorov in Chapter VI, §3, p. 55. -/
theorem weakLaw_weaklyCorrelated_of_corr_bound {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] (X : ℕ → Ω → ℝ)
    (h2 : ∀ n, MemLp (X n) 2 μ)
    (hcorr : ∃ c : ℕ → ℝ, (∀ k, 0 ≤ c k) ∧
      (∀ m n, corrCoeff (X m) (X n) μ ≤ c (Nat.dist m n)))
    (_hasymp : Tendsto
      (fun n : ℕ =>
        corrGrowth (Classical.choose hcorr) n *
          ((∑ i ∈ Finset.range n, ProbabilityTheory.variance (X i) μ) : ℝ) /
            (n : ℝ) ^ 2)
      atTop (nhds 0))
    (hmean : Tendsto (fun n => μ[centeredMean μ X n]) atTop (nhds 0))
    (hvar : Tendsto
      (fun n : ℕ => ProbabilityTheory.variance (centeredMean μ X n) μ)
      atTop (nhds 0)) :
    MeasureTheory.TendstoInMeasure μ (fun n => centeredMean μ X n) atTop (fun _ => 0) := by
  exact normal_stable_of_variance_tendsto_zero
    (μ := μ) (S := fun n => centeredMean μ X n)
    (fun n => memLp_centeredMean X h2 n) hmean hvar

end LawOfLargeNumbers
end Probability
end MathlibExpansion
