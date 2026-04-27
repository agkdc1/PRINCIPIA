/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff

/-!
# Periodic wrappers from Cayley-Hamilton

This module packages the simple divisibility corollaries behind Cayley's
periodicity applications.
-/

open Polynomial

namespace Matrix

section Periodic

variable {n : Type*} {K : Type*}
variable [Field K] [Fintype n] [DecidableEq n]

/-- Any polynomial divisible by the characteristic polynomial annihilates the matrix. -/
theorem aeval_eq_zero_of_charpoly_dvd
    (M : Matrix n n K) {q : K[X]} (hdiv : M.charpoly ∣ q) :
    aeval M q = 0 := by
  rcases hdiv with ⟨r, rfl⟩
  calc
    aeval M (M.charpoly * r) = aeval M M.charpoly * aeval M r := by simp
    _ = 0 := by simp [Matrix.aeval_self_charpoly]

/-- A standard periodicity wrapper: if `χ_M` divides `X^k - 1`, then `M^k = 1`. -/
theorem pow_eq_one_of_charpoly_dvd_X_pow_sub_one
    (M : Matrix n n K) (k : ℕ) (hdiv : M.charpoly ∣ ((X : K[X]) ^ k - 1)) :
    M ^ k = 1 := by
  have hzero : M ^ k - 1 = 0 := by
    simpa using
      (aeval_eq_zero_of_charpoly_dvd (M := M) (q := ((X : K[X]) ^ k - 1)) hdiv)
  exact sub_eq_zero.mp hzero

end Periodic

end Matrix
