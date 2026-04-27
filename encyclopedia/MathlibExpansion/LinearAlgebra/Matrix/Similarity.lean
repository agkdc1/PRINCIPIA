/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import Mathlib.LinearAlgebra.Charpoly.ToMatrix
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv

/-!
# Matrix-facing similarity invariants

This module bundles characteristic polynomial, determinant, and trace
invariance under matrix conjugation.
-/

namespace Matrix

section Similarity

variable {n : Type*} {K : Type*}
variable [Field K] [Fintype n] [DecidableEq n]

private theorem charpoly_eq_toLin'_charpoly (M : Matrix n n K) :
    M.charpoly = (Matrix.toLin' M).charpoly := by
  simpa [LinearMap.toMatrix_eq_toMatrix'] using
    (LinearMap.charpoly_toMatrix (f := Matrix.toLin' M) (b := Pi.basisFun K n))

/-- Conjugation by an invertible matrix preserves charpoly, determinant, and trace. -/
theorem charpoly_det_trace_invariant_under_conj
    (P M : Matrix n n K) (hP : IsUnit P.det) :
    (P * M * P⁻¹).charpoly = M.charpoly ∧
      Matrix.det (P * M * P⁻¹) = M.det ∧
      Matrix.trace (P * M * P⁻¹) = Matrix.trace M := by
  have hP' : IsUnit P := (Matrix.isUnit_iff_isUnit_det (A := P)).2 hP
  let hInv : Invertible P := hP'.unit.invertible
  let e : (n → K) ≃ₗ[K] n → K := P.toLinearEquiv' hInv
  have hconj : Matrix.toLin' (P * M * P⁻¹) = e.conj (Matrix.toLin' M) := by
    ext v
    simp [e, Matrix.toLinearEquiv'_apply, Matrix.toLinearEquiv'_symm_apply,
      LinearEquiv.conj_apply, Matrix.toLin'_mul, LinearMap.comp_apply]
  refine ⟨?_, Matrix.det_conj hP' M, Matrix.trace_conj hP' M⟩
  calc
    (P * M * P⁻¹).charpoly = (Matrix.toLin' (P * M * P⁻¹)).charpoly := by
      rw [charpoly_eq_toLin'_charpoly]
    _ = (e.conj (Matrix.toLin' M)).charpoly := by rw [hconj]
    _ = (Matrix.toLin' M).charpoly := LinearEquiv.charpoly_conj e (Matrix.toLin' M)
    _ = M.charpoly := (charpoly_eq_toLin'_charpoly M).symm

end Similarity

end Matrix
