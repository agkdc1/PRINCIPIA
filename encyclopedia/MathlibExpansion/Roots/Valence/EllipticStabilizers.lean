import Mathlib.GroupTheory.GroupAction.Quotient
import MathlibExpansion.Roots.Valence.SL2ZFundamentalDomain

/-!
# Elliptic stabilizers in `PSL₂(ℤ)`

This file computes the stabilizers of the elliptic points `I` and `rho` for the
projective modular group.
-/

noncomputable section

open Matrix Matrix.SpecialLinearGroup UpperHalfPlane ModularGroup QuotientGroup
open scoped MatrixGroups UpperHalfPlane Modular

namespace MathlibExpansion.Roots.Valence

/-- The central element `-1` becomes trivial in `PSL₂(ℤ)`. -/
@[simp]
theorem neg_one_psl_eq_one : (((-1 : SL(2, ℤ)) : PSL2Z) : PSL2Z) = 1 := by
  exact
    (QuotientGroup.eq_one_iff (N := Subgroup.center (SL(2, ℤ))) (x := (-1 : SL(2, ℤ)))).2 <| by
      rw [Subgroup.mem_center_iff]
      intro g
      simp

/-- Negating an `SL₂(ℤ)` representative does not change its projective class. -/
@[simp]
theorem psl_neg (g : SL(2, ℤ)) : (((-g : SL(2, ℤ)) : PSL2Z) : PSL2Z) = (g : PSL2Z) := by
  have hneg : (-g : SL(2, ℤ)) = (-1 : SL(2, ℤ)) * g := by
    ext i j
    simp
  rw [hneg]
  change (((-1 : SL(2, ℤ)) : PSL2Z) * (g : PSL2Z)) = (g : PSL2Z)
  simp

/-- Quotient classes in `PSL₂(ℤ)` act by their chosen representatives. -/
theorem psl_mk_smul (g : SL(2, ℤ)) (z : ℍ) : ((g : PSL2Z) • z) = g • z := by
  change pslToPerm ((QuotientGroup.mk' (Subgroup.center (SL(2, ℤ)))) g) z = g • z
  simp [pslToPerm]

/-- The image of `S` in `PSL₂(ℤ)` fixes `I`. -/
theorem psl_S_fix_I : ((ModularGroup.S : PSL2Z) • UpperHalfPlane.I) = UpperHalfPlane.I := by
  rw [psl_mk_smul]
  rw [UpperHalfPlane.modular_S_smul]
  apply Subtype.ext
  change ((-Complex.I : ℂ)⁻¹) = Complex.I
  apply inv_eq_of_mul_eq_one_left
  norm_num

/-- The class of `S` has order dividing `2` in `PSL₂(ℤ)`. -/
theorem psl_S_sq_eq_one : ((ModularGroup.S : PSL2Z) ^ 2) = 1 := by
  have hSsq : ModularGroup.S ^ 2 = (-1 : SL(2, ℤ)) := by
    ext i j
    fin_cases i <;> fin_cases j <;> simp [pow_two, ModularGroup.coe_S]
  change (((ModularGroup.S ^ 2 : SL(2, ℤ)) : PSL2Z)) = 1
  rw [hSsq, neg_one_psl_eq_one]

/-- The class of `S` is nontrivial in `PSL₂(ℤ)`. -/
theorem psl_S_ne_one : ((ModularGroup.S : PSL2Z) : PSL2Z) ≠ 1 := by
  intro hS
  have h := congrArg (fun q : PSL2Z => q • rho) hS
  have h' : (ModularGroup.S • rho : ℍ) = rho := by
    simpa [psl_mk_smul] using h
  have hre : (ModularGroup.S • rho).re = (1 : ℝ) / 2 := by
    rw [UpperHalfPlane.modular_S_smul]
    change ((-(rho : ℂ))⁻¹).re = (1 : ℝ) / 2
    rw [Complex.inv_re, Complex.normSq_neg, rho_normSq]
    simpa [rho_re] using (show -(-(1 : ℝ) / 2) / 1 = (1 : ℝ) / 2 by norm_num)
  have hcoe := congrArg UpperHalfPlane.re h'
  nlinarith [hcoe, hre, rho_re]

/-- If `g ∈ SL₂(ℤ)` fixes `I`, then its diagonal entries are equal. -/
theorem sl_fix_I_diag {g : SL(2, ℤ)} (hg : g • UpperHalfPlane.I = UpperHalfPlane.I) :
    g 0 0 = g 1 1 := by
  have hcomplex : (((g • UpperHalfPlane.I : ℍ) : ℂ)) = Complex.I := by
    simpa using congrArg (fun z : ℍ => (z : ℂ)) hg
  rw [ModularGroup.sl_moeb, UpperHalfPlane.coe_smul] at hcomplex
  have hdenom : UpperHalfPlane.denom (g : GL(2, ℝ)⁺) UpperHalfPlane.I ≠ 0 := by
    simpa using UpperHalfPlane.denom_ne_zero (g := (g : GL(2, ℝ)⁺)) UpperHalfPlane.I
  have hmul :=
    congrArg (fun w : ℂ => w * UpperHalfPlane.denom (g : GL(2, ℝ)⁺) UpperHalfPlane.I) hcomplex
  field_simp [hdenom] at hmul
  simp [UpperHalfPlane.num, UpperHalfPlane.denom, Complex.I_sq] at hmul
  have him := Complex.ext_iff.mp hmul |>.2
  norm_num at him
  simpa using him

/-- If `g ∈ SL₂(ℤ)` fixes `I`, then its upper-right entry is `-c`. -/
theorem sl_fix_I_off {g : SL(2, ℤ)} (hg : g • UpperHalfPlane.I = UpperHalfPlane.I) :
    g 0 1 = -g 1 0 := by
  have hcomplex : (((g • UpperHalfPlane.I : ℍ) : ℂ)) = Complex.I := by
    simpa using congrArg (fun z : ℍ => (z : ℂ)) hg
  rw [ModularGroup.sl_moeb, UpperHalfPlane.coe_smul] at hcomplex
  have hdenom : UpperHalfPlane.denom (g : GL(2, ℝ)⁺) UpperHalfPlane.I ≠ 0 := by
    simpa using UpperHalfPlane.denom_ne_zero (g := (g : GL(2, ℝ)⁺)) UpperHalfPlane.I
  have hmul :=
    congrArg (fun w : ℂ => w * UpperHalfPlane.denom (g : GL(2, ℝ)⁺) UpperHalfPlane.I) hcomplex
  field_simp [hdenom] at hmul
  simp [UpperHalfPlane.num, UpperHalfPlane.denom, Complex.I_sq] at hmul
  have hre := Complex.ext_iff.mp hmul |>.1
  norm_num at hre
  exact_mod_cast hre

/-- The only elements of `SL₂(ℤ)` fixing `I` are `±1` and `±S`. -/
theorem sl_fix_I_cases {g : SL(2, ℤ)} (hg : g • UpperHalfPlane.I = UpperHalfPlane.I) :
    g = 1 ∨ g = -1 ∨ g = ModularGroup.S ∨ g = -ModularGroup.S := by
  have hdiag : g 0 0 = g 1 1 := sl_fix_I_diag hg
  have hoff : g 0 1 = -g 1 0 := sl_fix_I_off hg
  have hdet : g 0 0 ^ 2 + g 0 1 ^ 2 = 1 := by
    have h10 : g 1 0 = -g 0 1 := by nlinarith [hoff]
    have h11 : g 1 1 = g 0 0 := by nlinarith [hdiag]
    have h := g.det_coe
    rw [det_fin_two] at h
    rw [h11, h10] at h
    ring_nf at h
    exact h
  have h00sq : g 0 0 ^ 2 ≤ 1 := by nlinarith [sq_nonneg (g 0 1), hdet]
  have h01sq : g 0 1 ^ 2 ≤ 1 := by nlinarith [sq_nonneg (g 0 0), hdet]
  have h00abs : |g 0 0| ≤ 1 := by
    have h00sq' : g 0 0 ^ 2 ≤ 1 ^ 2 := by simpa using h00sq
    rwa [sq_le_sq, abs_one] at h00sq'
  have h01abs : |g 0 1| ≤ 1 := by
    have h01sq' : g 0 1 ^ 2 ≤ 1 ^ 2 := by simpa using h01sq
    rwa [sq_le_sq, abs_one] at h01sq'
  have h00bounds : -1 ≤ g 0 0 ∧ g 0 0 ≤ 1 := abs_le.mp h00abs
  have h01bounds : -1 ≤ g 0 1 ∧ g 0 1 ≤ 1 := abs_le.mp h01abs
  have h00cases : g 0 0 = -1 ∨ g 0 0 = 0 ∨ g 0 0 = 1 := by omega
  have h01cases : g 0 1 = -1 ∨ g 0 1 = 0 ∨ g 0 1 = 1 := by omega
  rcases h00cases with h00 | h00 | h00 <;> rcases h01cases with h01 | h01 | h01
  · exfalso
    simp [h00, h01] at hdet
  · right; left
    have h10 : g 1 0 = 0 := by nlinarith [hoff, h01]
    have h11 : g 1 1 = -1 := by nlinarith [hdiag, h00]
    ext i j
    fin_cases i <;> fin_cases j <;> simp [h00, h01, h10, h11]
  · exfalso
    simp [h00, h01] at hdet
  · right; right; left
    have h10 : g 1 0 = 1 := by nlinarith [hoff, h01]
    have h11 : g 1 1 = 0 := by nlinarith [hdiag, h00]
    ext i j
    fin_cases i <;> fin_cases j <;> simp [h00, h01, h10, h11, ModularGroup.coe_S]
  · exfalso
    simp [h00, h01] at hdet
  · right; right; right
    have h10 : g 1 0 = -1 := by nlinarith [hoff, h01]
    have h11 : g 1 1 = 0 := by nlinarith [hdiag, h00]
    ext i j
    fin_cases i <;> fin_cases j <;> simp [h00, h01, h10, h11, ModularGroup.coe_S]
  · exfalso
    simp [h00, h01] at hdet
  · left
    have h10 : g 1 0 = 0 := by nlinarith [hoff, h01]
    have h11 : g 1 1 = 1 := by nlinarith [hdiag, h00]
    ext i j
    fin_cases i <;> fin_cases j <;> simp [h00, h01, h10, h11]
  · exfalso
    simp [h00, h01] at hdet

/-- Any projective element fixing `I` is either `1` or the class of `S`. -/
theorem psl_fix_I_cases {q : PSL2Z} (hq : q • UpperHalfPlane.I = UpperHalfPlane.I) :
    q = 1 ∨ q = (ModularGroup.S : PSL2Z) := by
  have hout : q.out • UpperHalfPlane.I = UpperHalfPlane.I := by
    simpa [psl_smul_out q UpperHalfPlane.I] using hq
  rcases sl_fix_I_cases hout with h | h | h | h
  · left
    have houtq := QuotientGroup.out_eq' q
    rw [h] at houtq
    simpa using houtq.symm
  · left
    have houtq := QuotientGroup.out_eq' q
    rw [h, neg_one_psl_eq_one] at houtq
    simpa using houtq.symm
  · right
    have houtq := QuotientGroup.out_eq' q
    rw [h] at houtq
    simpa using houtq.symm
  · right
    have houtq := QuotientGroup.out_eq' q
    rw [h, psl_neg] at houtq
    simpa using houtq.symm

/-- The standard order-three elliptic stabilizer generator. -/
abbrev ST : SL(2, ℤ) := ModularGroup.S * ModularGroup.T

@[simp] theorem ST_00 : (ST : SL(2, ℤ)) 0 0 = 0 := by
  change (((ModularGroup.S : SL(2, ℤ)) * ModularGroup.T : SL(2, ℤ)) 0 0 = 0)
  norm_num [Matrix.mul_apply, ModularGroup.coe_S, ModularGroup.coe_T]

@[simp] theorem ST_01 : (ST : SL(2, ℤ)) 0 1 = -1 := by
  change (((ModularGroup.S : SL(2, ℤ)) * ModularGroup.T : SL(2, ℤ)) 0 1 = -1)
  norm_num [Matrix.mul_apply, ModularGroup.coe_S, ModularGroup.coe_T]

@[simp] theorem ST_10 : (ST : SL(2, ℤ)) 1 0 = 1 := by
  change (((ModularGroup.S : SL(2, ℤ)) * ModularGroup.T : SL(2, ℤ)) 1 0 = 1)
  norm_num [Matrix.mul_apply, ModularGroup.coe_S, ModularGroup.coe_T]

@[simp] theorem ST_11 : (ST : SL(2, ℤ)) 1 1 = 1 := by
  change (((ModularGroup.S : SL(2, ℤ)) * ModularGroup.T : SL(2, ℤ)) 1 1 = 1)
  norm_num [Matrix.mul_apply, ModularGroup.coe_S, ModularGroup.coe_T]

@[simp] theorem ST_sq_00 : (ST ^ 2 : SL(2, ℤ)) 0 0 = -1 := by
  change ((((ModularGroup.S : SL(2, ℤ)) * ModularGroup.T) ^ 2 : SL(2, ℤ)) 0 0 = -1)
  norm_num [pow_two, Matrix.mul_apply, ModularGroup.coe_S, ModularGroup.coe_T]

@[simp] theorem ST_sq_01 : (ST ^ 2 : SL(2, ℤ)) 0 1 = -1 := by
  change ((((ModularGroup.S : SL(2, ℤ)) * ModularGroup.T) ^ 2 : SL(2, ℤ)) 0 1 = -1)
  norm_num [pow_two, Matrix.mul_apply, ModularGroup.coe_S, ModularGroup.coe_T]

@[simp] theorem ST_sq_10 : (ST ^ 2 : SL(2, ℤ)) 1 0 = 1 := by
  change ((((ModularGroup.S : SL(2, ℤ)) * ModularGroup.T) ^ 2 : SL(2, ℤ)) 1 0 = 1)
  norm_num [pow_two, Matrix.mul_apply, ModularGroup.coe_S, ModularGroup.coe_T]

@[simp] theorem ST_sq_11 : (ST ^ 2 : SL(2, ℤ)) 1 1 = 0 := by
  change ((((ModularGroup.S : SL(2, ℤ)) * ModularGroup.T) ^ 2 : SL(2, ℤ)) 1 1 = 0)
  norm_num [pow_two, Matrix.mul_apply, ModularGroup.coe_S, ModularGroup.coe_T]

/-- The matrix `ST` fixes `rho`. -/
theorem sl_ST_fix_rho : (ST • rho : ℍ) = rho := by
  have hstep : ((ST : SL(2, ℤ)) • rho : ℍ) = (ModularGroup.S • (ModularGroup.T • rho) : ℍ) := by
    change (((ModularGroup.S : SL(2, ℤ)) * ModularGroup.T) • rho : ℍ) =
      (ModularGroup.S • (ModularGroup.T • rho) : ℍ)
    exact MulAction.mul_smul _ _ _
  rw [hstep, UpperHalfPlane.modular_S_smul]
  apply Subtype.ext
  change ((-(((ModularGroup.T • rho : ℍ) : ℂ)))⁻¹) = rho
  have hT : (((ModularGroup.T • rho : ℍ) : ℂ)) = (rho : ℂ) + 1 := by
    simpa using (ModularGroup.coe_T_zpow_smul_eq (z := rho) (n := 1))
  rw [hT]
  have hq : (rho : ℂ) ^ 2 + rho = -1 := by
    apply eq_neg_iff_add_eq_zero.mpr
    simpa [add_assoc] using rho_quad
  have hmul : (rho : ℂ) * (-(rho : ℂ) - 1) = 1 := by
    calc
      (rho : ℂ) * (-(rho : ℂ) - 1) = -((rho : ℂ) ^ 2 + rho) := by ring
      _ = 1 := by rw [hq]; ring
  apply inv_eq_of_mul_eq_one_left
  simpa [sub_eq_add_neg, add_assoc, add_comm, add_left_comm] using hmul

/-- The class of `ST` fixes `rho`. -/
theorem psl_ST_fix_rho : (((ST : SL(2, ℤ)) : PSL2Z) • rho) = rho := by
  simpa [psl_mk_smul] using sl_ST_fix_rho

/-- The cube of `ST` is `-1` in `SL₂(ℤ)`. -/
theorem sl_ST_pow_three_eq_neg_one : (ST ^ 3 : SL(2, ℤ)) = -1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [ST, pow_succ, pow_two, mul_assoc, ModularGroup.coe_S, ModularGroup.coe_T]

/-- The class of `ST` has order dividing `3` in `PSL₂(ℤ)`. -/
theorem psl_ST_pow_three_eq_one : (((ST : SL(2, ℤ)) : PSL2Z) ^ 3) = 1 := by
  change (((ST ^ 3 : SL(2, ℤ)) : PSL2Z)) = 1
  rw [sl_ST_pow_three_eq_neg_one, neg_one_psl_eq_one]

/-- The class of `ST` is nontrivial in `PSL₂(ℤ)`. -/
theorem psl_ST_ne_one : (((ST : SL(2, ℤ)) : PSL2Z) : PSL2Z) ≠ 1 := by
  intro h
  have hcenter :
      ST ∈ Subgroup.center (SL(2, ℤ)) :=
    (QuotientGroup.eq_one_iff (N := Subgroup.center (SL(2, ℤ))) (x := ST)).1 h
  obtain ⟨r, hrpow, hrscalar⟩ :=
    Matrix.SpecialLinearGroup.mem_center_iff.mp hcenter
  have h00 : r = 0 := by
    simpa [ST, ModularGroup.coe_S, ModularGroup.coe_T] using congr_fun₂ hrscalar 0 0
  have hrpow' : r ^ 2 = 1 := by simpa using hrpow
  norm_num [h00] at hrpow'

theorem psl_ST_sq_ne_one : ((((ST : SL(2, ℤ)) : PSL2Z) ^ 2) : PSL2Z) ≠ 1 := by
  intro hsq
  have h' : (ST : PSL2Z) = 1 := by
    calc
      (ST : PSL2Z) = (1 : PSL2Z) * (ST : PSL2Z) := by simp
      _ = (((ST : PSL2Z) ^ 2) : PSL2Z) * (ST : PSL2Z) := by rw [hsq]
      _ = (((ST : PSL2Z) ^ 3) : PSL2Z) := by
        group
      _ = 1 := psl_ST_pow_three_eq_one
  exact psl_ST_ne_one h'

theorem psl_ST_sq_ne_ST : ((((ST : SL(2, ℤ)) : PSL2Z) ^ 2) : PSL2Z) ≠ (ST : PSL2Z) := by
  intro hsq
  have hmul := congrArg (fun x : PSL2Z => x * ((ST : PSL2Z)⁻¹)) hsq
  have h' : (ST : PSL2Z) = 1 := by
    simpa [pow_two, mul_assoc] using hmul
  exact psl_ST_ne_one h'

@[simp] theorem psl_ST_sq_eq : (((ST ^ 2 : SL(2, ℤ)) : PSL2Z) : PSL2Z) = ((ST : PSL2Z) ^ 2) := rfl

private theorem sqrt3_sq_complex : ((Real.sqrt 3 : ℂ) ^ 2) = 3 := by
  apply Complex.ext
  · simp [pow_two, Real.sq_sqrt (show (0 : ℝ) ≤ 3 by positivity)]
  · simp [pow_two]

private theorem sl_fix_rho_re_eq {g : SL(2, ℤ)} (hg : g • rho = rho) :
    (g 0 0 : ℝ) * (-1 / 2) + g 0 1 =
      -(3 * g 1 0 * (1 / 4)) + g 1 0 * (1 / 4) + g 1 1 * (-1 / 2) := by
  have hcomplex : (((g • rho : ℍ) : ℂ)) = rho := by
    simpa using congrArg (fun z : ℍ => (z : ℂ)) hg
  rw [ModularGroup.sl_moeb, UpperHalfPlane.coe_smul, rho_coe] at hcomplex
  have hdenom : UpperHalfPlane.denom (g : GL(2, ℝ)⁺) rho ≠ 0 := by
    simpa using UpperHalfPlane.denom_ne_zero (g := (g : GL(2, ℝ)⁺)) rho
  have hmul := (div_eq_iff hdenom).mp hcomplex
  simp [UpperHalfPlane.num, UpperHalfPlane.denom, mul_add, mul_assoc, rho_coe] at hmul
  ring_nf at hmul
  have hre := congrArg Complex.re hmul
  simpa [sqrt3_sq_complex] using hre

private theorem sl_fix_rho_im_eq {g : SL(2, ℤ)} (hg : g • rho = rho) :
    (g 0 0 : ℝ) * Real.sqrt 3 * (1 / 2) =
      Real.sqrt 3 * g 1 0 * (-1 / 2) + Real.sqrt 3 * g 1 1 * (1 / 2) := by
  have hcomplex : (((g • rho : ℍ) : ℂ)) = rho := by
    simpa using congrArg (fun z : ℍ => (z : ℂ)) hg
  rw [ModularGroup.sl_moeb, UpperHalfPlane.coe_smul, rho_coe] at hcomplex
  have hdenom : UpperHalfPlane.denom (g : GL(2, ℝ)⁺) rho ≠ 0 := by
    simpa using UpperHalfPlane.denom_ne_zero (g := (g : GL(2, ℝ)⁺)) rho
  have hmul := (div_eq_iff hdenom).mp hcomplex
  simp [UpperHalfPlane.num, UpperHalfPlane.denom, mul_add, mul_assoc, rho_coe] at hmul
  ring_nf at hmul
  have him := congrArg Complex.im hmul
  simpa [sqrt3_sq_complex] using him

/-- If `g ∈ SL₂(ℤ)` fixes `rho`, then `d = a + c`. -/
theorem sl_fix_rho_diag {g : SL(2, ℤ)} (hg : g • rho = rho) :
    g 1 1 = g 0 0 + g 1 0 := by
  have him := sl_fix_rho_im_eq hg
  have hsqrt : (0 : ℝ) < Real.sqrt 3 := by
    positivity
  have hdiagR : ((g 1 1 : ℤ) : ℝ) = g 0 0 + g 1 0 := by
    nlinarith
  exact_mod_cast hdiagR

/-- If `g ∈ SL₂(ℤ)` fixes `rho`, then its upper-right entry is `-c`. -/
theorem sl_fix_rho_off {g : SL(2, ℤ)} (hg : g • rho = rho) :
    g 0 1 = -g 1 0 := by
  have hre := sl_fix_rho_re_eq hg
  have hdiagR : (g 1 1 : ℝ) = g 0 0 + g 1 0 := by
    exact_mod_cast sl_fix_rho_diag hg
  have hoffR : ((g 0 1 : ℤ) : ℝ) = -g 1 0 := by
    nlinarith
  exact_mod_cast hoffR

/-- The only elements of `SL₂(ℤ)` fixing `rho` are `±1`, `±ST`, and `±(ST)^2`. -/
theorem sl_fix_rho_cases {g : SL(2, ℤ)} (hg : g • rho = rho) :
    g = 1 ∨ g = -1 ∨ g = ST ∨ g = -ST ∨ g = ST ^ 2 ∨ g = -(ST ^ 2) := by
  have hoff : g 0 1 = -g 1 0 := sl_fix_rho_off hg
  have hdiag : g 1 1 = g 0 0 + g 1 0 := sl_fix_rho_diag hg
  have hdet' : g 0 0 * g 1 0 + g 0 0 ^ 2 + g 1 0 ^ 2 = 1 := by
    have h := g.det_coe
    rw [det_fin_two] at h
    rw [hoff, hdiag] at h
    ring_nf at h
    exact h
  have hdet : g 0 0 ^ 2 + g 0 0 * g 1 0 + g 1 0 ^ 2 = 1 := by
    nlinarith [hdet']
  have hquad : (2 * g 0 0 + g 1 0) ^ 2 + 3 * g 1 0 ^ 2 = 4 := by
    nlinarith [hdet]
  have h10sq : g 1 0 ^ 2 ≤ 1 := by
    nlinarith [sq_nonneg (2 * g 0 0 + g 1 0), hquad]
  have h10abs : |g 1 0| ≤ 1 := by
    have h10sq' : g 1 0 ^ 2 ≤ 1 ^ 2 := by simpa using h10sq
    rwa [sq_le_sq, abs_one] at h10sq'
  have h10bounds : -1 ≤ g 1 0 ∧ g 1 0 ≤ 1 := abs_le.mp h10abs
  have h10cases : g 1 0 = -1 ∨ g 1 0 = 0 ∨ g 1 0 = 1 := by omega
  rcases h10cases with h10 | h10 | h10
  · have h00eq : g 0 0 ^ 2 - g 0 0 = 0 := by
      have hdetm := hdet
      simpa [h10] using hdetm
    have hfac : g 0 0 * (g 0 0 - 1) = 0 := by
      calc
        g 0 0 * (g 0 0 - 1) = g 0 0 ^ 2 - g 0 0 := by ring
        _ = 0 := h00eq
    have h00cases : g 0 0 = 0 ∨ g 0 0 = 1 := by
      rcases mul_eq_zero.mp hfac with h00 | h00
      · exact Or.inl h00
      · exact Or.inr (by linarith)
    rcases h00cases with h00 | h00
    · right; right; right; left
      have h01 : g 0 1 = 1 := by
        simpa [h10] using hoff
      have h11 : g 1 1 = -1 := by
        simpa [h00, h10] using hdiag
      ext i j
      fin_cases i <;> fin_cases j <;>
        norm_num [Matrix.mul_apply, ModularGroup.coe_S, ModularGroup.coe_T, h00, h01, h10, h11]
    · right; right; right; right; right
      have h01 : g 0 1 = 1 := by
        simpa [h10] using hoff
      have h11 : g 1 1 = 0 := by
        simpa [h00, h10] using hdiag
      ext i j
      fin_cases i <;> fin_cases j <;>
        norm_num [Matrix.mul_apply, pow_two, ModularGroup.coe_S, ModularGroup.coe_T,
          h00, h01, h10, h11]
  · have h00sq : g 0 0 ^ 2 = 1 := by
      have hdet0 := hdet
      simpa [h10] using hdet0
    have hfac : (g 0 0 - 1) * (g 0 0 + 1) = 0 := by
      calc
        (g 0 0 - 1) * (g 0 0 + 1) = g 0 0 ^ 2 - 1 := by ring
        _ = 0 := by linarith
    have h00cases : g 0 0 = -1 ∨ g 0 0 = 1 := by
      rcases mul_eq_zero.mp hfac with h00 | h00
      · exact Or.inr (by linarith)
      · exact Or.inl (by linarith)
    rcases h00cases with h00 | h00
    · right; left
      have h01 : g 0 1 = 0 := by
        simpa [h10] using hoff
      have h11 : g 1 1 = -1 := by
        simpa [h00, h10] using hdiag
      ext i j
      fin_cases i
      · fin_cases j
        · change g 0 0 = -1
          exact h00
        · change g 0 1 = 0
          exact h01
      · fin_cases j
        · change g 1 0 = 0
          exact h10
        · change g 1 1 = -1
          exact h11
    · left
      have h01 : g 0 1 = 0 := by
        simpa [h10] using hoff
      have h11 : g 1 1 = 1 := by
        simpa [h00, h10] using hdiag
      ext i j
      fin_cases i
      · fin_cases j
        · change g 0 0 = 1
          exact h00
        · change g 0 1 = 0
          exact h01
      · fin_cases j
        · change g 1 0 = 0
          exact h10
        · change g 1 1 = 1
          exact h11
  · have h00eq : g 0 0 ^ 2 + g 0 0 = 0 := by
      have hdet1 : g 0 0 ^ 2 + g 0 0 + 1 = 1 := by
        simpa [h10] using hdet
      linarith
    have hfac : g 0 0 * (g 0 0 + 1) = 0 := by
      calc
        g 0 0 * (g 0 0 + 1) = g 0 0 ^ 2 + g 0 0 := by ring
        _ = 0 := h00eq
    have h00cases : g 0 0 = -1 ∨ g 0 0 = 0 := by
      rcases mul_eq_zero.mp hfac with h00 | h00
      · exact Or.inr h00
      · exact Or.inl (by linarith)
    rcases h00cases with h00 | h00
    · right; right; right; right; left
      have h01 : g 0 1 = -1 := by
        simpa [h10] using hoff
      have h11 : g 1 1 = 0 := by
        simpa [h00, h10] using hdiag
      ext i j
      fin_cases i <;> fin_cases j <;>
        norm_num [Matrix.mul_apply, pow_two, ModularGroup.coe_S, ModularGroup.coe_T,
          h00, h01, h10, h11]
    · right; right; left
      have h01 : g 0 1 = -1 := by
        simpa [h10] using hoff
      have h11 : g 1 1 = 1 := by
        simpa [h00, h10] using hdiag
      ext i j
      fin_cases i <;> fin_cases j <;>
        norm_num [Matrix.mul_apply, ModularGroup.coe_S, ModularGroup.coe_T, h00, h01, h10, h11]

/-- Any projective element fixing `rho` is one of `1`, `ST`, or `(ST)^2`. -/
theorem psl_fix_rho_cases {q : PSL2Z} (hq : q • rho = rho) :
    q = 1 ∨ q = (ST : PSL2Z) ∨ q = ((ST : PSL2Z) ^ 2) := by
  have hout : q.out • rho = rho := by
    simpa [psl_smul_out q rho] using hq
  rcases sl_fix_rho_cases hout with h | h | h | h | h | h
  · left
    have houtq := QuotientGroup.out_eq' q
    rw [h] at houtq
    simpa using houtq.symm
  · left
    have houtq := QuotientGroup.out_eq' q
    rw [h, neg_one_psl_eq_one] at houtq
    simpa using houtq.symm
  · right; left
    have houtq := QuotientGroup.out_eq' q
    rw [h] at houtq
    simpa using houtq.symm
  · right; left
    have houtq := QuotientGroup.out_eq' q
    rw [h, psl_neg] at houtq
    simpa using houtq.symm
  · right; right
    have houtq := QuotientGroup.out_eq' q
    rw [h, psl_ST_sq_eq] at houtq
    simpa using houtq.symm
  · right; right
    have houtq := QuotientGroup.out_eq' q
    rw [h, psl_neg, psl_ST_sq_eq] at houtq
    simpa using houtq.symm

theorem psl_ST_sq_fix_rho : ((((ST : SL(2, ℤ)) : PSL2Z) ^ 2) • rho) = rho := by
  change (((ST : PSL2Z) * (ST : PSL2Z)) • rho) = rho
  rw [MulAction.mul_smul, psl_ST_fix_rho, psl_ST_fix_rho]

private theorem one_ne_psl_S : (1 : PSL2Z) ≠ (ModularGroup.S : PSL2Z) := by
  intro h
  exact psl_S_ne_one h.symm

private def IStabFinset : Finset PSL2Z :=
  ⟨[1, (ModularGroup.S : PSL2Z)], by simp [one_ne_psl_S]⟩

private theorem mem_IStabFinset_iff (q : PSL2Z) :
    q ∈ IStabFinset ↔ q ∈ MulAction.stabilizer PSL2Z UpperHalfPlane.I := by
  rw [MulAction.mem_stabilizer_iff]
  constructor
  · intro hq
    simp [IStabFinset] at hq
    rcases hq with rfl | rfl
    · simp
    · exact psl_S_fix_I
  · intro hq
    rcases psl_fix_I_cases hq with h | h
    · simp [IStabFinset, h]
    · simp [IStabFinset, h]

private theorem IStabFinset_card : IStabFinset.card = 2 := by
  simp [IStabFinset, psl_S_ne_one]

private theorem psl_ST_ne_sq : (ST : PSL2Z) ≠ ((ST : PSL2Z) ^ 2) := by
  intro h
  exact psl_ST_sq_ne_ST h.symm

private theorem one_ne_psl_ST : (1 : PSL2Z) ≠ (ST : PSL2Z) := by
  intro h
  exact psl_ST_ne_one h.symm

private theorem one_ne_psl_ST_sq : (1 : PSL2Z) ≠ ((ST : PSL2Z) ^ 2) := by
  intro h
  exact psl_ST_sq_ne_one h.symm

private def RhoStabFinset : Finset PSL2Z :=
  ⟨[1, (ST : PSL2Z), ((ST : PSL2Z) ^ 2)], by
    simpa using
      (show (¬ (1 : PSL2Z) = (ST : PSL2Z) ∧ ¬ (1 : PSL2Z) = ((ST : PSL2Z) ^ 2)) ∧
          ¬ (ST : PSL2Z) = ((ST : PSL2Z) ^ 2) from
        ⟨⟨one_ne_psl_ST, one_ne_psl_ST_sq⟩, psl_ST_ne_sq⟩)⟩

private theorem mem_RhoStabFinset_iff (q : PSL2Z) :
    q ∈ RhoStabFinset ↔ q ∈ MulAction.stabilizer PSL2Z rho := by
  rw [MulAction.mem_stabilizer_iff]
  constructor
  · intro hq
    simp [RhoStabFinset] at hq
    rcases hq with rfl | rfl | rfl
    · simp
    · exact psl_ST_fix_rho
    · exact psl_ST_sq_fix_rho
  · intro hq
    rcases psl_fix_rho_cases hq with h | h | h
    · simp [RhoStabFinset, h]
    · simp [RhoStabFinset, h]
    · simp [RhoStabFinset, h]

private theorem RhoStabFinset_card : RhoStabFinset.card = 3 := by
  simp [RhoStabFinset, psl_ST_ne_one, psl_ST_sq_ne_one, psl_ST_sq_ne_ST, psl_ST_ne_sq]

noncomputable instance : Fintype (MulAction.stabilizer PSL2Z UpperHalfPlane.I) :=
  Fintype.subtype IStabFinset mem_IStabFinset_iff

noncomputable instance : Fintype (MulAction.stabilizer PSL2Z rho) :=
  Fintype.subtype RhoStabFinset mem_RhoStabFinset_iff

namespace Matrix

theorem Stab_I_card :
    Fintype.card (MulAction.stabilizer MathlibExpansion.Roots.Valence.PSL2Z UpperHalfPlane.I) = 2 := by
  calc
    Fintype.card (MulAction.stabilizer MathlibExpansion.Roots.Valence.PSL2Z UpperHalfPlane.I) =
        MathlibExpansion.Roots.Valence.IStabFinset.card := by
          simpa using
            (Fintype.card_ofFinset MathlibExpansion.Roots.Valence.IStabFinset
              MathlibExpansion.Roots.Valence.mem_IStabFinset_iff)
    _ = 2 := MathlibExpansion.Roots.Valence.IStabFinset_card

theorem Stab_rho_card :
    Fintype.card
        (MulAction.stabilizer MathlibExpansion.Roots.Valence.PSL2Z
          MathlibExpansion.Roots.Valence.rho) = 3 := by
  calc
    Fintype.card
        (MulAction.stabilizer MathlibExpansion.Roots.Valence.PSL2Z
          MathlibExpansion.Roots.Valence.rho) =
        MathlibExpansion.Roots.Valence.RhoStabFinset.card := by
          simpa using
            (Fintype.card_ofFinset MathlibExpansion.Roots.Valence.RhoStabFinset
              MathlibExpansion.Roots.Valence.mem_RhoStabFinset_iff)
    _ = 3 := MathlibExpansion.Roots.Valence.RhoStabFinset_card

end Matrix

end MathlibExpansion.Roots.Valence
