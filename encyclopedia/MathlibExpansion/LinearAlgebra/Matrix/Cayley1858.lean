/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import Mathlib.LinearAlgebra.Matrix.Adjugate
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.LinearAlgebra.Matrix.ZPow

/-!
# Cayley's 1858 matrix wrappers

This module packages a few matrix-power and inverse-entry statements in a form
closer to Cayley's 1858 memoir, while normalizing the inverse criterion to the
modern `IsUnit det` formulation.
-/

namespace Matrix
namespace Cayley1858

section CommRing

variable {n : Type*} {R : Type*}
variable [Fintype n] [DecidableEq n] [CommRing R]

/-- Cayley's zeroth power is the identity matrix. -/
theorem pow_zero (A : Matrix n n R) : A ^ (0 : ℕ) = 1 := by
  simp

/-- Natural matrix powers add in the expected way. -/
theorem pow_add (A : Matrix n n R) (m k : ℕ) : A ^ (m + k) = A ^ m * A ^ k := by
  simpa using _root_.pow_add A m k

/-- Cayley's reciprocal-matrix power rule for integer powers. -/
theorem zpow_neg (A : Matrix n n R) (hA : IsUnit A.det) (m : ℤ) :
    A ^ (-m) = (A ^ m)⁻¹ := by
  simpa using Matrix.zpow_neg (A := A) hA m

/-- The Art. 17 inverse-entry formula in modern adjugate language. -/
theorem inv_entry_eq_unit_inv_mul_adjugate
    (A : Matrix n n R) (hA : IsUnit A.det) (i j : n) :
    A⁻¹ i j = (↑hA.unit⁻¹ : R) * A.adjugate i j := by
  rw [Matrix.nonsing_inv_apply (A := A) hA]
  simp [smul_eq_mul]

/-- The honest invertibility criterion over a commutative ring. -/
theorem isUnit_iff_isUnit_det (A : Matrix n n R) :
    IsUnit A ↔ IsUnit A.det :=
  Matrix.isUnit_iff_isUnit_det (A := A)

end CommRing

section Field

variable {n : Type*} {K : Type*}
variable [Fintype n] [DecidableEq n] [Field K]

/-- Over a field, Cayley's determinant-vanishing criterion becomes `det ≠ 0`. -/
theorem isUnit_iff_det_ne_zero (A : Matrix n n K) :
    IsUnit A ↔ A.det ≠ 0 := by
  rw [isUnit_iff_isUnit_det (A := A), isUnit_iff_ne_zero]

end Field

end Cayley1858
end Matrix
