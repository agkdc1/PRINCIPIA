import Mathlib

noncomputable section

/-!
# Tchebychef-Poisson law-of-large-numbers wrappers

This file packages the Chapter V weak-law boundary isolated by the Lévy recon.
-/

namespace MathlibExpansion
namespace Probability
namespace LawOfLargeNumbers

open MeasureTheory Filter ProbabilityTheory

open scoped Topology ProbabilityTheory Function

/-- Centered empirical average attached to a real-valued process. -/
def centeredEmpiricalAverage {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) : ℝ :=
  (((∑ i ∈ Finset.range n, X i ω) - ∑ i ∈ Finset.range n, μ[X i]) / n)

/-- The expectation of a finite process sum is the sum of expectations. -/
theorem integral_sum_range_eq_sum_integral {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] (X : ℕ → Ω → ℝ)
    (h2 : ∀ n, MemLp (X n) 2 μ) (n : ℕ) :
    μ[(∑ i ∈ Finset.range n, X i)] = ∑ i ∈ Finset.range n, μ[X i] := by
  simpa [Finset.sum_apply] using
    (integral_finset_sum (Finset.range n)
      (μ := μ) (f := fun i ω => X i ω)
      (fun i _hi => (h2 i).integrable one_le_two))

/-- The variance of a finite sum of pairwise independent process terms is the sum of variances. -/
theorem variance_sum_range_of_pairwise_indep {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] (X : ℕ → Ω → ℝ)
    (h2 : ∀ n, MemLp (X n) 2 μ)
    (hindep : Pairwise ((ProbabilityTheory.IndepFun · · μ) on X)) (n : ℕ) :
    ProbabilityTheory.variance (∑ i ∈ Finset.range n, X i) μ =
      ∑ i ∈ Finset.range n, ProbabilityTheory.variance (X i) μ := by
  exact ProbabilityTheory.IndepFun.variance_sum
    (μ := μ) (X := X) (s := Finset.range n)
    (fun i _hi => h2 i)
    (fun i _hi j _hj hij => hindep hij)

/-- Tchebychef-Poisson weak-law boundary for pairwise independent summands.

Source: P. L. Chebyshev, "Des valeurs moyennes", Journal de Mathématiques
Pures et Appliquées, Série 2, 12 (1867), pp. 177-184. Poisson's naming
context is S.-D. Poisson, *Recherches sur la probabilité des jugements en
matière criminelle et en matière civile* (1837). -/
theorem chebyshev_poisson_weak_law {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : ℕ → Ω → ℝ)
    (h2 : ∀ n, MemLp (X n) 2 μ)
    (hindep : Pairwise ((ProbabilityTheory.IndepFun · · μ) on X))
    (hvar : Tendsto
      (fun n : ℕ =>
        (∑ i ∈ Finset.range n, ProbabilityTheory.variance (X i) μ) / (n : ℝ)^2)
      atTop (nhds 0)) :
    TendstoInMeasure μ (fun n ω => centeredEmpiricalAverage μ X n ω) atTop (fun _ => 0) := by
  intro ε hε
  have hupper :
      Tendsto
        (fun n : ℕ =>
          ENNReal.ofReal
            (((∑ i ∈ Finset.range n, ProbabilityTheory.variance (X i) μ) / (n : ℝ)^2) /
              ε ^ 2))
        atTop (nhds 0) := by
    have hscaled :
        Tendsto
          (fun n : ℕ =>
            ((∑ i ∈ Finset.range n, ProbabilityTheory.variance (X i) μ) / (n : ℝ)^2) /
              ε ^ 2)
          atTop (nhds 0) := by
      simpa using hvar.div_const (ε ^ 2)
    simpa using ENNReal.tendsto_ofReal hscaled
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le' tendsto_const_nhds hupper
    (Eventually.of_forall fun _ => zero_le _) ?_
  refine eventually_atTop.2 ⟨1, fun n hn => ?_⟩
  have hnpos_nat : 0 < n := lt_of_lt_of_le Nat.zero_lt_one hn
  have hnpos : 0 < (n : ℝ) := by exact_mod_cast hnpos_nat
  have hcn : 0 < ε * (n : ℝ) := mul_pos hε hnpos
  have hmean_sum :
      μ[(∑ i ∈ Finset.range n, X i)] = ∑ i ∈ Finset.range n, μ[X i] :=
    integral_sum_range_eq_sum_integral X h2 n
  have hsum_mem : MemLp (∑ i ∈ Finset.range n, X i) 2 μ :=
    memLp_finset_sum' _ fun i _hi => h2 i
  have hvar_sum :
      ProbabilityTheory.variance (∑ i ∈ Finset.range n, X i) μ =
        ∑ i ∈ Finset.range n, ProbabilityTheory.variance (X i) μ :=
    variance_sum_range_of_pairwise_indep X h2 hindep n
  calc
    μ {ω | ε ≤ dist (centeredEmpiricalAverage μ X n ω) 0} ≤
        μ {ω | ε * (n : ℝ) ≤
          |(∑ i ∈ Finset.range n, X i) ω - μ[(∑ i ∈ Finset.range n, X i)]|} := by
      refine measure_mono ?_
      intro ω hω
      have hωabs :
          ε ≤ |(∑ i ∈ Finset.range n, X i ω) - ∑ i ∈ Finset.range n, μ[X i]| /
              (n : ℝ) := by
        simpa [centeredEmpiricalAverage, Real.dist_eq, abs_div, abs_of_pos hnpos] using hω
      have hmul :
          ε * (n : ℝ) ≤
            |(∑ i ∈ Finset.range n, X i ω) - ∑ i ∈ Finset.range n, μ[X i]| :=
        (le_div_iff₀ hnpos).mp hωabs
      rw [hmean_sum]
      simpa [Finset.sum_apply] using hmul
    _ ≤ ENNReal.ofReal (ProbabilityTheory.variance (∑ i ∈ Finset.range n, X i) μ /
          (ε * (n : ℝ)) ^ 2) := by
      exact ProbabilityTheory.meas_ge_le_variance_div_sq hsum_mem hcn
    _ = ENNReal.ofReal
          (((∑ i ∈ Finset.range n, ProbabilityTheory.variance (X i) μ) / (n : ℝ)^2) /
              ε ^ 2) := by
      rw [hvar_sum]
      congr 1
      ring_nf

end LawOfLargeNumbers
end Probability
end MathlibExpansion
