import MathlibExpansion.QExpansionLinearMap

/-!
# Root R3: q-expansion as a linear map

This root file exposes the principal-congruence q-expansion linear-map API from
`MathlibExpansion.QExpansionLinearMap` at the requested `Roots/` path.

Mathlib v4.17.0 defines `ModularFormClass.qExpansion` for principal
congruence subgroups `Γ(n)` and leaves the bundled linear map as a TODO in
`Mathlib/NumberTheory/ModularForms/QExpansion.lean`.  The imported module proves
the additive and scalar compatibility of that scalar q-expansion and bundles it
as `qExpansionLinearMapGamma`.
-/

namespace MathlibExpansion
namespace Roots
namespace QExpansionLinearMap

open MathlibExpansion.QExpansionLinearMap

open scoped MatrixGroups ModularForm Topology

noncomputable section

export MathlibExpansion.QExpansionLinearMap
  (cuspFunction_add_gamma
   cuspFunction_smul_gamma
   qExpansion_add_gamma
   qExpansion_smul_gamma
   qExpansionLinearMapGamma
   cuspform_qExpansion_zeroth_coeff_zero
   cuspFormToModularForm
   sturmTruncationBound
   powerSeriesSturmTruncation
   cuspFormQExpansionSturmTruncationLinearMap
   cuspFormQExpansionSturmTruncation
   QExpansionSturmTruncationInjectiveOnCusp
   cuspform_finiteDim_via_qExpansion_truncation
   cuspform_finiteDim_of_qExpansion_sturm_truncation_injective
   finiteDimensional_cuspForm_gamma_two_weight_two_of_qExpansion_sturm
   finiteDimensional_cuspForm_gamma0_two_weight_two_of_qExpansion_sturm)

/-- Root-facing principal-congruence q-expansion, bundled as a complex-linear
map. -/
def qExpansionLinearMap
    (n : ℕ) (k : ℤ) [NeZero n] :
    ModularForm (CongruenceSubgroup.Gamma n) k →ₗ[ℂ] PowerSeries ℂ :=
  MathlibExpansion.QExpansionLinearMap.qExpansionLinearMapGamma n k

/-- Attempt #3 constructor surface.  `LinearMap.mk₂` is a bilinear constructor,
while q-expansion is unary, so the delivered constructor is the unary linear
map proved in `MathlibExpansion.QExpansionLinearMap`. -/
def qExpansionLinearMapGammaViaUnary
    (n : ℕ) (k : ℤ) [NeZero n] :
    ModularForm (CongruenceSubgroup.Gamma n) k →ₗ[ℂ] PowerSeries ℂ :=
  qExpansionLinearMap n k

/-- Evaluation of the root-facing principal-congruence q-expansion map. -/
theorem qExpansionLinearMapGamma_apply
    (n : ℕ) (k : ℤ) [NeZero n]
    (f : ModularForm (CongruenceSubgroup.Gamma n) k) :
    qExpansionLinearMapGammaViaUnary n k f =
      ModularFormClass.qExpansion n f :=
  rfl

/-- Root-facing additivity theorem for principal-congruence q-expansions. -/
theorem qExpansionLinearMap_add
    (n : ℕ) (k : ℤ) [NeZero n]
    (f g : ModularForm (CongruenceSubgroup.Gamma n) k) :
    qExpansionLinearMap n k (f + g) =
      qExpansionLinearMap n k f + qExpansionLinearMap n k g :=
  MathlibExpansion.QExpansionLinearMap.qExpansion_add_gamma n k f g

/-- Root-facing scalar theorem for principal-congruence q-expansions. -/
theorem qExpansionLinearMap_smul
    (n : ℕ) (k : ℤ) [NeZero n]
    (c : ℂ) (f : ModularForm (CongruenceSubgroup.Gamma n) k) :
    qExpansionLinearMap n k (c • f) =
      c • qExpansionLinearMap n k f :=
  MathlibExpansion.QExpansionLinearMap.qExpansion_smul_gamma n k c f

/-! ### Attempt #15: direct q-expansion linear-map constructor -/

/-- Attempt #15 direct constructor: principal-congruence q-expansion bundled
as a complex-linear map with `toFun f := ModularFormClass.qExpansion n f`. -/
def qExpansionLinearMapGammaDirect
    (n : ℕ) (k : ℤ) [NeZero n] :
    ModularForm (CongruenceSubgroup.Gamma n) k →ₗ[ℂ] PowerSeries ℂ where
  toFun f := ModularFormClass.qExpansion n f
  map_add' f g := qExpansion_add_gamma n k f g
  map_smul' c f := qExpansion_smul_gamma n k c f

/-- Evaluation rule for the Attempt #15 direct constructor. -/
theorem qExpansionLinearMapGammaDirect_apply
    (n : ℕ) (k : ℤ) [NeZero n]
    (f : ModularForm (CongruenceSubgroup.Gamma n) k) :
    qExpansionLinearMapGammaDirect n k f = ModularFormClass.qExpansion n f :=
  rfl

/-- The Attempt #15 direct constructor is pointwise the root-facing q-expansion
linear map. -/
theorem qExpansionLinearMapGammaDirect_eq
    (n : ℕ) (k : ℤ) [NeZero n] :
    qExpansionLinearMapGammaDirect n k = qExpansionLinearMap n k := by
  ext f
  rfl

/-- Injectivity inherited by the Attempt #15 direct constructor. -/
theorem qExpansionLinearMapGammaDirect_injective
    (n : ℕ) (k : ℤ) [NeZero n] :
    Function.Injective (qExpansionLinearMapGammaDirect n k) := by
  rw [qExpansionLinearMapGammaDirect_eq n k]
  exact qExpansionLinearMap_injective n k

/-! ### Attempt #10: build the additive map first -/

/-- Attempt #10 additive layer: Mathlib's principal-level q-expansion bundled
as an additive monoid homomorphism before imposing complex scalar
compatibility. -/
def qExpansionAddMonoidHomGamma
    (n : ℕ) (k : ℤ) [NeZero n] :
    ModularForm (CongruenceSubgroup.Gamma n) k →+ PowerSeries ℂ where
  toFun f := qExpansionLinearMap n k f
  map_zero' := map_zero (qExpansionLinearMap n k)
  map_add' f g := map_add (qExpansionLinearMap n k) f g

/-- Attempt #10 linear map obtained by reusing the additive layer as the
additive layer and then adding scalar compatibility. -/
def qExpansionLinearMapGammaViaAddMonoidHom
    (n : ℕ) (k : ℤ) [NeZero n] :
    ModularForm (CongruenceSubgroup.Gamma n) k →ₗ[ℂ] PowerSeries ℂ where
  toFun f := qExpansionAddMonoidHomGamma n k f
  map_add' f g := map_add (qExpansionAddMonoidHomGamma n k) f g
  map_smul' c f := qExpansion_smul_gamma n k c f

/-- The Attempt #10 linear-map construction agrees pointwise with the requested
additive layer. -/
theorem qExpansionLinearMapGammaViaAddMonoidHom_toAddMonoidHom
    (n : ℕ) (k : ℤ) [NeZero n] :
    ∀ f : ModularForm (CongruenceSubgroup.Gamma n) k,
      qExpansionLinearMapGammaViaAddMonoidHom n k f =
        qExpansionAddMonoidHomGamma n k f := by
  intro f
  rfl

/-- Evaluation of the Attempt #10 additive q-expansion layer. -/
theorem qExpansionAddMonoidHomGamma_apply
    (n : ℕ) (k : ℤ) [NeZero n]
    (f : ModularForm (CongruenceSubgroup.Gamma n) k) :
    qExpansionAddMonoidHomGamma n k f = ModularFormClass.qExpansion n f :=
  rfl

/-- Evaluation of the Attempt #10 linear q-expansion map. -/
theorem qExpansionLinearMapGammaViaAddMonoidHom_apply
    (n : ℕ) (k : ℤ) [NeZero n]
    (f : ModularForm (CongruenceSubgroup.Gamma n) k) :
    qExpansionLinearMapGammaViaAddMonoidHom n k f =
      ModularFormClass.qExpansion n f :=
  rfl

/-- The AddMonoidHom-first construction is extensionally the existing
principal-congruence q-expansion linear map. -/
theorem qExpansionLinearMapGammaViaAddMonoidHom_eq
    (n : ℕ) (k : ℤ) [NeZero n] :
    qExpansionLinearMapGammaViaAddMonoidHom n k = qExpansionLinearMap n k :=
  rfl

/-- Injectivity of the Attempt #10 AddMonoidHom-first linear map. -/
theorem qExpansionLinearMapGammaViaAddMonoidHom_injective
    (n : ℕ) (k : ℤ) [NeZero n] :
    Function.Injective (qExpansionLinearMapGammaViaAddMonoidHom n k) := by
  intro f g hfg
  rw [qExpansionLinearMapGammaViaAddMonoidHom_eq n k] at hfg
  exact qExpansionLinearMap_injective n k hfg

/-- Attempt #7 root-facing additivity identity for Mathlib's principal-level
q-expansion. -/
theorem qExpansion_add
    (n : ℕ) (k : ℤ) [NeZero n]
    (f g : ModularForm (CongruenceSubgroup.Gamma n) k) :
    ModularFormClass.qExpansion n (f + g) =
      ModularFormClass.qExpansion n f + ModularFormClass.qExpansion n g :=
  qExpansion_add_gamma n k f g

/-- Attempt #7 root-facing scalar compatibility identity for Mathlib's
principal-level q-expansion. -/
theorem qExpansion_smul
    (n : ℕ) (k : ℤ) [NeZero n]
    (c : ℂ) (f : ModularForm (CongruenceSubgroup.Gamma n) k) :
    ModularFormClass.qExpansion n (c • f) =
      c • ModularFormClass.qExpansion n f :=
  qExpansion_smul_gamma n k c f

/-- Attempt #7 bundled linear-map additivity, obtained from the linear-map
structure. -/
theorem qExpansionLinearMap_map_add
    (n : ℕ) (k : ℤ) [NeZero n]
    (f g : ModularForm (CongruenceSubgroup.Gamma n) k) :
    qExpansionLinearMap n k (f + g) =
      qExpansionLinearMap n k f + qExpansionLinearMap n k g :=
  LinearMap.map_add (qExpansionLinearMap n k) f g

/-- Attempt #7 bundled linear-map scalar compatibility, obtained from the
linear-map structure. -/
theorem qExpansionLinearMap_map_smul
    (n : ℕ) (k : ℤ) [NeZero n]
    (c : ℂ) (f : ModularForm (CongruenceSubgroup.Gamma n) k) :
    qExpansionLinearMap n k (c • f) =
      c • qExpansionLinearMap n k f :=
  LinearMap.map_smul_of_tower (qExpansionLinearMap n k) c f

/-- Root-facing injectivity of the principal-congruence q-expansion map. -/
theorem qExpansionLinearMap_injective
    (n : ℕ) (k : ℤ) [NeZero n] :
    Function.Injective (qExpansionLinearMap n k) :=
  MathlibExpansion.QExpansionLinearMap.qExpansionLinearMap_injective n k

/-- Injectivity of the Attempt #3 principal-congruence q-expansion map. -/
theorem qExpansionLinearMapGamma_injective
    (n : ℕ) (k : ℤ) [NeZero n] :
    Function.Injective (qExpansionLinearMapGammaViaUnary n k) :=
  MathlibExpansion.QExpansionLinearMap.qExpansionLinearMap_injective n k

/-! ### Attempt #11: `toFun` consequences of q-expansion equality -/

/-- If two principal-congruence modular forms have the same value under the
root-facing q-expansion linear map, their underlying functions are equal. -/
theorem toFun_eq_of_qExpansionLinearMap_eq
    (n : ℕ) (k : ℤ) [NeZero n]
    {f g : ModularForm (CongruenceSubgroup.Gamma n) k}
    (h : qExpansionLinearMap n k f = qExpansionLinearMap n k g) :
    f.toFun = g.toFun := by
  have hfg : f = g := qExpansionLinearMap_injective n k h
  simp [hfg]

/-- Pointwise form of `toFun_eq_of_qExpansionLinearMap_eq`. -/
theorem apply_eq_of_qExpansionLinearMap_eq
    (n : ℕ) (k : ℤ) [NeZero n]
    {f g : ModularForm (CongruenceSubgroup.Gamma n) k}
    (h : qExpansionLinearMap n k f = qExpansionLinearMap n k g)
    (τ : UpperHalfPlane) :
    f τ = g τ := by
  have hfg : f = g := qExpansionLinearMap_injective n k h
  simp [hfg]

/-- Direct q-expansion principle for principal congruence subgroups: if every
coefficient in the q-expansion is zero, then the modular form is zero. -/
theorem eq_zero_of_qExpansion_coeff_zero
    (n : ℕ) (k : ℤ) [NeZero n]
    (f : ModularForm (CongruenceSubgroup.Gamma n) k)
    (hcoeff : ∀ m : ℕ, (qExpansionLinearMap n k f).coeff ℂ m = 0) :
    f = 0 := by
  have hq : qExpansionLinearMap n k f = 0 := by
    apply PowerSeries.ext
    intro m
    simpa using hcoeff m
  exact qExpansionLinearMap_injective n k (by simpa using hq)

/-- Attempt #6 coefficient extensionality for complex power series: if every
coefficient of a power series is zero, then the power series is zero. -/
theorem powerSeries_eq_zero_of_coeff_zero
    (F : PowerSeries ℂ)
    (hcoeff : ∀ m : ℕ, F.coeff ℂ m = 0) :
    F = 0 := by
  apply PowerSeries.ext
  intro m
  simpa using hcoeff m

/-- Attempt #6 principal-congruence q-expansion coefficient-zero criterion,
stated for the root-facing linear map. -/
theorem qExpansionLinearMap_eq_zero_of_coeff_zero
    (n : ℕ) (k : ℤ) [NeZero n]
    (f : ModularForm (CongruenceSubgroup.Gamma n) k)
    (hcoeff : ∀ m : ℕ, (qExpansionLinearMap n k f).coeff ℂ m = 0) :
    f = 0 := by
  have hq : qExpansionLinearMap n k f = 0 :=
    powerSeries_eq_zero_of_coeff_zero (qExpansionLinearMap n k f) hcoeff
  exact qExpansionLinearMap_injective n k (by simpa using hq)

/-- Attempt #6 iff form of the principal-congruence q-expansion
coefficient-zero criterion. -/
theorem qExpansionLinearMap_eq_zero_iff_coeff_zero
    (n : ℕ) (k : ℤ) [NeZero n]
    (f : ModularForm (CongruenceSubgroup.Gamma n) k) :
    f = 0 ↔ ∀ m : ℕ, (qExpansionLinearMap n k f).coeff ℂ m = 0 := by
  constructor
  · intro hf m
    subst f
    simp
  · intro hcoeff
    exact qExpansionLinearMap_eq_zero_of_coeff_zero n k f hcoeff

/-- Attempt #6 coefficientwise equality of principal-congruence q-expansions
implies equality of modular forms. -/
theorem qExpansionLinearMap_eq_of_coeff_eq
    (n : ℕ) (k : ℤ) [NeZero n]
    (f g : ModularForm (CongruenceSubgroup.Gamma n) k)
    (hcoeff : ∀ m : ℕ,
      (qExpansionLinearMap n k f).coeff ℂ m =
        (qExpansionLinearMap n k g).coeff ℂ m) :
    f = g := by
  apply qExpansionLinearMap_injective n k
  apply PowerSeries.ext
  intro m
  exact hcoeff m

/-- Attempt #9 extensionality theorem for the root-facing principal
q-expansion linear map: modular forms for `Γ(n)` are equal when all
q-expansion coefficients agree. -/
theorem qExpansionLinearMap_ext
    (n : ℕ) (k : ℤ) [NeZero n]
    {f g : ModularForm (CongruenceSubgroup.Gamma n) k}
    (hcoeff : ∀ m : ℕ,
      (qExpansionLinearMap n k f).coeff ℂ m =
        (qExpansionLinearMap n k g).coeff ℂ m) :
    f = g :=
  qExpansionLinearMap_eq_of_coeff_eq n k f g hcoeff

/-- Remaining Mathlib boundary: q-expansion linear maps for arbitrary
finite-index congruence subgroups, not only principal `Γ(n)`. -/
def ArbitraryCongruenceSubgroupQExpansionLinearMapGap : Prop :=
  MathlibExpansion.QExpansionLinearMap.ArbitraryFiniteIndexQExpansionGap

/-- Attempt #6 boundary for coefficient-injective q-expansion maps on arbitrary
finite-index congruence subgroups.  The coefficient-extensionality argument
above closes the principal `Γ(n)` case; Mathlib v4.17.0 still lacks the
underlying q-expansion linear map for arbitrary finite-index congruence
subgroups. -/
def qExpansionLinearMap_coeff_injective_gap_for_arbitrary_subgroups : Prop :=
  ArbitraryCongruenceSubgroupQExpansionLinearMapGap

/-- Remaining classical Sturm boundary for the cusp-form truncation map. -/
def ClassicalSturmInjectivityGap : Prop :=
  MathlibExpansion.QExpansionLinearMap.QExpansionSturmTruncationInjectiveOnCusp

/-- Conditional finite-prefix zero criterion from the classical Sturm
injectivity boundary. -/
theorem cuspForm_eq_zero_of_sturmPrefix_coeff_zero
    (hSturm : ClassicalSturmInjectivityGap)
    (N k : ℕ) [NeZero N]
    (f : CuspForm (CongruenceSubgroup.Gamma N) (k : ℤ))
    (hcoeff : ∀ i : Fin (sturmTruncationBound N k + 1),
      cuspFormQExpansionSturmTruncation N k f i = 0) :
    f = 0 := by
  apply hSturm N k
  funext i
  rw [hcoeff i]
  simp [cuspFormQExpansionSturmTruncation]

/-- Direct Attempt #5 statement: vanishing of the q-expansion prefix through
the local Sturm bound forces a cusp form to vanish.  This proposition is
equivalent to `ClassicalSturmInjectivityGap`; it is intentionally kept as a
boundary until Mathlib supplies the corresponding classical Sturm/valence
theorem. -/
def SturmBoundFinitePrefixQExpansionGap : Prop :=
  ∀ (N k : ℕ) [NeZero N],
    ∀ f : CuspForm (CongruenceSubgroup.Gamma N) (k : ℤ),
      (∀ i : Fin (sturmTruncationBound N k + 1),
        cuspFormQExpansionSturmTruncation N k f i = 0) →
      f = 0

/-- The requested finite-prefix zero criterion, conditional on the exact
Attempt #5 Sturm-bound gap. -/
theorem cuspForm_eq_zero_of_sturmBound_coeff_zero_of_gap
    (hSturm : SturmBoundFinitePrefixQExpansionGap)
    (N k : ℕ) [NeZero N]
    (f : CuspForm (CongruenceSubgroup.Gamma N) (k : ℤ))
    (hcoeff : ∀ i : Fin (sturmTruncationBound N k + 1),
      cuspFormQExpansionSturmTruncation N k f i = 0) :
    f = 0 :=
  hSturm N k f hcoeff

/-- The direct finite-prefix zero criterion is exactly the same mathematical
gap as injectivity of the finite q-expansion truncation map. -/
theorem SturmBoundFinitePrefixQExpansionGap_is_classicalSturm :
    SturmBoundFinitePrefixQExpansionGap ↔ ClassicalSturmInjectivityGap := by
  constructor
  · intro hSturm
    intro N k hN f g hfg
    have hzero :
        (cuspFormQExpansionSturmTruncationLinearMap N k) (f - g) = 0 := by
      rw [map_sub]
      exact sub_eq_zero.mpr hfg
    have hsub : f - g = 0 := by
      exact hSturm N k (f - g) (fun i => congrFun hzero i)
    exact sub_eq_zero.mp hsub
  · intro hSturm
    intro N k hN f hcoeff
    exact cuspForm_eq_zero_of_sturmPrefix_coeff_zero hSturm N k f hcoeff

/-! ### Attempt #13: order-vanishing induction boundary -/

/-- Attempt #13 packages the proposed induction on q-expansion order with
Sturm-bound termination as the same remaining classical injectivity statement.
The local files do not contain a theorem proving the required termination
bound, so this is a named boundary rather than an asserted proof. -/
def SturmInductionOrderVanishingGap : Prop :=
  ClassicalSturmInjectivityGap

/-- The Attempt #13 induction-on-order formulation is equivalent to the
finite-prefix Sturm q-expansion formulation already isolated in this file. -/
theorem SturmInductionOrderVanishingGap_iff_finitePrefix :
    SturmInductionOrderVanishingGap ↔ SturmBoundFinitePrefixQExpansionGap := by
  unfold SturmInductionOrderVanishingGap
  exact SturmBoundFinitePrefixQExpansionGap_is_classicalSturm.symm

/-- The Attempt #13 induction-on-order boundary gives the same finite-prefix
zero criterion: if all coefficients up to the local Sturm bound vanish, then
the cusp form vanishes. -/
theorem cuspForm_eq_zero_of_sturmInductionOrderVanishingGap
    (hSturm : SturmInductionOrderVanishingGap)
    (N k : ℕ) [NeZero N]
    (f : CuspForm (CongruenceSubgroup.Gamma N) (k : ℤ))
    (hcoeff : ∀ i : Fin (sturmTruncationBound N k + 1),
      cuspFormQExpansionSturmTruncation N k f i = 0) :
    f = 0 :=
  cuspForm_eq_zero_of_sturmPrefix_coeff_zero hSturm N k f hcoeff

/- The missing close of Attempt #13 is the classical theorem that finite
q-expansion prefix vanishing through a valid Sturm bound terminates order
induction for `CuspForm (CongruenceSubgroup.Gamma N) k`. -/

/-! ### Attempt #11: cusp-form constant coefficient at the Sturm boundary -/

/-- Attempt #11 root-facing coefficient-zero theorem for cusp forms, stated
through the principal q-expansion linear map rather than the scalar
`ModularFormClass.qExpansion`. -/
theorem cuspForm_qExpansionLinearMap_coeff_zero_zero
    (N k : ℕ) [NeZero N]
    (f : CuspForm (CongruenceSubgroup.Gamma N) (k : ℤ)) :
    (qExpansionLinearMap N (k : ℤ)
      (cuspFormToModularForm (CongruenceSubgroup.Gamma N) (k : ℤ) f)).coeff ℂ 0 = 0 :=
  cuspform_qExpansion_zeroth_coeff_zero N (k : ℤ) f

/-- Attempt #11: the index-zero coordinate of the local Sturm truncation of a
principal-level cusp form vanishes unconditionally.  Full finite-prefix
injectivity remains the classical Sturm boundary named above, but the constant
term in that prefix is already closed by Mathlib's cusp-form API. -/
theorem cuspFormQExpansionSturmTruncation_zero_index
    (N k : ℕ) [NeZero N]
    (f : CuspForm (CongruenceSubgroup.Gamma N) (k : ℤ)) :
    cuspFormQExpansionSturmTruncation N k f ⟨0, Nat.succ_pos _⟩ = 0 :=
  cuspform_qExpansion_zeroth_coeff_zero N (k : ℤ) f

/-! ### Attempt #14: coefficient functionals as dual linear maps -/

/-- Attempt #14: the `m`th q-expansion coefficient, bundled as a dual vector
for principal congruence modular forms. -/
def qExpansionCoeffFunctionalGamma
    (n : ℕ) (k : ℤ) [NeZero n] (m : ℕ) :
    ModularForm (CongruenceSubgroup.Gamma n) k →ₗ[ℂ] ℂ :=
  (PowerSeries.coeff ℂ m).comp (qExpansionLinearMap n k)

/-- Evaluation rule for the Attempt #14 coefficient functional. -/
theorem qExpansionCoeffFunctionalGamma_apply
    (n : ℕ) (k : ℤ) [NeZero n] (m : ℕ)
    (f : ModularForm (CongruenceSubgroup.Gamma n) k) :
    qExpansionCoeffFunctionalGamma n k m f =
      (ModularFormClass.qExpansion n f).coeff ℂ m :=
  rfl

/-- Additivity of the Attempt #14 coefficient functional. -/
theorem qExpansionCoeffFunctionalGamma_add
    (n : ℕ) (k : ℤ) [NeZero n] (m : ℕ)
    (f g : ModularForm (CongruenceSubgroup.Gamma n) k) :
    qExpansionCoeffFunctionalGamma n k m (f + g) =
      qExpansionCoeffFunctionalGamma n k m f +
        qExpansionCoeffFunctionalGamma n k m g :=
  LinearMap.map_add (qExpansionCoeffFunctionalGamma n k m) f g

/-- Scalar compatibility of the Attempt #14 coefficient functional. -/
theorem qExpansionCoeffFunctionalGamma_smul
    (n : ℕ) (k : ℤ) [NeZero n] (m : ℕ)
    (c : ℂ) (f : ModularForm (CongruenceSubgroup.Gamma n) k) :
    qExpansionCoeffFunctionalGamma n k m (c • f) =
      c • qExpansionCoeffFunctionalGamma n k m f :=
  LinearMap.map_smul_of_tower (qExpansionCoeffFunctionalGamma n k m) c f

/-- Attempt #14 boundary: coefficient functionals for arbitrary finite-index
congruence subgroups require Mathlib's missing arbitrary-subgroup q-expansion
linear map. -/
def ArbitraryCongruenceSubgroupQExpansionCoeffFunctionalGap : Prop :=
  ArbitraryCongruenceSubgroupQExpansionLinearMapGap

/-! ### Attempt #8: `Γ₀(2)`, weight-two q-expansion linear map -/

/-- Boundary isolated by Attempt #8: Mathlib's direct `Γ₀(2)` q-expansion term
typechecks, but the coefficient and analyticity lemmas still require the
principal `Γ(2)` `ModularFormClass` instance. -/
def Gamma0TwoWeightTwoDirectQExpansionCoefficientAPIGap : Prop :=
  True

/-- Attempt #8 specialized q-expansion bundled as a complex-linear map for
`Γ₀(2)` and weight `2`, obtained by restriction to the principal subgroup
`Γ(2)` and the proven principal-level q-expansion linear map. -/
def qExpansionLinearMapGamma0TwoWeightTwo :
    ModularForm (CongruenceSubgroup.Gamma0 2) (2 : ℤ) →ₗ[ℂ] PowerSeries ℂ :=
  (qExpansionLinearMap 2 (2 : ℤ)).comp
    (MathlibExpansion.RiemannRochBridge.restrictGamma0ToGamma2 2)

/-- The restricted `Γ₀(2)`, weight-two linear map evaluates to the principal
q-expansion of the restricted modular form. -/
theorem qExpansionLinearMapGamma0TwoWeightTwo_apply
    (f : ModularForm (CongruenceSubgroup.Gamma0 2) (2 : ℤ)) :
    qExpansionLinearMapGamma0TwoWeightTwo f =
      ModularFormClass.qExpansion 2
        (MathlibExpansion.RiemannRochBridge.restrictGamma0ToGamma2 2 f) :=
  rfl

/-- Additivity of the specialized restricted `Γ₀(2)`, weight-two q-expansion
linear map. -/
theorem qExpansionLinearMapGamma0TwoWeightTwo_add
    (f g : ModularForm (CongruenceSubgroup.Gamma0 2) (2 : ℤ)) :
    qExpansionLinearMapGamma0TwoWeightTwo (f + g) =
      qExpansionLinearMapGamma0TwoWeightTwo f +
        qExpansionLinearMapGamma0TwoWeightTwo g :=
  LinearMap.map_add qExpansionLinearMapGamma0TwoWeightTwo f g

/-- Scalar compatibility of the specialized restricted `Γ₀(2)`, weight-two
q-expansion linear map. -/
theorem qExpansionLinearMapGamma0TwoWeightTwo_smul
    (c : ℂ) (f : ModularForm (CongruenceSubgroup.Gamma0 2) (2 : ℤ)) :
    qExpansionLinearMapGamma0TwoWeightTwo (c • f) =
      c • qExpansionLinearMapGamma0TwoWeightTwo f :=
  LinearMap.map_smul_of_tower qExpansionLinearMapGamma0TwoWeightTwo c f

#check @qExpansion_add_gamma
#check @qExpansion_smul_gamma
#check @qExpansionLinearMapGamma
#check @qExpansionLinearMap
#check @qExpansionLinearMapGammaViaUnary
#check @qExpansionLinearMapGamma_apply
#check @qExpansionLinearMap_add
#check @qExpansionLinearMap_smul
#check @qExpansionLinearMapGammaDirect
#check @qExpansionLinearMapGammaDirect_apply
#check @qExpansionLinearMapGammaDirect_eq
#check @qExpansionLinearMapGammaDirect_injective
#check @qExpansionAddMonoidHomGamma
#check @qExpansionLinearMapGammaViaAddMonoidHom
#check @qExpansionLinearMapGammaViaAddMonoidHom_toAddMonoidHom
#check @qExpansionAddMonoidHomGamma_apply
#check @qExpansionLinearMapGammaViaAddMonoidHom_apply
#check @qExpansionLinearMapGammaViaAddMonoidHom_eq
#check @qExpansionLinearMapGammaViaAddMonoidHom_injective
#check @qExpansionLinearMapGamma_injective
#check @qExpansionLinearMap_injective
#check @toFun_eq_of_qExpansionLinearMap_eq
#check @apply_eq_of_qExpansionLinearMap_eq
#check @eq_zero_of_qExpansion_coeff_zero
#check @powerSeries_eq_zero_of_coeff_zero
#check @qExpansionLinearMap_eq_zero_of_coeff_zero
#check @qExpansionLinearMap_eq_zero_iff_coeff_zero
#check @qExpansionLinearMap_eq_of_coeff_eq
#check @qExpansionLinearMap_ext
#check @QExpansionSturmTruncationInjectiveOnCusp
#check ArbitraryCongruenceSubgroupQExpansionLinearMapGap
#check qExpansionLinearMap_coeff_injective_gap_for_arbitrary_subgroups
#check ClassicalSturmInjectivityGap
#check cuspForm_eq_zero_of_sturmPrefix_coeff_zero
#check SturmBoundFinitePrefixQExpansionGap
#check cuspForm_eq_zero_of_sturmBound_coeff_zero_of_gap
#check SturmBoundFinitePrefixQExpansionGap_is_classicalSturm
#check SturmInductionOrderVanishingGap
#check SturmInductionOrderVanishingGap_iff_finitePrefix
#check @cuspForm_eq_zero_of_sturmInductionOrderVanishingGap
#check @cuspForm_qExpansionLinearMap_coeff_zero_zero
#check @cuspFormQExpansionSturmTruncation_zero_index
#check @qExpansionCoeffFunctionalGamma
#check @qExpansionCoeffFunctionalGamma_apply
#check @qExpansionCoeffFunctionalGamma_add
#check @qExpansionCoeffFunctionalGamma_smul
#check ArbitraryCongruenceSubgroupQExpansionCoeffFunctionalGap
#check Gamma0TwoWeightTwoDirectQExpansionCoefficientAPIGap
#check qExpansionLinearMapGamma0TwoWeightTwo
#check @qExpansionLinearMapGamma0TwoWeightTwo_apply
#check @qExpansionLinearMapGamma0TwoWeightTwo_add
#check @qExpansionLinearMapGamma0TwoWeightTwo_smul

end
end QExpansionLinearMap
end Roots
end MathlibExpansion
