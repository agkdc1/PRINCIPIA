import Mathlib

/-!
# Deferred inventory wrappers for Kolmogorov 1933

The Step 5 verdict marks the foundational Chapter I axioms and the appendix
zero-one theorem as deferred inventory, not as active Step 6 breach lanes.
Because the exact modern owners already exist upstream, we land wrappers rather
than new axioms here and keep `module_path = NULL` in the SQL ledger.
-/

namespace MathlibExpansion
namespace Probability
namespace Kolmogorov1933

open MeasureTheory ProbabilityTheory Filter

/-- Deferred inventory wrapper for Kolmogorov 1933, Chapter I, §1, p. 2:
the axioms have a concrete one-point model.

Modern owner: `Measure.dirac`.
Historical note: Kolmogorov cites Hausdorff's *Mengenlehre* (1927) for the
event-algebra vocabulary on the same page. -/
theorem exists_singleton_probability_model :
    ∃ μ : Measure Unit, IsProbabilityMeasure μ := by
  exact ⟨Measure.dirac (), by infer_instance⟩

/-- Deferred inventory wrapper for Kolmogorov's appendix zero-one theorem.

The exact modern owner already exists upstream as
`ProbabilityTheory.measure_zero_or_one_of_measurableSet_limsup_atTop`; this
deferred signature is recorded here only to keep the Step 6 ledger explicit
while the HVT itself remains non-critical-path.

Historical note: Kolmogorov cites P. Lévy, *Sur un théorème de M. Khintchine*,
*Bull. des Sc. Math.* 55 (1931), Théorème II, at the end of the appendix. -/
theorem measure_zero_or_one_of_measurableSet_limsup_atTop
    {Ω : Type*} {m0 : MeasurableSpace Ω} {μ : Measure Ω} [IsProbabilityMeasure μ]
    (s : ℕ → MeasurableSpace Ω)
    (h_le : ∀ n, s n ≤ m0) (h_indep : ProbabilityTheory.iIndep s μ)
    {t : Set Ω} (ht_tail : MeasurableSet[limsup s atTop] t) :
    μ t = 0 ∨ μ t = 1 := by
  exact ProbabilityTheory.measure_zero_or_one_of_measurableSet_limsup_atTop h_le h_indep ht_tail

end Kolmogorov1933
end Probability
end MathlibExpansion
