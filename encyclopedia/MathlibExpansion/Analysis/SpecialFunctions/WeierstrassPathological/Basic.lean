import Mathlib.Data.Real.Basic

import Mathlib

/-!
# The basic Weierstrass pathological cosine series

This file packages the definition of the classical Weierstrass cosine series,
its continuity, and its `2`-periodicity.
-/

noncomputable section

open scoped Topology

namespace MathlibExpansion
namespace Analysis
namespace SpecialFunctions
namespace WeierstrassPathological

/-- The `n`-th term of the classical Weierstrass cosine series. -/
def weierstrassCosTerm (a : ℕ) (b : ℝ) (n : ℕ) (x : ℝ) : ℝ :=
  b ^ n * Real.cos (((a : ℝ) ^ n) * Real.pi * x)

/-- The classical Weierstrass cosine series. -/
def weierstrassCos (a : ℕ) (b : ℝ) (x : ℝ) : ℝ :=
  ∑' n : ℕ, weierstrassCosTerm a b n x

theorem norm_weierstrassCosTerm_le (a : ℕ) (b : ℝ) (n : ℕ) (x : ℝ) :
    ‖weierstrassCosTerm a b n x‖ ≤ |b| ^ n := by
  rw [weierstrassCosTerm, Real.norm_eq_abs, abs_mul, abs_pow]
  calc
    |b| ^ n * abs (Real.cos (((a : ℝ) ^ n) * Real.pi * x)) ≤ |b| ^ n * 1 := by
      gcongr
      exact Real.abs_cos_le_one _
    _ = |b| ^ n := by ring

theorem periodic_weierstrassCosTerm (a : ℕ) (b : ℝ) (n : ℕ) :
    Function.Periodic (weierstrassCosTerm a b n) 2 := by
  intro x
  unfold weierstrassCosTerm
  have harg :
      ((a : ℝ) ^ n) * Real.pi * (x + 2) =
        (((a : ℝ) ^ n) * Real.pi * x) + ((a ^ n : ℕ) : ℝ) * (2 * Real.pi) := by
    calc
      ((a : ℝ) ^ n) * Real.pi * (x + 2)
          = ((a : ℝ) ^ n) * Real.pi * x + ((a : ℝ) ^ n) * Real.pi * 2 := by ring
      _ = ((a : ℝ) ^ n) * Real.pi * x + ((a ^ n : ℕ) : ℝ) * (2 * Real.pi) := by
        norm_num [Nat.cast_pow, mul_assoc, mul_left_comm, mul_comm]
  calc
    b ^ n * Real.cos (((a : ℝ) ^ n) * Real.pi * (x + 2))
        = b ^ n * Real.cos ((((a : ℝ) ^ n) * Real.pi * x) + ((a ^ n : ℕ) : ℝ) * (2 * Real.pi)) := by
            rw [harg]
    _ = b ^ n * Real.cos (((a : ℝ) ^ n) * Real.pi * x) := by
          exact congrArg (fun t => b ^ n * t)
            (Real.cos_add_nat_mul_two_pi ((((a : ℝ) ^ n) * Real.pi * x)) (a ^ n))

/-- The Weierstrass cosine series is continuous when `0 < b < 1`. -/
theorem continuous_weierstrassCos (a : ℕ) (b : ℝ)
    (_ha1 : 1 < a) (_haodd : Odd a) (hb0 : 0 < b) (hb1 : b < 1) :
    Continuous (weierstrassCos a b) := by
  have hbabs : |b| < 1 := by simpa [abs_of_pos hb0] using hb1
  refine continuous_tsum
    (fun n => by
      simpa [weierstrassCosTerm] using
        (show Continuous (fun x : ℝ => b ^ n * Real.cos (((a : ℝ) ^ n) * Real.pi * x)) by
          continuity))
    (summable_geometric_of_lt_one (abs_nonneg b) hbabs)
    (fun n x => norm_weierstrassCosTerm_le a b n x)

/-- The Weierstrass cosine series is `2`-periodic. -/
theorem periodic_weierstrassCos (a : ℕ) (b : ℝ)
    (_ha1 : 1 < a) (_haodd : Odd a) (_hb0 : 0 < b) (_hb1 : b < 1) :
    Function.Periodic (weierstrassCos a b) 2 := by
  intro x
  have hterm :
      (fun n : ℕ => weierstrassCosTerm a b n (x + 2)) =
        fun n : ℕ => weierstrassCosTerm a b n x := by
    funext n
    exact periodic_weierstrassCosTerm a b n x
  simpa [weierstrassCos] using congrArg tsum hterm

end WeierstrassPathological
end SpecialFunctions
end Analysis
end MathlibExpansion
