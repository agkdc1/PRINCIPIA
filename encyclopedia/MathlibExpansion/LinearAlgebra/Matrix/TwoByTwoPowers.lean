/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import Mathlib.Data.Matrix.Notation
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.Trace

/-!
# `2 x 2` power recurrences

This module packages the standard second-order recurrence for powers of a
`2 x 2` matrix.
-/

namespace Matrix

section TwoByTwoPowers

variable {K : Type*} [CommRing K]

/-- The `2 x 2` Cayley-Hamilton identity in trace-determinant form. -/
theorem twoByTwo_sq_eq_trace_smul_sub_det_smul_one
    (M : Matrix (Fin 2) (Fin 2) K) :
    M ^ 2 = Matrix.trace M • M - M.det • (1 : Matrix (Fin 2) (Fin 2) K) := by
  rcases Matrix.two_mul_expl M M with ⟨h00, h01, h10, h11⟩
  ext i j
  fin_cases i <;> fin_cases j
  · simp [pow_two, h00, Matrix.trace_fin_two, Matrix.det_fin_two]
    ring
  · simp [pow_two, h01, Matrix.trace_fin_two, Matrix.det_fin_two]
    ring
  · simp [pow_two, h10, Matrix.trace_fin_two, Matrix.det_fin_two]
    ring
  · simp [pow_two, h11, Matrix.trace_fin_two, Matrix.det_fin_two]
    ring

/-- Powers of a `2 x 2` matrix satisfy Cayley's second-order recurrence. -/
theorem twoByTwo_pow_recurrence
    (M : Matrix (Fin 2) (Fin 2) K) (n : ℕ) :
    M ^ (n + 2) = Matrix.trace M • M ^ (n + 1) - M.det • M ^ n := by
  calc
    M ^ (n + 2) = M ^ n * M ^ 2 := by rw [pow_add]
    _ = M ^ n * (Matrix.trace M • M - M.det • (1 : Matrix (Fin 2) (Fin 2) K)) := by
      rw [twoByTwo_sq_eq_trace_smul_sub_det_smul_one]
    _ = Matrix.trace M • M ^ (n + 1) - M.det • M ^ n := by
      simp [pow_succ, mul_sub, mul_assoc, smul_mul_assoc, mul_smul_comm]

end TwoByTwoPowers

end Matrix
