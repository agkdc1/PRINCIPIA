import Mathlib

/-!
# Precision from quadratic error size

This file packages the precision/variance identification surface in Lévy's
error-theory chapter.
-/

namespace MathlibExpansion
namespace Probability
namespace ErrorTheory

open MeasureTheory Filter ProbabilityTheory
open scoped ProbabilityTheory

/-- Empirical second moment of the first `n` errors. -/
noncomputable def sampleSecondMoment {Ω : Type*} [MeasurableSpace Ω]
    (X : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) : ℝ :=
  (∑ i ∈ Finset.range n, (X i ω) ^ 2) / n

/-- The empirical second moment converges to the variance for centered iid `L²` errors.

Historical source: Paul Levy, *Calcul des probabilites* (Gauthier-Villars, 1925),
Part II, Chapter VII, "Theorie des erreurs", precision/variance discussion.
Formal source: `ProbabilityTheory.strong_law_ae_real`, Mathlib's Etemadi pairwise-independent
strong law, from N. Etemadi, "An elementary proof of the strong law of large numbers",
*Z. Wahrscheinlichkeitstheorie verw. Gebiete* 55 (1981), main theorem. -/
theorem sampleSecondMoment_tendsto_variance_of_centered_errors {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsFiniteMeasure μ] (X : ℕ → Ω → ℝ)
    (h2 : MemLp (X 0) 2 μ)
    (hindep : Pairwise fun i j ↦ ProbabilityTheory.IndepFun (X i) (X j) μ)
    (hident : ∀ n, IdentDistrib (X n) (X 0) μ μ)
    (hmean : μ[X 0] = 0) :
    TendstoInMeasure μ (fun n ω ↦ sampleSecondMoment X n ω) atTop
      (fun _ ↦ ProbabilityTheory.variance (X 0) μ) := by
  let Y : ℕ → Ω → ℝ := fun i ω ↦ (X i ω) ^ 2
  have hYint : Integrable (Y 0) μ := by
    simpa [Y] using h2.integrable_sq
  have hsq_meas : Measurable fun x : ℝ ↦ x ^ 2 :=
    measurable_id.pow_const 2
  have hYindep : Pairwise fun i j => ProbabilityTheory.IndepFun (Y i) (Y j) μ := by
    intro i j hij
    simpa [Y] using (hindep hij).comp hsq_meas hsq_meas
  have hYident : ∀ n, IdentDistrib (Y n) (Y 0) μ μ := by
    intro n
    simpa [Y] using (hident n).sq
  have hYae :
      ∀ᵐ ω ∂μ,
        Tendsto (fun n : ℕ => (∑ i ∈ Finset.range n, Y i ω) / n)
          atTop (nhds μ[Y 0]) :=
    ProbabilityTheory.strong_law_ae_real Y hYint hYindep hYident
  have hXmeas : ∀ i, AEStronglyMeasurable (X i) μ := fun i =>
    (hident i).aestronglyMeasurable_iff.2 h2.1
  have hsample_meas :
      ∀ n, AEStronglyMeasurable (fun ω => sampleSecondMoment X n ω) μ := by
    intro n
    rw [aestronglyMeasurable_iff_aemeasurable]
    exact ((Finset.range n).aemeasurable_sum fun i _ =>
      (hXmeas i).aemeasurable.pow_const 2).div_const (n : ℝ)
  have hvar : μ[Y 0] = ProbabilityTheory.variance (X 0) μ := by
    rw [ProbabilityTheory.variance_of_integral_eq_zero h2.1.aemeasurable hmean]
  refine tendstoInMeasure_of_tendsto_ae
    (f := fun n ω => sampleSecondMoment X n ω)
    (g := fun _ => ProbabilityTheory.variance (X 0) μ) hsample_meas ?_
  filter_upwards [hYae] with ω hω
  have hω' :
      Tendsto (fun n : ℕ => (∑ i ∈ Finset.range n, Y i ω) / n)
        atTop (nhds (ProbabilityTheory.variance (X 0) μ)) := by
    simpa [hvar] using hω
  simpa [sampleSecondMoment, Y] using hω'

end ErrorTheory
end Probability
end MathlibExpansion
