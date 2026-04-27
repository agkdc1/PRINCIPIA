import Mathlib

/-!
# Compensation of accidental errors

This file packages the finite-sample averaging theorem boundary in Lévy's error
theory chapter.
-/

namespace MathlibExpansion
namespace Probability
namespace ErrorTheory

open MeasureTheory ProbabilityTheory

/-- Arithmetic mean of the first `n` observations. -/
noncomputable def arithmeticMean {Ω : Type*} [MeasurableSpace Ω]
    (X : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) : ℝ :=
  (∑ i ∈ Finset.range n, X i ω) / n

/-- Averaging compensates centered accidental errors by dividing the variance by sample size.

This packages the variance identity used in Paul Lévy, *Calcul des probabilités*
(Gauthier-Villars, 1925), Part II, Chapter VII, "Théorie des erreurs",
least-squares/error-compensation chapter. -/
theorem variance_mean_of_iid_errors {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    [IsProbabilityMeasure μ] (X : ℕ → Ω → ℝ) (n : ℕ) (hn : 0 < n)
    (h2 : ∀ i, MemLp (X i) 2 μ) (hmean : ∀ i, μ[X i] = 0)
    (hident : ∀ i, IdentDistrib (X i) (X 0) μ μ)
    (hindep : Pairwise fun i j ↦ IndepFun (X i) (X j) μ) :
    variance (fun ω ↦ arithmeticMean X n ω) μ = variance (X 0) μ / n := by
  classical
  have _centered : ∀ i, μ[X i] = 0 := hmean
  have hn_ne : (n : ℝ) ≠ 0 := by exact_mod_cast hn.ne'
  have hsum :
      variance (∑ i ∈ Finset.range n, X i) μ =
        n * variance (X 0) μ := by
    calc
      variance (∑ i ∈ Finset.range n, X i) μ =
          ∑ i ∈ Finset.range n, variance (X i) μ := by
        simpa using
          (IndepFun.variance_sum (μ := μ) (X := X) (s := Finset.range n)
            (by
              intro i _hi
              exact h2 i)
            (by
              intro i _hi j _hj hij
              exact hindep hij))
      _ = ∑ _i ∈ Finset.range n, variance (X 0) μ := by
        exact Finset.sum_congr rfl fun i _hi ↦ hident i |>.variance_eq
      _ = n * variance (X 0) μ := by
        simp
  have hmean_fun :
      (fun ω ↦ arithmeticMean X n ω) =
        fun ω ↦ (n : ℝ)⁻¹ * (∑ i ∈ Finset.range n, X i) ω := by
    funext ω
    simp [arithmeticMean, div_eq_inv_mul]
  calc
    variance (fun ω ↦ arithmeticMean X n ω) μ =
        variance (fun ω ↦ (n : ℝ)⁻¹ * (∑ i ∈ Finset.range n, X i) ω) μ := by
      rw [hmean_fun]
    _ = ((n : ℝ)⁻¹) ^ 2 * variance (∑ i ∈ Finset.range n, X i) μ := by
      rw [variance_mul]
    _ = ((n : ℝ)⁻¹) ^ 2 * (n * variance (X 0) μ) := by
      rw [hsum]
    _ = variance (X 0) μ / n := by
      field_simp [hn_ne]
      ring

end ErrorTheory
end Probability
end MathlibExpansion
