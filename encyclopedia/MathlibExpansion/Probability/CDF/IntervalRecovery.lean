import Mathlib

/-!
# Interval and atom recovery from the CDF

This file exposes the textbook-facing real-line interval formulas attached to a
probability law and its CDF.
-/

namespace MathlibExpansion
namespace Probability
namespace CDF

open MeasureTheory

/-- Left limit of the CDF of a probability law. -/
noncomputable def cdfLeftLim (μ : ProbabilityMeasure ℝ) (x : ℝ) : ℝ :=
  Function.leftLim (ProbabilityTheory.cdf (μ : Measure ℝ)) x

/-- Bundled interval/atom recovery formulas for a real probability law. -/
structure CDFIntervalRecovery (μ : ProbabilityMeasure ℝ) where
  Ioc_formula :
    ∀ a b : ℝ,
      (μ : Measure ℝ) (Set.Ioc a b) =
        ENNReal.ofReal (ProbabilityTheory.cdf (μ : Measure ℝ) b -
          ProbabilityTheory.cdf (μ : Measure ℝ) a)
  atom_formula :
    ∀ a : ℝ,
      (μ : Measure ℝ) ({a} : Set ℝ) =
        ENNReal.ofReal (ProbabilityTheory.cdf (μ : Measure ℝ) a - cdfLeftLim μ a)
  Icc_formula :
    ∀ a b : ℝ,
      (μ : Measure ℝ) (Set.Icc a b) =
        ENNReal.ofReal (ProbabilityTheory.cdf (μ : Measure ℝ) b - cdfLeftLim μ a)
  Ioo_formula :
    ∀ a b : ℝ,
      (μ : Measure ℝ) (Set.Ioo a b) =
        ENNReal.ofReal (cdfLeftLim μ b - ProbabilityTheory.cdf (μ : Measure ℝ) a)
  Ico_formula :
    ∀ a b : ℝ,
      (μ : Measure ℝ) (Set.Ico a b) =
        ENNReal.ofReal (cdfLeftLim μ b - cdfLeftLim μ a)

/--
The direct `cdf μ` interval / atom recovery package.

Formal substrate: Mathlib's `StieltjesFunction.measure_Ioc`,
`StieltjesFunction.measure_singleton`, `StieltjesFunction.measure_Icc`,
`StieltjesFunction.measure_Ioo`, `StieltjesFunction.measure_Ico`, and
`ProbabilityTheory.measure_cdf`.
-/
theorem cdf_interval_recovery (μ : ProbabilityMeasure ℝ) : CDFIntervalRecovery μ := by
  let F : StieltjesFunction := ProbabilityTheory.cdf (μ : Measure ℝ)
  have hF : F.measure = (μ : Measure ℝ) := by
    simpa [F] using ProbabilityTheory.measure_cdf (μ : Measure ℝ)
  refine
    { Ioc_formula := ?_
      atom_formula := ?_
      Icc_formula := ?_
      Ioo_formula := ?_
      Ico_formula := ?_ }
  · intro a b
    simpa [F, hF] using F.measure_Ioc a b
  · intro a
    simpa [F, hF, cdfLeftLim] using F.measure_singleton a
  · intro a b
    simpa [F, hF, cdfLeftLim] using F.measure_Icc a b
  · intro a b
    simpa [F, hF, cdfLeftLim] using F.measure_Ioo (a := a) (b := b)
  · intro a b
    simpa [F, hF, cdfLeftLim] using F.measure_Ico a b

end CDF
end Probability
end MathlibExpansion
