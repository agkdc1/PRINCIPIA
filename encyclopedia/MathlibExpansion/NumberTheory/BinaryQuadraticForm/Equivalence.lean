import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import MathlibExpansion.NumberTheory.BinaryQuadraticForm.Basic

/-!
# Equivalence relations for binary quadratic forms

This file packages the typed `GL₂(ℤ)` change-of-variables action and the
equivalence relations needed by the Dirichlet B1a substrate shell.
-/

namespace MathlibExpansion.NumberTheory

open Matrix

namespace BinaryQuadraticForm

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

/-- Proper equivalence: determinant-`1` changes of variables. -/
def ProperlyEquivalent (f g : BinaryQuadraticForm) : Prop :=
  ∃ γ : Matrix (Fin 2) (Fin 2) ℤ, γ.det = 1 ∧ act γ f = g

/-- Integral binary quadratic forms are equivalent if they differ by a
`GL₂(ℤ)` change of variables. -/
def Equivalent (f g : BinaryQuadraticForm) : Prop :=
  ∃ γ : Matrix (Fin 2) (Fin 2) ℤ, IsUnit γ.det ∧ act γ f = g

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

theorem disc_eq_of_properlyEquivalent {f g : BinaryQuadraticForm}
    (h : f.ProperlyEquivalent g) : f.disc = g.disc := by
  rcases h with ⟨γ, hγ, rfl⟩
  simpa [hγ] using (disc_act γ f).symm

theorem ProperlyEquivalent.equivalent {f g : BinaryQuadraticForm}
    (hfg : f.ProperlyEquivalent g) : f.Equivalent g := by
  rcases hfg with ⟨γ, hγ, hact⟩
  exact ⟨γ, hγ ▸ isUnit_one, hact⟩

end BinaryQuadraticForm

end MathlibExpansion.NumberTheory
