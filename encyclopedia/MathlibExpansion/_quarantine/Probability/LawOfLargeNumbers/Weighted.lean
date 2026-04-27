import Mathlib

/-!
# Weighted law of large numbers boundary

This module packages the weighted aggregation theorem needed by Laplace's
asymmetric-error discussion.
-/

namespace MathlibExpansion
namespace Probability
namespace LawOfLargeNumbers

open MeasureTheory Filter
open ProbabilityTheory

/-- Weighted empirical averages of a real-valued process. -/
noncomputable def weightedPartialSum {Ω : Type*} [MeasurableSpace Ω]
    (w : ℕ → ℝ) (X : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) : ℝ :=
  (∑ i ∈ Finset.range n, w i * X i ω) / n

/-- The theorem-level package behind weighted large-number convergence. -/
structure WeightedStrongLawPackage {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (w : ℕ → ℝ) (X : ℕ → Ω → ℝ) where
  limit : ℝ
  almostSureConvergence :
    ∀ᵐ ω ∂μ, Tendsto (fun n : ℕ => weightedPartialSum w X n ω) atTop (nhds limit)

/-- Constant-weight empirical averages of iid integrable errors converge almost surely.

The former boundary declaration asserted deterministic convergence for arbitrary weights and
arbitrary processes, which is false. This sharpened package is the constant-weight case
of Mathlib's strong law of large numbers.

Historical source: N. Etemadi, "An elementary proof of the strong law of large numbers",
*Z. Wahrscheinlichkeitstheorie verw. Gebiete* 55 (1981), 119-122, main theorem.
Formal source: `ProbabilityTheory.strong_law_ae_real`. -/
noncomputable def weighted_error_average_tendsto {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsFiniteMeasure μ] (c : ℝ) (X : ℕ → Ω → ℝ)
    (hint : Integrable (X 0) μ)
    (hindep : Pairwise fun i j => IndepFun (X i) (X j) μ)
    (hident : ∀ n, IdentDistrib (X n) (X 0) μ μ) :
    WeightedStrongLawPackage μ (fun _ => c) X := by
  refine ⟨c * μ[X 0], ?_⟩
  have hstrong :
      ∀ᵐ ω ∂μ,
        Tendsto (fun n : ℕ => (∑ i ∈ Finset.range n, X i ω) / n) atTop (nhds μ[X 0]) :=
    ProbabilityTheory.strong_law_ae_real X hint hindep hident
  filter_upwards [hstrong] with ω hω
  simpa [weightedPartialSum, Finset.mul_sum, div_eq_mul_inv, mul_comm, mul_left_comm,
    mul_assoc] using (tendsto_const_nhds.mul hω : Tendsto
      (fun n : ℕ => c * ((∑ i ∈ Finset.range n, X i ω) / n)) atTop (nhds (c * μ[X 0])))

end LawOfLargeNumbers
end Probability
end MathlibExpansion
