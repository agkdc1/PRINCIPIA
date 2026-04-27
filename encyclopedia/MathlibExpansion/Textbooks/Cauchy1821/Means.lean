import Mathlib

/-!
# Means between extrema

This module packages the arithmetic and geometric mean interval facts that
appear in Cauchy's preliminaries.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Cauchy1821

/-- A weighted arithmetic mean with nonnegative weights lies between the finite
minimum and maximum of the sampled values. -/
theorem weighted_arith_mean_mem_Icc {ι : Type*} (s : Finset ι) (hs : s.Nonempty)
    (w z : ι → ℝ) (hw : ∀ i ∈ s, 0 ≤ w i) (hw' : 0 < ∑ i ∈ s, w i) :
    (∑ i ∈ s, w i * z i) / (∑ i ∈ s, w i) ∈ Set.Icc (s.inf' hs z) (s.sup' hs z) := by
  have hLow : ∀ i ∈ s, s.inf' hs z ≤ z i := fun i hi =>
    (Finset.inf'_le_iff (s := s) (H := hs)).2 ⟨i, hi, le_rfl⟩
  have hHigh : ∀ i ∈ s, z i ≤ s.sup' hs z := fun i hi =>
    (Finset.le_sup'_iff (s := s) (H := hs)).2 ⟨i, hi, le_rfl⟩
  have hLowerSum :
      ∑ i ∈ s, w i * s.inf' hs z ≤ ∑ i ∈ s, w i * z i := by
    exact Finset.sum_le_sum fun i hi =>
      mul_le_mul_of_nonneg_left (hLow i hi) (hw i hi)
  have hUpperSum :
      ∑ i ∈ s, w i * z i ≤ ∑ i ∈ s, w i * s.sup' hs z := by
    exact Finset.sum_le_sum fun i hi =>
      mul_le_mul_of_nonneg_left (hHigh i hi) (hw i hi)
  have hLowerSum' :
      s.inf' hs z * (∑ i ∈ s, w i) ≤ ∑ i ∈ s, w i * z i := by
    rw [Finset.mul_sum]
    simpa [mul_comm, mul_left_comm, mul_assoc] using hLowerSum
  have hUpperSum' :
      ∑ i ∈ s, w i * z i ≤ s.sup' hs z * (∑ i ∈ s, w i) := by
    rw [Finset.mul_sum]
    simpa [mul_comm, mul_left_comm, mul_assoc] using hUpperSum
  constructor
  · exact (le_div_iff₀ hw').2 hLowerSum'
  · exact (div_le_iff₀ hw').2 hUpperSum'

/-- A weighted geometric mean of nonnegative entries lies between the finite
minimum and maximum of the sampled values when the weights sum to `1`. -/
theorem geom_mean_mem_Icc {ι : Type*} (s : Finset ι) (hs : s.Nonempty)
    (w z : ι → ℝ) (hw : ∀ i ∈ s, 0 ≤ w i) (hw' : ∑ i ∈ s, w i = 1)
    (hz : ∀ i ∈ s, 0 ≤ z i) :
    (∏ i ∈ s, z i ^ w i) ∈ Set.Icc (s.inf' hs z) (s.sup' hs z) := by
  let m := s.inf' hs z
  let M := s.sup' hs z
  have hm_le : ∀ i ∈ s, m ≤ z i := fun i hi =>
    (Finset.inf'_le_iff (s := s) (H := hs)).2 ⟨i, hi, le_rfl⟩
  have le_hM : ∀ i ∈ s, z i ≤ M := fun i hi =>
    (Finset.le_sup'_iff (s := s) (H := hs)).2 ⟨i, hi, le_rfl⟩
  have hm_nonneg : 0 ≤ m := by
    obtain ⟨i, hi, hm_eq⟩ := Finset.exists_mem_eq_inf' (s := s) (H := hs) z
    simpa [m, hm_eq] using hz i hi
  have hM_nonneg : 0 ≤ M := by
    obtain ⟨i, hi, hM_eq⟩ := Finset.exists_mem_eq_sup' (s := s) (H := hs) z
    simpa [M, hM_eq] using hz i hi
  have hprod_nonneg : 0 ≤ ∏ i ∈ s, z i ^ w i := by
    exact Finset.prod_nonneg fun i hi => Real.rpow_nonneg (hz i hi) _
  have hUpperProd :
      ∏ i ∈ s, z i ^ w i ≤ ∏ i ∈ s, M ^ w i := by
    refine Finset.prod_le_prod (fun i hi => Real.rpow_nonneg (hz i hi) _) ?_
    intro i hi
    exact Real.rpow_le_rpow (hz i hi) (le_hM i hi) (hw i hi)
  have hUpperConst : ∏ i ∈ s, M ^ w i = M := by
    exact Real.geom_mean_weighted_of_constant s w (fun _ => M) M hw hw'
      (fun _ _ => hM_nonneg) (fun _ _ _ => rfl)
  have hLowerProd :
      ∏ i ∈ s, m ^ w i ≤ ∏ i ∈ s, z i ^ w i := by
    refine Finset.prod_le_prod (fun i hi => Real.rpow_nonneg hm_nonneg _) ?_
    intro i hi
    exact Real.rpow_le_rpow hm_nonneg (hm_le i hi) (hw i hi)
  have hLowerConst : ∏ i ∈ s, m ^ w i = m := by
    exact Real.geom_mean_weighted_of_constant s w (fun _ => m) m hw hw'
      (fun _ _ => hm_nonneg) (fun _ _ _ => rfl)
  have hLower :
      m ≤ ∏ i ∈ s, z i ^ w i := by
    exact hLowerConst.symm.trans_le hLowerProd
  have hUpper : ∏ i ∈ s, z i ^ w i ≤ M := by
    exact hUpperProd.trans_eq hUpperConst
  constructor
  · change m ≤ ∏ i ∈ s, z i ^ w i
    exact hLower
  · change ∏ i ∈ s, z i ^ w i ≤ M
    exact hUpper

end Cauchy1821
end Textbooks
end MathlibExpansion
