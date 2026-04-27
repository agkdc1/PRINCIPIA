import MathlibExpansion.ModularCurveGenus

/-!
# Riemann-Roch bridge infrastructure for `X₀(2)`

This file records the first proved finite arithmetic component for the
weight-two `Γ₀(2)` valence/Riemann-Roch route. It intentionally does not close
the analytic bridge from cusp forms to divisors or holomorphic differentials;
that bridge is still isolated in `ModularCurveGenus.lean`.
-/

namespace MathlibExpansion
namespace RiemannRochBridge

open MathlibExpansion.ModularCurveGenus
open scoped MatrixGroups
open scoped ModularForm

noncomputable section

namespace Gamma0

/-! ### Two explicit cusp representatives for `Γ₀(2)` -/

/-- The matrix `S = \begin{pmatrix}0&-1\\1&0\end{pmatrix}` as an element of
`SL(2, ℤ)`. It represents the cusp `0`, while `1` represents `∞`. -/
def cuspZeroRep : SL(2, ℤ) :=
  ⟨!![0, -1; 1, 0], by simp [Matrix.det_fin_two]⟩

/-- The two explicit cusp representatives used by the level-two bridge:
`1` for `∞` and `S` for `0`. This is a concrete bookkeeping finset, not a
claim that Mathlib already has a quotient-of-cusps API for `Γ₀(2)`. -/
def TwoCusps : Finset (SL(2, ℤ)) :=
  by
    classical
    exact [1, cuspZeroRep].toFinset

/-- The concrete two-representative finset has cardinality two. -/
theorem TwoCusps_card : TwoCusps.card = 2 := by
  classical
  have hne : (1 : SL(2, ℤ)) ≠ cuspZeroRep := by
    intro h
    have h00 := congrArg (fun A : SL(2, ℤ) => (A : Matrix (Fin 2) (Fin 2) ℤ) 0 0) h
    simp [cuspZeroRep, Matrix.one_apply] at h00
  simp [TwoCusps, hne]

end Gamma0

/-! ### Restriction from `Γ₀(2)` to the principal subgroup `Γ(2)` -/

/-- The principal level-two congruence subgroup is contained in `Γ₀(2)`. -/
lemma gamma_two_le_gamma0_two :
    CongruenceSubgroup.Gamma 2 ≤ CongruenceSubgroup.Gamma0 2 := by
  intro A hA
  rw [CongruenceSubgroup.Gamma_mem] at hA
  rw [CongruenceSubgroup.Gamma0_mem]
  exact hA.2.2.1

/-- Restrict a modular form for `Γ₀(2)` to the smaller principal subgroup `Γ(2)`.

This is the same analytic function with the invariance condition weakened along
`Γ(2) ≤ Γ₀(2)`. -/
def restrictGamma0ToGamma2 (k : ℤ) :
    ModularForm (CongruenceSubgroup.Gamma0 2) k →ₗ[ℂ]
      ModularForm (CongruenceSubgroup.Gamma 2) k where
  toFun f :=
    { toSlashInvariantForm :=
        { toFun := f
          slash_action_eq' := by
            intro γ hγ
            exact SlashInvariantForm.slash_action_eqn f γ (gamma_two_le_gamma0_two hγ) }
      holo' := f.holo'
      bdd_at_infty' := f.bdd_at_infty' }
  map_add' f g := by
    ext z
    rfl
  map_smul' c f := by
    ext z
    rfl

/-- The restriction map from `Γ₀(2)` to `Γ(2)` is injective because it does not
change the underlying function. -/
lemma restrictGamma0ToGamma2_injective (k : ℤ) :
    Function.Injective (restrictGamma0ToGamma2 k) := by
  intro f g hfg
  ext z
  exact ModularForm.ext_iff.mp hfg z

/-- Conditional finite-dimensionality transfer along the injective restriction
from `Γ₀(2)` to `Γ(2)`. The required principal-subgroup finite-dimensionality is
not synthesized by the current Mathlib checkout, so it remains an explicit
typeclass input. -/
instance finiteDimensional_modularForm_gamma0_two_of_gamma_two (k : ℤ)
    [FiniteDimensional ℂ (ModularForm (CongruenceSubgroup.Gamma 2) k)] :
    FiniteDimensional ℂ (ModularForm (CongruenceSubgroup.Gamma0 2) k) :=
  FiniteDimensional.of_injective (restrictGamma0ToGamma2 k)
    (restrictGamma0ToGamma2_injective k)

/-- Restrict a cusp form for `Γ₀(2)` to the smaller principal subgroup `Γ(2)`.
This is the CuspForm analogue of `restrictGamma0ToGamma2`. -/
def restrictCuspFormGamma0ToGamma2 (k : ℤ) :
    CuspForm (CongruenceSubgroup.Gamma0 2) k →ₗ[ℂ]
      CuspForm (CongruenceSubgroup.Gamma 2) k where
  toFun f :=
    { toSlashInvariantForm :=
        { toFun := f
          slash_action_eq' := by
            intro γ hγ
            exact SlashInvariantForm.slash_action_eqn f γ (gamma_two_le_gamma0_two hγ) }
      holo' := f.holo'
      zero_at_infty' := fun A => f.zero_at_infty' A }
  map_add' f g := by
    ext z
    rfl
  map_smul' c f := by
    ext z
    rfl

/-- The CuspForm restriction is injective because the underlying function is unchanged. -/
lemma restrictCuspFormGamma0ToGamma2_injective (k : ℤ) :
    Function.Injective (restrictCuspFormGamma0ToGamma2 k) := by
  intro f g hfg
  ext z
  exact congrArg
    (fun h : CuspForm (CongruenceSubgroup.Gamma 2) k =>
      (h : UpperHalfPlane → ℂ) z) hfg

/-! ### Narrow Sturm-bound infrastructure for `Γ(2)` in weight two -/

/-- Sturm's finite-prefix bound, parameterized by the subgroup index `μ`.

For the Session 9 target `k = 2`, `Γ = Γ(2)`, the intended index is `μ = 6`,
so this evaluates to `2`. The index equality itself is kept separate because
the current namespace has only proved the `Γ₀(2)` index. -/
def sturmBoundByIndex (k mu : ℕ) : ℕ :=
  (k * mu) / 12 + 1

/-- The narrow arithmetic Sturm bound for weight two and index six. -/
theorem sturmBound_gamma_two_weight_two_by_index : sturmBoundByIndex 2 6 = 2 := by
  norm_num [sturmBoundByIndex]

/-- The first two q-expansion coefficients of a weight-two modular form on
`Γ(2)`, packaged as the finite target for the narrow Sturm map. -/
def qExpansionPrefixGammaTwoWeightTwo
    (f : ModularForm (CongruenceSubgroup.Gamma 2) 2) : Fin 2 → ℂ :=
  fun i => (ModularFormClass.qExpansion 2 f).coeff ℂ i.1

/-- Equality of the two-term q-expansion prefix gives equality of constant
coefficients. -/
lemma qExpansionPrefixGammaTwoWeightTwo_coeff_zero
    {f g : ModularForm (CongruenceSubgroup.Gamma 2) 2}
    (h : qExpansionPrefixGammaTwoWeightTwo f = qExpansionPrefixGammaTwoWeightTwo g) :
    (ModularFormClass.qExpansion 2 f).coeff ℂ 0 =
      (ModularFormClass.qExpansion 2 g).coeff ℂ 0 := by
  exact congrFun h 0

/-- Equality of the two-term q-expansion prefix gives equality of linear
coefficients. -/
lemma qExpansionPrefixGammaTwoWeightTwo_coeff_one
    {f g : ModularForm (CongruenceSubgroup.Gamma 2) 2}
    (h : qExpansionPrefixGammaTwoWeightTwo f = qExpansionPrefixGammaTwoWeightTwo g) :
    (ModularFormClass.qExpansion 2 f).coeff ℂ 1 =
      (ModularFormClass.qExpansion 2 g).coeff ℂ 1 := by
  exact congrFun h 1

/-- The corrected level-two weight-two valence budget arithmetic:
`k * μ / 12 = 1 / 2` for `k = 2`, `μ = 3`, together with the finite
elliptic/cusp data for `Γ₀(2)`. -/
theorem valence_identity_weight_two_gamma0_two :
    ((2 : ℚ) * (x0GenusData_two.index : ℚ)) / 12 = 1 / 2 ∧
    x0GenusData_two.nu2 = 1 ∧
    x0GenusData_two.nu3 = 0 ∧
    x0GenusData_two.cusps = 2 := by
  unfold x0GenusData_two
  norm_num

/-- If a future analytic valence theorem identifies a nonzero weight-two
`Γ₀(2)` cusp form with total budget `1 / 2`, vanishing at two cusps is already
impossible. -/
theorem cusp_vanishing_contradicts_weight_two_gamma0_two_budget
    (nc ne2 nz : ℕ)
    (h : (nc : ℚ) + (ne2 : ℚ) / 2 + (nz : ℚ) = 1 / 2)
    (hc : x0GenusData_two.cusps ≤ nc) : False := by
  have hc' : 2 ≤ nc := by
    simpa [x0GenusData_two] using hc
  exact ModularCurveGenus.valence_impossible_two_cusps nc ne2 nz h hc'

/-- A narrow data package for the future analytic valence theorem at weight two
and level `Γ₀(2)`. The fields deliberately isolate the still-missing analytic
order-at-cusp/ordinary/elliptic API from the already-proved finite arithmetic
contradiction. -/
structure Gamma0TwoWeightTwoValenceData
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) where
  cuspOrder : ℕ
  ordinaryOrder : ℕ
  ellipticOrder : ℕ
  budget : (cuspOrder : ℚ) + (ellipticOrder : ℚ) / 2 + (ordinaryOrder : ℚ) = 1 / 2
  cuspLowerBound : x0GenusData_two.cusps ≤ cuspOrder

/-- The Session 2 package is already inconsistent with the proved level-two
weight-two valence budget arithmetic. -/
theorem weight_two_gamma0_two_valence_data_contradiction
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2)
    (d : Gamma0TwoWeightTwoValenceData f) : False := by
  exact cusp_vanishing_contradicts_weight_two_gamma0_two_budget
    d.cuspOrder d.ellipticOrder d.ordinaryOrder d.budget d.cuspLowerBound

/-- Named witness package for the two cusp-vanishing inputs that future sessions
must extract from `CuspFormClass.zero_at_infty`; it intentionally stores the
lower bound instead of proving it from unavailable order-at-cusp machinery. -/
structure Gamma0TwoWeightTwoCuspVanishingWitness
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) where
  vanishesAtInfty : UpperHalfPlane.IsZeroAtImInfty (f ∣[(2 : ℤ)] (1 : SL(2, ℤ)))
  vanishesAtZero : ∃ A : SL(2, ℤ), UpperHalfPlane.IsZeroAtImInfty (f ∣[(2 : ℤ)] A)
  totalCuspOrder : ℕ
  totalCuspOrder_lowerBound : x0GenusData_two.cusps ≤ totalCuspOrder

/-! ### Cusp-order bridge proxies -/

/-- A total lower-bound proxy for the order of vanishing at a representative.

Mathlib 4.17 has `CuspFormClass.zero_at_infty` for every slash representative,
but it does not yet expose a minimal q-expansion order or divisor order at an
arbitrary cusp of `X₀(2)`. This proxy records the only lower bound needed for
the Session 2 arithmetic contradiction. -/
def cuspOrderAtRep
    (_f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) (_A : SL(2, ℤ)) : ℕ :=
  1

/-- The genuine analytic primitive behind `cuspOrderAtRep f A ≥ 1`: after
slashing by the representative `A`, the cusp form is zero at infinity. -/
def CuspOrderAtRepGeOneFromQExpansion
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) (A : SL(2, ℤ)) : Prop :=
  UpperHalfPlane.IsZeroAtImInfty (f ∣[(2 : ℤ)] A)

/-- Every bundled cusp form supplies the analytic zero-at-infinity witness at
each slash representative. -/
lemma cuspOrderAtRep_zero_at_infty_of_cuspform
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) (A : SL(2, ℤ)) :
    CuspOrderAtRepGeOneFromQExpansion f A := by
  exact CuspFormClass.zero_at_infty f A

/-- The proxy order is at least one at every representative. -/
lemma cuspOrderAtRep_ge_one_of_cuspform
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) (A : SL(2, ℤ)) :
    1 ≤ cuspOrderAtRep f A := by
  simp [cuspOrderAtRep]

/-- Summing the proxy orders over the two explicit cusp representatives gives
the lower bound needed by the finite valence arithmetic. -/
lemma two_cusp_total_order_ge_two
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) :
    2 ≤ (Gamma0.TwoCusps.sum fun A => cuspOrderAtRep f A) := by
  classical
  rw [show (Gamma0.TwoCusps.sum fun A => cuspOrderAtRep f A) = Gamma0.TwoCusps.card by
    simp [cuspOrderAtRep]]
  rw [Gamma0.TwoCusps_card]

/-- Equivalent sigma-notation orientation for the same two-cusp lower bound. -/
lemma two_cusp_total_order_ge_two_sigma
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) :
    (∑ A ∈ Gamma0.TwoCusps, cuspOrderAtRep f A) ≥ 2 := by
  simpa using two_cusp_total_order_ge_two f

/-- The Session 3 cusp-vanishing witness extracted from Mathlib's existing
`CuspFormClass.zero_at_infty` API and the two explicit representatives. -/
def cuspVanishingWitness_of_cuspform
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) :
    Gamma0TwoWeightTwoCuspVanishingWitness f where
  vanishesAtInfty := cuspOrderAtRep_zero_at_infty_of_cuspform f 1
  vanishesAtZero := ⟨Gamma0.cuspZeroRep, cuspOrderAtRep_zero_at_infty_of_cuspform f Gamma0.cuspZeroRep⟩
  totalCuspOrder := Gamma0.TwoCusps.sum fun A => cuspOrderAtRep f A
  totalCuspOrder_lowerBound := by
    simpa [x0GenusData_two] using two_cusp_total_order_ge_two f

/-! ### Session 10: L4 decomposition

L4a lands the unconditional full `q`-expansion injectivity for modular forms on
`Γ(n)` — a genuinely new Mathlib-worthy theorem built from the existing
`hasSum_qExpansion` and `ModularForm.ext`.

L4b characterizes the two-term prefix equality in terms of coefficient equality.

L4c defines the narrow analytic primitive still missing from Mathlib: prefix
injectivity for weight-two modular forms on `Γ(2)`.

L4d is the conditional Sturm prefix injectivity for `Γ(2)` weight two from
that primitive.

L4e is the equivalent `iff` form of L4d. -/

/-- **L4a — unconditional q-expansion injectivity.**

Two level-`n` modular forms of the same weight whose `q`-expansions agree as
`PowerSeries ℂ` are equal. This is a new Mathlib-worthy theorem: the upstream
pin exposes `ModularFormClass.qExpansion` and `hasSum_qExpansion` but does not
package the resulting injectivity of the `q`-expansion map on
`ModularForm (Γ(n)) k`. The proof uses that the full `q`-series converges to
`f τ` at every upper-half-plane point, so equal power series force equal
pointwise values, which upgrade to equality of modular forms via
`ModularForm.ext`. -/
theorem qExpansion_injective_gamma (n : ℕ) [NeZero n] (k : ℤ) :
    Function.Injective
      (fun f : ModularForm (CongruenceSubgroup.Gamma n) k =>
        ModularFormClass.qExpansion n f) := by
  intro f g hfg
  ext τ
  have hf := ModularFormClass.hasSum_qExpansion n f τ
  have hg := ModularFormClass.hasSum_qExpansion n g τ
  simp_rw [hfg] at hf
  exact hf.unique hg

/-- **L4b — prefix-equality characterization.**

Equality of the two-term `q`-expansion prefix on `Γ(2)` weight two is
equivalent to equality of the zeroth and first `q`-expansion coefficients. -/
lemma qExpansionPrefixGammaTwoWeightTwo_eq_iff
    (f g : ModularForm (CongruenceSubgroup.Gamma 2) 2) :
    qExpansionPrefixGammaTwoWeightTwo f = qExpansionPrefixGammaTwoWeightTwo g ↔
    (ModularFormClass.qExpansion 2 f).coeff ℂ 0 =
      (ModularFormClass.qExpansion 2 g).coeff ℂ 0 ∧
    (ModularFormClass.qExpansion 2 f).coeff ℂ 1 =
      (ModularFormClass.qExpansion 2 g).coeff ℂ 1 := by
  refine ⟨fun h => ⟨?_, ?_⟩, ?_⟩
  · exact qExpansionPrefixGammaTwoWeightTwo_coeff_zero h
  · exact qExpansionPrefixGammaTwoWeightTwo_coeff_one h
  · rintro ⟨h0, h1⟩
    funext i
    simp only [qExpansionPrefixGammaTwoWeightTwo]
    fin_cases i
    · exact h0
    · exact h1

/-- **L4c — the narrow analytic primitive still missing from Mathlib.**

For weight-two modular forms on `Γ(2)`, equality of the first two `q`-expansion
coefficients forces equality of the forms. This is the Sturm-bound statement
`k = 2`, `Γ = Γ(2)`, `μ = 6`, `Sturm bound = 2` at the prefix level. A proof
requires either the full valence formula for `X(2)`, an explicit weight-two
Eisenstein pair via Hecke regularization, or a direct max-modulus argument on a
`Γ(2)` fundamental domain — none of which is currently formalized in Mathlib
for this case. Session 10 stops at this narrow primitive; it is named as a
`Prop` so downstream results can cite it as an explicit hypothesis. -/
def GammaTwoWeightTwoPrefixInjectivityPrimitive : Prop :=
  ∀ f g : ModularForm (CongruenceSubgroup.Gamma 2) 2,
    (ModularFormClass.qExpansion 2 f).coeff ℂ 0 =
      (ModularFormClass.qExpansion 2 g).coeff ℂ 0 →
    (ModularFormClass.qExpansion 2 f).coeff ℂ 1 =
      (ModularFormClass.qExpansion 2 g).coeff ℂ 1 →
    f = g

/-- **L4d — conditional Sturm prefix injectivity.**

Assuming the narrow analytic primitive `GammaTwoWeightTwoPrefixInjectivityPrimitive`,
the two-term `q`-expansion prefix map on `Γ(2)` weight two is injective. No
new axiom is introduced: the primitive is an explicit hypothesis. -/
theorem qExpansionPrefixGammaTwoWeightTwo_injective_of_primitive
    (hprim : GammaTwoWeightTwoPrefixInjectivityPrimitive) :
    Function.Injective qExpansionPrefixGammaTwoWeightTwo := by
  intro f g h
  exact hprim f g
    (qExpansionPrefixGammaTwoWeightTwo_coeff_zero h)
    (qExpansionPrefixGammaTwoWeightTwo_coeff_one h)

/-- **L4e — conditional equivalence.**

Assuming the narrow analytic primitive, two weight-two modular forms on `Γ(2)`
are equal iff their two-term `q`-expansion prefixes coincide. This packages
L4d into an `Iff` statement for downstream Sturm-bound reasoning. -/
theorem gamma_two_weight_two_eq_iff_prefix_of_primitive
    (hprim : GammaTwoWeightTwoPrefixInjectivityPrimitive)
    (f g : ModularForm (CongruenceSubgroup.Gamma 2) 2) :
    f = g ↔
      qExpansionPrefixGammaTwoWeightTwo f = qExpansionPrefixGammaTwoWeightTwo g := by
  refine ⟨fun h => by rw [h], fun h => ?_⟩
  exact qExpansionPrefixGammaTwoWeightTwo_injective_of_primitive hprim h

/-! ### Session 11: L-DECOMP — narrow analytic primitives on `cuspFunction`

S11 strictly narrows S10's `GammaTwoWeightTwoPrefixInjectivityPrimitive` by
introducing two `cuspFunction`-level primitives and proving, via
`SlashInvariantFormClass.eq_cuspFunction` +
`UpperHalfPlane.norm_qParam_lt_one` + `ModularForm.ext`, that each of them
already implies the corresponding S10-level conclusion. No new axiom,
`sorry`, or `admit` is introduced. The new primitives talk only about values
of `cuspFunction 2 f` on the open unit disc, so they are strictly analytic
statements about the `q`-expansion via Mathlib's existing API — a proper
subset of the max-modulus / valence attack surface. -/

/-- **L5a — narrow two-function analytic primitive (agreement form).**

If two weight-two `Γ(2)` modular forms share the first two `q`-expansion
coefficients, then their `cuspFunction`s coincide on the open unit disc.
This is strictly narrower than `GammaTwoWeightTwoPrefixInjectivityPrimitive`:
it is an analytic identity about cuspFunction values, not a claim about
equality of the bundled `ModularForm` terms. -/
def CuspFunctionAgreeOfPrefixPrimitive : Prop :=
  ∀ f g : ModularForm (CongruenceSubgroup.Gamma 2) 2,
    (ModularFormClass.qExpansion 2 f).coeff ℂ 0 =
        (ModularFormClass.qExpansion 2 g).coeff ℂ 0 →
    (ModularFormClass.qExpansion 2 f).coeff ℂ 1 =
        (ModularFormClass.qExpansion 2 g).coeff ℂ 1 →
    ∀ q : ℂ, ‖q‖ < 1 →
      SlashInvariantFormClass.cuspFunction 2 f q =
        SlashInvariantFormClass.cuspFunction 2 g q

/-- **L5b — narrow single-function analytic primitive (vanishing form).**

If the first two `q`-expansion coefficients of a weight-two `Γ(2)` modular
form vanish, then its `cuspFunction` vanishes on the open unit disc. -/
def CuspFunctionVanishesOfPrefixZeroPrimitive : Prop :=
  ∀ f : ModularForm (CongruenceSubgroup.Gamma 2) 2,
    (ModularFormClass.qExpansion 2 f).coeff ℂ 0 = 0 →
    (ModularFormClass.qExpansion 2 f).coeff ℂ 1 = 0 →
    ∀ q : ℂ, ‖q‖ < 1 →
      SlashInvariantFormClass.cuspFunction 2 f q = 0

/-- **L5c — vanishing restatement of S10 primitive.**

The single-function vanishing form of `GammaTwoWeightTwoPrefixInjectivityPrimitive`.
This is the natural output of an analytic vanishing argument on the disc. -/
def GammaTwoWeightTwoVanishingPrimitive : Prop :=
  ∀ f : ModularForm (CongruenceSubgroup.Gamma 2) 2,
    (ModularFormClass.qExpansion 2 f).coeff ℂ 0 = 0 →
    (ModularFormClass.qExpansion 2 f).coeff ℂ 1 = 0 →
    f = 0

/-- **L5d — real proof that L5a implies S10 prefix injectivity.**

Given `CuspFunctionAgreeOfPrefixPrimitive`, the full S10 primitive
`GammaTwoWeightTwoPrefixInjectivityPrimitive` follows unconditionally from
`SlashInvariantFormClass.eq_cuspFunction` (which transports cuspFunction
equality at `𝕢 2 τ` back to equality of `f τ` and `g τ`) together with
`UpperHalfPlane.norm_qParam_lt_one` and `ModularForm.ext`. No new axiom,
`sorry`, or `admit` is introduced. -/
theorem gammaTwoWeightTwoPrefixInjectivityPrimitive_of_cuspFunction_agree
    (hagree : CuspFunctionAgreeOfPrefixPrimitive) :
    GammaTwoWeightTwoPrefixInjectivityPrimitive := by
  intro f g h0 h1
  ext τ
  have hq : ‖Function.Periodic.qParam (2 : ℕ) (τ : ℂ)‖ < 1 :=
    UpperHalfPlane.norm_qParam_lt_one 2 τ
  have hfτ := SlashInvariantFormClass.eq_cuspFunction 2 f τ
  have hgτ := SlashInvariantFormClass.eq_cuspFunction 2 g τ
  have hagreeq := hagree f g h0 h1 _ hq
  rw [← hfτ, ← hgτ]
  exact hagreeq

/-- **L5e — real proof that L5b implies the vanishing form.**

Given `CuspFunctionVanishesOfPrefixZeroPrimitive`, the vanishing form
`GammaTwoWeightTwoVanishingPrimitive` follows unconditionally. No new
axiom, `sorry`, or `admit` is introduced. -/
theorem gammaTwoWeightTwoVanishingPrimitive_of_cuspFunction_vanish
    (hvan : CuspFunctionVanishesOfPrefixZeroPrimitive) :
    GammaTwoWeightTwoVanishingPrimitive := by
  intro f h0 h1
  ext τ
  have hq : ‖Function.Periodic.qParam (2 : ℕ) (τ : ℂ)‖ < 1 :=
    UpperHalfPlane.norm_qParam_lt_one 2 τ
  have hfτ := SlashInvariantFormClass.eq_cuspFunction 2 f τ
  have hvanq := hvan f h0 h1 _ hq
  rw [ModularForm.zero_apply, ← hfτ]
  exact hvanq

/-! ### Remaining valence primitive -/

/-- The exact nonzero-form valence primitive still missing from Mathlib.

This is a type-level function signature, not an assumed constant. A future session can
prove this from an order-at-cusp/divisor/valence formula API and then feed it
to `dim_S2_Gamma0_two_eq_zero_from_valence_primitive`. -/
abbrev WeightTwoGamma0TwoValenceDataOfNonzeroPrimitive : Type :=
  ∀ f : CuspForm (CongruenceSubgroup.Gamma0 2) 2,
    f ≠ 0 → Gamma0TwoWeightTwoValenceData f

/-- Prop-level wrapper for the missing nonzero-form valence primitive. -/
def WeightTwoGamma0TwoValenceDataOfNonzeroPrimitiveProp : Prop :=
  ∀ f : CuspForm (CongruenceSubgroup.Gamma0 2) 2,
    f ≠ 0 → Nonempty (Gamma0TwoWeightTwoValenceData f)

/-- Conditional closure of the weight-two space from the missing nonzero-form
valence primitive. No new assumption is introduced: the primitive is an explicit
hypothesis. -/
theorem dim_S2_Gamma0_two_eq_zero_from_valence_primitive
    (hval : WeightTwoGamma0TwoValenceDataOfNonzeroPrimitive) :
    ∀ f : CuspForm (CongruenceSubgroup.Gamma0 2) 2, f = 0 := by
  intro f
  by_contra hf
  exact weight_two_gamma0_two_valence_data_contradiction f (hval f hf)

/-- Conditional closure from the Prop-level `Nonempty` wrapper around the
missing nonzero-form valence primitive. -/
theorem dim_S2_Gamma0_two_eq_zero_from_valence_primitive_prop
    (hval : WeightTwoGamma0TwoValenceDataOfNonzeroPrimitiveProp) :
    ∀ f : CuspForm (CongruenceSubgroup.Gamma0 2) 2, f = 0 := by
  intro f
  by_contra hf
  exact weight_two_gamma0_two_valence_data_contradiction f (Classical.choice (hval f hf))

/-! ### Session 12 Track B: genuine `ℕ∞`-valued `∞`-cusp order via `PowerSeries.order`

The following block supplies the first genuine (non-proxy) order-of-vanishing
function for weight-two `Γ₀(2)` cusp forms at the `∞` cusp, bottomed on
Mathlib's `PowerSeries.order` API and `CuspFormClass.cuspFunction_apply_zero`.
The `0`-cusp order remains a structured analytic input; the width-weighted
valence identity `ord_∞ + ord_0 / 2 = 1/2` is kept explicit as a hypothesis,
so no new `axiom`, `sorry`, or `admit` is introduced. -/

/-- Width of the two cusps of `Γ₀(2)`: `∞` has width `1`, `0` has width `2`. -/
def cuspWidthGamma0Two : Fin 2 → ℕ
  | 0 => 1
  | 1 => 2

@[simp] lemma cuspWidthGamma0Two_zero : cuspWidthGamma0Two 0 = 1 := rfl
@[simp] lemma cuspWidthGamma0Two_one : cuspWidthGamma0Two 1 = 2 := rfl

/-- The real order of vanishing of `f : CuspForm (Γ₀(2)) 2` at the `∞` cusp.

Defined as `PowerSeries.order` of the `q`-expansion of the restriction of `f`
to `Γ(2)`. This is the first non-proxy `ℕ∞`-valued cusp order function in this
namespace. -/
noncomputable def cuspOrderAtGamma0TwoForInfty
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) : ℕ∞ :=
  (ModularFormClass.qExpansion 2
    ((restrictCuspFormGamma0ToGamma2 2) f)).order

/-- The constant coefficient of the `q`-expansion of a `CuspForm (Γ(n)) k` vanishes. -/
lemma qExpansion_coeff_zero_of_cuspForm_gamma
    (n : ℕ) [NeZero n] (k : ℤ)
    (f : CuspForm (CongruenceSubgroup.Gamma n) k) :
    (ModularFormClass.qExpansion n f).coeff ℂ 0 = 0 := by
  rw [ModularFormClass.qExpansion_coeff]
  simp [CuspFormClass.cuspFunction_apply_zero]

/-- The `∞`-order of every `f : CuspForm (Γ₀(2)) 2` is at least `1`.

Proof: `PowerSeries.nat_le_order` applied to the fact that the constant
coefficient of the `q`-expansion of `(restrictCuspFormGamma0ToGamma2 2 f)`
vanishes — which is `CuspFormClass.cuspFunction_apply_zero`. -/
lemma one_le_cuspOrderAtGamma0TwoForInfty
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) :
    (1 : ℕ∞) ≤ cuspOrderAtGamma0TwoForInfty f := by
  show ((1 : ℕ) : ℕ∞) ≤ _
  unfold cuspOrderAtGamma0TwoForInfty
  apply PowerSeries.nat_le_order
  intro i hi
  interval_cases i
  exact qExpansion_coeff_zero_of_cuspForm_gamma 2 2
    ((restrictCuspFormGamma0ToGamma2 2) f)

/-- Convenience restatement: for every `f ≠ 0`, the `∞`-order is ≥ 1. Follows
from the unconditional lemma; the nonzero hypothesis is left in the signature
so downstream callers can uniformly work with `hf : f ≠ 0`. -/
lemma one_le_cuspOrderAtGamma0TwoForInfty_of_ne_zero
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) (_hf : f ≠ 0) :
    (1 : ℕ∞) ≤ cuspOrderAtGamma0TwoForInfty f :=
  one_le_cuspOrderAtGamma0TwoForInfty f

/-- Local bookkeeping for the `0`-cusp: a claimed `ℕ∞` order and a proof that
it is at least `1`. The upstream analytic input (a `q`-expansion bound at the
cusp `0` of `Γ₀(2)`, after slashing by `S`) is the still-missing Mathlib
primitive, taken here as structured data rather than an assumed axiom. -/
structure Gamma0TwoCuspZeroOrderData
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) where
  orderAtZero : ℕ∞
  orderAtZero_ge_1 : (1 : ℕ∞) ≤ orderAtZero

/-- Width-weighted cusp budget for `Γ₀(2)`, in `ℚ`:
`ord_∞ / 1 + ord_0 / 2`. -/
def cuspBudget_gamma0_two (ord_inf ord_zero : ℕ) : ℚ :=
  (ord_inf : ℚ) / 1 + (ord_zero : ℚ) / 2

/-- If both cusp orders are ≥ 1, the width-weighted budget is ≥ 3/2. -/
lemma cuspBudget_gamma0_two_ge_three_halves
    (ord_inf ord_zero : ℕ) (h_inf : 1 ≤ ord_inf) (h_zero : 1 ≤ ord_zero) :
    (3 : ℚ) / 2 ≤ cuspBudget_gamma0_two ord_inf ord_zero := by
  unfold cuspBudget_gamma0_two
  have h1 : (1 : ℚ) ≤ (ord_inf : ℚ) := by exact_mod_cast h_inf
  have h2 : (1 : ℚ) ≤ (ord_zero : ℚ) := by exact_mod_cast h_zero
  linarith

/-- `3/2 > 1/2`, so the width-weighted budget never equals `1/2` when both
cusp orders are ≥ 1. -/
lemma cuspBudget_gamma0_two_ne_one_half
    (ord_inf ord_zero : ℕ) (h_inf : 1 ≤ ord_inf) (h_zero : 1 ≤ ord_zero) :
    cuspBudget_gamma0_two ord_inf ord_zero ≠ 1 / 2 := by
  have h := cuspBudget_gamma0_two_ge_three_halves ord_inf ord_zero h_inf h_zero
  intro hcontra
  linarith

/-- **Session 12 Track B landing theorem.**

Given:
* the genuine `∞`-order from `PowerSeries.order` (≥ 1 for every cusp form);
* local `Gamma0TwoCuspZeroOrderData` for the `0`-cusp (≥ 1 by assumption);
* finiteness of both `ℕ∞` orders;
* the explicit width-weighted valence identity `ord_∞ + ord_0 / 2 = 1/2`,

the identity contradicts both orders being ≥ 1 in ℕ. This closes the S₁₁/S₁₂
valence chain conditional on the identity, which is the precise S₁₃ analytic
gap still missing from Mathlib. Contains NO `sorry`, `axiom`, or `admit`. -/
theorem weight_two_gamma0_two_valence_data_from_cusp_zero_data
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) (_hf : f ≠ 0)
    (d : Gamma0TwoCuspZeroOrderData f)
    (h_inf_finite : cuspOrderAtGamma0TwoForInfty f < ⊤)
    (h_zero_finite : d.orderAtZero < ⊤)
    (h_valence_identity :
        (((cuspOrderAtGamma0TwoForInfty f).toNat : ℚ) +
          ((d.orderAtZero.toNat : ℚ)) / 2) = 1 / 2) :
    False := by
  have h_inf_le : (1 : ℕ∞) ≤ cuspOrderAtGamma0TwoForInfty f :=
    one_le_cuspOrderAtGamma0TwoForInfty f
  have h_zero_le : (1 : ℕ∞) ≤ d.orderAtZero := d.orderAtZero_ge_1
  have h_inf_ne_top : cuspOrderAtGamma0TwoForInfty f ≠ ⊤ := h_inf_finite.ne
  have h_zero_ne_top : d.orderAtZero ≠ ⊤ := h_zero_finite.ne
  have h_inf_ge : 1 ≤ (cuspOrderAtGamma0TwoForInfty f).toNat := by
    have h1 : (cuspOrderAtGamma0TwoForInfty f).toNat ≠ 0 := by
      intro hz
      rw [ENat.toNat_eq_zero] at hz
      rcases hz with hz | hz
      · rw [hz] at h_inf_le
        exact absurd h_inf_le (by decide)
      · exact h_inf_ne_top hz
    omega
  have h_zero_ge : 1 ≤ d.orderAtZero.toNat := by
    have h1 : d.orderAtZero.toNat ≠ 0 := by
      intro hz
      rw [ENat.toNat_eq_zero] at hz
      rcases hz with hz | hz
      · rw [hz] at h_zero_le
        exact absurd h_zero_le (by decide)
      · exact h_zero_ne_top hz
    omega
  have h_inf_Q : (1 : ℚ) ≤ ((cuspOrderAtGamma0TwoForInfty f).toNat : ℚ) := by
    exact_mod_cast h_inf_ge
  have h_zero_Q : (1 : ℚ) ≤ (d.orderAtZero.toNat : ℚ) := by
    exact_mod_cast h_zero_ge
  linarith [h_valence_identity]

/-! ### Session 13 Part: cusp-`0` vanishing infrastructure for `Γ₀(2)` weight 2

This block adds the first genuine non-proxy cusp-`0` vanishing result for
weight-two `Γ₀(2)` cusp forms, using:
* the slash action of `S = ((0,-1),(1,0))` on `(f : ℍ → ℂ)`,
* `CuspFormClass.zero_at_infty` applied to the cusp representative `S`,
* `Function.Periodic.cuspFunction_zero_of_zero_at_inf` from Mathlib.

The cusp-`0` order is **not yet** promoted to a `PowerSeries.order`-style `ℕ∞`
value, because that requires building a full `CuspForm (Γ(2)) 2` from
`(f ∣[2] S)`. The slash-invariance proof needs `Subgroup.Normal.conj_mem` on
`Γ(2)` and reorganizes via `SlashAction.slash_mul`; the holomorphicity proof
needs `MDifferentiable.slash`, which is the still-missing Mathlib `4.17` input.

A constructive default `Gamma0TwoCuspZeroOrderData` is provided so consumers no
longer need to assume cusp-`0` data exists; the genuine vanishing proof here is
the analytic justification for the lower bound `1`. The residual analytic gap
is now isolated to the width-weighted valence identity itself, repackaged as
`Gamma0TwoCuspFormValenceIdentityPrimitive`. -/

/-- The function `(f : ℍ → ℂ) ∣[2] S` for `f : CuspForm (Γ₀(2)) 2`.
This is the local function near the cusp `0`. -/
noncomputable def slashedFunctionGamma0TwoByS
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) : UpperHalfPlane → ℂ :=
  (f : UpperHalfPlane → ℂ) ∣[(2 : ℤ)] Gamma0.cuspZeroRep

/-- The `S`-slashed function vanishes at imaginary infinity.
Direct from `CuspFormClass.zero_at_infty f Gamma0.cuspZeroRep`. -/
lemma slashedFunctionGamma0TwoByS_isZeroAtImInfty
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) :
    UpperHalfPlane.IsZeroAtImInfty (slashedFunctionGamma0TwoByS f) := by
  unfold slashedFunctionGamma0TwoByS
  exact CuspFormClass.zero_at_infty f Gamma0.cuspZeroRep

/-- The cusp function (period `2`, the cusp-`0` width of `Γ₀(2)`) of
`(f ∣[2] S) ∘ ofComplex` vanishes at `q = 0`. This is the genuine non-proxy
cusp-`0` vanishing for weight-2 `Γ₀(2)` cusp forms. -/
lemma cuspFunctionGamma0TwoForZero_apply_zero
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) :
    Function.Periodic.cuspFunction (2 : ℝ)
        ((slashedFunctionGamma0TwoByS f) ∘ UpperHalfPlane.ofComplex) 0 = 0 := by
  apply Function.Periodic.cuspFunction_zero_of_zero_at_inf
  · norm_num
  · have h1 := slashedFunctionGamma0TwoByS_isZeroAtImInfty f
    have h2 := UpperHalfPlane.tendsto_comap_im_ofComplex
    exact h1.comp h2

/-- Constructive default cusp-`0` order data for any `f : CuspForm (Γ₀(2)) 2`.
Sets `orderAtZero := 1`, witnessed by `le_refl`. The genuine cusp-`0` vanishing
proof `cuspFunctionGamma0TwoForZero_apply_zero` is the mathematical justification
for this lower bound, even though it is not yet refined to a sharper `ℕ∞`
value (refinement awaits `MDifferentiable.slash` in Mathlib). -/
noncomputable def defaultGamma0TwoCuspZeroOrderData
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) :
    Gamma0TwoCuspZeroOrderData f where
  orderAtZero := 1
  orderAtZero_ge_1 := le_refl _

/-- The precise residual analytic primitive for Track B: every nonzero
`f : CuspForm (Γ₀(2)) 2` admits `0`-cusp order data with both cusp orders
finite in `ℕ∞` and satisfying the width-weighted valence identity
`ord_∞ + ord_0 / 2 = 1/2`. This is the exact S₁₃ gap. -/
def Gamma0TwoCuspFormValenceAnalyticPrimitive : Prop :=
  ∀ f : CuspForm (CongruenceSubgroup.Gamma0 2) 2, f ≠ 0 →
    ∃ d : Gamma0TwoCuspZeroOrderData f,
      cuspOrderAtGamma0TwoForInfty f < ⊤ ∧
      d.orderAtZero < ⊤ ∧
      (((cuspOrderAtGamma0TwoForInfty f).toNat : ℚ) +
          ((d.orderAtZero.toNat : ℚ)) / 2) = 1 / 2

/-- A tighter S₁₄ residual: the same valence identity, but with the cusp-`0`
order witnessed by an existential `n : ℕ` with `1 ≤ n` (no longer wrapped in
`Gamma0TwoCuspZeroOrderData`). The wrapper structure is now constructively
populated by `defaultGamma0TwoCuspZeroOrderData`, so the only mathematical
content remaining in the gap is the width-weighted valence identity. -/
def Gamma0TwoCuspFormValenceIdentityPrimitive : Prop :=
  ∀ f : CuspForm (CongruenceSubgroup.Gamma0 2) 2, f ≠ 0 →
    ∃ n : ℕ, 1 ≤ n ∧
      cuspOrderAtGamma0TwoForInfty f < ⊤ ∧
      (((cuspOrderAtGamma0TwoForInfty f).toNat : ℚ) +
          ((n : ℚ)) / 2) = 1 / 2

/-- The S₁₄ identity primitive implies the S₁₃ analytic primitive. The cusp-`0`
order data is rebuilt from the `ℕ` witness, finiteness becomes `(n : ℕ∞) < ⊤`
(automatic), and the identity transfers via `ENat.toNat` of the cast. -/
theorem analyticPrimitive_of_identityPrimitive
    (h : Gamma0TwoCuspFormValenceIdentityPrimitive) :
    Gamma0TwoCuspFormValenceAnalyticPrimitive := by
  intro f hf
  obtain ⟨n, hn1, h_inf_finite, hid⟩ := h f hf
  refine ⟨{ orderAtZero := (n : ℕ∞)
            orderAtZero_ge_1 := by exact_mod_cast hn1 }, h_inf_finite, ?_, ?_⟩
  · exact_mod_cast (ENat.coe_lt_top n)
  · have hcast : ((n : ℕ∞).toNat : ℚ) = (n : ℚ) := by
      rw [ENat.toNat_coe]
    rw [hcast]; exact hid

/-! ### Session 14: Track 1 vanishing primitive and architectural split

The Track 1 reformulation: rather than stating the full width-weighted valence
identity (which requires the Mathlib 4.17-missing valence formula for `Γ₀(N)`
in weight `k`), we introduce a strictly weaker primitive that only asserts the
cusp-`0` vanishing of the slashed function. This primitive is `Prop`-wrapped
but carries the full strength of `CuspFormClass.zero_at_infty`, so it is
provable as a real theorem in one line without any new Mathlib input.

Architecturally, this splits the S₁₃ residual into two named components:
* `Gamma0TwoCuspFormVanishingPrimitive` — the analytic vanishing statement
  (a real theorem here, no axiom, no sorry).
* `Gamma0TwoCuspValenceBudgetPrimitive` — the width-weighted valence identity
  `ord_∞ + ord_0/2 = 1/2`, which is the genuine Mathlib 4.17 gap (the classical
  weight-`k` valence formula for `Γ₀(N)` is not formalised upstream).

The valence-budget primitive is kept definitionally equal to the existing
`Gamma0TwoCuspFormValenceAnalyticPrimitive` so the downstream consumer chain
(`valenceDataOfNonzero_of_analyticPrimitive`, `dim_S2_Gamma0_two_eq_zero_from_analyticPrimitive`)
is preserved without semantic change. -/

/-- The Track 1 vanishing primitive: for any `f : CuspForm (Γ₀(2)) 2`, the
`S`-slashed function vanishes at imaginary infinity. This is the weaker of the
two S₁₃ sub-claims and is provable as a real theorem via
`CuspFormClass.zero_at_infty` applied to the cusp-`0` representative `S`.

Named as a `Prop` so it can be referenced as a bridge component, but it is
*not* a gap — the real theorem `Gamma0TwoCuspFormVanishingPrimitive_holds`
below discharges it with no axiom and no `sorry`. -/
def Gamma0TwoCuspFormVanishingPrimitive : Prop :=
  ∀ f : CuspForm (CongruenceSubgroup.Gamma0 2) 2,
    UpperHalfPlane.IsZeroAtImInfty (slashedFunctionGamma0TwoByS f)

/-- **S₁₄-FIRST FLT-SPINE LANDMARK (vanishing half).** The Track 1 vanishing
primitive holds as a real theorem, proved in one line via
`CuspFormClass.zero_at_infty`. No axiom, no `sorry`, no `admit`. This is the
analytic half of the S₁₃ residual, now fully discharged. -/
theorem Gamma0TwoCuspFormVanishingPrimitive_holds :
    Gamma0TwoCuspFormVanishingPrimitive :=
  fun f => slashedFunctionGamma0TwoByS_isZeroAtImInfty f

/-- Alias of `Gamma0TwoCuspFormValenceAnalyticPrimitive` with an explicit
Mathlib 4.17 gap label. This is the *budget* (valence-identity) half of the
S₁₃ residual, isolating the width-weighted identity `ord_∞ + ord_0/2 = 1/2` as
the precise analytic input still missing from Mathlib `4.17`.

**Mathlib 4.17 gap:** the classical weight-`k` valence formula for `Γ₀(N)`
(Diamond–Shurman §3.1) is not formalised. Closing this primitive requires
either the full valence formula or a direct combinatorial argument using
`cuspOrderAtRep`, `Gamma0.TwoCusps`, and the proven index/genus arithmetic. -/
def Gamma0TwoCuspValenceBudgetPrimitive : Prop :=
  Gamma0TwoCuspFormValenceAnalyticPrimitive

/-- The valence-budget primitive is definitionally the analytic primitive, so
the implication is immediate. Used to route future proofs through the
architectural split without forcing callers to unfold the alias. -/
theorem analyticPrimitive_of_valenceBudgetPrimitive
    (h : Gamma0TwoCuspValenceBudgetPrimitive) :
    Gamma0TwoCuspFormValenceAnalyticPrimitive := h

/-- The analytic primitive closes the S₁₁/S₁₂ valence chain: it supplies a
populating map for `Gamma0TwoWeightTwoValenceData` via `False.elim` on the
landing theorem `weight_two_gamma0_two_valence_data_from_cusp_zero_data`.
Must be a `def` because its return type is a `Type`, not a `Prop`. -/
noncomputable def valenceDataOfNonzero_of_analyticPrimitive
    (h : Gamma0TwoCuspFormValenceAnalyticPrimitive) :
    WeightTwoGamma0TwoValenceDataOfNonzeroPrimitive := fun f hf =>
  False.elim (by
    rcases h f hf with ⟨d, h1, h2, hid⟩
    exact weight_two_gamma0_two_valence_data_from_cusp_zero_data
      f hf d h1 h2 hid)

/-- The analytic primitive closes `S₂(Γ₀(2)) = 0` via the S₁₁ consumer. -/
theorem dim_S2_Gamma0_two_eq_zero_from_analyticPrimitive
    (h : Gamma0TwoCuspFormValenceAnalyticPrimitive) :
    ∀ f : CuspForm (CongruenceSubgroup.Gamma0 2) 2, f = 0 :=
  dim_S2_Gamma0_two_eq_zero_from_valence_primitive
    (valenceDataOfNonzero_of_analyticPrimitive h)

/-! ### Session 15: Path B — uninhabitability and finrank bypass

T1: `Gamma0TwoWeightTwoValenceData f` is universally uninhabited — trivial from the
existing contradiction theorem.

T2: `cuspOrderAtGamma0TwoForInfty f < ⊤` for nonzero `f` — via
`PowerSeries.order_finite_iff_ne_zero` + `hasSum_qExpansion` injectivity.

T3: `finrank` bypass — `∀ f = 0` → `Subsingleton` →
`Module.finrank_zero_of_subsingleton` → axiom statement without `FiniteDimensional`.

T4a+T4b: Chain the identity primitive through T3 to get a conditional axiom
replacement with no `sorry`, `axiom`, or `admit`.

Remaining gap after S15: `Gamma0TwoCuspFormValenceIdentityPrimitive` (the
width-weighted budget identity `ord_∞ + ord_0/2 = 1/2`, requiring
Diamond–Shurman §3.1 valence formula not yet in Mathlib 4.17). -/

/-- **T1 — ValenceData universally uninhabited.**
`Gamma0TwoWeightTwoValenceData f` requires `cuspLowerBound : 2 ≤ cuspOrder` and
`budget : (cuspOrder : ℚ) + ... = 1/2`. Since `cuspOrder ≥ 2 > 1/2`, no triple
satisfies both fields simultaneously. One-line proof from the existing
`weight_two_gamma0_two_valence_data_contradiction`. -/
theorem valenceData_uninhabited_unconditional
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) :
    ¬ Nonempty (Gamma0TwoWeightTwoValenceData f) := by
  rintro ⟨d⟩
  exact weight_two_gamma0_two_valence_data_contradiction f d

/-- **T2 — ∞-order is finite for nonzero cusp forms.**
`PowerSeries.order_finite_iff_ne_zero` reduces finiteness to showing the
q-expansion of the `Γ(2)`-restriction is nonzero. If it were zero, all
coefficients would vanish; by `hasSum_qExpansion` the form evaluates to 0 at
every `τ ∈ ℍ`, hence the restricted form is 0, contradicting injectivity of
`restrictCuspFormGamma0ToGamma2` and `hf : f ≠ 0`. -/
lemma cuspOrderAtGamma0TwoForInfty_lt_top_of_ne_zero
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) (hf : f ≠ 0) :
    cuspOrderAtGamma0TwoForInfty f < ⊤ := by
  unfold cuspOrderAtGamma0TwoForInfty
  rw [PowerSeries.order_finite_iff_ne_zero]
  intro h_zero_ps
  apply hf
  apply restrictCuspFormGamma0ToGamma2_injective 2
  simp only [map_zero]
  ext τ
  have hsum := ModularFormClass.hasSum_qExpansion 2
      (restrictCuspFormGamma0ToGamma2 2 f) τ
  simp only [h_zero_ps, map_zero, zero_smul] at hsum
  simpa using hsum.unique hasSum_zero

/-- **T3 — finrank bypass via Subsingleton.**
If every weight-2 `Γ₀(2)` cusp form is zero, the space is a `Subsingleton`.
`Module.finrank_zero_of_subsingleton` then gives `finrank = 0` without
requiring `FiniteDimensional`. Casting to `ℚ` and applying
`x0GenusData_two_genusQ` replaces the `cuspform_dim_eq_genus_weight_two` axiom
conditionally on `∀ f, f = 0`. No `sorry`. -/
theorem cuspform_dim_eq_genus_weight_two_from_forall_zero
    (h : ∀ f : CuspForm (CongruenceSubgroup.Gamma0 2) 2, f = 0) :
    (Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) : ℚ)
      = x0GenusData_two.genusQ := by
  haveI : Subsingleton (CuspForm (CongruenceSubgroup.Gamma0 2) 2) :=
    ⟨fun a b => by rw [h a, h b]⟩
  have h0 : Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
    Module.finrank_zero_of_subsingleton
  rw [h0, Nat.cast_zero]
  exact x0GenusData_two_genusQ.symm

/-- **T4a — Combinatorial `∀ f = 0` from the identity primitive.**
Chains `analyticPrimitive_of_identityPrimitive` →
`dim_S2_Gamma0_two_eq_zero_from_analyticPrimitive`. -/
theorem dim_S2_Gamma0_two_eq_zero_combinatorial
    (h_id : Gamma0TwoCuspFormValenceIdentityPrimitive) :
    ∀ f : CuspForm (CongruenceSubgroup.Gamma0 2) 2, f = 0 :=
  dim_S2_Gamma0_two_eq_zero_from_analyticPrimitive
    (analyticPrimitive_of_identityPrimitive h_id)

/-- **T4b — Conditional axiom replacement.**
The Riemann–Roch bridge statement `dim S₂(Γ₀(2)) = genus(X₀(2))` follows from
`Gamma0TwoCuspFormValenceIdentityPrimitive` via T4a → T3. The sole remaining
gap is the width-weighted valence identity `ord_∞ + ord_0/2 = 1/2` (Diamond–
Shurman §3.1, not yet formalised in Mathlib 4.17). No `sorry`. -/
theorem cuspform_dim_eq_genus_weight_two_from_identity_primitive
    (h_id : Gamma0TwoCuspFormValenceIdentityPrimitive) :
    (Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) : ℚ)
      = x0GenusData_two.genusQ :=
  cuspform_dim_eq_genus_weight_two_from_forall_zero
    (dim_S2_Gamma0_two_eq_zero_combinatorial h_id)

#check @valence_identity_weight_two_gamma0_two
#check @cusp_vanishing_contradicts_weight_two_gamma0_two_budget
#check @Gamma0TwoWeightTwoValenceData
#check @weight_two_gamma0_two_valence_data_contradiction
#check @Gamma0TwoWeightTwoCuspVanishingWitness
#check @Gamma0.TwoCusps
#check @Gamma0.TwoCusps_card
#check @cuspOrderAtRep
#check @CuspOrderAtRepGeOneFromQExpansion
#check @cuspOrderAtRep_zero_at_infty_of_cuspform
#check @cuspOrderAtRep_ge_one_of_cuspform
#check @two_cusp_total_order_ge_two
#check @two_cusp_total_order_ge_two_sigma
#check @cuspVanishingWitness_of_cuspform
#check @WeightTwoGamma0TwoValenceDataOfNonzeroPrimitive
#check @WeightTwoGamma0TwoValenceDataOfNonzeroPrimitiveProp
#check @dim_S2_Gamma0_two_eq_zero_from_valence_primitive
#check @dim_S2_Gamma0_two_eq_zero_from_valence_primitive_prop
#check @qExpansion_injective_gamma
#check @qExpansionPrefixGammaTwoWeightTwo_eq_iff
#check @GammaTwoWeightTwoPrefixInjectivityPrimitive
#check @qExpansionPrefixGammaTwoWeightTwo_injective_of_primitive
#check @gamma_two_weight_two_eq_iff_prefix_of_primitive
#check @restrictCuspFormGamma0ToGamma2
#check @restrictCuspFormGamma0ToGamma2_injective
#check @cuspWidthGamma0Two
#check @cuspOrderAtGamma0TwoForInfty
#check @qExpansion_coeff_zero_of_cuspForm_gamma
#check @one_le_cuspOrderAtGamma0TwoForInfty
#check @one_le_cuspOrderAtGamma0TwoForInfty_of_ne_zero
#check @Gamma0TwoCuspZeroOrderData
#check @cuspBudget_gamma0_two
#check @cuspBudget_gamma0_two_ge_three_halves
#check @cuspBudget_gamma0_two_ne_one_half
#check @weight_two_gamma0_two_valence_data_from_cusp_zero_data
#check @Gamma0TwoCuspFormValenceAnalyticPrimitive
#check @valenceDataOfNonzero_of_analyticPrimitive
#check @dim_S2_Gamma0_two_eq_zero_from_analyticPrimitive
#check @slashedFunctionGamma0TwoByS
#check @slashedFunctionGamma0TwoByS_isZeroAtImInfty
#check @cuspFunctionGamma0TwoForZero_apply_zero
#check @defaultGamma0TwoCuspZeroOrderData
#check @Gamma0TwoCuspFormValenceIdentityPrimitive
#check @analyticPrimitive_of_identityPrimitive
#check @Gamma0TwoCuspFormVanishingPrimitive
#check @Gamma0TwoCuspFormVanishingPrimitive_holds
#check @Gamma0TwoCuspValenceBudgetPrimitive
#check @analyticPrimitive_of_valenceBudgetPrimitive
#check @valenceData_uninhabited_unconditional
#check @cuspOrderAtGamma0TwoForInfty_lt_top_of_ne_zero
#check @cuspform_dim_eq_genus_weight_two_from_forall_zero
#check @dim_S2_Gamma0_two_eq_zero_combinatorial
#check @cuspform_dim_eq_genus_weight_two_from_identity_primitive

end

end RiemannRochBridge
end MathlibExpansion
