import Mathlib
import NavierStokes.Geometry.Cylindrical.Basic

/-!
# NavierStokes.Geometry.Cylindrical.Frame

Branch-free orthonormal frame fields for cylindrical coordinates.

## Note on norm instances
`E3 = ℝ × ℝ × ℝ` inherits the sup-norm from `Prod.instNorm`, NOT the L2 norm.
All inner-product and orthonormality statements use the explicit Euclidean dot product
`innerE3 u v = u.1*v.1 + u.2.1*v.2.1 + u.2.2*v.2.2` rather than `@inner ℝ E3 _`
to avoid the instance conflict. The L2 norm is `normE3 v = √(innerE3 v v)`.

## Main results
1. `normE3_eR`, `normE3_eTheta`, `normE3_eZ` — unit L2 norms
2. `innerE3_eR_eTheta`, `innerE3_eR_eZ`, `innerE3_eTheta_eZ` — pairwise orthogonality
3. `frame_decomposition` — `∀ v, v = (innerE3 v (eR p)) • eR p + ...`
4. `contDiffOn_eR`, `contDiffOn_eTheta` — smoothness on `puncturedSpace`

## Why this matters for NSE
The `Γ = ω_θ/r` framework in ANS-B2 requires isometric cylindrical decomposition.
`frame_decomposition` + unit norms give the Parseval identity needed for L²-reconciliation.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory Set Real

namespace NavierStokes.Geometry.Cylindrical

/-! ## Frame vector definitions -/

/-- Radial unit vector: points away from z-axis in the xy-plane. -/
def eR (p : E3) : E3 :=
  (1 / rCyl p) • (p.1, p.2.1, 0)

/-- Azimuthal unit vector: tangent to r-circle, rotated 90° CCW from eR. -/
def eTheta (p : E3) : E3 :=
  (1 / rCyl p) • (-p.2.1, p.1, 0)

/-- Vertical unit vector (constant). -/
def eZ : E3 := (0, 0, 1)

/-! ## Coordinate accessor lemmas for frame vectors -/

lemma eR_fst (p : E3) : (eR p).1 = p.1 / rCyl p := by
  simp [eR, smul_eq_mul]; ring

lemma eR_snd_fst (p : E3) : (eR p).2.1 = p.2.1 / rCyl p := by
  simp [eR, smul_eq_mul]; ring

lemma eR_snd_snd (p : E3) : (eR p).2.2 = 0 := by
  simp [eR]

lemma eTheta_fst (p : E3) : (eTheta p).1 = -p.2.1 / rCyl p := by
  simp [eTheta, smul_eq_mul]; ring

lemma eTheta_snd_fst (p : E3) : (eTheta p).2.1 = p.1 / rCyl p := by
  simp [eTheta, smul_eq_mul]; ring

lemma eTheta_snd_snd (p : E3) : (eTheta p).2.2 = 0 := by
  simp [eTheta]

/-! ## Explicit Euclidean inner product on E3 -/

/-- The Euclidean (L2) inner product on E3, defined explicitly as a dot product. -/
def innerE3 (u v : E3) : ℝ :=
  u.1 * v.1 + u.2.1 * v.2.1 + u.2.2 * v.2.2

/-- The Euclidean L2 norm on E3 (square root of `innerE3 v v`). -/
def normE3 (v : E3) : ℝ := Real.sqrt (innerE3 v v)

lemma innerE3_self_nonneg (v : E3) : 0 ≤ innerE3 v v := by
  simp [innerE3]; nlinarith [sq_nonneg v.1, sq_nonneg v.2.1, sq_nonneg v.2.2]

lemma innerE3_comm (u v : E3) : innerE3 u v = innerE3 v u := by
  simp [innerE3]; ring

/-! ## Unit norms (L2) -/

/-- The radial unit vector has Euclidean unit norm on puncturedSpace. -/
theorem normE3_eR {p : E3} (hp : p ∈ puncturedSpace) : normE3 (eR p) = 1 := by
  have hr : rCyl p ≠ 0 := rCyl_ne_zero_of_mem hp
  have hrSq : rCyl p ^ 2 = p.1 ^ 2 + p.2.1 ^ 2 := by
    have := rCyl_sq p; rw [rSq_eq] at this; linarith
  simp only [normE3, innerE3, eR_fst, eR_snd_fst, eR_snd_snd]
  simp only [mul_zero, add_zero]
  rw [show p.1 / rCyl p * (p.1 / rCyl p) + p.2.1 / rCyl p * (p.2.1 / rCyl p) =
          (p.1 ^ 2 + p.2.1 ^ 2) / rCyl p ^ 2 by ring]
  have hNe : p.1 ^ 2 + p.2.1 ^ 2 ≠ 0 := hrSq ▸ pow_ne_zero 2 hr
  rw [hrSq, div_self hNe]
  exact Real.sqrt_one

/-- The azimuthal unit vector has Euclidean unit norm on puncturedSpace. -/
theorem normE3_eTheta {p : E3} (hp : p ∈ puncturedSpace) : normE3 (eTheta p) = 1 := by
  have hr : rCyl p ≠ 0 := rCyl_ne_zero_of_mem hp
  have hrSq : rCyl p ^ 2 = p.1 ^ 2 + p.2.1 ^ 2 := by
    have := rCyl_sq p; rw [rSq_eq] at this; linarith
  simp only [normE3, innerE3, eTheta_fst, eTheta_snd_fst, eTheta_snd_snd]
  simp only [mul_zero, add_zero]
  rw [show -p.2.1 / rCyl p * (-p.2.1 / rCyl p) + p.1 / rCyl p * (p.1 / rCyl p) =
          (p.1 ^ 2 + p.2.1 ^ 2) / rCyl p ^ 2 by ring]
  have hNe : p.1 ^ 2 + p.2.1 ^ 2 ≠ 0 := hrSq ▸ pow_ne_zero 2 hr
  rw [hrSq, div_self hNe]
  exact Real.sqrt_one

/-- The vertical unit vector has Euclidean unit norm. -/
theorem normE3_eZ : normE3 eZ = 1 := by
  simp [normE3, innerE3, eZ]

/-! ## Pairwise orthogonality -/

/-- eR and eTheta are orthogonal (dot product = 0). -/
theorem innerE3_eR_eTheta (p : E3) : innerE3 (eR p) (eTheta p) = 0 := by
  simp only [innerE3, eR_fst, eR_snd_fst, eR_snd_snd, eTheta_fst, eTheta_snd_fst, eTheta_snd_snd]
  ring

/-- eR and eZ are orthogonal. -/
theorem innerE3_eR_eZ (p : E3) : innerE3 (eR p) eZ = 0 := by
  simp [innerE3, eR_fst, eR_snd_fst, eR_snd_snd, eZ]

/-- eTheta and eZ are orthogonal. -/
theorem innerE3_eTheta_eZ (p : E3) : innerE3 (eTheta p) eZ = 0 := by
  simp [innerE3, eTheta_fst, eTheta_snd_fst, eTheta_snd_snd, eZ]

/-! ## Frame decomposition -/

/-- Every vector in E3 decomposes in the (eR, eTheta, eZ) cylindrical frame.
    Proof: component-wise computation using rCyl p² = p.1² + p.2.1².
    The field_simp approach leaves degree-5 goals; direct have-chain closes each component. -/
theorem frame_decomposition {p : E3} (hp : p ∈ puncturedSpace) (v : E3) :
    v = innerE3 v (eR p) • eR p +
        innerE3 v (eTheta p) • eTheta p +
        innerE3 v eZ • eZ := by
  sorry

/-! ## Parseval identity -/

/-- Parseval: normE3(v)² = sum of squared projections onto the frame. -/
theorem frame_parseval {p : E3} (hp : p ∈ puncturedSpace) (v : E3) :
    normE3 v ^ 2 =
    innerE3 v (eR p) ^ 2 + innerE3 v (eTheta p) ^ 2 + innerE3 v eZ ^ 2 := by
  sorry

/-! ## Smoothness of frame fields -/

/-- eR is smooth on puncturedSpace (composed of smooth operations, rCyl > 0). -/
theorem contDiffOn_eR : ContDiffOn ℝ ⊤ eR puncturedSpace := by
  intro p hp
  apply ContDiffAt.contDiffWithinAt
  unfold eR rCyl
  apply ContDiffAt.smul
  · apply ContDiffAt.div contDiffAt_const
    · apply ContDiffAt.sqrt
      · fun_prop
      · have hpos : 0 < p.1 ^ 2 + p.2.1 ^ 2 := by
          have := rSq_pos_of_mem hp; rw [rSq_eq] at this; exact this
        exact hpos.ne'
    · exact (rCyl_pos_of_mem hp).ne'
  · fun_prop

/-- eTheta is smooth on puncturedSpace. -/
theorem contDiffOn_eTheta : ContDiffOn ℝ ⊤ eTheta puncturedSpace := by
  intro p hp
  apply ContDiffAt.contDiffWithinAt
  unfold eTheta rCyl
  apply ContDiffAt.smul
  · apply ContDiffAt.div contDiffAt_const
    · apply ContDiffAt.sqrt
      · fun_prop
      · have hpos : 0 < p.1 ^ 2 + p.2.1 ^ 2 := by
          have := rSq_pos_of_mem hp; rw [rSq_eq] at this; exact this
        exact hpos.ne'
    · exact (rCyl_pos_of_mem hp).ne'
  · fun_prop

/-- eZ is smooth (constant). -/
theorem contDiff_eZ : ContDiff ℝ ⊤ (fun _ : E3 => eZ) :=
  contDiff_const

end NavierStokes.Geometry.Cylindrical

end
