/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import Mathlib.Data.Matrix.Notation
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

/-!
# `2 x 2` split characteristic-polynomial consequences

This module extracts the Art. 28 `2 x 2` factor theorem and a concrete
zero-divisor warning example.
-/

open Polynomial

namespace Matrix

section TwoByTwo

variable {K : Type*} [Field K]

/-- If the characteristic polynomial splits as `(X - a) (X - b)`, then the
corresponding matrix factors multiply to zero. -/
theorem twoByTwo_factor_of_charpoly_split
    (M : Matrix (Fin 2) (Fin 2) K) {a b : K}
    (hχ : M.charpoly = (X - C a) * (X - C b)) :
    (M - Matrix.scalar (Fin 2) a) * (M - Matrix.scalar (Fin 2) b) = 0 := by
  have hM : aeval M M.charpoly = 0 := Matrix.aeval_self_charpoly M
  rw [hχ] at hM
  simpa [sub_eq_add_neg, Matrix.scalar_apply, Matrix.algebraMap_eq_diagonal] using hM

/-- Art. 28's warning is real: both split-charpoly factors can be nonzero and
singular even though their product vanishes. -/
theorem exists_nonzero_singular_factors_of_split_charpoly :
    ∃ (M A B : Matrix (Fin 2) (Fin 2) K) (a b : K),
      M.charpoly = (X - C a) * (X - C b) ∧
      A = M - Matrix.scalar (Fin 2) a ∧
      B = M - Matrix.scalar (Fin 2) b ∧
      A ≠ 0 ∧ B ≠ 0 ∧ A.det = 0 ∧ B.det = 0 ∧ A * B = 0 := by
  refine ⟨!![(0 : K), 1; 0, 0], !![(0 : K), 1; 0, 0], !![(0 : K), 1; 0, 0], 0, 0, ?_⟩
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · rw [Matrix.charpoly, Matrix.det_fin_two]
    simp [Matrix.charmatrix, Matrix.scalar_apply, pow_two]
  · simp [Matrix.scalar_apply]
  · simp [Matrix.scalar_apply]
  · intro hA
    have h01 := congrFun (congrFun hA 0) 1
    simp at h01
  · intro hB
    have h01 := congrFun (congrFun hB 0) 1
    simp at h01
  · simp [Matrix.det_fin_two]
  · simp [Matrix.det_fin_two]
  · ext i j
    fin_cases i <;> fin_cases j <;> simp [pow_two]

end TwoByTwo

end Matrix
