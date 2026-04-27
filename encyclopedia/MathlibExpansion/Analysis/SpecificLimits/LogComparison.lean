import Mathlib.Data.Real.Basic

import Mathlib

/-!
# Logarithmic comparison for positive real series

This module packages a textbook-facing logarithmic comparison criterion in the
restricted real positive-term setting used in Cauchy's Chapter VI.
-/

open Filter

namespace MathlibExpansion
namespace Analysis
namespace SpecificLimits

/-- If `log (u n) / log (1 / n)` tends to a value strictly larger than `1`,
then `u` is summable. -/
theorem summable_of_log_comparison {u : ℕ → ℝ} {h : ℝ}
    (hu : ∀ᶠ n in atTop, 0 < u n) (hh : 1 < h)
    (hlog : Tendsto (fun n => Real.log (u n) / Real.log (1 / (n : ℝ))) atTop (nhds h)) :
    Summable u := by
  obtain ⟨p, hp, hph⟩ := exists_between hh
  refine Summable.of_norm_bounded_eventually_nat (fun n => ((n : ℝ) ^ p)⁻¹)
    (Real.summable_nat_rpow_inv.2 hp) ?_
  filter_upwards [hu, hlog.eventually_const_lt hph, Ici_mem_atTop 2] with n hun hratio hn
  have hn2 : 2 ≤ n := by simpa using hn
  have hnpos : 0 < (n : ℝ) := by
    exact_mod_cast (lt_of_lt_of_le (by norm_num : 0 < 2) hn2)
  have hn_gt_one : (1 : ℝ) < n := by
    exact_mod_cast (lt_of_lt_of_le (by norm_num : 1 < 2) hn2)
  have hlogn_pos : 0 < Real.log (n : ℝ) := Real.log_pos hn_gt_one
  have hratio0 : p < Real.log (u n) / (-Real.log (n : ℝ)) := by
    simpa [one_div, Real.log_inv, div_eq_mul_inv] using hratio
  have hratio' : p < -Real.log (u n) / Real.log (n : ℝ) := by
    simpa [div_neg, neg_div] using hratio0
  have hmul : p * Real.log (n : ℝ) < -Real.log (u n) :=
    (lt_div_iff₀ hlogn_pos).mp hratio'
  have hlog_upper : Real.log (u n) < Real.log (((n : ℝ) ^ p)⁻¹) := by
    have : Real.log (u n) < -(p * Real.log (n : ℝ)) := by linarith
    simpa [Real.log_inv, Real.log_rpow hnpos p] using this
  have hcomp_pos : 0 < ((n : ℝ) ^ p)⁻¹ := by
    exact inv_pos.mpr (Real.rpow_pos_of_pos hnpos p)
  have hu_upper : u n < ((n : ℝ) ^ p)⁻¹ :=
    (Real.log_lt_log_iff hun hcomp_pos).mp hlog_upper
  calc
    ‖u n‖ = u n := by simpa [abs_of_pos hun]
    _ ≤ ((n : ℝ) ^ p)⁻¹ := hu_upper.le

end SpecificLimits
end Analysis
end MathlibExpansion
