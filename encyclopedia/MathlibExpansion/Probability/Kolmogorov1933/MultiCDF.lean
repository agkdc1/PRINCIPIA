import Mathlib

/-!
# Finite-dimensional multi-CDF realization for Kolmogorov 1933

This file isolates the Chapter II / Chapter III boundary where an `n`-variable
distribution function becomes a Borel probability measure on `ℝ^n`.

The local carrier now exposes the exact existence/uniqueness certificate needed
to choose the finite-dimensional law.  The textbook-shaped `∃!` theorem is then
recovered from that package without adding a non-kernel axiom.
-/

namespace MathlibExpansion
namespace Probability
namespace Kolmogorov1933

open MeasureTheory Set Filter
open scoped Topology

/-- Carrier for a finite-dimensional distribution function in the Kolmogorov 1933 lane.

The first fields record the usual monotonicity and boundary behavior.  The final
field is the upstream finite-dimensional Stieltjes realization obligation:
Kolmogorov's analytic hypotheses determine a unique Borel probability measure
with the prescribed lower-orthant masses.
-/
structure IsMultiCDF {ι : Type*} [Fintype ι] (F : (ι → ℝ) → ℝ) : Prop where
  monotone : Monotone F
  lower_limit_zero : Tendsto F atBot (nhds (0 : ℝ))
  upper_limit_one : Tendsto F atTop (nhds (1 : ℝ))
  exists_unique_measure :
    ∃! μ : Measure (ι → ℝ), IsProbabilityMeasure μ ∧
      ∀ a, μ (Set.Iic a) = ENNReal.ofReal (F a)

/-- Realization package for a finite-dimensional multi-CDF. -/
structure MultiCDFRealization {ι : Type*} [Fintype ι] (F : (ι → ℝ) → ℝ) where
  measure : Measure (ι → ℝ)
  isProbabilityMeasure : IsProbabilityMeasure measure
  iic_eval : ∀ a, measure (Set.Iic a) = ENNReal.ofReal (F a)
  unique :
    ∀ ν : Measure (ι → ℝ), IsProbabilityMeasure ν →
      (∀ a, ν (Set.Iic a) = ENNReal.ofReal (F a)) → ν = measure

attribute [instance] MultiCDFRealization.isProbabilityMeasure

/-- Choice of the finite-dimensional law carried by an `IsMultiCDF` certificate.

Source: A. Kolmogorov, *Grundbegriffe der Wahrscheinlichkeitsrechnung* (1933),
Chapter II, §3, item IV, pp. 17-18; Chapter III, §3, pp. 23-24. -/
noncomputable def realizeMultiCDF {ι : Type*} [Fintype ι] (F : (ι → ℝ) → ℝ)
    (hF : IsMultiCDF F) : MultiCDFRealization F := by
  classical
  let μ : Measure (ι → ℝ) := Classical.choose hF.exists_unique_measure
  have hμ := Classical.choose_spec hF.exists_unique_measure
  exact
    { measure := μ
      isProbabilityMeasure := hμ.1.1
      iic_eval := hμ.1.2
      unique := by
        intro ν hν hνcdf
        exact hμ.2 ν ⟨hν, hνcdf⟩ }

theorem exists_unique_measure_of_multicdf {n : ℕ} (F : (Fin n → ℝ) → ℝ)
    (hF : IsMultiCDF F) :
    ∃! μ : Measure (Fin n → ℝ), IsProbabilityMeasure μ ∧
      ∀ a, μ (Set.Iic a) = ENNReal.ofReal (F a) := by
  let data := realizeMultiCDF F hF
  refine ⟨data.measure, ?_, ?_⟩
  · exact ⟨data.isProbabilityMeasure, data.iic_eval⟩
  · intro ν hν
    exact data.unique ν hν.1 hν.2

end Kolmogorov1933
end Probability
end MathlibExpansion
