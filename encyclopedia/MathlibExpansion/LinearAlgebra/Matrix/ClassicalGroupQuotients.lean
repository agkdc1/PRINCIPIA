import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Defs
import Mathlib.LinearAlgebra.Matrix.ProjectiveSpecialLinearGroup

namespace MathlibExpansion
namespace LinearAlgebra
namespace Matrix

open scoped MatrixGroups

variable {n : Type*} [Fintype n] [DecidableEq n] {R : Type*} [CommRing R]

/-- The determinant homomorphism on `GLₙ`. -/
abbrev detHom : Matrix.GeneralLinearGroup n R →* Rˣ :=
  Matrix.GeneralLinearGroup.det

/-- Membership in the image of `SLₙ → GLₙ` is exactly the determinant-one condition. -/
theorem mem_range_toGL_iff (g : Matrix.GeneralLinearGroup n R) :
    g ∈ (Matrix.SpecialLinearGroup.toGL : Matrix.SpecialLinearGroup n R →*
      Matrix.GeneralLinearGroup n R).range ↔ detHom g = 1 := by
  constructor
  · rintro ⟨A, rfl⟩
    simp [detHom]
  · intro hg
    refine ⟨⟨(g : Matrix n n R), by simpa using congrArg Units.val hg⟩, ?_⟩
    ext i j
    rfl

/-- The determinant kernel is exactly the image of `SLₙ → GLₙ`. -/
theorem ker_det_eq_range_toGL :
    (detHom (n := n) (R := R)).ker =
      (Matrix.SpecialLinearGroup.toGL : Matrix.SpecialLinearGroup n R →*
        Matrix.GeneralLinearGroup n R).range := by
  ext g
  constructor
  · intro hg
    exact (mem_range_toGL_iff (g := g)).2 <| by simpa [MonoidHom.mem_ker, detHom] using hg
  · intro hg
    simpa [MonoidHom.mem_ker, detHom] using (mem_range_toGL_iff (g := g)).1 hg

/-- Jordan's projective quotient, packaged in the local namespace. -/
abbrev PSL := Matrix.ProjectiveSpecialLinearGroup n R

/-- The center of `SLₙ` consists of scalar matrices with scalar an `n`-th root of unity. -/
theorem mem_center_specialLinearGroup_iff {A : Matrix.SpecialLinearGroup n R} :
    A ∈ Subgroup.center (Matrix.SpecialLinearGroup n R) ↔
      ∃ r : R, r ^ Fintype.card n = 1 ∧ Matrix.scalar n r = A :=
  Matrix.SpecialLinearGroup.mem_center_iff

end Matrix
end LinearAlgebra
end MathlibExpansion
