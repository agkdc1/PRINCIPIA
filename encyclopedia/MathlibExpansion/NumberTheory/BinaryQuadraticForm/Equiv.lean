import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import MathlibExpansion.NumberTheory.BinaryQuadraticForm.Basic

/-!
# Matrix action and equivalence for binary quadratic forms
-/

namespace MathlibExpansion.NumberTheory

open Matrix

namespace BinaryQuadraticForm

/-- The opposite form `a x^2 - b x y + c y^2`. -/
def opposite (f : BinaryQuadraticForm) : BinaryQuadraticForm :=
  ⟨f.a, -f.b, f.c⟩

/-- The arithmetic `GL₂(ℤ)` coefficient action induced by substitution
`(x, y) = (pX + qY, rX + sY)`. -/
def act (γ : Matrix (Fin 2) (Fin 2) ℤ) (f : BinaryQuadraticForm) : BinaryQuadraticForm :=
  let p := γ 0 0
  let q := γ 0 1
  let r := γ 1 0
  let s := γ 1 1
  ⟨f.a * p ^ 2 + f.b * p * r + f.c * r ^ 2,
    2 * f.a * p * q + f.b * (p * s + q * r) + 2 * f.c * r * s,
    f.a * q ^ 2 + f.b * q * s + f.c * s ^ 2⟩

/-- Proper equivalence: change of variables by determinant-`1` matrices. -/
def ProperlyEquivalent (f g : BinaryQuadraticForm) : Prop :=
  ∃ γ : Matrix (Fin 2) (Fin 2) ℤ, γ.det = 1 ∧ act γ f = g

/-- Improper equivalence: change of variables by determinant-`-1` matrices. -/
def ImproperlyEquivalent (f g : BinaryQuadraticForm) : Prop :=
  ∃ γ : Matrix (Fin 2) (Fin 2) ℤ, γ.det = -1 ∧ act γ f = g

/-- A single-step adjacent form is obtained from the standard continued-fraction
reduction matrix. -/
def Adjacent (f g : BinaryQuadraticForm) : Prop :=
  ∃ m : ℤ,
    g = act !![0, -1; 1, m] f

/-- Discriminant transport under the `GL₂(ℤ)` action. -/
theorem disc_act (γ : Matrix (Fin 2) (Fin 2) ℤ) (f : BinaryQuadraticForm) :
    (act γ f).disc = γ.det ^ 2 * f.disc := by
  rcases f with ⟨a, b, c⟩
  let p : ℤ := γ 0 0
  let q : ℤ := γ 0 1
  let r : ℤ := γ 1 0
  let s : ℤ := γ 1 1
  simp [act, BinaryQuadraticForm.disc, p, q, r, s, Matrix.det_fin_two]
  ring

theorem disc_act_of_det_sq_one {γ : Matrix (Fin 2) (Fin 2) ℤ} {f : BinaryQuadraticForm}
    (hγ : γ.det = 1 ∨ γ.det = -1) :
    (act γ f).disc = f.disc := by
  rcases hγ with hγ | hγ
  · rw [disc_act, hγ]
    ring
  · rw [disc_act, hγ]
    ring

theorem disc_eq_of_properlyEquivalent {f g : BinaryQuadraticForm} (h : f.ProperlyEquivalent g) :
    f.disc = g.disc := by
  rcases h with ⟨γ, hγ, rfl⟩
  simpa [hγ] using (disc_act γ f).symm

theorem disc_eq_of_improperlyEquivalent {f g : BinaryQuadraticForm}
    (h : f.ImproperlyEquivalent g) : f.disc = g.disc := by
  rcases h with ⟨γ, hγ, rfl⟩
  simpa [hγ] using (disc_act γ f).symm

end BinaryQuadraticForm

end MathlibExpansion.NumberTheory
