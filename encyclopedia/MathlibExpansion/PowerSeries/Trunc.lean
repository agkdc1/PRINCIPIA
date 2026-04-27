import Mathlib.RingTheory.PowerSeries.Trunc

/-!
# Namespace-local truncation helpers for Weierstrass preparation

This file backports the head/tail split lemmas from the accepted upstream
Weierstrass division/preparation helper split, but keeps them under the
`MathlibExpansion.PowerSeries` namespace to avoid `Mathlib.*` shadow paths.
-/

noncomputable section

open Polynomial

namespace MathlibExpansion
namespace PowerSeries

variable {R : Type*} [CommSemiring R]

/-- Split off the first `n` coefficients of a power series. -/
  theorem eq_shift_mul_X_pow_add_trunc (n : ℕ) (f : _root_.PowerSeries R) :
    f =
      (_root_.PowerSeries.mk fun i => _root_.PowerSeries.coeff R (i + n) f) *
          (_root_.PowerSeries.X : _root_.PowerSeries R) ^ n +
        ((_root_.PowerSeries.trunc n f : Polynomial R) : _root_.PowerSeries R) := by
  ext j
  rw [map_add, Polynomial.coeff_coe, _root_.PowerSeries.coeff_mul_X_pow',
    _root_.PowerSeries.coeff_trunc]
  by_cases h : n ≤ j
  · rw [if_pos h, if_neg (not_lt_of_le h), _root_.PowerSeries.coeff_mk,
      tsub_add_cancel_of_le h, add_zero]
  · rw [if_neg h, if_pos (Nat.lt_of_not_ge h), zero_add]

/-- Split off the first `n` coefficients of a power series, with the tail on the right. -/
theorem eq_X_pow_mul_shift_add_trunc (n : ℕ) (f : _root_.PowerSeries R) :
    f =
      (_root_.PowerSeries.X : _root_.PowerSeries R) ^ n *
          (_root_.PowerSeries.mk fun i => _root_.PowerSeries.coeff R (i + n) f) +
        ((_root_.PowerSeries.trunc n f : Polynomial R) : _root_.PowerSeries R) := by
  simpa [mul_comm] using eq_shift_mul_X_pow_add_trunc (R := R) n f

end PowerSeries
end MathlibExpansion
