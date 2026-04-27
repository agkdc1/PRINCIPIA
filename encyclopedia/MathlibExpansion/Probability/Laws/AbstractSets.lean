import Mathlib

/-!
# Probability laws on abstract measurable spaces

This file packages the thin normalized-density wrapper identified by the Lévy
recon for abstract probability laws.
-/

namespace MathlibExpansion
namespace Probability
namespace Laws

open MeasureTheory
open scoped ENNReal

/-- Narrow probability-law wrapper: a normalized measurable density defines a probability law. -/
theorem isProbabilityMeasure_withDensity {α : Type*} [MeasurableSpace α] {μ : Measure α} [SFinite μ]
    {f : α → ℝ≥0∞} (_hf : Measurable f) (hnorm : ∫⁻ x, f x ∂μ = 1) :
    IsProbabilityMeasure (μ.withDensity f) := by
  rw [isProbabilityMeasure_iff, withDensity_apply _ MeasurableSet.univ]
  simpa using hnorm

/-- Bundle the normalized-density wrapper as a probability measure. -/
noncomputable def probabilityMeasureOfDensity {α : Type*} [MeasurableSpace α]
    {μ : Measure α} [SFinite μ] (f : α → ℝ≥0∞) (hf : Measurable f)
    (hnorm : ∫⁻ x, f x ∂μ = 1) : ProbabilityMeasure α :=
  ⟨μ.withDensity f, isProbabilityMeasure_withDensity hf hnorm⟩

end Laws
end Probability
end MathlibExpansion
