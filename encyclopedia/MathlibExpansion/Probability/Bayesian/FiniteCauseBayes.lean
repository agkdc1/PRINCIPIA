import Mathlib

/-!
# Finite-cause Bayes packaging

This file records the finite-partition posterior formula identified by the
Lévy Chapter I recon.
-/

namespace MathlibExpansion
namespace Probability
namespace Bayesian

open MeasureTheory BigOperators

/-- The posterior weight of one hypothesis inside a finite exhaustive family. -/
noncomputable def finitePosteriorWeight {ι Ω : Type*} [Fintype ι] [DecidableEq ι]
    [MeasurableSpace Ω] (μ : ProbabilityMeasure Ω) (A : ι → Set Ω) (E : Set Ω) (i : ι) : ℝ :=
  ((∑ j, (μ (A j ∩ E) : ℝ)))⁻¹ * (μ (A i ∩ E) : ℝ)

/-- Finite exhaustive families of causes give a normalized posterior weight vector,
provided the normalizing denominator is nonzero. -/
theorem posterior_of_finite_partition {ι Ω : Type*} [Fintype ι] [DecidableEq ι]
    [MeasurableSpace Ω] (μ : ProbabilityMeasure Ω) (A : ι → Set Ω) (E : Set Ω)
    (_hA : ∀ i, MeasurableSet (A i)) (_hpart : Pairwise fun i j => Disjoint (A i) (A j))
    (_hcover : (⋃ i, A i) = Set.univ)
    (hdenom : (∑ j, (μ (A j ∩ E) : ℝ)) ≠ 0) :
    ∑ i, finitePosteriorWeight μ A E i = 1 := by
  classical
  let Z : ℝ := ∑ i, (μ (A i ∩ E) : ℝ)
  have hZ : Z ≠ 0 := by
    simpa [Z] using hdenom
  calc
    ∑ i, finitePosteriorWeight μ A E i
        = Z⁻¹ * Z := by
          simp [finitePosteriorWeight, Z, Finset.mul_sum]
    _ = 1 := inv_mul_cancel₀ hZ

end Bayesian
end Probability
end MathlibExpansion
