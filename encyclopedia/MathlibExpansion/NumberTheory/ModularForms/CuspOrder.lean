import Mathlib.NumberTheory.ModularForms.QExpansion
import Mathlib.RingTheory.PowerSeries.Order
import Mathlib.Algebra.Group.Subgroup.Pointwise
import Mathlib.Analysis.Calculus.Deriv.ZPow

/-!
# Orders at cusps of modular forms

This file packages orders at cusps using explicit cusp representatives and their
widths. The underlying local `q`-parameter is always obtained from the slashed
function at `∞`, so transformed-cusp formulas become slash-action tautologies.

## Main definitions

- `CuspOrder.ordAtInfinity`
- `CuspOrder.cuspFunctionAtCusp`
- `CuspOrder.qExpansionAtCusp`
- `CuspOrder.ordAtCusp`

## Main results

- `CuspOrder.qExpansion_order_eq_ordAtInfinity`
- `CuspOrder.cuspFunctionAtCusp_mul_left`
- `CuspOrder.qExpansionAtCusp_mul_left`
- `CuspOrder.ordAtCusp_mul_left`
-/

open Function ModularForm Complex UpperHalfPlane Filter

open scoped MatrixGroups CongruenceSubgroup ModularForm Pointwise

noncomputable section

variable {Γ : Subgroup SL(2, ℤ)} {k : ℤ}

namespace CuspOrder

/-- Order at the `∞` cusp for a principal-level modular form, measured in the
standard width-`n` q-parameter from Mathlib's `qExpansion`. -/
def ordAtInfinity (n : ℕ) [NeZero n]
    (f : ModularForm (CongruenceSubgroup.Gamma n) k) : ℕ∞ :=
  (ModularFormClass.qExpansion n f).order

@[simp] theorem qExpansion_order_eq_ordAtInfinity
    (n : ℕ) [NeZero n] (f : ModularForm (CongruenceSubgroup.Gamma n) k) :
    (ModularFormClass.qExpansion n f).order = ordAtInfinity n f := rfl

/-- A cusp order together with the width of the chosen local `q`-parameter. -/
structure LocalCuspOrder where
  width : ℕ
  order : ℕ∞

private def slashedCompOfComplex
    (f : ℍ → ℂ) (A : SL(2, ℤ)) : ℂ → ℂ :=
  ((f ∣[k] A) ∘ ofComplex)

private theorem periodic_slashedCompOfComplex {F : Type*} [FunLike F ℍ ℂ]
    [SlashInvariantFormClass F Γ k] (f : F) (A : SL(2, ℤ)) (w : ℕ) [NeZero w]
    (hA : A * ModularGroup.T ^ (w : ℤ) * A⁻¹ ∈ Γ) :
    Periodic (slashedCompOfComplex (k := k) (f : ℍ → ℂ) A) w := by
  intro z
  by_cases hz : 0 < Complex.im z
  · have hzw : 0 < Complex.im (z + w) := by
      simpa [Complex.add_im] using hz
    let τ : ℍ := ⟨z, hz⟩
    let τw : ℍ := ⟨z + w, hzw⟩
    have hslash :
        (((f : ℍ → ℂ) ∣[k] A) ∣[k] (ModularGroup.T ^ (w : ℤ))) =
          ((f : ℍ → ℂ) ∣[k] A) := by
      calc
        (((f : ℍ → ℂ) ∣[k] A) ∣[k] (ModularGroup.T ^ (w : ℤ)))
            = (f : ℍ → ℂ) ∣[k] (A * ModularGroup.T ^ (w : ℤ)) := by
              rw [← SlashAction.slash_mul]
        _ = (f : ℍ → ℂ) ∣[k] (((A * ModularGroup.T ^ (w : ℤ)) * A⁻¹) * A) := by
              congr 1
              rw [mul_assoc, inv_mul_cancel, mul_one]
        _ = (((f : ℍ → ℂ) ∣[k] (A * ModularGroup.T ^ (w : ℤ) * A⁻¹)) ∣[k] A) := by
              rw [SlashAction.slash_mul]
        _ = ((f : ℍ → ℂ) ∣[k] A) := by
              rw [SlashInvariantForm.slash_action_eqn f _ hA]
    have hval := congrArg (fun h : ℍ → ℂ => h τ) hslash
    have hTτ : (ModularGroup.T ^ (w : ℤ)) • τ = τw := by
      apply UpperHalfPlane.ext
      simpa [τ, τw, add_comm] using
        congrArg (fun z : ℍ => (z : ℂ)) (UpperHalfPlane.modular_T_zpow_smul τ (w : ℤ))
    have hTτGL :
        ((↑(ModularGroup.T ^ (w : ℤ)) : GL(2, ℝ)⁺) • τ) = τw := by
      simpa using hTτ
    have hdenT :
        UpperHalfPlane.denom (↑(ModularGroup.T ^ (w : ℤ)) : GL(2, ℝ)⁺) τ = 1 := by
      have hdenT' :
          UpperHalfPlane.denom
              (↑(ModularGroup.T ^ (w : ℤ)) : GL(2, ℝ)⁺) τ = 1 := by
        rw [ModularGroup.denom_apply, ModularGroup.coe_T_zpow]
        simp
      exact hdenT'
    have hperiod : ((f : ℍ → ℂ) ∣[k] A) τw = ((f : ℍ → ℂ) ∣[k] A) τ := by
      have hval' := hval
      rw [ModularForm.SL_slash, ModularForm.slash_def] at hval'
      simp [ModularForm.slash, ModularGroup.det_coe] at hval'
      have hpow :
          (UpperHalfPlane.denom (↑(ModularGroup.T ^ (w : ℤ)) : GL(2, ℝ)⁺) τ ^ k)⁻¹ = 1 := by
        rw [hdenT]
        simp
      have hTτGL_nat :
          ((↑(ModularGroup.T ^ w) : GL(2, ℝ)⁺) • τ) = τw := by
        simpa using hTτGL
      have hdenT_nat :
          UpperHalfPlane.denom (↑(ModularGroup.T ^ w) : GL(2, ℝ)⁺) τ = 1 := by
        simpa using hdenT
      have hpow_nat :
          (UpperHalfPlane.denom (↑(ModularGroup.T ^ w) : GL(2, ℝ)⁺) τ ^ k)⁻¹ = 1 := by
        rw [hdenT_nat]
        simp
      have hperiodGL : ((f : ℍ → ℂ) ∣[k] (A : GL(2, ℝ)⁺)) τw =
          ((f : ℍ → ℂ) ∣[k] (A : GL(2, ℝ)⁺)) τ := by
        calc
          ((f : ℍ → ℂ) ∣[k] (A : GL(2, ℝ)⁺)) τw
            = ((f : ℍ → ℂ) ∣[k] (A : GL(2, ℝ)⁺))
                ((↑(ModularGroup.T ^ w) : GL(2, ℝ)⁺) • τ) := by rw [hTτGL_nat]
          _ = ((f : ℍ → ℂ) ∣[k] (A : GL(2, ℝ)⁺))
                ((↑(ModularGroup.T ^ w) : GL(2, ℝ)⁺) • τ) *
                (UpperHalfPlane.denom (↑(ModularGroup.T ^ w) : GL(2, ℝ)⁺) τ ^ k)⁻¹ := by
                  rw [hpow_nat, mul_one]
          _ = ((f : ℍ → ℂ) ∣[k] (A : GL(2, ℝ)⁺)) τ := hval'
      simpa [ModularForm.SL_slash] using hperiodGL
    simpa [slashedCompOfComplex, Function.comp, τ, τw,
      ofComplex_apply_of_im_pos hz, ofComplex_apply_of_im_pos hzw] using hperiod
  · have hzw : Complex.im (z + w) ≤ 0 := by
      simpa [Complex.add_im] using hz
    have hz' : Complex.im z ≤ 0 := not_lt.mp hz
    simp [slashedCompOfComplex, ofComplex_apply_of_im_nonpos hz',
      ofComplex_apply_of_im_nonpos hzw]

private theorem differentiableAt_slashedCompOfComplex
    (f : ModularForm Γ k) (A : SL(2, ℤ)) {z : ℂ} (hz : 0 < Complex.im z) :
    DifferentiableAt ℂ (slashedCompOfComplex (k := k) (f : ℍ → ℂ) A) z := by
  let g : ℂ → ℂ :=
    fun w => ((A 0 0 : ℂ) * w + A 0 1) / ((A 1 0 : ℂ) * w + A 1 1)
  have hden :
      ((A 1 0 : ℂ) * z + A 1 1 : ℂ) ≠ 0 := by
    simpa [ModularGroup.denom_apply, UpperHalfPlane.ofComplex_apply_of_im_pos hz] using
      (UpperHalfPlane.denom_ne_zero (A : GL(2, ℝ)⁺) (UpperHalfPlane.ofComplex z))
  have hgz : 0 < Complex.im (g z) := by
    have hA : g z = ((A • UpperHalfPlane.ofComplex z : ℍ) : ℂ) := by
      simp [g, UpperHalfPlane.specialLinearGroup_apply, UpperHalfPlane.ofComplex_apply_of_im_pos hz]
    rw [hA]
    exact (A • UpperHalfPlane.ofComplex z).im_pos
  have hf :
      DifferentiableAt ℂ ((f : ℍ → ℂ) ∘ ofComplex) (g z) :=
    ModularFormClass.differentiableAt_comp_ofComplex f hgz
  have hnum :
      DifferentiableAt ℂ (fun w => (A 0 0 : ℂ) * w + A 0 1) z := by
    simpa using (differentiableAt_id.const_mul (A 0 0 : ℂ)).add_const (A 0 1 : ℂ)
  have hdenf :
      DifferentiableAt ℂ (fun w => (A 1 0 : ℂ) * w + A 1 1) z := by
    simpa using (differentiableAt_id.const_mul (A 1 0 : ℂ)).add_const (A 1 1 : ℂ)
  have hg : DifferentiableAt ℂ g z := hnum.div hdenf hden
  have hpow :
      DifferentiableAt ℂ (fun w => ((A 1 0 : ℂ) * w + A 1 1) ^ (-k)) z :=
    hdenf.zpow (m := -k) (Or.inl hden)
  have hexp :
      DifferentiableAt ℂ
        (fun w => ((f : ℍ → ℂ) ∘ ofComplex) (g w) *
          ((A 1 0 : ℂ) * w + A 1 1) ^ (-k)) z :=
    (hf.comp z hg).mul hpow
  have hpos : {w : ℂ | 0 < Complex.im w} ∈ nhds z :=
    Complex.continuous_im.continuousAt.preimage_mem_nhds (isOpen_Ioi.mem_nhds hz)
  have hEq :
      slashedCompOfComplex (k := k) (f : ℍ → ℂ) A =ᶠ[nhds z]
        fun w => ((f : ℍ → ℂ) ∘ ofComplex) (g w) *
          ((A 1 0 : ℂ) * w + A 1 1) ^ (-k) := by
    filter_upwards [hpos] with w hw
    rw [slashedCompOfComplex, Function.comp, ModularForm.SL_slash, ModularForm.slash_def,
      ModularForm.slash]
    have hAwSL : ((A • UpperHalfPlane.ofComplex w : ℍ) : ℂ) = g w := by
      simp [g, UpperHalfPlane.specialLinearGroup_apply,
        UpperHalfPlane.ofComplex_apply_of_im_pos hw]
    have hAw :
        (((((A : SL(2, ℤ)) : GL(2, ℝ)⁺) • UpperHalfPlane.ofComplex w : ℍ) : ℂ)) = g w := by
      simpa using hAwSL
    have hgw : 0 < Complex.im (g w) := by
      have : 0 < Complex.im (((A • UpperHalfPlane.ofComplex w : ℍ) : ℂ)) :=
        (A • UpperHalfPlane.ofComplex w).im_pos
      rw [hAwSL] at this
      exact this
    have hAw' :
        ((A : GL(2, ℝ)⁺) • UpperHalfPlane.ofComplex w) = UpperHalfPlane.ofComplex (g w) := by
      apply UpperHalfPlane.ext
      simpa [UpperHalfPlane.ofComplex_apply_of_im_pos hgw] using hAw
    rw [hAw', ModularGroup.denom_apply]
    simp [Function.comp, g, hgw, UpperHalfPlane.ofComplex_apply_of_im_pos hw]
  exact hexp.congr_of_eventuallyEq hEq

private theorem boundedAtFilter_slashedCompOfComplex
    (f : ModularForm Γ k) (A : SL(2, ℤ)) :
    BoundedAtFilter (comap Complex.im atTop)
      (slashedCompOfComplex (k := k) (f : ℍ → ℂ) A) := by
  simpa [slashedCompOfComplex, Function.comp] using
    (ModularFormClass.bdd_at_infty f A).comp_tendsto UpperHalfPlane.tendsto_comap_im_ofComplex

/-- The local cusp function attached to the representative `A` and width `w`. -/
def cuspFunctionAtCusp (f : ModularForm Γ k) (A : SL(2, ℤ)) (w : ℕ) [NeZero w]
    (_hA : A * ModularGroup.T ^ (w : ℤ) * A⁻¹ ∈ Γ) : ℂ → ℂ :=
  Function.Periodic.cuspFunction w (slashedCompOfComplex (k := k) (f : ℍ → ℂ) A)

theorem eq_cuspFunctionAtCusp
    (f : ModularForm Γ k) (A : SL(2, ℤ)) (w : ℕ) [NeZero w]
    (hA : A * ModularGroup.T ^ (w : ℤ) * A⁻¹ ∈ Γ) (τ : ℍ) :
    cuspFunctionAtCusp (Γ := Γ) (k := k) f A w hA
        (Function.Periodic.qParam w (τ : ℂ)) =
      (((f : ℍ → ℂ) ∣[k] A) τ) := by
  have hw0 : (w : ℝ) ≠ 0 := by
    exact_mod_cast (NeZero.ne w)
  simpa [cuspFunctionAtCusp, slashedCompOfComplex, Function.comp] using
    (periodic_slashedCompOfComplex (Γ := Γ) (k := k) f A w hA).eq_cuspFunction hw0 (τ : ℂ)

theorem differentiableAt_cuspFunctionAtCusp
    (f : ModularForm Γ k) (A : SL(2, ℤ)) (w : ℕ) [NeZero w]
    (hA : A * ModularGroup.T ^ (w : ℤ) * A⁻¹ ∈ Γ) {q : ℂ} (hq : ‖q‖ < 1) :
    DifferentiableAt ℂ (cuspFunctionAtCusp (Γ := Γ) (k := k) f A w hA) q := by
  have hwpos : 0 < (w : ℝ) := by
    exact_mod_cast Nat.pos_iff_ne_zero.mpr (NeZero.ne w)
  let hperiodic := periodic_slashedCompOfComplex (Γ := Γ) (k := k) f A w hA
  rcases eq_or_ne q 0 with rfl | hq0
  · exact
      hperiodic.differentiableAt_cuspFunction_zero
      hwpos
      (eventually_of_mem (preimage_mem_comap (Ioi_mem_atTop 0))
        (fun z hz => differentiableAt_slashedCompOfComplex (Γ := Γ) (k := k) f A hz))
      (boundedAtFilter_slashedCompOfComplex (Γ := Γ) (k := k) f A)
  · exact Function.Periodic.qParam_right_inv hwpos.ne' hq0 ▸
      hperiodic.differentiableAt_cuspFunction hwpos.ne'
        <| differentiableAt_slashedCompOfComplex (Γ := Γ) (k := k) f A <|
            Function.Periodic.im_invQParam_pos_of_norm_lt_one hwpos hq hq0

lemma analyticAt_cuspFunctionAtCusp
    (f : ModularForm Γ k) (A : SL(2, ℤ)) (w : ℕ) [NeZero w]
    (hA : A * ModularGroup.T ^ (w : ℤ) * A⁻¹ ∈ Γ) :
    AnalyticAt ℂ (cuspFunctionAtCusp (Γ := Γ) (k := k) f A w hA) 0 :=
  DifferentiableOn.analyticAt
    (fun q hq =>
      (differentiableAt_cuspFunctionAtCusp (Γ := Γ) (k := k) f A w hA
        (by simpa using hq)).differentiableWithinAt)
    (by simpa only [ball_zero_eq] using Metric.ball_mem_nhds (0 : ℂ) zero_lt_one)

/-- The local `q`-expansion attached to the cusp representative `A` and width `w`. -/
def qExpansionAtCusp (f : ModularForm Γ k) (A : SL(2, ℤ)) (w : ℕ) [NeZero w]
    (hA : A * ModularGroup.T ^ (w : ℤ) * A⁻¹ ∈ Γ) : PowerSeries ℂ :=
  .mk fun m => (↑m.factorial)⁻¹ *
    iteratedDeriv m (cuspFunctionAtCusp (Γ := Γ) (k := k) f A w hA) 0

/-- Order at the cusp represented by `A`, measured in the width-`w` local
`q`-parameter. -/
def ordAtCusp (f : ModularForm Γ k) (A : SL(2, ℤ)) (w : ℕ) [NeZero w]
    (hA : A * ModularGroup.T ^ (w : ℤ) * A⁻¹ ∈ Γ) : LocalCuspOrder where
  width := w
  order := (qExpansionAtCusp (Γ := Γ) (k := k) f A w hA).order

@[simp] theorem ordAtCusp_width
    (f : ModularForm Γ k) (A : SL(2, ℤ)) (w : ℕ) [NeZero w]
    (hA : A * ModularGroup.T ^ (w : ℤ) * A⁻¹ ∈ Γ) :
    (ordAtCusp (Γ := Γ) (k := k) f A w hA).width = w := rfl

/-- Slash transport of modular forms along conjugation of the level subgroup. -/
def slashModularForm (f : ModularForm Γ k) (g : SL(2, ℤ)) :
    ModularForm (MulAut.conj g⁻¹ • Γ) k where
  toSlashInvariantForm :=
    { toFun := (f : ℍ → ℂ) ∣[k] g
      slash_action_eq' := by
        intro δ hδ
        have hδΓ : MulAut.conj g δ ∈ Γ := by
          simpa using
            ((Subgroup.mem_pointwise_smul_iff_inv_smul_mem
              (a := MulAut.conj g⁻¹) (S := Γ) (x := δ)).1 hδ)
        calc
          (((f : ℍ → ℂ) ∣[k] g) ∣[k] δ) = (f : ℍ → ℂ) ∣[k] (g * δ) := by
            rw [← SlashAction.slash_mul]
          _ = (f : ℍ → ℂ) ∣[k] (MulAut.conj g δ * g) := by
            congr 1
            simp [MulAut.conj_apply, mul_assoc]
          _ = (((f : ℍ → ℂ) ∣[k] MulAut.conj g δ) ∣[k] g) := by
            rw [SlashAction.slash_mul]
          _ = (f : ℍ → ℂ) ∣[k] g := by
            rw [SlashInvariantForm.slash_action_eqn f _ hδΓ] }
  holo' := by
    intro τ
    rw [UpperHalfPlane.mdifferentiableAt_iff]
    simpa [slashedCompOfComplex] using
      differentiableAt_slashedCompOfComplex (Γ := Γ) (k := k) f g
        (z := (τ : ℂ)) τ.im_pos
  bdd_at_infty' := by
    intro A
    simpa [SlashAction.slash_mul] using f.bdd_at_infty' (g * A)

@[simp] theorem slashModularForm_coe
    (f : ModularForm Γ k) (g : SL(2, ℤ)) :
    (slashModularForm f g : ℍ → ℂ) = (f : ℍ → ℂ) ∣[k] g := rfl

private lemma cusp_conj_mem
    (g A : SL(2, ℤ)) (w : ℕ) [NeZero w]
    (hA : A * ModularGroup.T ^ (w : ℤ) * A⁻¹ ∈ MulAut.conj g⁻¹ • Γ) :
    g * A * ModularGroup.T ^ (w : ℤ) * (g * A)⁻¹ ∈ Γ := by
  rcases (Subgroup.mem_smul_pointwise_iff_exists _ _ _).1 hA with ⟨γ, hγ, hγeq⟩
  have hγeq : g⁻¹ * γ * g = A * ModularGroup.T ^ (w : ℤ) * A⁻¹ := by
    simpa [MulAut.smul_def, MulAut.conj_apply] using hγeq
  have htarget : γ = g * A * ModularGroup.T ^ (w : ℤ) * (g * A)⁻¹ := by
    calc
      γ = g * (g⁻¹ * γ * g) * g⁻¹ := by simp [mul_assoc]
      _ = g * (A * ModularGroup.T ^ (w : ℤ) * A⁻¹) * g⁻¹ := by rw [hγeq]
      _ = g * A * ModularGroup.T ^ (w : ℤ) * (g * A)⁻¹ := by
            simp [mul_assoc, mul_inv_rev]
  rw [← htarget]
  exact hγ

/-- Transport of the local cusp function under slashing by `g`. -/
theorem cuspFunctionAtCusp_mul_left
    (f : ModularForm Γ k) (g A : SL(2, ℤ)) (w : ℕ) [NeZero w]
    (hA : A * ModularGroup.T ^ (w : ℤ) * A⁻¹ ∈ MulAut.conj g⁻¹ • Γ) :
    cuspFunctionAtCusp (Γ := Γ) (k := k) f (g * A) w
        (cusp_conj_mem g A w hA) =
      cuspFunctionAtCusp (Γ := MulAut.conj g⁻¹ • Γ) (k := k)
        (slashModularForm f g) A w hA := by
  unfold cuspFunctionAtCusp slashedCompOfComplex
  funext z
  simp [slashModularForm_coe, Function.comp, SlashAction.slash_mul]

/-- Transport of local `q`-expansions under slashing by `g`. -/
theorem qExpansionAtCusp_mul_left
    (f : ModularForm Γ k) (g A : SL(2, ℤ)) (w : ℕ) [NeZero w]
    (hA : A * ModularGroup.T ^ (w : ℤ) * A⁻¹ ∈ MulAut.conj g⁻¹ • Γ) :
    qExpansionAtCusp (Γ := Γ) (k := k) f (g * A) w
        (cusp_conj_mem g A w hA) =
      qExpansionAtCusp (Γ := MulAut.conj g⁻¹ • Γ) (k := k)
        (slashModularForm f g) A w hA := by
  rw [qExpansionAtCusp, qExpansionAtCusp, cuspFunctionAtCusp_mul_left]

/-- Transformed-cusp formula in representative language. -/
theorem ordAtCusp_mul_left
    (f : ModularForm Γ k) (g A : SL(2, ℤ)) (w : ℕ) [NeZero w]
    (hA : A * ModularGroup.T ^ (w : ℤ) * A⁻¹ ∈ MulAut.conj g⁻¹ • Γ) :
    ordAtCusp (Γ := Γ) (k := k) f (g * A) w
        (cusp_conj_mem g A w hA) =
      ordAtCusp (Γ := MulAut.conj g⁻¹ • Γ) (k := k)
        (slashModularForm f g) A w hA := by
  rw [ordAtCusp, ordAtCusp, qExpansionAtCusp_mul_left]

private lemma T_mem_gamma0_two :
    ModularGroup.T ∈ CongruenceSubgroup.Gamma0 2 := by
  rw [CongruenceSubgroup.Gamma0_mem]
  simp [ModularGroup.T]

private lemma T_sq_mem_gamma_two :
    ModularGroup.T ^ (2 : ℤ) ∈ CongruenceSubgroup.Gamma 2 := by
  simpa using
    (CongruenceSubgroup.ModularGroup_T_pow_mem_Gamma (N := 2) (M := 2) dvd_rfl)

private lemma S_T_sq_S_inv_mem_gamma0_two :
    ModularGroup.S * (ModularGroup.T ^ (2 : ℤ)) * ModularGroup.S⁻¹ ∈
      CongruenceSubgroup.Gamma0 2 := by
  rw [CongruenceSubgroup.Gamma0_mem]
  native_decide

private lemma S_T_sq_S_inv_mem_gamma_two :
    ModularGroup.S * (ModularGroup.T ^ (2 : ℤ)) * ModularGroup.S⁻¹ ∈
      CongruenceSubgroup.Gamma 2 := by
  rw [CongruenceSubgroup.Gamma_mem]
  native_decide

/-- The `∞` cusp of `Γ(2)` has width `2`. -/
def ordAtCuspInftyGammaTwo
    (f : ModularForm (CongruenceSubgroup.Gamma 2) k) : LocalCuspOrder :=
  ordAtCusp (Γ := CongruenceSubgroup.Gamma 2) (k := k) f 1 2 (by
    simpa using T_sq_mem_gamma_two)

/-- The `0` cusp of `Γ(2)` also has width `2`. -/
def ordAtCuspZeroGammaTwo
    (f : ModularForm (CongruenceSubgroup.Gamma 2) k) : LocalCuspOrder :=
  ordAtCusp (Γ := CongruenceSubgroup.Gamma 2) (k := k) f ModularGroup.S 2
    S_T_sq_S_inv_mem_gamma_two

/-- The `∞` cusp of `Γ₀(2)` has width `1`. -/
def ordAtCuspInftyGamma0Two
    (f : ModularForm (CongruenceSubgroup.Gamma0 2) k) : LocalCuspOrder :=
  ordAtCusp (Γ := CongruenceSubgroup.Gamma0 2) (k := k) f 1 1 (by
    simpa using T_mem_gamma0_two)

/-- The `0` cusp of `Γ₀(2)` has width `2`. -/
def ordAtCuspZeroGamma0Two
    (f : ModularForm (CongruenceSubgroup.Gamma0 2) k) : LocalCuspOrder :=
  ordAtCusp (Γ := CongruenceSubgroup.Gamma0 2) (k := k) f ModularGroup.S 2
    S_T_sq_S_inv_mem_gamma0_two

@[simp] theorem ordAtCuspInftyGammaTwo_width
    (f : ModularForm (CongruenceSubgroup.Gamma 2) k) :
    (ordAtCuspInftyGammaTwo (k := k) f).width = 2 := rfl

@[simp] theorem ordAtCuspZeroGammaTwo_width
    (f : ModularForm (CongruenceSubgroup.Gamma 2) k) :
    (ordAtCuspZeroGammaTwo (k := k) f).width = 2 := rfl

@[simp] theorem ordAtCuspInftyGamma0Two_width
    (f : ModularForm (CongruenceSubgroup.Gamma0 2) k) :
    (ordAtCuspInftyGamma0Two (k := k) f).width = 1 := rfl

@[simp] theorem ordAtCuspZeroGamma0Two_width
    (f : ModularForm (CongruenceSubgroup.Gamma0 2) k) :
    (ordAtCuspZeroGamma0Two (k := k) f).width = 2 := rfl

@[simp] theorem ordAtCuspInftyGammaTwo_order
    (f : ModularForm (CongruenceSubgroup.Gamma 2) k) :
    (ordAtCuspInftyGammaTwo (k := k) f).order = ordAtInfinity 2 f := by
  simp [ordAtCuspInftyGammaTwo, ordAtCusp, qExpansionAtCusp, cuspFunctionAtCusp,
    slashedCompOfComplex, ordAtInfinity, ModularFormClass.qExpansion,
    SlashInvariantFormClass.cuspFunction]

end CuspOrder
