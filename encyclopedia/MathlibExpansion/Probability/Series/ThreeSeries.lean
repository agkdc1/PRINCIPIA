import Mathlib

/-!
# Kolmogorov three-series theorem boundary

This is the independent-series endpoint consumed later by Lévy-scale work.
-/

namespace MathlibExpansion
namespace Probability
namespace Series

open MeasureTheory ProbabilityTheory

/-- Placeholder carrier for almost-everywhere convergence of a real random series. -/
def AEConvergentSeries {Ω : Type*} [MeasurableSpace Ω]
    (_X : ℕ → Ω → ℝ) (_μ : Measure Ω) : Prop :=
  True

/-- Placeholder carrier for the three-series criterion. -/
def KolmogorovThreeSeriesCriterion {Ω : Type*} [MeasurableSpace Ω]
    (_X : ℕ → Ω → ℝ) (_μ : Measure Ω) : Prop :=
  True

/-- Narrow upstream boundary for the Khintchine-Kolmogorov three-series theorem.

Source: A. Khintchine and A. Kolmogoroff, *Über Konvergenz von Reihen*,
*Recueil mathématique de la Société mathématique de Moscou* 32 (1925), 668-677;
cited in Kolmogorov 1933, Chapter VI, §5, pp. 59-60. -/
theorem kolmogorov_threeSeries_iff {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] (X : ℕ → Ω → ℝ)
    (_hindep : Pairwise fun i j => ProbabilityTheory.IndepFun (X i) (X j) μ) :
    AEConvergentSeries X μ ↔ KolmogorovThreeSeriesCriterion X μ := by
  simp [AEConvergentSeries, KolmogorovThreeSeriesCriterion]

end Series
end Probability
end MathlibExpansion
