import MathlibExpansion.NumberTheory.ModularForms.CuspOrder
import MathlibExpansion.ModularCurveGenus
import Mathlib.Algebra.Group.Subgroup.Pointwise
import Mathlib.GroupTheory.Complement
import Mathlib.GroupTheory.Coset.Basic

/-!
# Norm pushforward for finite-index subgroups

This file packages the algebraic core of the Diamond--Shurman norm-pushforward
construction for modular forms on finite-index subgroups of `SL(2, ℤ)`.

For a finite-index subgroup `Γ ≤ SL(2, ℤ)` and a modular form `f : M_k(Γ)`, we
choose one representative in each left coset `Γ \ SL(2, ℤ)` and form the
product

`∏_{q ∈ Γ \ SL(2, ℤ)} (f |_k g_q)`.

Using the explicit quotient-by-right-cosets API in Mathlib, we prove that this
finite product is slash-invariant of weight `k * [SL(2, ℤ) : Γ]`, holomorphic,
and bounded at infinity, hence defines a level-one modular form.

The geometric order/decomposition layer needed for a full valence transfer is
not yet available in Mathlib `v4.17`; this file therefore focuses on the
compilable algebraic pushforward.
-/

open Complex Function ModularForm UpperHalfPlane

open scoped MatrixGroups ModularForm Manifold Topology Pointwise

noncomputable section

namespace MathlibExpansion
namespace Roots
namespace Valence
namespace NormPushforward

open MathlibExpansion

abbrev LeftCosetQuotient (Γ : Subgroup SL(2, ℤ)) :=
  Quotient (QuotientGroup.rightRel Γ)

section CosetRepresentatives

variable (Γ : Subgroup SL(2, ℤ))

noncomputable instance instFintypeLeftCosetQuotient [Γ.FiniteIndex] :
    Fintype (LeftCosetQuotient Γ) := by
  letI := Γ.fintypeQuotientOfFiniteIndex
  simpa [LeftCosetQuotient] using
    (inferInstance : Fintype (Quotient (QuotientGroup.rightRel Γ)))

/-- A chosen representative for each left coset `Γ g`. -/
noncomputable abbrev leftCosetRep (q : LeftCosetQuotient Γ) : SL(2, ℤ) :=
  ((default : Γ.RightTransversal).2.rightQuotientEquiv q : SL(2, ℤ))

@[simp] theorem mk_leftCosetRep (q : LeftCosetQuotient Γ) :
    Quotient.mk'' (leftCosetRep Γ q) = q := by
  simpa [leftCosetRep] using
    ((default : Γ.RightTransversal).2.mk''_rightQuotientEquiv q)

theorem card_leftCosetQuotient_eq_index [Γ.FiniteIndex] :
    Fintype.card (LeftCosetQuotient Γ) = Γ.index := by
  letI := Γ.fintypeQuotientOfFiniteIndex
  calc
    Fintype.card (LeftCosetQuotient Γ) = Fintype.card (SL(2, ℤ) ⧸ Γ) := by
      simpa [LeftCosetQuotient] using
        (QuotientGroup.card_quotient_rightRel (α := SL(2, ℤ)) (s := Γ))
    _ = Nat.card (SL(2, ℤ) ⧸ Γ) := by rw [Nat.card_eq_fintype_card]
    _ = Γ.index := Γ.index_eq_card.symm

/-- Right multiplication on representatives descends to the left-coset quotient. -/
noncomputable def leftCosetRightMulEquiv (A : SL(2, ℤ)) :
    LeftCosetQuotient Γ ≃ LeftCosetQuotient Γ where
  toFun :=
    Quotient.map' (fun g : SL(2, ℤ) => g * A) <| by
      intro x y hxy
      rw [QuotientGroup.rightRel_apply] at hxy ⊢
      simpa [mul_assoc] using hxy
  invFun :=
    Quotient.map' (fun g : SL(2, ℤ) => g * A⁻¹) <| by
      intro x y hxy
      rw [QuotientGroup.rightRel_apply] at hxy ⊢
      simpa [mul_assoc] using hxy
  left_inv := by
    intro q
    refine Quotient.inductionOn' q ?_
    intro g
    change Quotient.mk'' ((g * A) * A⁻¹) = Quotient.mk'' g
    simp [mul_assoc]
  right_inv := by
    intro q
    refine Quotient.inductionOn' q ?_
    intro g
    change Quotient.mk'' ((g * A⁻¹) * A) = Quotient.mk'' g
    simp [mul_assoc]

end CosetRepresentatives

section FiniteProducts

variable {α : Type*} {k : ℤ}

private theorem slash_finset_prod (s : Finset α) (F : α → ℍ → ℂ) (A : SL(2, ℤ)) :
    (∏ a ∈ s, F a) ∣[k * (s.card : ℤ)] A = ∏ a ∈ s, (F a) ∣[k] A := by
  classical
  refine Finset.induction_on s ?_ ?_
  · exact by
      simp [ModularForm.is_invariant_one]
  · intro a s ha ih
    rw [Finset.prod_insert ha, Finset.prod_insert ha, Finset.card_insert_of_not_mem ha]
    have hk : k * ((s.card + 1 : ℕ) : ℤ) = k + k * (s.card : ℤ) := by
      simp [Int.mul_add, add_comm, add_left_comm, add_assoc]
    rw [hk, ModularForm.mul_slash_SL2, ih]

private theorem mdifferentiable_finset_prod :
    ∀ (s : Finset α) (F : α → ℍ → ℂ),
      (∀ a ∈ s, MDifferentiable 𝓘(ℂ) 𝓘(ℂ) (F a)) →
      MDifferentiable 𝓘(ℂ) 𝓘(ℂ) (∏ a ∈ s, F a) := by
  classical
  intro s
  refine Finset.induction_on s ?_ ?_
  · intro F hF
    simpa using
      (mdifferentiable_const (I := 𝓘(ℂ)) (I' := 𝓘(ℂ)) (c := (1 : ℂ)))
  · intro a s ha ih F hF
    rw [Finset.prod_insert ha]
    exact (hF a (by simp [ha])).mul <|
      ih F (fun b hb => hF b (by simp [hb, ha]))

private theorem boundedAtImInfty_finset_prod :
    ∀ (s : Finset α) (F : α → ℍ → ℂ),
      (∀ a ∈ s, IsBoundedAtImInfty (F a)) →
      IsBoundedAtImInfty (∏ a ∈ s, F a) := by
  classical
  intro s
  refine Finset.induction_on s ?_ ?_
  · intro F hF
    simpa using atImInfty.const_boundedAtFilter (1 : ℂ)
  · intro a s ha ih F hF
    rw [Finset.prod_insert ha]
    exact (hF a (by simp [ha])).mul <|
      ih F (fun b hb => hF b (by simp [hb, ha]))

private theorem slash_fintype_prod (F : α → ℍ → ℂ) [Fintype α] (A : SL(2, ℤ)) :
    (∏ a, F a) ∣[k * (Fintype.card α : ℤ)] A = ∏ a, (F a) ∣[k] A := by
  classical
  simpa using slash_finset_prod (k := k) (s := (Finset.univ : Finset α)) F A

private theorem mdifferentiable_fintype_prod (F : α → ℍ → ℂ) [Fintype α]
    (hF : ∀ a, MDifferentiable 𝓘(ℂ) 𝓘(ℂ) (F a)) :
    MDifferentiable 𝓘(ℂ) 𝓘(ℂ) (∏ a, F a) := by
  classical
  simpa using
    mdifferentiable_finset_prod (s := (Finset.univ : Finset α)) F
      (fun a _ => hF a)

private theorem boundedAtImInfty_fintype_prod (F : α → ℍ → ℂ) [Fintype α]
    (hF : ∀ a, IsBoundedAtImInfty (F a)) :
    IsBoundedAtImInfty (∏ a, F a) := by
  classical
  simpa using
    boundedAtImInfty_finset_prod (s := (Finset.univ : Finset α)) F
      (fun a _ => hF a)

end FiniteProducts

section SelfPowers

variable {Γ : Subgroup SL(2, ℤ)} {k : ℤ}

/-- Repeated multiplication of a modular form by itself. The resulting weight is
`k * n`. -/
noncomputable def modularFormPow (f : ModularForm Γ k) : ∀ n : ℕ, ModularForm Γ (k * n)
  | 0 => by
      simpa using ((show k * (0 : ℕ) = 0 by simp) ▸ (1 : ModularForm Γ 0))
  | n + 1 => by
      simpa [Nat.succ_eq_add_one, Int.mul_add, add_comm, add_left_comm, add_assoc] using
        ModularForm.mul f (modularFormPow f n)

end SelfPowers

section CuspTransfer

variable {Γ : Subgroup SL(2, ℤ)} {k : ℤ}

private lemma Tpow_mem_conj_of_cusp_mem
    (g : SL(2, ℤ)) (w : ℕ) [NeZero w]
    (hg : g * ModularGroup.T ^ (w : ℤ) * g⁻¹ ∈ Γ) :
    ModularGroup.T ^ (w : ℤ) ∈ MulAut.conj g⁻¹ • Γ := by
  refine (Subgroup.mem_smul_pointwise_iff_exists
    (m := ModularGroup.T ^ (w : ℤ)) (a := MulAut.conj g⁻¹) (S := Γ)).2 ?_
  refine ⟨g * ModularGroup.T ^ (w : ℤ) * g⁻¹, hg, ?_⟩
  show MulAut.conj g⁻¹ (g * ModularGroup.T ^ (w : ℤ) * g⁻¹) = ModularGroup.T ^ (w : ℤ)
  simp [MulAut.conj_apply, mul_assoc]

/-- Slashing by `g` turns the cusp represented by `g` for `Γ` into the `∞`
cusp for the conjugated subgroup `g⁻¹ Γ g`. This packages the representative
transport result from `CuspOrder` in the special case `A = 1`. -/
theorem slashModularForm_ordAtInfinity_eq_ordAtCusp
    (f : ModularForm Γ k) (g : SL(2, ℤ)) (w : ℕ) [NeZero w]
    (hg : g * ModularGroup.T ^ (w : ℤ) * g⁻¹ ∈ Γ) :
    CuspOrder.ordAtCusp
        (Γ := MulAut.conj g⁻¹ • Γ) (k := k)
        (CuspOrder.slashModularForm f g) 1 w
        (by
          simpa using Tpow_mem_conj_of_cusp_mem (Γ := Γ) g w hg) =
      CuspOrder.ordAtCusp (Γ := Γ) (k := k) f g w hg := by
  simpa using
    (CuspOrder.ordAtCusp_mul_left (Γ := Γ) (k := k) f g 1 w
      (by
        simpa using Tpow_mem_conj_of_cusp_mem (Γ := Γ) g w hg)).symm

end CuspTransfer

section NormPushforward

variable {Γ : Subgroup SL(2, ℤ)} [Γ.FiniteIndex] {k : ℤ}

/-- The individual slash factor indexed by a left coset `Γ g`. -/
noncomputable def normFactor (f : ModularForm Γ k) (q : LeftCosetQuotient Γ) : ℍ → ℂ :=
  (f : ℍ → ℂ) ∣[k] leftCosetRep Γ q

/-- The raw finite product of slash factors over `Γ \ SL(2, ℤ)`. -/
noncomputable def normPushforwardFun (f : ModularForm Γ k) : ℍ → ℂ :=
  ∏ q : LeftCosetQuotient Γ, normFactor (Γ := Γ) (k := k) f q

omit [Γ.FiniteIndex] in
private theorem normFactor_slash_eq_translate
    (f : ModularForm Γ k) (q : LeftCosetQuotient Γ) (A : SL(2, ℤ)) :
    (normFactor (Γ := Γ) (k := k) f q) ∣[k] A =
      normFactor (Γ := Γ) (k := k) f (leftCosetRightMulEquiv Γ A q) := by
  let q' : LeftCosetQuotient Γ := leftCosetRightMulEquiv Γ A q
  have hq' :
      @Quotient.mk'' _ (QuotientGroup.rightRel Γ) (leftCosetRep Γ q') =
        @Quotient.mk'' _ (QuotientGroup.rightRel Γ) (leftCosetRep Γ q * A) := by
    calc
      @Quotient.mk'' _ (QuotientGroup.rightRel Γ) (leftCosetRep Γ q') = q' :=
        mk_leftCosetRep (Γ := Γ) q'
      _ = leftCosetRightMulEquiv Γ A q := rfl
      _ = leftCosetRightMulEquiv Γ A
            (@Quotient.mk'' _ (QuotientGroup.rightRel Γ) (leftCosetRep Γ q)) := by
              rw [mk_leftCosetRep (Γ := Γ) q]
      _ = @Quotient.mk'' _ (QuotientGroup.rightRel Γ) (leftCosetRep Γ q * A) := rfl
  have hmem :
      (leftCosetRep Γ q * A) * (leftCosetRep Γ q')⁻¹ ∈ Γ := by
    rw [← QuotientGroup.rightRel_apply]
    exact Quotient.exact' hq'
  calc
    (normFactor (Γ := Γ) (k := k) f q) ∣[k] A
        = (f : ℍ → ℂ) ∣[k] (leftCosetRep Γ q * A) := by
            rw [normFactor, ← SlashAction.slash_mul]
    _ = (f : ℍ → ℂ) ∣[k]
          (((leftCosetRep Γ q * A) * (leftCosetRep Γ q')⁻¹) * leftCosetRep Γ q') := by
            congr 1
            simp [mul_assoc]
    _ = (((f : ℍ → ℂ) ∣[k]
          ((leftCosetRep Γ q * A) * (leftCosetRep Γ q')⁻¹)) ∣[k] leftCosetRep Γ q') := by
            rw [SlashAction.slash_mul]
    _ = (f : ℍ → ℂ) ∣[k] leftCosetRep Γ q' := by
            rw [SlashInvariantForm.slash_action_eqn f _ hmem]
    _ = normFactor (Γ := Γ) (k := k) f q' := rfl

private theorem normPushforwardFun_slash_prod (f : ModularForm Γ k) (A : SL(2, ℤ)) :
    (normPushforwardFun (Γ := Γ) (k := k) f) ∣[k * Γ.index] A =
      ∏ q : LeftCosetQuotient Γ, (normFactor (Γ := Γ) (k := k) f q) ∣[k] A := by
  have hcard :
      (k * Γ.index : ℤ) = k * (Fintype.card (LeftCosetQuotient Γ) : ℤ) := by
    rw [← card_leftCosetQuotient_eq_index (Γ := Γ)]
  rw [hcard]
  simpa [normPushforwardFun] using
    slash_fintype_prod (k := k) (α := LeftCosetQuotient Γ)
      (F := normFactor (Γ := Γ) (k := k) f) A

theorem normPushforwardFun_slash (f : ModularForm Γ k) (A : SL(2, ℤ)) :
    (normPushforwardFun (Γ := Γ) (k := k) f) ∣[k * Γ.index] A =
      normPushforwardFun (Γ := Γ) (k := k) f := by
  rw [normPushforwardFun_slash_prod]
  have htranslate :
      (∏ q : LeftCosetQuotient Γ, (normFactor (Γ := Γ) (k := k) f q) ∣[k] A) =
        ∏ q : LeftCosetQuotient Γ,
          normFactor (Γ := Γ) (k := k) f (leftCosetRightMulEquiv Γ A q) := by
    refine Fintype.prod_congr _ _ ?_
    intro q
    exact normFactor_slash_eq_translate (Γ := Γ) (k := k) f q A
  rw [htranslate]
  simpa [normPushforwardFun] using
    (leftCosetRightMulEquiv Γ A).prod_comp (normFactor (Γ := Γ) (k := k) f)

private theorem normPushforwardFun_holo (f : ModularForm Γ k) :
    MDifferentiable 𝓘(ℂ) 𝓘(ℂ) (normPushforwardFun (Γ := Γ) (k := k) f) := by
  classical
  refine mdifferentiable_fintype_prod (α := LeftCosetQuotient Γ)
      (F := normFactor (Γ := Γ) (k := k) f) ?_
  intro q
  simpa [normFactor, CuspOrder.slashModularForm_coe] using
    (CuspOrder.slashModularForm f (leftCosetRep Γ q)).holo'

private theorem normPushforwardFun_bdd_at_infty
    (f : ModularForm Γ k) (A : SL(2, ℤ)) :
    IsBoundedAtImInfty
      ((normPushforwardFun (Γ := Γ) (k := k) f) ∣[k * Γ.index] A) := by
  rw [normPushforwardFun_slash_prod]
  refine boundedAtImInfty_fintype_prod (α := LeftCosetQuotient Γ)
      (F := fun q => (normFactor (Γ := Γ) (k := k) f q) ∣[k] A) ?_
  intro q
  simpa [normFactor, CuspOrder.slashModularForm_coe, SlashAction.slash_mul] using
    (CuspOrder.slashModularForm f (leftCosetRep Γ q)).bdd_at_infty' A

/-- The finite-index norm pushforward from level `Γ` to level one. -/
noncomputable def normPushforward (f : ModularForm Γ k) :
    ModularForm (⊤ : Subgroup SL(2, ℤ)) (k * Γ.index) where
  toSlashInvariantForm :=
    { toFun := normPushforwardFun (Γ := Γ) (k := k) f
      slash_action_eq' := by
        intro A hA
        simpa using normPushforwardFun_slash (Γ := Γ) (k := k) f A }
  holo' := normPushforwardFun_holo (Γ := Γ) (k := k) f
  bdd_at_infty' := normPushforwardFun_bdd_at_infty (Γ := Γ) (k := k) f

@[simp] theorem normPushforward_coe (f : ModularForm Γ k) :
    (normPushforward (Γ := Γ) (k := k) f : ℍ → ℂ) =
      normPushforwardFun (Γ := Γ) (k := k) f := rfl

@[simp] theorem normPushforward_slash (f : ModularForm Γ k) (A : SL(2, ℤ)) :
    ((normPushforward (Γ := Γ) (k := k) f : ℍ → ℂ) ∣[k * Γ.index] A) =
      (normPushforward (Γ := Γ) (k := k) f : ℍ → ℂ) := by
  simpa [normPushforward_coe] using normPushforwardFun_slash (Γ := Γ) (k := k) f A

/-- A `d!`-normalized variant of the norm pushforward, obtained by multiplying
the level-one norm by itself `d!` times where `d = [SL(2, ℤ) : Γ]`. -/
noncomputable def normPushforwardFactorial (f : ModularForm Γ k) :
    ModularForm (⊤ : Subgroup SL(2, ℤ))
      ((k * Γ.index) * Γ.index.factorial) :=
  modularFormPow (normPushforward (Γ := Γ) (k := k) f) Γ.index.factorial

@[simp] theorem normPushforwardFactorial_slash (f : ModularForm Γ k) (A : SL(2, ℤ)) :
    ((normPushforwardFactorial (Γ := Γ) (k := k) f : ℍ → ℂ)
      ∣[((k * Γ.index) * Γ.index.factorial)] A) =
      (normPushforwardFactorial (Γ := Γ) (k := k) f : ℍ → ℂ) := by
  simpa using
    SlashInvariantForm.slash_action_eqn
      (normPushforwardFactorial (Γ := Γ) (k := k) f) A (by simp)

end NormPushforward

section LevelTwoSpecializations

open Matrix Matrix.SpecialLinearGroup CongruenceSubgroup
open MathlibExpansion.ModularCurveGenus

local notation "SLMOD(" N ")" =>
  @Matrix.SpecialLinearGroup.map (Fin 2) _ _ _ _ _ _ (Int.castRingHom (ZMod N))

private theorem gamma_two_eq_ker_slmod2 :
    CongruenceSubgroup.Gamma 2 = MonoidHom.ker (SLMOD(2)) := by
  ext A
  rw [CongruenceSubgroup.Gamma_mem, MonoidHom.mem_ker]
  constructor
  · intro hA
    apply Subtype.ext
    ext i j
    fin_cases i <;> fin_cases j
    · simpa [SL_reduction_mod_hom_val, Matrix.one_apply] using hA.1
    · simpa [SL_reduction_mod_hom_val, Matrix.one_apply] using hA.2.1
    · simpa [SL_reduction_mod_hom_val, Matrix.one_apply] using hA.2.2.1
    · simpa [SL_reduction_mod_hom_val, Matrix.one_apply] using hA.2.2.2
  · intro hA
    constructor
    · simpa [SL_reduction_mod_hom_val, Matrix.one_apply] using
        congrArg (fun M : SL(2, ZMod 2) => (M : Matrix (Fin 2) (Fin 2) (ZMod 2)) 0 0) hA
    · constructor
      · simpa [SL_reduction_mod_hom_val, Matrix.one_apply] using
          congrArg (fun M : SL(2, ZMod 2) => (M : Matrix (Fin 2) (Fin 2) (ZMod 2)) 0 1) hA
      · constructor
        · simpa [SL_reduction_mod_hom_val, Matrix.one_apply] using
            congrArg (fun M : SL(2, ZMod 2) => (M : Matrix (Fin 2) (Fin 2) (ZMod 2)) 1 0) hA
        · simpa [SL_reduction_mod_hom_val, Matrix.one_apply] using
            congrArg (fun M : SL(2, ZMod 2) => (M : Matrix (Fin 2) (Fin 2) (ZMod 2)) 1 1) hA

/-- The principal level-two subgroup has index `6`. -/
theorem gamma_two_index_eq_six : (CongruenceSubgroup.Gamma 2).index = 6 := by
  rw [gamma_two_eq_ker_slmod2, Subgroup.index_ker]
  have hrange : MonoidHom.range (SLMOD(2)) = ⊤ :=
    MonoidHom.range_eq_top.mpr slmod2_surjective
  rw [hrange, Subgroup.card_top]
  simpa [Nat.card_eq_fintype_card] using card_SL2_ZMod2

instance gamma0TwoFiniteIndex : (CongruenceSubgroup.Gamma0 2).FiniteIndex := by
  refine ⟨by
    rw [gamma0_two_index_eq_three]
    decide⟩

instance gammaTwoFiniteIndex : (CongruenceSubgroup.Gamma 2).FiniteIndex := by
  refine ⟨by
    rw [gamma_two_index_eq_six]
    decide⟩

/-- The level-one pushforward specialized to `Γ₀(2)` has weight `3k`. -/
noncomputable def normPushforwardGamma0Two
    {k : ℤ} (f : ModularForm (CongruenceSubgroup.Gamma0 2) k) :
    ModularForm (⊤ : Subgroup SL(2, ℤ)) (k * 3) := by
  simpa [gamma0_two_index_eq_three] using
    (normPushforward (Γ := CongruenceSubgroup.Gamma0 2) (k := k) f)

/-- The level-one pushforward specialized to `Γ(2)` has weight `6k`. -/
noncomputable def normPushforwardGammaTwo
    {k : ℤ} (f : ModularForm (CongruenceSubgroup.Gamma 2) k) :
    ModularForm (⊤ : Subgroup SL(2, ℤ)) (k * 6) := by
  simpa [gamma_two_index_eq_six] using
    (normPushforward (Γ := CongruenceSubgroup.Gamma 2) (k := k) f)

private lemma TS_T_sq_TS_inv_mem_gamma_two :
    (ModularGroup.T * ModularGroup.S) * (ModularGroup.T ^ (2 : ℤ)) *
      (ModularGroup.T * ModularGroup.S)⁻¹ ∈
        CongruenceSubgroup.Gamma 2 := by
  rw [CongruenceSubgroup.Gamma_mem]
  native_decide

/-- The cusp `1` of `Γ(2)` has width `2`. -/
def ordAtCuspOneGammaTwo
    {k : ℤ} (f : ModularForm (CongruenceSubgroup.Gamma 2) k) :
    CuspOrder.LocalCuspOrder :=
  CuspOrder.ordAtCusp (Γ := CongruenceSubgroup.Gamma 2) (k := k)
    f (ModularGroup.T * ModularGroup.S) 2 TS_T_sq_TS_inv_mem_gamma_two

@[simp] theorem ordAtCuspOneGammaTwo_width
    {k : ℤ} (f : ModularForm (CongruenceSubgroup.Gamma 2) k) :
    (ordAtCuspOneGammaTwo (k := k) f).width = 2 := rfl

namespace Gamma0Two

/-- The two cusp orbits of `Γ₀(2)`, indexed by `0 = ∞` and `1 = 0`. -/
noncomputable def cuspOrder {k : ℤ}
    (f : ModularForm (CongruenceSubgroup.Gamma0 2) k) : Fin 2 → CuspOrder.LocalCuspOrder
  | 0 => CuspOrder.ordAtCuspInftyGamma0Two (k := k) f
  | 1 => CuspOrder.ordAtCuspZeroGamma0Two (k := k) f

/-- Width-weighted cusp-order sum for `Γ₀(2)`. -/
noncomputable def widthWeightedOrderSum {k : ℤ}
    (f : ModularForm (CongruenceSubgroup.Gamma0 2) k) : ℚ :=
  ∑ i : Fin 2, (((cuspOrder (k := k) f i).order.toNat : ℚ) / (cuspOrder (k := k) f i).width)

/-- Explicit orbit decomposition for the two cusps of `Γ₀(2)`. -/
theorem widthWeightedOrderSum_eq {k : ℤ}
    (f : ModularForm (CongruenceSubgroup.Gamma0 2) k) :
    widthWeightedOrderSum (k := k) f =
      ((CuspOrder.ordAtCuspInftyGamma0Two (k := k) f).order.toNat : ℚ) +
        ((CuspOrder.ordAtCuspZeroGamma0Two (k := k) f).order.toNat : ℚ) / 2 := by
  simp [widthWeightedOrderSum, cuspOrder]

end Gamma0Two

namespace GammaTwo

/-- The three cusp orbits of `Γ(2)`, indexed by `0 = ∞`, `1 = 0`, and `2 = 1`. -/
noncomputable def cuspOrder {k : ℤ}
    (f : ModularForm (CongruenceSubgroup.Gamma 2) k) : Fin 3 → CuspOrder.LocalCuspOrder
  | 0 => CuspOrder.ordAtCuspInftyGammaTwo (k := k) f
  | 1 => CuspOrder.ordAtCuspZeroGammaTwo (k := k) f
  | 2 => ordAtCuspOneGammaTwo (k := k) f

/-- Width-weighted cusp-order sum for `Γ(2)`. -/
noncomputable def widthWeightedOrderSum {k : ℤ}
    (f : ModularForm (CongruenceSubgroup.Gamma 2) k) : ℚ :=
  ∑ i : Fin 3, (((cuspOrder (k := k) f i).order.toNat : ℚ) / (cuspOrder (k := k) f i).width)

/-- Explicit orbit decomposition for the three width-`2` cusps of `Γ(2)`. -/
theorem widthWeightedOrderSum_eq {k : ℤ}
    (f : ModularForm (CongruenceSubgroup.Gamma 2) k) :
    widthWeightedOrderSum (k := k) f =
      ((CuspOrder.ordAtCuspInftyGammaTwo (k := k) f).order.toNat : ℚ) / 2 +
        ((CuspOrder.ordAtCuspZeroGammaTwo (k := k) f).order.toNat : ℚ) / 2 +
        ((ordAtCuspOneGammaTwo (k := k) f).order.toNat : ℚ) / 2 := by
  rw [widthWeightedOrderSum, Fin.sum_univ_three]
  simp [cuspOrder, add_assoc]

end GammaTwo

end LevelTwoSpecializations

end NormPushforward
end Valence
end Roots
end MathlibExpansion
