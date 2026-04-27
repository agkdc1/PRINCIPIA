import Mathlib.Data.Real.Basic

import Mathlib

/-!
# Root test for nonnegative real series

This module provides textbook-facing real root-test wrappers in the restricted
positive-term setting requested by the Cauchy 1821 expansion.
-/

open Filter

namespace MathlibExpansion
namespace Analysis
namespace SpecificLimits

/-- An eventual root bound by some `r < 1` implies summability of a
nonnegative real series. -/
theorem summable_of_eventually_root_bound_le {u : ℕ → ℝ} (hu : ∀ n, 0 ≤ u n)
    {r : ℝ} (hr₁ : r < 1)
    (hroot : ∀ᶠ n in atTop, u n ^ ((n : ℝ)⁻¹) ≤ r) :
    Summable u := by
  have hroot_nonneg : ∀ᶠ n in atTop, 0 ≤ u n ^ ((n : ℝ)⁻¹) := by
    filter_upwards with n
    exact Real.rpow_nonneg (hu n) _
  have hr₀ : 0 ≤ r := by
    rcases (hroot.and hroot_nonneg).exists with ⟨n, hnle, hnnonneg⟩
    exact hnnonneg.trans hnle
  refine Summable.of_norm_bounded_eventually_nat (fun n => r ^ n)
    (summable_geometric_of_lt_one hr₀ hr₁) ?_
  filter_upwards [hroot, Ici_mem_atTop 1] with n hnroot hn
  have hn1 : 1 ≤ n := by simpa using hn
  have hn0 : n ≠ 0 := Nat.ne_of_gt (lt_of_lt_of_le Nat.zero_lt_one hn1)
  have hpow :
      (u n ^ ((n : ℝ)⁻¹)) ^ n ≤ r ^ n := by
    have : (u n ^ ((n : ℝ)⁻¹)) ^ (n : ℝ) ≤ r ^ (n : ℝ) := by
      exact Real.rpow_le_rpow (Real.rpow_nonneg (hu n) _) hnroot (show 0 ≤ (n : ℝ) by positivity)
    simpa [Real.rpow_natCast] using this
  calc
    ‖u n‖ = u n := by simpa [abs_of_nonneg (hu n)]
    _ = (u n ^ ((n : ℝ)⁻¹)) ^ n := by
      symm
      exact Real.rpow_inv_natCast_pow (hu n) hn0
    _ ≤ r ^ n := hpow

/-- A limsup root bound below `1` implies summability, provided the root
sequence is bounded above so that `limsup` estimates can be converted to an
eventual estimate. -/
theorem summable_of_root_test_limsup_lt_one {u : ℕ → ℝ} (hu : ∀ n, 0 ≤ u n)
    (hbounded : IsBoundedUnder (· ≤ ·) atTop (fun n => u n ^ ((n : ℝ)⁻¹)))
    (hroot : Filter.limsup (fun n => u n ^ ((n : ℝ)⁻¹)) atTop < 1) :
    Summable u := by
  obtain ⟨r, hrLeft, hrRight⟩ := exists_between hroot
  refine summable_of_eventually_root_bound_le hu hrRight ?_
  exact (eventually_lt_of_limsup_lt hrLeft hbounded).mono fun n hn => hn.le

end SpecificLimits
end Analysis
end MathlibExpansion
