import Mathlib

/-!
# Countable total probability

This file packages the countable-partition total-probability formula in the
law-first style required by the Lévy recon.
-/

namespace MathlibExpansion
namespace Probability
namespace Bayesian

open MeasureTheory

/-- Countable total probability along the measurable singleton fibers of a countable-valued
observable, proved from Mathlib's countable additivity theorem `MeasureTheory.measure_iUnion`
and `ENNReal.tsum_toReal_eq`. -/
theorem total_probability_countable_partition {Ω ι : Type*} [MeasurableSpace Ω]
    [MeasurableSpace ι] [MeasurableSingletonClass ι] [Countable ι]
    (μ : ProbabilityMeasure Ω) (X : Ω → ι) (hX : Measurable X)
    (E : Set Ω) (hE : MeasurableSet E) :
    (∑' i, ((μ : Measure Ω) (X ⁻¹' {i} ∩ E)).toReal) = ((μ : Measure Ω) E).toReal := by
  let ν : Measure Ω := (μ : Measure Ω)
  have hmeas : ∀ i, MeasurableSet (X ⁻¹' {i} ∩ E) := fun i =>
    (hX (measurableSet_singleton i)).inter hE
  have hdisj : Pairwise (fun i j => Disjoint (X ⁻¹' {i} ∩ E) (X ⁻¹' {j} ∩ E)) := by
    intro i j hij
    rw [Set.disjoint_left]
    intro ω hωi hωj
    have hi : X ω = i := by simpa using hωi.1
    have hj : X ω = j := by simpa using hωj.1
    exact hij (hi.symm.trans hj)
  have hUnion : (⋃ i, X ⁻¹' {i} ∩ E) = E := by
    ext ω
    constructor
    · intro hω
      rcases Set.mem_iUnion.mp hω with ⟨i, hi⟩
      exact hi.2
    · intro hω
      exact Set.mem_iUnion.mpr ⟨X ω, ⟨rfl, hω⟩⟩
  have hmeasure : (∑' i, ν (X ⁻¹' {i} ∩ E)) = ν E := by
    rw [← MeasureTheory.measure_iUnion hdisj hmeas, hUnion]
  calc
    (∑' i, ((μ : Measure Ω) (X ⁻¹' {i} ∩ E)).toReal)
        = (∑' i, (ν (X ⁻¹' {i} ∩ E)).toReal) := by rfl
    _ = (∑' i, ν (X ⁻¹' {i} ∩ E)).toReal := by
      exact (ENNReal.tsum_toReal_eq fun i => measure_ne_top ν (X ⁻¹' {i} ∩ E)).symm
    _ = (ν E).toReal := by rw [hmeasure]
    _ = ((μ : Measure Ω) E).toReal := by rfl

end Bayesian
end Probability
end MathlibExpansion
