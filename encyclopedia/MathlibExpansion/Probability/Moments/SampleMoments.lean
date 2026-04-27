import Mathlib

/-!
# Sample moment asymptotics

This file packages the asymptotic law for empirical moments of large samples.
-/

noncomputable section

namespace MathlibExpansion
namespace Probability
namespace Moments

open MeasureTheory Filter ProbabilityTheory

/-- The empirical `k`-th moment of the first `n` samples. -/
def sampleMoment {Ω : Type*} [MeasurableSpace Ω]
    (X : ℕ → Ω → ℝ) (k n : ℕ) (ω : Ω) : ℝ :=
  (∑ i ∈ Finset.range n, (X i ω) ^ k) / n

/-- The theorem-level package for sample-moment asymptotics. -/
structure SampleMomentAsymptotics {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ℕ → Ω → ℝ) (k : ℕ) where
  limit : ℝ
  almostSureConvergence :
    ∀ᵐ ω ∂μ, Tendsto (fun n : ℕ => sampleMoment X k n ω) atTop (nhds limit)

/-- Empirical moments converge to the expected moment in the required package form.

Formal source: Mathlib's `ProbabilityTheory.strong_law_ae_real`, the pairwise-independent
strong law following Nasrollah Etemadi, "An elementary proof of the strong law of large
numbers", *Z. Wahrscheinlichkeitstheorie verw. Gebiete* 55 (1981), 119-122, main theorem. -/
noncomputable def iid_sampleMoment_tendsto_expectation {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsFiniteMeasure μ] (X : ℕ → Ω → ℝ) (k : ℕ)
    (hint : Integrable (fun ω => (X 0 ω) ^ k) μ)
    (hindep : Pairwise fun i j => ProbabilityTheory.IndepFun (X i) (X j) μ)
    (hident : ∀ n, IdentDistrib (X n) (X 0) μ μ) :
    SampleMomentAsymptotics μ X k := by
  let Y : ℕ → Ω → ℝ := fun i ω => (X i ω) ^ k
  have hpow_meas : Measurable fun x : ℝ => x ^ k :=
    measurable_id.pow_const k
  have hYindep : Pairwise fun i j => ProbabilityTheory.IndepFun (Y i) (Y j) μ := by
    intro i j hij
    simpa [Y, Function.comp_def] using (hindep hij).comp hpow_meas hpow_meas
  have hYident : ∀ n, IdentDistrib (Y n) (Y 0) μ μ := by
    intro n
    simpa [Y, Function.comp_def] using (hident n).comp hpow_meas
  refine ⟨μ[Y 0], ?_⟩
  have hYae :
      ∀ᵐ ω ∂μ,
        Tendsto (fun n : ℕ => (∑ i ∈ Finset.range n, Y i ω) / n)
          atTop (nhds μ[Y 0]) :=
    ProbabilityTheory.strong_law_ae_real Y hint hYindep hYident
  simpa [sampleMoment, Y] using hYae

end Moments
end Probability
end MathlibExpansion
