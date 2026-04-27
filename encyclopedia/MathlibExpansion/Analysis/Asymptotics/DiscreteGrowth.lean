import Mathlib.Data.Real.Basic

import Mathlib
import MathlibExpansion.Analysis.Asymptotics.FiniteDifference

/-!
# Discrete multiplicative growth

This module packages the sequence-level ratio-to-root transfer theorem used by
Cauchy's Chapter II, Section III.
-/

open Filter

namespace MathlibExpansion
namespace Analysis
namespace Asymptotics

/-- If a positive real sequence has successive quotients tending to `A > 0`,
then its `n`-th roots tend to `A`. -/
theorem tendsto_nat_rpow_inv_of_tendsto_succ_ratio {u : ℕ → ℝ} {A : ℝ}
    (hA : 0 < A) (hpos : ∀ᶠ n in atTop, 0 < u n)
    (h : Tendsto (fun n => u (n + 1) / u n) atTop (nhds A)) :
    Tendsto (fun n => Real.rpow (u n) ((n : ℝ)⁻¹)) atTop (nhds A) := by
  have hposSucc : ∀ᶠ n in atTop, 0 < u (n + 1) := by
    exact (tendsto_add_atTop_nat 1).eventually hpos
  have hLogRatio : Tendsto (fun n => Real.log (u (n + 1) / u n)) atTop (nhds (Real.log A)) := by
    exact (Real.continuousAt_log hA.ne').tendsto.comp h
  have hLogDiff :
      Tendsto (fun n => Real.log (u (n + 1)) - Real.log (u n)) atTop (nhds (Real.log A)) := by
    refine Tendsto.congr' ?_ hLogRatio
    filter_upwards [hposSucc, hpos] with n hsucc hposn
    rw [Real.log_div (ne_of_gt hsucc) (ne_of_gt hposn)]
  have hLogAverage :
      Tendsto (fun n => Real.log (u n) / n) atTop (nhds (Real.log A)) :=
    tendsto_nat_div_of_tendsto_succ_sub hLogDiff
  have hExp :
      Tendsto (fun n => Real.exp (Real.log (u n) / n)) atTop (nhds (Real.exp (Real.log A))) :=
    (Real.continuous_exp.continuousAt : ContinuousAt Real.exp (Real.log A)).tendsto.comp
      hLogAverage
  have hEventually :
      (fun n => Real.rpow (u n) ((n : ℝ)⁻¹))
        =ᶠ[atTop] fun n => Real.exp (Real.log (u n) / n) := by
    filter_upwards [hpos] with n hn
    change (u n) ^ ((n : ℝ)⁻¹) = Real.exp (Real.log (u n) / n)
    rw [Real.rpow_def_of_pos hn, div_eq_mul_inv]
  refine Tendsto.congr' hEventually.symm ?_
  simpa [Real.exp_log hA] using hExp

/-- Upstream-narrow floor reduction of the real-indexed ratio-to-root transfer
theorem. The extra logarithmic gap hypothesis controls the difference between
`f x` and the sampled values `f ⌊x⌋₊`. -/
theorem tendsto_rpow_inv_of_tendsto_stepRatio_floor {f : ℝ → ℝ} {k : ℝ}
    (hk : 0 < k) (hpos : ∀ᶠ x in atTop, 0 < f x)
    (h : Tendsto (fun x : ℝ => f (x + 1) / f x) atTop (nhds k))
    (hgap :
      Tendsto (fun x : ℝ => (Real.log (f x) - Real.log (f ⌊x⌋₊)) / x) atTop (nhds 0)) :
    Tendsto (fun x : ℝ => Real.rpow (f x) (x⁻¹)) atTop (nhds k) := by
  have hposNat : ∀ᶠ n : ℕ in atTop, 0 < f n := by
    exact tendsto_natCast_atTop_atTop.eventually hpos
  have hNat : Tendsto (fun n : ℕ => f (n + 1) / f n) atTop (nhds k) := by
    simpa [Nat.cast_add, Nat.cast_one] using h.comp tendsto_natCast_atTop_atTop
  have hSeq : Tendsto (fun n : ℕ => Real.rpow (f n) ((n : ℝ)⁻¹)) atTop (nhds k) :=
    tendsto_nat_rpow_inv_of_tendsto_succ_ratio hk hposNat <|
      by simpa [Nat.cast_add, Nat.cast_one] using hNat
  have hLogSeqAux :
      Tendsto (fun n : ℕ => Real.log (Real.rpow (f n) ((n : ℝ)⁻¹))) atTop (nhds (Real.log k)) := by
    exact (Real.continuousAt_log hk.ne').tendsto.comp hSeq
  have hLogSeqEq :
      (fun n : ℕ => Real.log (Real.rpow (f n) ((n : ℝ)⁻¹)))
        =ᶠ[atTop] fun n => Real.log (f n) / n := by
    filter_upwards [hposNat] with n hn
    change Real.log ((f n) ^ ((n : ℝ)⁻¹)) = Real.log (f n) / n
    rw [Real.rpow_def_of_pos hn, Real.log_exp, div_eq_mul_inv]
  have hLogSeq : Tendsto (fun n : ℕ => Real.log (f n) / n) atTop (nhds (Real.log k)) := by
    refine Tendsto.congr' hLogSeqEq ?_
    exact hLogSeqAux
  have hFloorLogSeq :
      Tendsto (fun x : ℝ => Real.log (f ⌊x⌋₊) / (⌊x⌋₊ : ℝ)) atTop (nhds (Real.log k)) := by
    simpa using hLogSeq.comp tendsto_nat_floor_atTop
  have hFloorLogAux :
      Tendsto
        (fun x : ℝ =>
          (Real.log (f ⌊x⌋₊) / (⌊x⌋₊ : ℝ)) * ((⌊x⌋₊ : ℝ) / x))
        atTop (nhds (Real.log k * 1)) :=
    hFloorLogSeq.mul tendsto_nat_floor_div_atTop
  have hFloorLogEq :
      (fun x : ℝ => Real.log (f ⌊x⌋₊) / x)
        =ᶠ[atTop] fun x =>
          (Real.log (f ⌊x⌋₊) / (⌊x⌋₊ : ℝ)) * ((⌊x⌋₊ : ℝ) / x) := by
    filter_upwards [Ioi_mem_atTop (1 : ℝ)] with x hx
    have hx1 : 1 < x := by simpa using hx
    have hfloor_pos : 0 < (⌊x⌋₊ : ℝ) := by
      exact_mod_cast (Nat.floor_pos.mpr hx1.le)
    field_simp [hx1.ne', hfloor_pos.ne']
  have hFloorLog : Tendsto (fun x : ℝ => Real.log (f ⌊x⌋₊) / x) atTop (nhds (Real.log k)) := by
    refine Tendsto.congr' hFloorLogEq.symm ?_
    simpa using hFloorLogAux
  have hLogDecomp :
      (fun x : ℝ => Real.log (f x) / x)
        =ᶠ[atTop] fun x =>
          Real.log (f ⌊x⌋₊) / x + (Real.log (f x) - Real.log (f ⌊x⌋₊)) / x := by
    filter_upwards [Ioi_mem_atTop (0 : ℝ)] with x hx
    have hx0 : 0 < x := by simpa using hx
    field_simp [hx0.ne']
  have hLog : Tendsto (fun x : ℝ => Real.log (f x) / x) atTop (nhds (Real.log k)) := by
    refine Tendsto.congr' hLogDecomp.symm ?_
    simpa using hFloorLog.add hgap
  have hExp :
      Tendsto (fun x : ℝ => Real.exp (Real.log (f x) / x)) atTop (nhds (Real.exp (Real.log k))) :=
    (Real.continuous_exp.continuousAt : ContinuousAt Real.exp (Real.log k)).tendsto.comp hLog
  have hEventually :
      (fun x : ℝ => Real.rpow (f x) (x⁻¹))
        =ᶠ[atTop] fun x => Real.exp (Real.log (f x) / x) := by
    filter_upwards [hpos] with x hx
    change (f x) ^ (x⁻¹) = Real.exp (Real.log (f x) / x)
    rw [Real.rpow_def_of_pos hx, div_eq_mul_inv]
  refine Tendsto.congr' hEventually.symm ?_
  simpa [Real.exp_log hk] using hExp

end Asymptotics
end Analysis
end MathlibExpansion
