import Mathlib

/-!
# Probability laws versus normalized Stieltjes functions

This file packages the bidirectional real-line `cdf` / Stieltjes correspondence
as an explicit equivalence object.
-/

namespace MathlibExpansion
namespace Probability
namespace CDF

open MeasureTheory Filter
open scoped Topology

/-- A normalized Stieltjes function is a right-continuous monotone function with
the correct limits at `±∞`. -/
def NormalizedStieltjesFunction :=
  {f : StieltjesFunction // Tendsto f atBot (𝓝 0) ∧ Tendsto f atTop (𝓝 1)}

/-- Bundled equivalence between real probability laws and normalized Stieltjes functions.

Formal substrate: Mathlib's `ProbabilityTheory.measure_cdf` and
`ProbabilityTheory.cdf_measure_stieltjesFunction`, formalizing the real-line
CDF/Stieltjes correspondence used in Billingsley (1999), *Convergence of
Probability Measures*, Chapter 1. -/
noncomputable def probabilityMeasureStieltjesEquiv :
    ProbabilityMeasure ℝ ≃ NormalizedStieltjesFunction where
  toFun μ :=
    ⟨ProbabilityTheory.cdf (μ : Measure ℝ),
      ProbabilityTheory.tendsto_cdf_atBot (μ : Measure ℝ),
      ProbabilityTheory.tendsto_cdf_atTop (μ : Measure ℝ)⟩
  invFun F :=
    ⟨F.1.measure, F.1.isProbabilityMeasure F.2.1 F.2.2⟩
  left_inv μ := by
    apply ProbabilityMeasure.toMeasure_injective
    exact ProbabilityTheory.measure_cdf (μ : Measure ℝ)
  right_inv F := by
    apply Subtype.ext
    exact ProbabilityTheory.cdf_measure_stieltjesFunction F.1 F.2.1 F.2.2

end CDF
end Probability
end MathlibExpansion
