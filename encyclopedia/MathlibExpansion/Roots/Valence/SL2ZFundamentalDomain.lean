import Mathlib.NumberTheory.Modular
import Mathlib.LinearAlgebra.Matrix.ProjectiveSpecialLinearGroup
import Mathlib.Algebra.Group.Action.End
import Mathlib.GroupTheory.QuotientGroup.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Data.Complex.Trigonometric

/-!
# Standard fundamental-domain boundary data for `SL₂(ℤ)`

This file packages the basic geometric objects around Mathlib's standard fundamental
domain `ModularGroup.fd` and its interior `ModularGroup.fdo`.

The upstream file `Mathlib/NumberTheory/Modular.lean` already provides the closed and
open domains.  For the valence-formula campaign we additionally need:

- the elliptic point `rho = exp (2π i / 3)` in `ℍ`;
- the action of `PSL(2,ℤ)` on `ℍ`, obtained by quotienting the `SL(2,ℤ)` action by the
  center;
- explicit boundary pieces of `fd`;
- the elementary side-pairing lemmas for `T` and `S`.
-/

noncomputable section

open Matrix Matrix.SpecialLinearGroup UpperHalfPlane ModularGroup QuotientGroup
open scoped MatrixGroups UpperHalfPlane Modular

namespace MathlibExpansion.Roots.Valence

/-- The projective modular group. -/
abbrev PSL2Z := PSL(2, ℤ)

private theorem center_le_upperHalfPlane_toPerm_ker :
    Subgroup.center (SL(2, ℤ)) ≤ (MulAction.toPermHom (SL(2, ℤ)) ℍ).ker := by
  intro g hg
  ext z
  obtain ⟨r, hrpow, hrscalar⟩ :=
    Matrix.SpecialLinearGroup.mem_center_iff.mp hg
  have hsq : r ^ 2 = (1 : ℤ) ^ 2 := by simpa using hrpow
  rcases eq_or_eq_neg_of_sq_eq_sq r 1 hsq with h | h
  · subst h
    have hg1 : g = 1 := by
      ext i j
      simpa using (congr_fun₂ hrscalar i j).symm
    simp [hg1]
  · subst h
    have hgneg : g = -1 := by
      ext i j
      simpa using (congr_fun₂ hrscalar i j).symm
    simpa [hgneg] using (ModularGroup.SL_neg_smul (1 : SL(2, ℤ)) z)

/-- The `SL(2,ℤ)` action on `ℍ` factors through `PSL(2,ℤ)`. -/
noncomputable def pslToPerm : PSL2Z →* Equiv.Perm ℍ :=
  QuotientGroup.lift (Subgroup.center (SL(2, ℤ)))
    (MulAction.toPermHom (SL(2, ℤ)) ℍ)
    center_le_upperHalfPlane_toPerm_ker

instance : MulAction PSL2Z ℍ :=
  MulAction.compHom ℍ pslToPerm

/-- A quotient class acts by any chosen representative. -/
theorem psl_smul_out (q : PSL2Z) (z : ℍ) : q • z = q.out • z := by
  change pslToPerm q z = q.out • z
  rw [← QuotientGroup.out_eq' q]
  have h :=
    congrArg (fun e : Equiv.Perm ℍ => e z)
      (QuotientGroup.lift_mk'
        (N := Subgroup.center (SL(2, ℤ)))
        (φ := MulAction.toPermHom (SL(2, ℤ)) ℍ)
        (HN := center_le_upperHalfPlane_toPerm_ker)
        q.out)
  simpa [pslToPerm] using h

/-- The standard cubic elliptic point written in coordinates. -/
private theorem exp_two_pi_div_three_eq_coord :
    Complex.exp (2 * Real.pi * Complex.I / 3) =
      (-(1 : ℝ) / 2 : ℂ) + (Real.sqrt 3 / 2) * Complex.I := by
  have harg : 2 * Real.pi * Complex.I / 3 = (((2 * Real.pi / 3 : ℝ) : ℂ) * Complex.I) := by
    norm_num [div_eq_mul_inv, mul_assoc, mul_left_comm, mul_comm]
  apply Complex.ext
  · rw [harg, Complex.exp_ofReal_mul_I_re]
    have hrewrite : (2 * Real.pi / 3 : ℝ) = Real.pi - Real.pi / 3 := by ring
    rw [hrewrite, Real.cos_pi_sub, Real.cos_pi_div_three]
    norm_num
  · rw [harg, Complex.exp_ofReal_mul_I_im]
    have hrewrite : (2 * Real.pi / 3 : ℝ) = Real.pi - Real.pi / 3 := by ring
    rw [hrewrite, Real.sin_pi_sub, Real.sin_pi_div_three]
    simp

/-- The order-three elliptic point in the standard fundamental domain. -/
def rho : ℍ :=
  ⟨Complex.exp (2 * Real.pi * Complex.I / 3), by
    rw [exp_two_pi_div_three_eq_coord]
    simp [Real.sqrt_pos.2 (by norm_num : (0 : ℝ) < 3)]⟩

@[simp]
theorem rho_coe : (rho : ℂ) = (-(1 : ℝ) / 2 : ℂ) + (Real.sqrt 3 / 2) * Complex.I :=
  exp_two_pi_div_three_eq_coord

@[simp]
theorem rho_re : rho.re = -(1 : ℝ) / 2 := by
  rw [show rho.re = ((rho : ℂ).re) by rfl, rho_coe]
  simp

@[simp]
theorem rho_im : rho.im = Real.sqrt 3 / 2 := by
  rw [show rho.im = ((rho : ℂ).im) by rfl, rho_coe]
  simp

private lemma two_pi_div_three_eq_pi_sub_pi_div_three :
    2 * Real.pi / 3 = Real.pi - Real.pi / 3 := by
  ring

@[simp]
theorem rho_normSq : Complex.normSq (rho : ℂ) = 1 := by
  simp [Complex.normSq, rho_coe]
  have hsqrt : (Real.sqrt 3) ^ 2 = 3 := by
    nlinarith [Real.sq_sqrt (show (0 : ℝ) ≤ 3 by positivity)]
  nlinarith

/-- The elliptic point `rho` satisfies `rho^2 + rho + 1 = 0`. -/
theorem rho_quad : (rho : ℂ) ^ 2 + rho + 1 = 0 := by
  apply Complex.ext
  · simp [rho_coe, pow_two, mul_add, add_mul]
    ring_nf
    field_simp [Real.sq_sqrt (show (0 : ℝ) ≤ 3 by positivity)]
  · simp [rho_coe, pow_two, mul_add, add_mul]
    ring_nf

/-- The standard left side `Re(z) = -1/2` of the closed fundamental domain. -/
def leftSide : Set ℍ :=
  {z | z ∈ ModularGroup.fd ∧ z.re = -(1 : ℝ) / 2}

/-- The standard right side `Re(z) = 1/2` of the closed fundamental domain. -/
def rightSide : Set ℍ :=
  {z | z ∈ ModularGroup.fd ∧ z.re = (1 : ℝ) / 2}

/-- The unit-circle arc on the boundary of the closed fundamental domain. -/
def unitArc : Set ℍ :=
  {z | z ∈ ModularGroup.fd ∧ Complex.normSq (z : ℂ) = 1}

@[simp]
theorem I_mem_unitArc : UpperHalfPlane.I ∈ unitArc := by
  refine ⟨?_, by norm_num [Complex.normSq, UpperHalfPlane.I]⟩
  constructor
  · norm_num [Complex.normSq, UpperHalfPlane.I]
  · change |(0 : ℝ)| ≤ (1 : ℝ) / 2
    norm_num

@[simp]
theorem rho_mem_leftSide : rho ∈ leftSide := by
  refine ⟨?_, rho_re⟩
  constructor
  · simpa [rho_normSq] using (show (1 : ℝ) ≤ Complex.normSq (rho : ℂ) by rw [rho_normSq])
  · rw [rho_re]
    have hconst : |(-(1 : ℝ) / 2 : ℝ)| = (1 : ℝ) / 2 := by norm_num
    rw [hconst]

@[simp]
theorem rho_mem_unitArc : rho ∈ unitArc := by
  exact ⟨rho_mem_leftSide.1, rho_normSq⟩

/-- Boundary points of `fd` are exactly on the two vertical sides or on the unit-circle arc. -/
theorem mem_boundary_iff (z : ℍ) :
    z ∈ ModularGroup.fd ∧ z ∉ ModularGroup.fdo ↔
      z ∈ leftSide ∨ z ∈ rightSide ∨ z ∈ unitArc := by
  constructor
  · rintro ⟨hzfd, hznotfdo⟩
    by_cases hnorm : Complex.normSq (z : ℂ) = 1
    · exact Or.inr <| Or.inr ⟨hzfd, hnorm⟩
    · have hnorm' : 1 < Complex.normSq (z : ℂ) := lt_of_le_of_ne hzfd.1 (by simpa [eq_comm] using hnorm)
      have habs' : ¬ |z.re| < (1 : ℝ) / 2 := by
        intro habs
        exact hznotfdo ⟨hnorm', habs⟩
      have habs_eq : |z.re| = (1 : ℝ) / 2 := le_antisymm hzfd.2 (le_of_not_gt habs')
      by_cases hre : 0 ≤ z.re
      · have hside : z.re = (1 : ℝ) / 2 := by simpa [abs_of_nonneg hre] using habs_eq
        exact Or.inr <| Or.inl ⟨hzfd, hside⟩
      · have hside : z.re = -(1 : ℝ) / 2 := by
          have hre' : z.re ≤ 0 := le_of_not_ge hre
          have hneg : -z.re = (1 : ℝ) / 2 := by
            simpa [abs_of_nonpos hre'] using habs_eq
          linarith
        exact Or.inl ⟨hzfd, hside⟩
  · rintro (hz | hz | hz)
    · refine ⟨hz.1, ?_⟩
      rintro ⟨_, hzre⟩
      have htmp : |(-(1 : ℝ) / 2 : ℝ)| < (1 : ℝ) / 2 := by simpa [hz.2] using hzre
      have habs : |(-(1 : ℝ) / 2 : ℝ)| = (1 : ℝ) / 2 := by norm_num
      rw [habs] at htmp
      exact lt_irrefl _ htmp
    · refine ⟨hz.1, ?_⟩
      rintro ⟨_, hzre⟩
      have htmp : |((1 : ℝ) / 2 : ℝ)| < (1 : ℝ) / 2 := by simpa [hz.2] using hzre
      have habs : |((1 : ℝ) / 2 : ℝ)| = (1 : ℝ) / 2 := by norm_num
      rw [habs] at htmp
      exact lt_irrefl _ htmp
    · refine ⟨hz.1, ?_⟩
      rintro ⟨hznorm, _⟩
      have hbad : ¬ (1 : ℝ) < 1 := by exact not_lt.mpr le_rfl
      exact hbad (by simpa [hz.2] using hznorm)

theorem T_normSq_eq_of_mem_leftSide {z : ℍ} (hz : z ∈ leftSide) :
    Complex.normSq ((ModularGroup.T • z : ℍ) : ℂ) = Complex.normSq (z : ℂ) := by
  rw [show (((ModularGroup.T • z : ℍ) : ℂ)) = z + 1 by
      simpa using (ModularGroup.coe_T_zpow_smul_eq (z := z) (n := 1))]
  simp [Complex.normSq, hz.2]
  ring

theorem T_maps_leftSide {z : ℍ} (hz : z ∈ leftSide) : ModularGroup.T • z ∈ rightSide := by
  refine ⟨?_, ?_⟩
  · constructor
    · rw [T_normSq_eq_of_mem_leftSide hz]
      exact hz.1.1
    · have hre : (ModularGroup.T • z).re = (1 : ℝ) / 2 := by
          nlinarith [ModularGroup.re_T_smul (z := z), hz.2]
      have habs : |(ModularGroup.T • z).re| ≤ (1 : ℝ) / 2 := by
        rw [hre]
        have hconst : |((1 : ℝ) / 2 : ℝ)| = (1 : ℝ) / 2 := by norm_num
        rw [hconst]
      exact habs
  · nlinarith [ModularGroup.re_T_smul (z := z), hz.2]

theorem T_inv_normSq_eq_of_mem_rightSide {z : ℍ} (hz : z ∈ rightSide) :
    Complex.normSq ((ModularGroup.T⁻¹ • z : ℍ) : ℂ) = Complex.normSq (z : ℂ) := by
  rw [show (((ModularGroup.T⁻¹ • z : ℍ) : ℂ)) = z - 1 by
      simpa [sub_eq_add_neg] using (ModularGroup.coe_T_zpow_smul_eq (z := z) (n := -1))]
  simp [sub_eq_add_neg, Complex.normSq, hz.2]
  ring

theorem T_inv_maps_rightSide {z : ℍ} (hz : z ∈ rightSide) :
    ModularGroup.T⁻¹ • z ∈ leftSide := by
  refine ⟨?_, ?_⟩
  · constructor
    · rw [T_inv_normSq_eq_of_mem_rightSide hz]
      exact hz.1.1
    · have hre : (ModularGroup.T⁻¹ • z).re = -(1 : ℝ) / 2 := by
          nlinarith [ModularGroup.re_T_inv_smul (z := z), hz.2]
      have habs : |(ModularGroup.T⁻¹ • z).re| ≤ (1 : ℝ) / 2 := by
        rw [hre]
        have hconst : |(-(1 : ℝ) / 2 : ℝ)| = (1 : ℝ) / 2 := by norm_num
        rw [hconst]
      exact habs
  · nlinarith [ModularGroup.re_T_inv_smul (z := z), hz.2]

theorem S_normSq_eq_one_of_mem_unitArc {z : ℍ} (hz : z ∈ unitArc) :
    Complex.normSq ((ModularGroup.S • z : ℍ) : ℂ) = 1 := by
  rw [UpperHalfPlane.modular_S_smul]
  change Complex.normSq ((-(z : ℂ))⁻¹) = 1
  simp [Complex.normSq_inv, Complex.normSq_neg, hz.2]

theorem S_abs_re_eq_of_mem_unitArc {z : ℍ} (hz : z ∈ unitArc) :
    |(ModularGroup.S • z).re| = |z.re| := by
  rw [UpperHalfPlane.modular_S_smul]
  change |((-(z : ℂ))⁻¹).re| = |z.re|
  rw [Complex.inv_re, Complex.normSq_neg, hz.2]
  simp

theorem S_maps_unitArc {z : ℍ} (hz : z ∈ unitArc) : ModularGroup.S • z ∈ unitArc := by
  refine ⟨?_, S_normSq_eq_one_of_mem_unitArc hz⟩
  constructor
  · change (1 : ℝ) ≤ Complex.normSq ((ModularGroup.S • z : ℍ) : ℂ)
    exact le_of_eq (S_normSq_eq_one_of_mem_unitArc hz).symm
  · have hfd : |z.re| ≤ (1 : ℝ) / 2 := hz.1.2
    rw [S_abs_re_eq_of_mem_unitArc hz]
    exact hfd

end MathlibExpansion.Roots.Valence
