import NavierStokes.AxisymNoSwirl.Basic
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv

/-!
# NavierStokes.AxisymNoSwirl.Infinitesimal

Forward direction of `axisym_integrated_imp_infinitesimal`:
if `u` is axisymmetric and Fréchet-differentiable, then
`u' (Jz x) = Jz (u x)` where `Jz` is the z-rotation generator.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open Real Matrix

namespace NavierStokes.AxisymNoSwirl

/-! ## Infinitesimal generator -/

def Jz : E3 →L[ℝ] E3 :=
  LinearMap.toContinuousLinearMap
    (Matrix.toEuclideanLin !![0, -1, 0; 1, 0, 0; 0, 0, 0])

/-! ## Decomposition of rotation into sin/cos terms -/

private def rotZ_r₀ (x : E3) : E3 :=
  (WithLp.equiv 2 (Fin 3 → ℝ)).symm (fun i => if i = 2 then 0 else x i)

private def rotZ_r₂ (x : E3) : E3 :=
  (WithLp.equiv 2 (Fin 3 → ℝ)).symm (fun i => if i = 2 then x 2 else 0)

private lemma rotZLin_decomp (θ : ℝ) (x : E3) :
    rotZLin θ x = cos θ • rotZ_r₀ x + sin θ • Jz x + rotZ_r₂ x := by
  have hv : ∀ j : Fin 3, (WithLp.equiv 2 (Fin 3 → ℝ) x) j = x j := fun _ => rfl
  have hLx : ∀ i, (rotZLin θ x) i =
      Matrix.mulVec (rotZMat θ) (WithLp.equiv 2 (Fin 3 → ℝ) x) i :=
    congr_fun (Matrix.piLp_equiv_toEuclideanLin_apply (rotZMat θ) x)
  have hJx : ∀ i, (Jz x) i =
      Matrix.mulVec !![0, -1, 0; 1, 0, 0; 0, 0, 0] (WithLp.equiv 2 (Fin 3 → ℝ) x) i :=
    congr_fun (Matrix.piLp_equiv_toEuclideanLin_apply !![0, -1, 0; 1, 0, 0; 0, 0, 0] x)
  have hr0 : ∀ i : Fin 3, (rotZ_r₀ x) i = if i = 2 then 0 else x i := fun _ => rfl
  have hr2 : ∀ i : Fin 3, (rotZ_r₂ x) i = if i = 2 then x 2 else 0 := fun _ => rfl
  -- Component access on E3 = WithLp 2 (Fin 3 → ℝ) is definitionally transparent
  have hadd : ∀ (f g : E3) (i : Fin 3), (f + g) i = f i + g i := fun _ _ _ => rfl
  have hsmul : ∀ (c : ℝ) (f : E3) (i : Fin 3), (c • f) i = c * f i := fun _ _ _ => rfl
  ext i; fin_cases i <;>
    simp [hLx, hJx, hr0, hr2, hadd, hsmul, hv, rotZMat,
          Matrix.mulVec, dotProduct, Fin.sum_univ_three] <;>
    ring

/-! ## HasDerivAt for the rotation curve -/

lemma hasDerivAt_rotZLin_zero (x : E3) :
    HasDerivAt (fun θ : ℝ => rotZLin θ x) (Jz x) 0 := by
  have hdecomp : ∀ θ, rotZLin θ x = cos θ • rotZ_r₀ x + sin θ • Jz x + rotZ_r₂ x :=
    fun θ => rotZLin_decomp θ x
  rw [show (fun θ : ℝ => rotZLin θ x) = (fun θ => cos θ • rotZ_r₀ x + sin θ • Jz x + rotZ_r₂ x)
      from funext hdecomp]
  have hcos : HasDerivAt (fun θ : ℝ => cos θ • rotZ_r₀ x) (0 : E3) 0 := by
    have h := (Real.hasDerivAt_cos 0).smul_const (rotZ_r₀ x); simp at h; exact h
  have hsin : HasDerivAt (fun θ : ℝ => sin θ • Jz x) (Jz x) 0 := by
    have h := (Real.hasDerivAt_sin 0).smul_const (Jz x); simp at h; exact h
  have hconst : HasDerivAt (fun _ : ℝ => rotZ_r₂ x) (0 : E3) 0 := hasDerivAt_const 0 _
  have h2 := (hcos.add hsin).add hconst
  simp only [zero_add, add_zero] at h2
  exact h2

/-! ## rotZLin 0 = id -/

private lemma rotZLin_zero_apply (x : E3) : rotZLin 0 x = x := by
  have hv : ∀ j : Fin 3, (WithLp.equiv 2 (Fin 3 → ℝ) x) j = x j := fun _ => rfl
  have hget : ∀ i, (rotZLin 0 x) i =
      Matrix.mulVec (rotZMat 0) (WithLp.equiv 2 (Fin 3 → ℝ) x) i :=
    congr_fun (Matrix.piLp_equiv_toEuclideanLin_apply (rotZMat 0) x)
  ext i; fin_cases i <;>
    simp [hget, hv, rotZMat, Matrix.mulVec, dotProduct, Fin.sum_univ_three,
          Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
          Matrix.head_cons, Matrix.head_fin_const, Real.cos_zero, Real.sin_zero]

/-! ## Forward direction: integrated → infinitesimal -/

theorem axisym_integrated_imp_infinitesimal
    {u : E3 → E3} {x : E3} {u' : E3 →L[ℝ] E3}
    (hax : AxisymVectorField u)
    (hderiv : HasFDerivAt u u' x) :
    u' (Jz x) = Jz (u x) := by
  have hγ : HasDerivAt (fun θ : ℝ => rotZLin θ x) (Jz x) 0 :=
    hasDerivAt_rotZLin_zero x
  have hL : HasDerivAt (fun θ : ℝ => u (rotZLin θ x)) (u' (Jz x)) 0 := by
    have hfat : HasFDerivAt u u' ((fun θ : ℝ => rotZLin θ x) 0) := by
      show HasFDerivAt u u' (rotZLin 0 x)
      rwa [rotZLin_zero_apply]
    exact hfat.comp_hasDerivAt (0 : ℝ) hγ
  have hR : HasDerivAt (fun θ : ℝ => rotZLin θ (u x)) (Jz (u x)) 0 :=
    hasDerivAt_rotZLin_zero (u x)
  have heq : ∀ θ, u (rotZLin θ x) = rotZLin θ (u x) := fun θ => hax θ x
  rw [show (fun θ : ℝ => u (rotZLin θ x)) = (fun θ => rotZLin θ (u x)) from funext heq] at hL
  exact hL.unique hR

end NavierStokes.AxisymNoSwirl

end
