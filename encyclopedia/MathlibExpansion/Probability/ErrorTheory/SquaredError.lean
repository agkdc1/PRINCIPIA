import Mathlib

/-!
# Squared-error asymptotics

This file packages the strong-law form of the asymptotic law for the mean
sum of squared errors.
-/

namespace MathlibExpansion
namespace Probability
namespace ErrorTheory

open MeasureTheory Filter ProbabilityTheory

/-- Cumulative squared-error energy over the first `n` samples. -/
def squaredErrorEnergy {Ω : Type*} [MeasurableSpace Ω]
    (X : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) : ℝ :=
  ∑ i ∈ Finset.range n, (X i ω) ^ 2

/-- The theorem-level package for squared-error asymptotics. -/
structure SquaredErrorAsymptotic {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ℕ → Ω → ℝ) where
  limit : ℝ
  convergenceInMeasure :
    TendstoInMeasure μ (fun n ω => squaredErrorEnergy X n ω / n) atTop (fun _ => limit)

/-- Squared-error energy has the expected asymptotic law for iid integrable squared errors.

This is the squared-error specialization of Mathlib's
`ProbabilityTheory.strong_law_ae`, whose module documentation cites
Etemadi, *An elementary proof of the strong law of large numbers* (1981). -/
noncomputable def sumsq_errors_asymptotic_law {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : ℕ → Ω → ℝ)
    (hint : Integrable (fun ω => (X 0 ω) ^ 2) μ)
    (hindep :
      Pairwise fun i j =>
        ProbabilityTheory.IndepFun (fun ω => (X i ω) ^ 2) (fun ω => (X j ω) ^ 2) μ)
    (hident :
      ∀ i, ProbabilityTheory.IdentDistrib
        (fun ω => (X i ω) ^ 2) (fun ω => (X 0 ω) ^ 2) μ μ) :
    SquaredErrorAsymptotic μ X := by
  let Y : ℕ → Ω → ℝ := fun n ω => (X n ω) ^ 2
  refine ⟨μ[Y 0], ?_⟩
  have hYae :
      ∀ᵐ ω ∂μ,
        Tendsto (fun n : ℕ => (n : ℝ)⁻¹ • (∑ i ∈ Finset.range n, Y i ω))
          atTop (nhds μ[Y 0]) :=
    ProbabilityTheory.strong_law_ae Y hint hindep hident
  have hYmeas : ∀ i, AEStronglyMeasurable (Y i) μ := fun i =>
    (hident i).aestronglyMeasurable_fst
  refine tendstoInMeasure_of_tendsto_ae ?_ ?_
  · intro n
    dsimp [squaredErrorEnergy, Y]
    simpa [div_eq_mul_inv, Finset.sum_apply, mul_comm, mul_left_comm, mul_assoc] using
      (Finset.aestronglyMeasurable_sum' _ fun i _ => hYmeas i).const_mul ((n : ℝ)⁻¹)
  · filter_upwards [hYae] with ω hω
    simpa [squaredErrorEnergy, Y, div_eq_mul_inv, Finset.sum_apply, mul_comm, mul_left_comm,
      mul_assoc] using hω

end ErrorTheory
end Probability
end MathlibExpansion
