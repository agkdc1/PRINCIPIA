import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

import Mathlib.Analysis.Asymptotics.SpecificAsymptotics
import Mathlib.Analysis.Fourier.AddCircle
import Mathlib.Order.Filter.AtTopBot.Finset

/-!
# Fejér means on the circle

This file introduces the basic Cesàro averaging operators for Fourier partial
sums and proves Fejér convergence under the stronger summable-coefficient
hypothesis already available in Mathlib.
-/

noncomputable section

open scoped BigOperators Topology
open AddCircle
open Complex
open Filter

namespace MathlibExpansion
namespace Analysis
namespace Fourier

local instance : Fact (0 < 2 * Real.pi) := ⟨by positivity⟩

/-- Symmetric Fourier partial sums on the circle. -/
def symmetricPartialSum
    (f : C(AddCircle (2 * Real.pi), ℂ)) (N : ℕ) :
    C(AddCircle (2 * Real.pi), ℂ) :=
  ∑ n ∈ Finset.Icc (-((N : ℤ))) (N : ℤ), fourierCoeff f n • fourier n

/-- Fejér mean as the Cesàro average of the symmetric partial sums. -/
def fejerMean
    (f : C(AddCircle (2 * Real.pi), ℂ)) (N : ℕ) :
    C(AddCircle (2 * Real.pi), ℂ) :=
  ((N + 1 : ℂ)⁻¹) • ∑ m ∈ Finset.range (N + 1), symmetricPartialSum f m

/-- The Fejér mean is, by definition, the Cesàro average of the symmetric
partial sums. This wrapper is kept explicit because later classical convergence
proofs use this identity as the entry point. -/
theorem fejerMean_eq_cesaroAverage
    (f : C(AddCircle (2 * Real.pi), ℂ)) (N : ℕ) :
    fejerMean f N =
      ((N + 1 : ℂ)⁻¹) • ∑ m ∈ Finset.range (N + 1), symmetricPartialSum f m :=
  rfl

/-- Symmetric Fourier partial sums converge in the sup norm when the Fourier
coefficients are summable. -/
theorem tendsto_symmetricPartialSum_of_summable
    (f : C(AddCircle (2 * Real.pi), ℂ))
    (h : Summable (fourierCoeff f)) :
    Tendsto (fun N : ℕ => symmetricPartialSum f N) atTop (𝓝 f) := by
  let g : ℤ → C(AddCircle (2 * Real.pi), ℂ) := fun n => fourierCoeff f n • fourier n
  have hsum : HasSum g f := by
    simpa [g] using (hasSum_fourier_series_of_summable (f := f) h)
  have hsets : Tendsto (fun N : ℕ => Finset.Icc (-((N : ℤ))) (N : ℤ)) atTop atTop := by
    refine Monotone.tendsto_atTop_finset ?_ ?_
    · intro m n hmn
      have hmn' : (m : ℤ) ≤ n := by exact_mod_cast hmn
      exact Finset.Icc_subset_Icc (neg_le_neg hmn') hmn'
    · intro z
      cases z with
      | ofNat n =>
          refine ⟨n, ?_⟩
          simp
      | negSucc n =>
          refine ⟨n + 1, ?_⟩
          simp
  simpa [symmetricPartialSum, g] using hsum.comp hsets

/-- Fejér means converge uniformly when the Fourier coefficients are summable.

This is weaker than the full classical theorem for arbitrary continuous data,
but it is an honest convergence theorem that already packages the Cesàro repair
route in the regime controlled by Mathlib's summable-coefficient theorem. -/
theorem tendsto_fejerMean_of_summable
    (f : C(AddCircle (2 * Real.pi), ℂ))
    (h : Summable (fourierCoeff f)) :
    Tendsto (fun N : ℕ => fejerMean f N) atTop (𝓝 f) := by
  have hpartial : Tendsto (fun N : ℕ => symmetricPartialSum f N) atTop (𝓝 f) :=
    tendsto_symmetricPartialSum_of_summable f h
  have hcesaro :
      Tendsto
        (fun N : ℕ =>
          ((N + 1 : ℝ)⁻¹) • ∑ m ∈ Finset.range (N + 1), symmetricPartialSum f m)
        atTop (𝓝 f) := by
    simpa using hpartial.cesaro_smul.comp (tendsto_add_atTop_nat 1)
  convert hcesaro using 1
  ext N x
  simp [fejerMean, Algebra.smul_def, mul_assoc]

end Fourier
end Analysis
end MathlibExpansion
