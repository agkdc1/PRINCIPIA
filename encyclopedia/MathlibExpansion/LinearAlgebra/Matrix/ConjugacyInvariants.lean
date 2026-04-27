import Mathlib.LinearAlgebra.Matrix.Charpoly.Minpoly
import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Defs
import MathlibExpansion.LinearAlgebra.Matrix.Similarity

namespace MathlibExpansion
namespace LinearAlgebra
namespace Matrix

open scoped MatrixGroups

variable {n : Type*} [Fintype n] [DecidableEq n] {K : Type*} [Field K]

/-- Conjugation by an invertible matrix preserves the characteristic polynomial. -/
theorem charpoly_conj_eq (P : Matrix.GeneralLinearGroup n K) (M : Matrix n n K) :
    ((↑P : Matrix n n K) * M * (↑P⁻¹ : Matrix n n K)).charpoly = M.charpoly := by
  have hP : IsUnit ((↑P : Matrix n n K).det) := ⟨Matrix.GeneralLinearGroup.det P, rfl⟩
  simpa [Matrix.GeneralLinearGroup.coe_inv] using
    (Matrix.charpoly_det_trace_invariant_under_conj
      (P := (↑P : Matrix n n K)) (M := M) hP).1

/-- Conjugation by an invertible matrix preserves the minimal polynomial. -/
theorem minpoly_conj_eq (P : Matrix.GeneralLinearGroup n K) (M : Matrix n n K) :
    minpoly K ((↑P : Matrix n n K) * M * (↑P⁻¹ : Matrix n n K)) = minpoly K M := by
  have hP : IsUnit (↑P : Matrix n n K) := ⟨P, rfl⟩
  let hInv : Invertible (↑P : Matrix n n K) := hP.unit.invertible
  let e : (n → K) ≃ₗ[K] n → K := (↑P : Matrix n n K).toLinearEquiv' hInv
  have hconj :
      Matrix.toLin' ((↑P : Matrix n n K) * M * (↑P⁻¹ : Matrix n n K)) =
        e.conj (Matrix.toLin' M) := by
    ext v
    simp [e, Matrix.toLinearEquiv'_apply, Matrix.toLinearEquiv'_symm_apply,
      LinearEquiv.conj_apply, Matrix.toLin'_mul, LinearMap.comp_apply,
      Matrix.GeneralLinearGroup.coe_inv]
  calc
    minpoly K ((↑P : Matrix n n K) * M * (↑P⁻¹ : Matrix n n K)) =
        minpoly K (Matrix.toLin' ((↑P : Matrix n n K) * M * (↑P⁻¹ : Matrix n n K))) := by
          rw [Matrix.minpoly_toLin']
    _ = minpoly K (e.conj (Matrix.toLin' M)) := by rw [hconj]
    _ = minpoly K (Matrix.toLin' M) := by
      exact minpoly.algEquiv_eq (LinearEquiv.algConj e) (Matrix.toLin' M)
    _ = minpoly K M := Matrix.minpoly_toLin' M

/-- The matrix-form wrapper with an `IsUnit det` hypothesis. -/
theorem charpoly_conj_eq_of_isUnit (P M : Matrix n n K) (hP : IsUnit P.det) :
    (P * M * P⁻¹).charpoly = M.charpoly := by
  simpa [Matrix.GeneralLinearGroup.coe_inv] using
    charpoly_conj_eq (P := Matrix.GeneralLinearGroup.mk'' P hP) M

/-- The matrix-form wrapper with an `IsUnit det` hypothesis. -/
theorem minpoly_conj_eq_of_isUnit (P M : Matrix n n K) (hP : IsUnit P.det) :
    minpoly K (P * M * P⁻¹) = minpoly K M := by
  simpa [Matrix.GeneralLinearGroup.coe_inv] using
    minpoly_conj_eq (P := Matrix.GeneralLinearGroup.mk'' P hP) M

end Matrix
end LinearAlgebra
end MathlibExpansion
