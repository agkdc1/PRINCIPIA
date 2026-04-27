import MathlibExpansion.DecisionTheory.LogUtility

/-!
# Log-utility certainty equivalents

This file packages the finite-lottery certainty-equivalent theorem boundary for
Lévy's moral-expectation chapter.
-/

namespace MathlibExpansion
namespace DecisionTheory

/-- Finite-lottery certainty equivalent under log utility.

Source boundary: Paul Lévy, *Calcul des probabilités* (Gauthier-Villars, 1925),
Part I, Chapter 6, moral-expectation chapter; the proof here is the finite
positive-real log/rpow identity supplied by Mathlib. -/
theorem moral_certainty_equivalent_eq_weighted_geomMean {ι : Type*} (s : Finset ι)
    (p x : ι → ℝ) (w c : ℝ)
    (hp_nonneg : ∀ i ∈ s, 0 ≤ p i) (hp_sum : ∑ i ∈ s, p i = 1)
    (hx_pos : ∀ i ∈ s, 0 < w + x i) (hc_pos : 0 < w + c) :
    Real.log (w + c) = ∑ i ∈ s, p i * Real.log (w + x i) ↔
      w + c = ∏ i ∈ s, Real.rpow (w + x i) (p i) := by
  have _ : ∀ i ∈ s, 0 ≤ p i := hp_nonneg
  have _ : ∑ i ∈ s, p i = 1 := hp_sum
  have hprod_pos : 0 < ∏ i ∈ s, Real.rpow (w + x i) (p i) := by
    exact Finset.prod_pos fun i hi => Real.rpow_pos_of_pos (hx_pos i hi) (p i)
  have hlog_prod :
      Real.log (∏ i ∈ s, Real.rpow (w + x i) (p i)) =
        ∑ i ∈ s, p i * Real.log (w + x i) := by
    rw [Real.log_prod]
    · refine Finset.sum_congr rfl ?_
      intro i hi
      simpa [Real.rpow_eq_pow] using Real.log_rpow (hx_pos i hi) (p i)
    · intro i hi
      exact (Real.rpow_pos_of_pos (hx_pos i hi) (p i)).ne'
  constructor
  · intro hlog
    exact Real.log_injOn_pos hc_pos hprod_pos (hlog.trans hlog_prod.symm)
  · intro hce
    rw [hce, hlog_prod]

end DecisionTheory
end MathlibExpansion
