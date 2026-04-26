import NavierStokes.AxisymNoSwirl.Basic
import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Topology.Algebra.Module.FiniteDimension

/-!
# NavierStokes.AxisymNoSwirl.Smooth

`ContDiff ℝ ⊤` stability under z-rotation (ANS-B2 F2).
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open Real Matrix

namespace NavierStokes.AxisymNoSwirl

/-! ## Smoothness of rotZ -/

/-- The z-rotation continuous linear map is smooth at every order. -/
lemma rotZ_contDiff (θ : ℝ) : ContDiff ℝ ⊤ (rotZ θ : E3 → E3) :=
  (rotZ θ).contDiff

/-- Pre-composition with `rotZ θ` preserves `ContDiff ℝ ⊤`. -/
lemma contDiff_comp_rotZ {f : E3 → E3} (hf : ContDiff ℝ ⊤ f) (θ : ℝ) :
    ContDiff ℝ ⊤ (f ∘ rotZ θ) :=
  hf.comp (rotZ θ).contDiff

/-- Post-composition with `rotZ θ` preserves `ContDiff ℝ ⊤`. -/
lemma rotZ_comp_contDiff {f : E3 → E3} (hf : ContDiff ℝ ⊤ f) (θ : ℝ) :
    ContDiff ℝ ⊤ (rotZ θ ∘ f) :=
  (rotZ θ).contDiff.comp hf

/-! ## Rotation composition and commutativity -/

private lemma rotZLin_compose (a b : ℝ) (v : E3) :
    rotZLin a (rotZLin b v) = rotZLin (a + b) v := by
  simp only [rotZLin, Matrix.toEuclideanLin_apply, Equiv.apply_symm_apply,
             Matrix.mulVec_mulVec, ← rotZMat_add]

private lemma rotZLin_comm (a b : ℝ) (v : E3) :
    rotZLin a (rotZLin b v) = rotZLin b (rotZLin a v) := by
  rw [rotZLin_compose a b, rotZLin_compose b a, add_comm]

/-! ## Smooth axisymmetric subspace carrier -/

/-- The smooth axisymmetric no-swirl carrier: `ContDiff ℝ ⊤` functions in
    `AxisymNoSwirlSubspace`. Closed under pre- and post-rotation. -/
def SmoothAxisymNoSwirl : Set (E3 → E3) :=
  {u | ContDiff ℝ ⊤ u ∧ AxisymVectorField u ∧ NoSwirlPoly u}

lemma SmoothAxisymNoSwirl_rotZ_stable {u : E3 → E3} (hu : u ∈ SmoothAxisymNoSwirl) (θ : ℝ) :
    (fun x => rotZ θ (u (rotZ (-θ) x))) ∈ SmoothAxisymNoSwirl := by
  obtain ⟨hsmooth, haxisym, hnoswirl⟩ := hu
  refine ⟨?_, ?_, ?_⟩
  · -- Smoothness: post ∘ smooth ∘ pre
    exact rotZ_comp_contDiff (contDiff_comp_rotZ hsmooth (-θ)) θ
  · -- Axisymmetry via rotation commutativity
    intro φ x
    show rotZLin θ (u (rotZLin (-θ) (rotZLin φ x))) =
         rotZLin φ (rotZLin θ (u (rotZLin (-θ) x)))
    rw [show rotZLin (-θ) (rotZLin φ x) = rotZLin φ (rotZLin (-θ) x) from
          rotZLin_comm (-θ) φ x,
        haxisym φ (rotZLin (-θ) x),
        show rotZLin θ (rotZLin φ (u (rotZLin (-θ) x))) =
             rotZLin φ (rotZLin θ (u (rotZLin (-θ) x))) from
          rotZLin_comm θ φ (u (rotZLin (-θ) x))]
  · -- No-swirl: component expansion + linear_combination
    intro x
    have hns := hnoswirl (rotZLin (-θ) x)
    change x 0 * (rotZLin θ (u (rotZLin (-θ) x))) 1 -
           x 1 * (rotZLin θ (u (rotZLin (-θ) x))) 0 = 0
    set y := rotZLin (-θ) x
    have hv  : ∀ j : Fin 3, (WithLp.equiv 2 (Fin 3 → ℝ) x) j = x j   := fun _ => rfl
    have hvy : ∀ j : Fin 3, (WithLp.equiv 2 (Fin 3 → ℝ) (u y)) j = u y j := fun _ => rfl
    have get_y : ∀ i, y i = (rotZMat (-θ) *ᵥ WithLp.equiv 2 (Fin 3 → ℝ) x) i :=
      congr_fun (Matrix.piLp_equiv_toEuclideanLin_apply (rotZMat (-θ)) x)
    have get_uy : ∀ i, (rotZLin θ (u y)) i =
        (rotZMat θ *ᵥ WithLp.equiv 2 (Fin 3 → ℝ) (u y)) i :=
      congr_fun (Matrix.piLp_equiv_toEuclideanLin_apply (rotZMat θ) (u y))
    have hy0 : y 0 = cos θ * x 0 + sin θ * x 1 := by
      rw [get_y 0]
      simp [hv, rotZMat, mulVec, dotProduct, Fin.sum_univ_three,
            Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
            Matrix.head_cons, Matrix.head_fin_const, Real.cos_neg, Real.sin_neg] <;> ring
    have hy1 : y 1 = -(sin θ) * x 0 + cos θ * x 1 := by
      rw [get_y 1]
      simp [hv, rotZMat, mulVec, dotProduct, Fin.sum_univ_three,
            Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
            Matrix.head_cons, Matrix.head_fin_const, Real.cos_neg, Real.sin_neg] <;> ring
    have huy0 : (rotZLin θ (u y)) 0 = cos θ * u y 0 - sin θ * u y 1 := by
      rw [get_uy 0]
      simp [hvy, rotZMat, mulVec, dotProduct, Fin.sum_univ_three,
            Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
            Matrix.head_cons, Matrix.head_fin_const] <;> ring
    have huy1 : (rotZLin θ (u y)) 1 = sin θ * u y 0 + cos θ * u y 1 := by
      rw [get_uy 1]
      simp [hvy, rotZMat, mulVec, dotProduct, Fin.sum_univ_three,
            Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
            Matrix.head_cons, Matrix.head_fin_const] <;> ring
    rw [hy0, hy1] at hns
    rw [huy0, huy1]
    linear_combination hns

end NavierStokes.AxisymNoSwirl

end
