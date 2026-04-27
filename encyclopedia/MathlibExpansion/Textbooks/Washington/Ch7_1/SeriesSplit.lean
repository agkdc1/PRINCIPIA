import Mathlib.RingTheory.PowerSeries.Trunc

/-!
# Washington Ch. 7.1: truncation and tail splitting

This file packages the basic decomposition of a power series into a finite
polynomial head and an `X^(n+1)` tail.
-/

noncomputable section

open Polynomial PowerSeries

namespace MathlibExpansion
namespace Textbooks
namespace Washington
namespace Ch7_1

section

variable {R : Type*} [CommSemiring R]

/-- The tail after degree `n`, reindexed to start at degree `0`. -/
def tailFrom (n : ℕ) (f : PowerSeries R) : PowerSeries R :=
  PowerSeries.mk fun m => PowerSeries.coeff R (m + n) f

@[simp] theorem coeff_tailFrom (n m : ℕ) (f : PowerSeries R) :
    PowerSeries.coeff R m (tailFrom n f) = PowerSeries.coeff R (m + n) f := by
  simp [tailFrom]

/-- Right-multiplication by `X^n` shifts coefficients by `n`. -/
theorem coeff_mul_X_pow (f : PowerSeries R) (m n : ℕ) :
    PowerSeries.coeff R (m + n) (f * (PowerSeries.X : PowerSeries R) ^ n) =
      PowerSeries.coeff R m f := by
  rw [mul_comm]
  simpa [add_comm, add_left_comm, add_assoc] using
    (PowerSeries.coeff_X_pow_mul' (p := f) n m)

/-- The truncation polynomial agrees with `f` below degree `n`. -/
theorem trunc_coeff_eq (f : PowerSeries R) (m n : ℕ) (hm : m < n) :
    (PowerSeries.trunc n f).coeff m = PowerSeries.coeff R m f := by
  simp [PowerSeries.coeff_trunc, hm]

/-- The truncation polynomial has zero coefficients at degree `≥ n`. -/
theorem trunc_coeff_eq_zero (f : PowerSeries R) (m n : ℕ) (hm : n ≤ m) :
    (PowerSeries.trunc n f).coeff m = 0 := by
  simp [PowerSeries.coeff_trunc, hm.not_lt]

/-- A power series splits into its degree-`≤ n` head and its tail. -/
theorem trunc_add_X_pow_tailFrom (f : PowerSeries R) (n : ℕ) :
    ((PowerSeries.trunc (n + 1) f : Polynomial R) : PowerSeries R) +
        (PowerSeries.X : PowerSeries R) ^ (n + 1) * tailFrom (n + 1) f = f := by
  ext m
  simp only [map_add, Polynomial.coeff_coe, coeff_tailFrom, PowerSeries.coeff_trunc,
    PowerSeries.coeff_X_pow_mul']
  by_cases hm : m < n + 1
  · rw [if_pos hm]
    have hmn : ¬ n + 1 ≤ m := not_le_of_lt hm
    simp [hmn]
  · rw [if_neg hm]
    have hmn : n + 1 ≤ m := Nat.le_of_not_lt hm
    rw [if_pos hmn]
    simp [Nat.sub_add_cancel hmn]

/-- Equivalent head-tail decomposition with the tail on the right. -/
theorem trunc_add_tail_mul_X_pow (f : PowerSeries R) (n : ℕ) :
    ((PowerSeries.trunc (n + 1) f : Polynomial R) : PowerSeries R) +
        tailFrom (n + 1) f * (PowerSeries.X : PowerSeries R) ^ (n + 1) = f := by
  rw [mul_comm]
  exact trunc_add_X_pow_tailFrom f n

/-- The tail has zero constant term iff the original coefficient at `n` vanishes. -/
theorem constantCoeff_tailFrom_eq (n : ℕ) (f : PowerSeries R) :
    PowerSeries.constantCoeff R (tailFrom n f) = PowerSeries.coeff R n f := by
  rw [← PowerSeries.coeff_zero_eq_constantCoeff_apply, coeff_tailFrom]
  simp

end

end Ch7_1
end Washington
end Textbooks
end MathlibExpansion
