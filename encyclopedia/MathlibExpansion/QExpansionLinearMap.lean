import MathlibExpansion.UnconditionalRR

/-!
# Q-expansion linear map path

This file records the Session 26 q-expansion path toward finite-dimensionality
of cusp-form spaces.

Mathlib 4.17 defines `ModularFormClass.qExpansion` only for principal
congruence subgroups `Γ(n)` and leaves the bundled linear map as a TODO in
`Mathlib/NumberTheory/ModularForms/QExpansion.lean`.  The earlier Session 26
attempt incorrectly filled the missing linearity, injectivity, and Sturm
truncation results with placeholders.  This replacement keeps the proved local
surface and names the exact remaining propositions without asserting them.
-/

namespace MathlibExpansion
namespace QExpansionLinearMap

open MathlibExpansion.RiemannRochBridge
open Filter
open scoped MatrixGroups ModularForm Topology

noncomputable section

/-! ### Mathlib 4.17 gap markers -/

/-- Mathlib 4.17 only defines q-expansions for `Γ(n)`, not for arbitrary
finite-index congruence subgroups. -/
def ArbitraryFiniteIndexQExpansionGap : Prop :=
  True

/-! ### Principal-level q-expansion linearity -/

/-- The principal-level cusp function preserves addition.  The only nontrivial
point is `q = 0`, where Mathlib's periodic cusp function is defined by
`limUnder`; analytic continuity supplies the required limiting value. -/
lemma cuspFunction_add_gamma
    (n : ℕ) (k : ℤ) [NeZero n]
    (f g : ModularForm (CongruenceSubgroup.Gamma n) k) :
    SlashInvariantFormClass.cuspFunction n (f + g) =
      SlashInvariantFormClass.cuspFunction n f +
        SlashInvariantFormClass.cuspFunction n g := by
  funext q
  change SlashInvariantFormClass.cuspFunction n (f + g) q =
    SlashInvariantFormClass.cuspFunction n f q +
      SlashInvariantFormClass.cuspFunction n g q
  by_cases hq : q = 0
  · subst q
    have hfcont :=
      (ModularFormClass.analyticAt_cuspFunction_zero n f).continuousAt.tendsto
    have hgcont :=
      (ModularFormClass.analyticAt_cuspFunction_zero n g).continuousAt.tendsto
    have hsum : Tendsto
        (fun q => SlashInvariantFormClass.cuspFunction n f q +
          SlashInvariantFormClass.cuspFunction n g q)
        (𝓝[≠] (0 : ℂ))
        (𝓝 (SlashInvariantFormClass.cuspFunction n f 0 +
          SlashInvariantFormClass.cuspFunction n g 0)) := by
      exact (tendsto_nhdsWithin_of_tendsto_nhds hfcont).add
        (tendsto_nhdsWithin_of_tendsto_nhds hgcont)
    have hcongr :
        SlashInvariantFormClass.cuspFunction n (f + g) =ᶠ[𝓝[≠] (0 : ℂ)]
          fun q => SlashInvariantFormClass.cuspFunction n f q +
            SlashInvariantFormClass.cuspFunction n g q := by
      filter_upwards [self_mem_nhdsWithin] with q hq
      simp only [Set.mem_compl_iff, Set.mem_singleton_iff] at hq
      simp [SlashInvariantFormClass.cuspFunction,
        Function.Periodic.cuspFunction_eq_of_nonzero, hq]
    have hlim : Tendsto
        (SlashInvariantFormClass.cuspFunction n (f + g))
        (𝓝[≠] (0 : ℂ))
        (𝓝 (SlashInvariantFormClass.cuspFunction n f 0 +
          SlashInvariantFormClass.cuspFunction n g 0)) :=
      hsum.congr' hcongr.symm
    change
      Function.Periodic.cuspFunction (n : ℝ)
        (⇑(f + g) ∘ ↑UpperHalfPlane.ofComplex) 0 =
      SlashInvariantFormClass.cuspFunction n f 0 +
        SlashInvariantFormClass.cuspFunction n g 0
    rw [Function.Periodic.cuspFunction_zero_eq_limUnder_nhds_ne]
    exact hlim.limUnder_eq
  · simp [SlashInvariantFormClass.cuspFunction,
      Function.Periodic.cuspFunction_eq_of_nonzero, hq]

/-- The principal-level cusp function preserves scalar multiplication. -/
lemma cuspFunction_smul_gamma
    (n : ℕ) (k : ℤ) [NeZero n]
    (c : ℂ) (f : ModularForm (CongruenceSubgroup.Gamma n) k) :
    SlashInvariantFormClass.cuspFunction n (c • f) =
      c • SlashInvariantFormClass.cuspFunction n f := by
  funext q
  change SlashInvariantFormClass.cuspFunction n (c • f) q =
    c • SlashInvariantFormClass.cuspFunction n f q
  by_cases hq : q = 0
  · subst q
    have hfcont :=
      (ModularFormClass.analyticAt_cuspFunction_zero n f).continuousAt.tendsto
    have hsmul : Tendsto
        (fun q => c • SlashInvariantFormClass.cuspFunction n f q)
        (𝓝[≠] (0 : ℂ))
        (𝓝 (c • SlashInvariantFormClass.cuspFunction n f 0)) := by
      exact (tendsto_nhdsWithin_of_tendsto_nhds hfcont).const_smul c
    have hcongr :
        SlashInvariantFormClass.cuspFunction n (c • f) =ᶠ[𝓝[≠] (0 : ℂ)]
          fun q => c • SlashInvariantFormClass.cuspFunction n f q := by
      filter_upwards [self_mem_nhdsWithin] with q hq
      simp only [Set.mem_compl_iff, Set.mem_singleton_iff] at hq
      simp [SlashInvariantFormClass.cuspFunction,
        Function.Periodic.cuspFunction_eq_of_nonzero, hq]
    have hlim : Tendsto
        (SlashInvariantFormClass.cuspFunction n (c • f))
        (𝓝[≠] (0 : ℂ))
        (𝓝 (c • SlashInvariantFormClass.cuspFunction n f 0)) :=
      hsmul.congr' hcongr.symm
    change
      Function.Periodic.cuspFunction (n : ℝ)
        (⇑(c • f) ∘ ↑UpperHalfPlane.ofComplex) 0 =
      c • SlashInvariantFormClass.cuspFunction n f 0
    rw [Function.Periodic.cuspFunction_zero_eq_limUnder_nhds_ne]
    exact hlim.limUnder_eq
  · simp [SlashInvariantFormClass.cuspFunction,
      Function.Periodic.cuspFunction_eq_of_nonzero, hq]

/-- Additivity of Mathlib's principal-level q-expansion. -/
theorem qExpansion_add_gamma
    (n : ℕ) (k : ℤ) [NeZero n]
    (f g : ModularForm (CongruenceSubgroup.Gamma n) k) :
    ModularFormClass.qExpansion n (f + g) =
      ModularFormClass.qExpansion n f + ModularFormClass.qExpansion n g := by
  apply PowerSeries.ext
  intro m
  simp only [ModularFormClass.qExpansion_coeff, map_add]
  rw [cuspFunction_add_gamma n k f g]
  rw [iteratedDeriv_add]
  ring
  · exact (ModularFormClass.analyticAt_cuspFunction_zero n f).contDiffAt
  · exact (ModularFormClass.analyticAt_cuspFunction_zero n g).contDiffAt

/-- Scalar compatibility of Mathlib's principal-level q-expansion. -/
theorem qExpansion_smul_gamma
    (n : ℕ) (k : ℤ) [NeZero n]
    (c : ℂ) (f : ModularForm (CongruenceSubgroup.Gamma n) k) :
    ModularFormClass.qExpansion n (c • f) =
      c • ModularFormClass.qExpansion n f := by
  apply PowerSeries.ext
  intro m
  simp only [ModularFormClass.qExpansion_coeff, PowerSeries.coeff_smul]
  rw [cuspFunction_smul_gamma n k c f]
  rw [iteratedDeriv_const_smul
    ((ModularFormClass.analyticAt_cuspFunction_zero n f).contDiffAt) c]
  simp [smul_eq_mul, mul_assoc, mul_left_comm, mul_comm]

/-- **Q1.** Principal-level q-expansion bundled as a linear map. -/
def qExpansionLinearMapGamma
    (n : ℕ) (k : ℤ) [NeZero n] :
    ModularForm (CongruenceSubgroup.Gamma n) k →ₗ[ℂ] PowerSeries ℂ where
  toFun f := ModularFormClass.qExpansion n f
  map_add' f g := qExpansion_add_gamma n k f g
  map_smul' c f := qExpansion_smul_gamma n k c f

/-- **Q2.** Principal-level q-expansion injectivity. -/
theorem qExpansionLinearMap_injective
    (n : ℕ) (k : ℤ) [NeZero n] :
    Function.Injective (qExpansionLinearMapGamma n k) := by
  intro f g hfg
  exact qExpansion_injective_gamma n k hfg

/-! ### Cusp-form constant coefficient -/

/-- **Q3.** The constant coefficient of the q-expansion of a principal-level
cusp form is zero.  This is already available from Mathlib's
`CuspFormClass.cuspFunction_apply_zero`. -/
theorem cuspform_qExpansion_zeroth_coeff_zero
    (n : ℕ) (k : ℤ) [NeZero n]
    (f : CuspForm (CongruenceSubgroup.Gamma n) k) :
    (ModularFormClass.qExpansion n f).coeff ℂ 0 = 0 := by
  rw [ModularFormClass.qExpansion_coeff]
  simp [CuspFormClass.cuspFunction_apply_zero]

/-! ### Sturm truncation path targets -/

/-! The finite-dimensionality argument needs a linear map out of cusp forms.
Mathlib 4.17 has a `CuspFormClass -> ModularFormClass` instance but no bundled
linear coercion between the concrete structures, so we provide the local one. -/

/-- A cusp form is a modular form, bundled as a linear map. -/
def cuspFormToModularForm
    (Γ : Subgroup SL(2, ℤ)) (k : ℤ) :
    CuspForm Γ k →ₗ[ℂ] ModularForm Γ k where
  toFun f :=
    { toSlashInvariantForm := f.toSlashInvariantForm
      holo' := f.holo'
      bdd_at_infty' := fun A => (f.zero_at_infty' A).boundedAtFilter }
  map_add' f g := by
    ext z
    rfl
  map_smul' c f := by
    ext z
    rfl

/-- Placeholder arithmetic size for the finite q-expansion target.  A future
classical Sturm theorem would replace this placeholder with the true all-level
bound and its proof. -/
def sturmTruncationBound (N k : ℕ) : ℕ :=
  k * (N + 1) / 12

/-- Truncate a power series to a finite coefficient prefix. -/
def powerSeriesSturmTruncation (B : ℕ) :
    PowerSeries ℂ →ₗ[ℂ] (Fin (B + 1) → ℂ) where
  toFun f := fun i => (PowerSeries.coeff ℂ i.1) f
  map_add' f g := by
    funext i
    exact LinearMap.map_add (PowerSeries.coeff ℂ i.1) f g
  map_smul' c f := by
    funext i
    exact LinearMap.map_smul_of_tower (PowerSeries.coeff ℂ i.1) c f

/-- **Q4.** Finite prefix of the principal-level cusp-form q-expansion,
bundled as a linear map. -/
def cuspFormQExpansionSturmTruncationLinearMap (N k : ℕ) [NeZero N] :
    CuspForm (CongruenceSubgroup.Gamma N) (k : ℤ) →ₗ[ℂ]
      (Fin (sturmTruncationBound N k + 1) → ℂ) :=
  (powerSeriesSturmTruncation (sturmTruncationBound N k)).comp
    ((qExpansionLinearMapGamma N (k : ℤ)).comp
      (cuspFormToModularForm (CongruenceSubgroup.Gamma N) (k : ℤ)))

/-- Function form of `cuspFormQExpansionSturmTruncationLinearMap`. -/
def cuspFormQExpansionSturmTruncation (N k : ℕ) [NeZero N] :
    CuspForm (CongruenceSubgroup.Gamma N) (k : ℤ) →
      (Fin (sturmTruncationBound N k + 1) → ℂ) :=
  cuspFormQExpansionSturmTruncationLinearMap N k

/-- Classical Sturm injectivity target for the local finite q-expansion
prefix.  This remains a named proposition, not an asserted theorem. -/
def QExpansionSturmTruncationInjectiveOnCusp : Prop :=
  ∀ (N k : ℕ) [NeZero N],
    Function.Injective (cuspFormQExpansionSturmTruncation N k)

/-- **Q5.** Finite-dimensionality follows from injectivity of the finite
q-expansion truncation map into the finite function space. -/
theorem cuspform_finiteDim_via_qExpansion_truncation
    (N k : ℕ) [NeZero N]
    (h : Function.Injective (cuspFormQExpansionSturmTruncationLinearMap N k)) :
    FiniteDimensional ℂ (CuspForm (CongruenceSubgroup.Gamma N) (k : ℤ)) :=
  FiniteDimensional.of_injective
    (cuspFormQExpansionSturmTruncationLinearMap N k) h

/-- All-principal-level finite-dimensionality target supplied by the classical
Sturm truncation theorem. -/
theorem cuspform_finiteDim_of_qExpansion_sturm_truncation_injective
    (h : QExpansionSturmTruncationInjectiveOnCusp)
    (N k : ℕ) [NeZero N] :
    FiniteDimensional ℂ (CuspForm (CongruenceSubgroup.Gamma N) (k : ℤ)) :=
  cuspform_finiteDim_via_qExpansion_truncation N k (h N k)

/-- **Q6.** The principal-level `(Γ(2), 2)` closure from the named Sturm
truncation target. -/
theorem finiteDimensional_cuspForm_gamma_two_weight_two_of_qExpansion_sturm
    (h : QExpansionSturmTruncationInjectiveOnCusp) :
    FiniteDimensional ℂ (CuspForm (CongruenceSubgroup.Gamma 2) 2) :=
  cuspform_finiteDim_of_qExpansion_sturm_truncation_injective h 2 2

/-- **Q6.** The requested `Γ₀(2)`, weight-two closure from the named Sturm
truncation target for principal levels.  The transfer uses the existing
injective restriction `Γ₀(2) -> Γ(2)`. -/
theorem finiteDimensional_cuspForm_gamma0_two_weight_two_of_qExpansion_sturm
    (h : QExpansionSturmTruncationInjectiveOnCusp) :
    FiniteDimensional ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) := by
  haveI : FiniteDimensional ℂ (CuspForm (CongruenceSubgroup.Gamma 2) 2) :=
    finiteDimensional_cuspForm_gamma_two_weight_two_of_qExpansion_sturm h
  exact FiniteDimensional.of_injective
    (restrictCuspFormGamma0ToGamma2 2)
    (restrictCuspFormGamma0ToGamma2_injective 2)

#check @qExpansion_add_gamma
#check @qExpansion_smul_gamma
#check @qExpansionLinearMapGamma
#check @qExpansionLinearMap_injective
#check @cuspform_qExpansion_zeroth_coeff_zero
#check @cuspFormToModularForm
#check @powerSeriesSturmTruncation
#check @cuspFormQExpansionSturmTruncationLinearMap
#check @cuspFormQExpansionSturmTruncation
#check @QExpansionSturmTruncationInjectiveOnCusp
#check @cuspform_finiteDim_via_qExpansion_truncation
#check @cuspform_finiteDim_of_qExpansion_sturm_truncation_injective
#check @finiteDimensional_cuspForm_gamma_two_weight_two_of_qExpansion_sturm
#check @finiteDimensional_cuspForm_gamma0_two_weight_two_of_qExpansion_sturm

end
end QExpansionLinearMap
end MathlibExpansion
