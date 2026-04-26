import Mathlib

/-!
# NavierStokes.AxisymNoSwirl.Basic

Z-rotation group on `EuclideanSpace ℝ (Fin 3)`, axisymmetric and no-swirl subspaces.
ANS-B2 breach target: `rotZIso`, `AxisymSubspace ⊓ NoSwirlSubspace`, `axisym_zero_xy_on_axis`.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory Set Real Matrix

namespace NavierStokes.AxisymNoSwirl

/-- Euclidean 3-space with L²-norm (supports `LinearIsometryEquiv`). -/
abbrev E3 := EuclideanSpace ℝ (Fin 3)

/-! ## Z-rotation matrix -/

/-- Explicit 3×3 z-rotation matrix. -/
def rotZMat (θ : ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  !![cos θ, -sin θ, 0; sin θ, cos θ, 0; 0, 0, 1]

/-- Z-rotation as a linear map on E3 via `Matrix.toEuclideanLin`. -/
def rotZLin (θ : ℝ) : E3 →ₗ[ℝ] E3 :=
  Matrix.toEuclideanLin (rotZMat θ)

/-- Z-rotation as a bundled continuous linear map. -/
def rotZ (θ : ℝ) : E3 →L[ℝ] E3 :=
  LinearMap.toContinuousLinearMap (rotZLin θ)

/-! ## Matrix group laws -/

@[simp] lemma rotZMat_zero : rotZMat 0 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rotZMat, Matrix.one_apply, Matrix.cons_val', Matrix.cons_val_zero,
          Matrix.cons_val_one, Matrix.head_cons, Matrix.head_fin_const]

lemma rotZMat_add (θ φ : ℝ) : rotZMat (θ + φ) = rotZMat θ * rotZMat φ := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rotZMat, Matrix.mul_apply, Fin.sum_univ_three,
          Real.cos_add, Real.sin_add] <;>
    ring

lemma rotZMat_neg_mul (θ : ℝ) : rotZMat (-θ) * rotZMat θ = 1 := by
  have h := rotZMat_add (-θ) θ
  simp only [neg_add_cancel, rotZMat_zero] at h
  exact h.symm

lemma rotZMat_mul_neg (θ : ℝ) : rotZMat θ * rotZMat (-θ) = 1 := by
  have h := rotZMat_add θ (-θ)
  simp only [add_neg_cancel, rotZMat_zero] at h
  exact h.symm

/-! ## Functoriality of toEuclideanLin -/

private lemma toEuclideanLin_comp (A B : Matrix (Fin 3) (Fin 3) ℝ) (v : E3) :
    Matrix.toEuclideanLin (A * B) v =
    Matrix.toEuclideanLin A (Matrix.toEuclideanLin B v) := by
  simp only [Matrix.toEuclideanLin_apply, ← Matrix.mulVec_mulVec,
             Equiv.apply_symm_apply]

/-! ## LinearEquiv construction -/

private lemma rotZLin_neg_comp (θ : ℝ) :
    (rotZLin (-θ)).comp (rotZLin θ) = LinearMap.id := by
  apply LinearMap.ext; intro v
  simp only [LinearMap.comp_apply, LinearMap.id_apply, rotZLin,
             Matrix.toEuclideanLin_apply]
  rw [Equiv.apply_symm_apply, Matrix.mulVec_mulVec, rotZMat_neg_mul,
      Matrix.one_mulVec, Equiv.symm_apply_apply]

private lemma rotZLin_comp_neg (θ : ℝ) :
    (rotZLin θ).comp (rotZLin (-θ)) = LinearMap.id := by
  have h := rotZLin_neg_comp (-θ)
  simp only [neg_neg] at h
  exact h

/-- Z-rotation as a linear equivalence (inverse = rotation by −θ). -/
def rotZEquiv (θ : ℝ) : E3 ≃ₗ[ℝ] E3 :=
  LinearEquiv.ofLinear (rotZLin θ) (rotZLin (-θ))
    (rotZLin_comp_neg θ) (rotZLin_neg_comp θ)

/-! ## Isometry — named sub-lemma (opus C2 mandate) -/

/-- Key identity: z-rotation preserves sum of squares. -/
lemma rotZ_sq_sum (θ x₀ x₁ x₂ : ℝ) :
    (cos θ * x₀ - sin θ * x₁) ^ 2 + (sin θ * x₀ + cos θ * x₁) ^ 2 + x₂ ^ 2 =
    x₀ ^ 2 + x₁ ^ 2 + x₂ ^ 2 := by
  nlinarith [Real.cos_sq_add_sin_sq θ]

/-- Z-rotation preserves the Euclidean norm. -/
lemma rotZLin_norm (θ : ℝ) (v : E3) : ‖rotZLin θ v‖ = ‖v‖ := by
  have key : ‖rotZLin θ v‖ ^ 2 = ‖v‖ ^ 2 := by
    rw [PiLp.norm_sq_eq_of_L2, PiLp.norm_sq_eq_of_L2, Fin.sum_univ_three, Fin.sum_univ_three]
    simp only [Real.norm_eq_abs, sq_abs]
    -- WithLp.equiv is Equiv.refl so component access is definitionally transparent
    have hv : ∀ j : Fin 3, (WithLp.equiv 2 (Fin 3 → ℝ) v) j = v j := fun _ => rfl
    have comp0 : (rotZMat θ *ᵥ WithLp.equiv 2 (Fin 3 → ℝ) v) 0 =
        cos θ * v 0 - sin θ * v 1 := by
      simp [hv, rotZMat, Matrix.mulVec, dotProduct, Fin.sum_univ_three,
            Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
            Matrix.head_cons, Matrix.head_fin_const]; ring
    have comp1 : (rotZMat θ *ᵥ WithLp.equiv 2 (Fin 3 → ℝ) v) 1 =
        sin θ * v 0 + cos θ * v 1 := by
      simp [hv, rotZMat, Matrix.mulVec, dotProduct, Fin.sum_univ_three,
            Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
            Matrix.head_cons, Matrix.head_fin_const]
    have comp2 : (rotZMat θ *ᵥ WithLp.equiv 2 (Fin 3 → ℝ) v) 2 = v 2 := by
      simp [hv, rotZMat, Matrix.mulVec, dotProduct, Fin.sum_univ_three,
            Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
            Matrix.head_cons, Matrix.head_fin_const]
    have get_i : ∀ i, (rotZLin θ v) i = (rotZMat θ *ᵥ WithLp.equiv 2 (Fin 3 → ℝ) v) i :=
      congr_fun (Matrix.piLp_equiv_toEuclideanLin_apply (rotZMat θ) v)
    rw [show (rotZLin θ v) 0 = cos θ * v 0 - sin θ * v 1 from (get_i 0).trans comp0,
        show (rotZLin θ v) 1 = sin θ * v 0 + cos θ * v 1 from (get_i 1).trans comp1,
        show (rotZLin θ v) 2 = v 2 from (get_i 2).trans comp2]
    exact rotZ_sq_sum θ (v 0) (v 1) (v 2)
  calc ‖rotZLin θ v‖
      = Real.sqrt (‖rotZLin θ v‖ ^ 2) := (Real.sqrt_sq (norm_nonneg _)).symm
    _ = Real.sqrt (‖v‖ ^ 2)           := by rw [key]
    _ = ‖v‖                            := Real.sqrt_sq (norm_nonneg _)

/-- Z-rotation as a linear isometry equivalence (zero axioms). -/
def rotZIso (θ : ℝ) : E3 ≃ₗᵢ[ℝ] E3 where
  toLinearEquiv := rotZEquiv θ
  norm_map' v := rotZLin_norm θ v

/-- Measure preservation via `LinearIsometryEquiv.measurePreserving` (zero axioms). -/
lemma rotZIso_measurePreserving (θ : ℝ) :
    MeasurePreserving (rotZIso θ) volume volume :=
  (rotZIso θ).measurePreserving

/-! ## Group laws for rotZ -/

@[simp] lemma rotZ_zero : rotZ 0 = ContinuousLinearMap.id ℝ E3 := by
  ext v
  simp [rotZ, rotZLin, rotZMat_zero, Matrix.toEuclideanLin_apply,
        Matrix.one_mulVec, Equiv.symm_apply_apply]

lemma rotZ_add (θ φ : ℝ) : rotZ (θ + φ) = (rotZ θ).comp (rotZ φ) := by
  ext v
  simp [rotZ, rotZLin, rotZMat_add, Matrix.toEuclideanLin_apply,
        Equiv.apply_symm_apply, Matrix.mulVec_mulVec]

lemma rotZ_neg_apply (θ : ℝ) (v : E3) : rotZ (-θ) (rotZ θ v) = v := by
  have h : rotZLin (-θ) (rotZLin θ v) = v := by
    have := (LinearMap.ext_iff.mp (rotZLin_neg_comp θ)) v
    simpa [LinearMap.comp_apply] using this
  exact h

/-! ## Axisymmetric and no-swirl predicates -/

/-- A vector field `u` is axisymmetric if it commutes with every z-rotation. -/
def AxisymVectorField (u : E3 → E3) : Prop :=
  ∀ θ x, u (rotZLin θ x) = rotZLin θ (u x)

/-- No-swirl (polynomial form): the azimuthal component vanishes. -/
def NoSwirlPoly (u : E3 → E3) : Prop :=
  ∀ x : E3, x 0 * u x 1 - x 1 * u x 0 = 0

/-- Combined predicate. -/
def AxisymNoSwirlPred (u : E3 → E3) : Prop :=
  AxisymVectorField u ∧ NoSwirlPoly u

/-! ## Submodule constructions -/

/-- Axisymmetric vector fields form a submodule. -/
def AxisymSubspace : Submodule ℝ (E3 → E3) where
  carrier := {u | AxisymVectorField u}
  zero_mem' θ x := by simp [AxisymVectorField]
  add_mem' {u v} hu hv θ x := by
    simp only [Pi.add_apply]
    rw [hu θ x, hv θ x, map_add]
  smul_mem' a {u} hu θ x := by
    simp only [Pi.smul_apply]
    rw [hu θ x]
    exact ((rotZLin θ).map_smul a (u x)).symm

/-- No-swirl fields form a submodule. -/
def NoSwirlSubspace : Submodule ℝ (E3 → E3) where
  carrier := {u | NoSwirlPoly u}
  zero_mem' x := by simp [NoSwirlPoly]
  add_mem' {u v} hu hv x := by
    simp only [Pi.add_apply, NoSwirlPoly] at hu hv ⊢
    calc x 0 * (u x 1 + v x 1) - x 1 * (u x 0 + v x 0)
        = (x 0 * u x 1 - x 1 * u x 0) + (x 0 * v x 1 - x 1 * v x 0) := by ring
      _ = 0 + 0 := by rw [hu x, hv x]
      _ = 0 := by ring
  smul_mem' a {u} hu x := by
    simp only [Pi.smul_apply, smul_eq_mul, NoSwirlPoly] at hu ⊢
    calc x 0 * (a * u x 1) - x 1 * (a * u x 0)
        = a * (x 0 * u x 1 - x 1 * u x 0) := by ring
      _ = a * 0 := by rw [hu x]
      _ = 0 := by ring

/-- The axisymmetric no-swirl subspace. -/
def AxisymNoSwirlSubspace : Submodule ℝ (E3 → E3) :=
  AxisymSubspace ⊓ NoSwirlSubspace

/-! ## Axis null-set and on-axis vanishing -/

private def zAxisSubmod : Submodule ℝ E3 where
  carrier := {x | x 0 = 0 ∧ x 1 = 0}
  zero_mem' := by simp
  add_mem' {u v} hu hv := ⟨by simp [hu.1, hv.1], by simp [hu.2, hv.2]⟩
  smul_mem' a {x} hx := ⟨by simp [hx.1], by simp [hx.2]⟩

private lemma zAxisSubmod_ne_top : zAxisSubmod ≠ ⊤ := by
  intro h
  have : (EuclideanSpace.single (0 : Fin 3) (1 : ℝ) : E3) ∈ zAxisSubmod := by
    simp [h]
  simp [zAxisSubmod, EuclideanSpace.single_apply] at this

/-- On a z-axis point, z-rotation fixes it. -/
private lemma rotZLin_axis_fixed (z : ℝ) :
    rotZLin (π / 2) (EuclideanSpace.single (2 : Fin 3) z) =
    EuclideanSpace.single (2 : Fin 3) z := by
  ext i
  set p := EuclideanSpace.single (2 : Fin 3) z
  have get_i : ∀ j, (rotZLin (π / 2) p) j =
      (rotZMat (π / 2) *ᵥ WithLp.equiv 2 (Fin 3 → ℝ) p) j :=
    congr_fun (Matrix.piLp_equiv_toEuclideanLin_apply (rotZMat (π / 2)) p)
  rw [get_i i]
  fin_cases i <;>
    simp [rotZMat, Matrix.mulVec, Matrix.dotProduct, Fin.sum_univ_three,
          Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
          Matrix.head_cons, Matrix.head_fin_const,
          Real.sin_pi_div_two, Real.cos_pi_div_two,
          EuclideanSpace.single_apply, p]

/-- If `rotZLin(π/2) v = v` then `v 0 = 0` and `v 1 = 0`. -/
private lemma quarter_turn_fixed_zero_xy {v : E3}
    (hfix : rotZLin (π / 2) v = v) : v 0 = 0 ∧ v 1 = 0 := by
  have get_i : ∀ i, (rotZMat (π / 2) *ᵥ WithLp.equiv 2 (Fin 3 → ℝ) v) i = v i := fun i =>
    (congr_fun (Matrix.piLp_equiv_toEuclideanLin_apply (rotZMat (π / 2)) v) i).symm.trans
      (congr_fun hfix i)
  have h0 : -v 1 = v 0 := by
    have := get_i 0
    simp [rotZMat, Matrix.mulVec, dotProduct, Fin.sum_univ_three,
          Real.sin_pi_div_two, Real.cos_pi_div_two,
          Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
          Matrix.head_cons, Matrix.head_fin_const] at this
    linarith
  have h1 : v 0 = v 1 := by
    have := get_i 1
    simp [rotZMat, Matrix.mulVec, dotProduct, Fin.sum_univ_three,
          Real.sin_pi_div_two, Real.cos_pi_div_two,
          Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
          Matrix.head_cons, Matrix.head_fin_const] at this
    linarith
  constructor <;> linarith

/-- Axisymmetric fields vanish horizontally on the z-axis. -/
lemma axisym_zero_xy_on_axis (u : E3 → E3) (hax : AxisymVectorField u) (z : ℝ) :
    (u (EuclideanSpace.single (2 : Fin 3) z)) 0 = 0 ∧
    (u (EuclideanSpace.single (2 : Fin 3) z)) 1 = 0 := by
  set p := EuclideanSpace.single (2 : Fin 3) z with hp
  have hfix : rotZLin (π / 2) p = p := rotZLin_axis_fixed z
  have hup : u p = rotZLin (π / 2) (u p) := by
    have h := hax (π / 2) p
    rw [hfix] at h
    exact h
  exact quarter_turn_fixed_zero_xy hup.symm

end NavierStokes.AxisymNoSwirl

end
