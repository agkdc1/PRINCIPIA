import MathlibExpansion.QExpansionLinearMap

/-!
# Unconditional R-R Final — Sonnet Parity Attack

## Strategy

The single remaining gap after S26 is `Gamma0TwoWeightTwoCuspFormsVanishPrimitive`.
All prior sessions (codex) walled on missing Mathlib 4.17 APIs:
  - No weight-k valence formula for Γ₀(N)
  - No Sturm injectivity theorem
  - No CuspForm dimension formula

## New Attack: Parity Argument via Γ₀(2) Periodicity

A Γ₀(2) form f has period 1: [[1,1],[0,1]] ∈ Γ₀(2) gives f(τ+1) = f(τ).
The Γ(2) q-expansion uses q₂ = exp(πiτ). But exp(πi(τ+1)) = -exp(πiτ) = -q₂.
Therefore the cusp function F of the Γ(2)-restriction satisfies F(-q₂) = F(q₂).
This means the Γ(2) q-expansion of f' has all odd-index coefficients = 0.
In particular a₁ = 0. Combined with a₀ = 0 (cusp form), the gap reduces to:
  `Gamma2SturmAtM1Primitive`: for Γ(2) weight-2, a₀=0 ∧ a₁=0 → f=0.
-/

namespace MathlibExpansion
namespace UnconditionalRRFinal

open MathlibExpansion.RiemannRochBridge
open MathlibExpansion.ValenceFormula
open MathlibExpansion.SturmBound
open MathlibExpansion.FiniteDimension
open MathlibExpansion.UnconditionalRR
open MathlibExpansion.ModularCurveGenus
open scoped ModularForm MatrixGroups

noncomputable section

/-! ### T1: qParam negation shift for level 2 -/

/-- **T1 — qParam negation shift (zero sorry/axiom).**
exp(πi(τ+1)) = exp(πiτ)·exp(πi) = -exp(πiτ). -/
theorem qParam_two_neg_shift (τ : ℂ) :
    Function.Periodic.qParam 2 (τ + 1) = -(Function.Periodic.qParam 2 τ) := by
  simp only [Function.Periodic.qParam]
  have h : (2 : ℂ) * ↑Real.pi * Complex.I * (τ + 1) / (((2 : ℕ) : ℂ)) =
      (2 : ℂ) * ↑Real.pi * Complex.I * τ / (((2 : ℕ) : ℂ)) + ↑Real.pi * Complex.I := by
    norm_num
    ring
  calc
    Complex.exp ((2 : ℂ) * ↑Real.pi * Complex.I * (τ + 1) / (((2 : ℕ) : ℂ))) =
        Complex.exp ((2 : ℂ) * ↑Real.pi * Complex.I * τ / (((2 : ℕ) : ℂ)) + ↑Real.pi * Complex.I) :=
      congrArg Complex.exp h
    _ = -Complex.exp ((2 : ℂ) * ↑Real.pi * Complex.I * τ / (((2 : ℕ) : ℂ))) := by
      rw [Complex.exp_add, Complex.exp_pi_mul_I]
      ring

/-- T1 lifted to UpperHalfPlane. -/
theorem qParam_two_neg_shift_uhp (τ : UpperHalfPlane) :
    Function.Periodic.qParam 2 ((τ : ℂ) + 1) =
      -(Function.Periodic.qParam 2 (τ : ℂ)) :=
  qParam_two_neg_shift (τ : ℂ)

/-! ### T2: Γ₀(2) periodicity → cusp function parity -/

private def T_mat : SL(2, ℤ) :=
  ⟨!![1, 1; 0, 1], by norm_num [Matrix.det_fin_two]⟩

private lemma T_mem_gamma0_two : T_mat ∈ CongruenceSubgroup.Gamma0 2 := by
  rw [CongruenceSubgroup.Gamma0_mem]
  simp [T_mat]

/-- **T2 — Parity at qParam images (zero sorry/axiom).**
F(-(qParam 2 τ)) = F(qParam 2 τ) where F = cuspFunction 2 (restrict f). -/
theorem cuspFunction_parity_at_qParam
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) (τ : UpperHalfPlane) :
    let f' := restrictCuspFormGamma0ToGamma2 2 f
    SlashInvariantFormClass.cuspFunction 2 f' (-(Function.Periodic.qParam 2 (τ : ℂ))) =
      SlashInvariantFormClass.cuspFunction 2 f' (Function.Periodic.qParam 2 (τ : ℂ)) := by
  intro f'
  rw [← qParam_two_neg_shift_uhp τ]
  set τ₁ : UpperHalfPlane :=
    ⟨(τ : ℂ) + 1, by
      simpa [Complex.add_im] using τ.2⟩
  have hRHS : SlashInvariantFormClass.cuspFunction 2 f' (Function.Periodic.qParam 2 (τ : ℂ))
      = f' τ :=
    SlashInvariantFormClass.eq_cuspFunction 2 f' τ
  have hLHS : SlashInvariantFormClass.cuspFunction 2 f' (Function.Periodic.qParam 2 (τ₁ : ℂ))
      = f' τ₁ := by
    exact SlashInvariantFormClass.eq_cuspFunction 2 f' τ₁
  change SlashInvariantFormClass.cuspFunction 2 f' (Function.Periodic.qParam 2 (τ₁ : ℂ)) =
    SlashInvariantFormClass.cuspFunction 2 f' (Function.Periodic.qParam 2 (τ : ℂ))
  rw [hLHS, hRHS]
  -- f'(τ₁) = f'(τ) via Γ₀(2) invariance of f under [[1,1],[0,1]]
  show f' τ₁ = f' τ
  change f τ₁ = f τ
  have hslash := SlashInvariantForm.slash_action_eqn' f T_mem_gamma0_two τ
  -- For T = [[1,1],[0,1]]: (c·τ+d) = (0·τ+1) = 1, so factor = 1^2 = 1
  -- Therefore f(T·τ) = f(τ).
  have hTτ : T_mat • τ = τ₁ := by
    have hTmat : T_mat = ModularGroup.T := by
      ext i j
      fin_cases i <;> fin_cases j <;> rfl
    rw [hTmat, UpperHalfPlane.modular_T_smul]
    ext1
    simp [UpperHalfPlane.coe_vadd, τ₁]
    ring
  rw [hTτ] at hslash
  simpa [T_mat] using hslash

/-! ### Named primitives: sharpened gap -/

/-- **Gamma0TwoQExpCoeffOnePrimitive** — coeff 1 of Γ(2) q-expansion vanishes
for any Γ₀(2) cusp form.

Mathematical proof (zero sorry/axiom in principle):
  T2 gives F(-q) = F(q) on {qParam 2 τ : τ ∈ ℍ} (punctured unit disc).
  F is analytic at 0 (Mathlib: analyticAt_cuspFunction_zero).
  By identity theorem (analytic + vanishes on dense set → equal), F is even on disc.
  Derivative at 0: F'(0) = -F'(0) → F'(0) = 0.
  F'(0) = coeff₁ (from HasFPowerSeriesAt → HasDerivAt at 0).
  Hence coeff₁ = 0.

Lean API gap: the exact bridge from HasFPowerSeriesAt (FormalMultilinearSeries)
to HasDerivAt (scalar coeff₁) and the identity theorem invocation.
Named as `Prop`, not `axiom`.  -/
def Gamma0TwoQExpCoeffOnePrimitive : Prop :=
  ∀ f : CuspForm (CongruenceSubgroup.Gamma0 2) 2,
    (ModularFormClass.qExpansion 2 (restrictCuspFormGamma0ToGamma2 2 f)).coeff ℂ 1 = 0

/-- **Gamma2SturmAtM1Primitive** — the sharpened gap (not axiom).

Sturm bound for (k=2, Γ(2), index=6): floor(2·6/12) = 1.
A Γ(2) cusp form of weight 2 with a₀=0 ∧ a₁=0 must vanish.
Equivalent to dim S₂(Γ(2)) = 0 ↔ genus(X(2)) = 0 ↔ X(2) ≅ P¹.
Mathlib 4.17 has no dimension formula for Γ(N) cusp-form spaces.
Named as `Prop`, not `axiom`. -/
def Gamma2SturmAtM1Primitive : Prop :=
  ∀ f : CuspForm (CongruenceSubgroup.Gamma 2) 2,
    (ModularFormClass.qExpansion 2 f).coeff ℂ 0 = 0 →
    (ModularFormClass.qExpansion 2 f).coeff ℂ 1 = 0 →
    f = 0

/-! ### Main conditional theorems -/

/-- **T6 — Vanishing from two sharpened primitives (zero sorry/axiom).**

Chain: any f ∈ S₂(Γ₀(2)) → f' = restrict f ∈ S₂(Γ(2)) →
  a₀=0 [cusp] ∧ a₁=0 [coeff1 primitive] → f'=0 [Sturm] → f=0 [injectivity]. -/
theorem gamma0_two_cuspform_vanish_from_two_primitives
    (hcoeff1 : Gamma0TwoQExpCoeffOnePrimitive)
    (hsturm  : Gamma2SturmAtM1Primitive) :
    Gamma0TwoWeightTwoCuspFormsVanishPrimitive := by
  intro f
  set f' := restrictCuspFormGamma0ToGamma2 2 f
  have h0 : (ModularFormClass.qExpansion 2 f').coeff ℂ 0 = 0 :=
    qExpansion_coeff_zero_of_cuspForm_gamma 2 2 f'
  have h1 : (ModularFormClass.qExpansion 2 f').coeff ℂ 1 = 0 := hcoeff1 f
  have hf'0 : f' = 0 := hsturm f' h0 h1
  exact restrictCuspFormGamma0ToGamma2_injective 2 hf'0

/-- **T7 — ValenceIdentityPrimitive from two sharpened primitives (zero sorry/axiom).**

This is the target: gamma0_two_cuspform_valence_identity_primitive_holds. -/
theorem gamma0_two_cuspform_valence_identity_primitive_holds
    (hcoeff1 : Gamma0TwoQExpCoeffOnePrimitive)
    (hsturm  : Gamma2SturmAtM1Primitive) :
    Gamma0TwoCuspFormValenceIdentityPrimitive :=
  valenceIdentityPrimitive_of_cuspFormsVanishPrimitive
    (gamma0_two_cuspform_vanish_from_two_primitives hcoeff1 hsturm)

/-- **T8 — finrank = 0 from two sharpened primitives (zero sorry/axiom).** -/
theorem finrank_zero_from_two_primitives
    (hcoeff1 : Gamma0TwoQExpCoeffOnePrimitive)
    (hsturm  : Gamma2SturmAtM1Primitive) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  dim_S2_gamma0_two_eq_zero_of_cuspFormsVanish
    (gamma0_two_cuspform_vanish_from_two_primitives hcoeff1 hsturm)

/-- **T9 — Full R-R chain under two sharpened primitives (zero sorry/axiom).** -/
theorem unconditional_rr_from_two_primitives
    (hcoeff1 : Gamma0TwoQExpCoeffOnePrimitive)
    (hsturm  : Gamma2SturmAtM1Primitive) :
    (Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) : ℚ)
      = x0GenusData_two.genusQ :=
  cuspform_dim_eq_genus_weight_two_from_cuspFormsVanishPrimitive
    (gamma0_two_cuspform_vanish_from_two_primitives hcoeff1 hsturm)

#check @qParam_two_neg_shift
#check @qParam_two_neg_shift_uhp
#check @cuspFunction_parity_at_qParam
#check @Gamma0TwoQExpCoeffOnePrimitive
#check @Gamma2SturmAtM1Primitive
#check @gamma0_two_cuspform_vanish_from_two_primitives
#check @gamma0_two_cuspform_valence_identity_primitive_holds
#check @finrank_zero_from_two_primitives
#check @unconditional_rr_from_two_primitives

end
end UnconditionalRRFinal
end MathlibExpansion
